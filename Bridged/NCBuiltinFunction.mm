//
//  NCBuiltinFunction.cpp
//  NaiveC
//
//  Created by 梁志远 on 28/08/2017.
//  Copyright © 2017 Ogreaxe. All rights reserved.
//

#include "NCBuiltinFunction.hpp"
#include "NCException.hpp"
#include "NCCocoaBox.hpp"

#include <cstdlib>

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>

/*
 print
 */
NCBuiltinPrint::NCBuiltinPrint(){
    name = "print";
    parameters.push_back(shared_ptr<NCParameter>(new NCParameter("string","str")));
}

bool NCBuiltinPrint::invoke(vector<shared_ptr<NCStackElement>> &arguments){
    auto str = arguments[0]->toString();
    NSString * nestedString = [NSString stringWithUTF8String:str.c_str()];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"NCPrintStringNotification" object:nestedString];
    
    return true;
}

bool NCBuiltinPrint::invoke(vector<shared_ptr<NCStackElement>> &arguments,vector<shared_ptr<NCStackElement>> & lastStack){
    return invoke(arguments);
}

/*
 get object
 */
NCBuiltinGetObject::NCBuiltinGetObject(){
    name = "getObject";
    parameters.push_back(shared_ptr<NCParameter>(new NCParameter("string","str")));
}

bool NCBuiltinGetObject::invoke(vector<shared_ptr<NCStackElement>> &arguments){
    
    return true;
}

bool NCBuiltinGetObject::invoke(vector<shared_ptr<NCStackElement>> &arguments,vector<shared_ptr<NCStackElement>> & lastStack){
    auto str = arguments[0]->toString();
//    NSString * nestedString = [NSString stringWithUTF8String:str.c_str()];
    char * end;
    unsigned long long ullAddr = strtoull(str.c_str(),&end, 16);
    
    if (errno == ERANGE) {
        NSLog(@"error range");
        return false;
    }
    
    NCCocoaBox * cbox = new NCCocoaBox((void*)ullAddr);
    
    lastStack.push_back(shared_ptr<NCStackPointerElement>(new NCStackPointerElement(shared_ptr<NCObject>(cbox))));
    
    return true;
}

/*
 query view
 */
/*
 get object
 */
NCBuiltinQueryView::NCBuiltinQueryView(){
    name = "queryView";
    parameters.push_back(shared_ptr<NCParameter>(new NCParameter("string","typename")));
    parameters.push_back(shared_ptr<NCParameter>(new NCParameter("string","attribute")));
    parameters.push_back(shared_ptr<NCParameter>(new NCParameter("original","value")));
    parameters.push_back(shared_ptr<NCParameter>(new NCParameter("string","attribute2")));
    parameters.push_back(shared_ptr<NCParameter>(new NCParameter("original","value2")));
}

bool NCBuiltinQueryView::invoke(vector<shared_ptr<NCStackElement>> &arguments){
    
    return true;
}

UIView * getRootView();

UIView*queryViewDFS(UIView * p, NSString * type, const vector<shared_ptr<NCStackElement>> &arguments);

bool NCBuiltinQueryView::invoke(vector<shared_ptr<NCStackElement>> &arguments,vector<shared_ptr<NCStackElement>> & lastStack){
    unsigned long argcount = arguments.size();
    if (argcount != 1 && argcount != 3 && argcount != 5) {
        throw NCRuntimeException(0, "query view request argument count 1, 3 or 5");
    }
   
//    UIWindow * root = [[[UIApplication sharedApplication] delegate] window];
    UIView * root = getRootView();
    
    auto argumentsCopy = arguments;
    argumentsCopy.erase(argumentsCopy.begin());
    NSString * type = [NSString stringWithUTF8String:arguments[0]->toString().c_str()];
    
    UIView * ret = queryViewDFS(root, type, argumentsCopy);
    
    NCCocoaBox * cbox = new NCCocoaBox((void*)CFBridgingRetain(ret));
    lastStack.push_back(shared_ptr<NCStackPointerElement>(new NCStackPointerElement(shared_ptr<NCObject>(cbox))));
    
    return true;
}

bool compareAttribute(NSObject * obj, const string & attrname, const shared_ptr<NCStackElement> & value);

UIView*queryViewDFS(UIView * p, NSString * type, const vector<shared_ptr<NCStackElement>> &arguments){
    NSArray<UIView*> * subviws = p.subviews;
    __block UIView * ret = nil;
    [subviws enumerateObjectsUsingBlock:^(UIView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([NSStringFromClass(obj.class) isEqualToString:type]) {
            if (arguments.size() == 0) {
                ret = obj;
                *stop = YES;
            }
            else if (arguments.size() == 2) {
                bool match = compareAttribute(obj, arguments[0]->toString(), arguments[1]);
                if (match) {
                    ret = obj;
                    *stop = YES;
                }
            }
            else if (arguments.size() == 4) {
                bool match = compareAttribute(obj, arguments[0]->toString(), arguments[1]) && compareAttribute(obj, arguments[2]->toString(), arguments[3]);
                if (match) {
                    ret = obj;
                    *stop = YES;
                }
            }
        }
        
        if (!ret) {
            ret = queryViewDFS(obj, type, arguments);
            if(ret){
                *stop = YES;
            }
        }
    }];

    return ret;
}

NSArray<UIView*> * queryMultipleViewDFS(UIView * p, NSString * type, const vector<shared_ptr<NCStackElement>> &arguments){
    NSArray<UIView*> * subviws = p.subviews;
    NSMutableArray <UIView *> * ret = [NSMutableArray array];
    [subviws enumerateObjectsUsingBlock:^(UIView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([NSStringFromClass(obj.class) isEqualToString:type]) {
            if (arguments.size() == 0) {
                [ret addObject:obj];
            }
            else if (arguments.size() == 2) {
                bool match = compareAttribute(obj, arguments[0]->toString(), arguments[1]);
                if (match) {
                    [ret addObject:obj];
                }
            }
            else if (arguments.size() == 4) {
                bool match = compareAttribute(obj, arguments[0]->toString(), arguments[1]) && compareAttribute(obj, arguments[2]->toString(), arguments[3]);
                if (match) {
                    [ret addObject:obj];
                }
            }
        }
        
        NSArray * subRet = queryMultipleViewDFS(obj, type, arguments);
        if(subRet.count > 0){
            [ret addObjectsFromArray:subRet];
        }
    }];
    
    return ret;
}

bool compareAttribute(NSObject * obj, const string & attrname, const shared_ptr<NCStackElement> & value){
    NSString * nsAtrr = [NSString stringWithUTF8String:attrname.c_str()];
    
    if (![obj respondsToSelector:NSSelectorFromString(nsAtrr)]) {
        return false;
    }
    
    if (value->type == "string") {
        auto vstr = value->toString();
        NSString * value = [NSString stringWithUTF8String:vstr.c_str()];
        NSString * realValue = [obj performSelector:NSSelectorFromString(nsAtrr)];
        if ([realValue isEqualToString:value]) {
            return true;
        }
    }
    else if (value->type == "int") {
        int intv = value->toInt();
        
        SEL selector = NSSelectorFromString(nsAtrr);
        NSInvocation *invocation = [NSInvocation invocationWithMethodSignature:
                                    [[obj class] instanceMethodSignatureForSelector:selector]];
        [invocation setSelector:selector];
        [invocation setTarget:obj];
        [invocation invoke];
        int realValue;
        [invocation getReturnValue:&realValue];
        
        if (realValue == intv) {
            return true;
        }
    }
    else if (value->type == "float") {
        float fv = value->toFloat();
        
        SEL selector = NSSelectorFromString(nsAtrr);
        NSInvocation *invocation = [NSInvocation invocationWithMethodSignature:
                                    [[obj class] instanceMethodSignatureForSelector:selector]];
        [invocation setSelector:selector];
        [invocation setTarget:obj];
        [invocation invoke];
        float realValue;
        [invocation getReturnValue:&realValue];
        if (realValue == fv) {
            return true;
        }
    }
    return false;
}

UIView * getRootView(){
    id appClass = NSClassFromString(@"UIApplication");
    id sharedApp = [appClass performSelector:@selector(sharedApplication)];
    id delegate = [sharedApp performSelector:@selector(delegate)];
    id window = [delegate performSelector:@selector(window)];
    id rootVC = [window performSelector:@selector(rootViewController)];
    id rootView = [rootVC performSelector:@selector(view)];
    return rootView;
}

/*
 query multiple views
 */

/*
 query view
 */
/*
 get object
 */
NCBuiltinQueryViews::NCBuiltinQueryViews(){
    name = "queryViews";
    parameters.push_back(shared_ptr<NCParameter>(new NCParameter("string","typename")));
    parameters.push_back(shared_ptr<NCParameter>(new NCParameter("string","attribute")));
    parameters.push_back(shared_ptr<NCParameter>(new NCParameter("original","value")));
    parameters.push_back(shared_ptr<NCParameter>(new NCParameter("string","attribute2")));
    parameters.push_back(shared_ptr<NCParameter>(new NCParameter("original","value2")));
}

bool NCBuiltinQueryViews::invoke(vector<shared_ptr<NCStackElement>> &arguments){
    return true;
}

bool NCBuiltinQueryViews::invoke(vector<shared_ptr<NCStackElement>> &arguments,vector<shared_ptr<NCStackElement>> & lastStack){
    unsigned long argcount = arguments.size();
    if (argcount != 1 && argcount != 3 && argcount != 5) {
        throw NCRuntimeException(0, "query views request argument count 1, 3 or 5");
    }
    
    //    UIWindow * root = [[[UIApplication sharedApplication] delegate] window];
    UIView * root = getRootView();
    
    auto argumentsCopy = arguments;
    argumentsCopy.erase(argumentsCopy.begin());
    NSString * type = [NSString stringWithUTF8String:arguments[0]->toString().c_str()];
    
    NSArray * ret = queryMultipleViewDFS(root, type, argumentsCopy);
    
    NCCocoaBox * cbox = new NCCocoaBox((void*)CFBridgingRetain(ret));
    lastStack.push_back(shared_ptr<NCStackPointerElement>(new NCStackPointerElement(shared_ptr<NCObject>(cbox))));
    
    return true;
}
