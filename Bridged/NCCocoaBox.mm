//
//  NCCocoaBox.cpp
//  NaiveC
//
//  Created by Liang,Zhiyuan(GIS) on 2018/2/13.
//  Copyright © 2018年 Ogreaxe. All rights reserved.
//

#include "NCCocoaBox.hpp"
#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <objc/runtime.h>
#import <objc/message.h>
#include "NCException.hpp"

//#import "NSObject+NCInvocation.h"
#include "NCStringFormatter.hpp"
#import "NCInvocation.h"

#pragma mark cocoaBox implementation

NCCocoaBox::NCCocoaBox(void * pCocoaObject){
    m_cocoaObject = pCocoaObject;
}

NCCocoaBox::NCCocoaBox(const string &str) {
    NSString *nsstr = [NSString stringWithUTF8String:str.c_str()];
    m_cocoaObject = NC_COCOA_BRIDGE(nsstr);
} //wrap as nsstring

NCCocoaBox::NCCocoaBox(NCInt value) {
    NSNumber *num = [NSNumber numberWithInt:value];
    m_cocoaObject = NC_COCOA_BRIDGE(num);
} //wrap as nsnumber

NCCocoaBox::NCCocoaBox(NCFloat value) {
    NSNumber *num = [NSNumber numberWithFloat:value];
    m_cocoaObject = NC_COCOA_BRIDGE(num);
}//wrap as nsnumber

NCCocoaBox::~NCCocoaBox(){
    NC_COCOA_UNBRIDGE(m_cocoaObject);
}

bool NCCocoaBox::invokeMethod(string methodName, vector<shared_ptr<NCStackElement>> &arguments,vector<shared_ptr<NCStackElement>> & lastStack){
//    if (m_cocoaObject == nullptr) {
//        return false;
//    }
//    
//    NSObject * wrappedObject = (__bridge NSObject*)m_cocoaObject;
//    
//    NSString * methodStr = [NSString stringWithUTF8String:methodName.c_str()];
//    
//    BOOL res = [wrappedObject invoke:methodStr arguments:arguments stack:lastStack];
    
    vector<shared_ptr<NCStackElement>> formatArguments;
    
    return invokeMethod(methodName, arguments, formatArguments, lastStack);
}

bool NCCocoaBox::invokeMethod(string methodName, vector<shared_ptr<NCStackElement>> &arguments, vector<shared_ptr<NCStackElement>> &formatArguments,vector<shared_ptr<NCStackElement>> & lastStack) {
    if (m_cocoaObject == nullptr) {
        return false;
    }
    
    NSObject * wrappedObject = (__bridge NSObject*)m_cocoaObject;
    
    NSString * methodStr = [NSString stringWithUTF8String:methodName.c_str()];
    
    if (formatArguments.size()) {
        auto formatResult = stringWithFormat(arguments.back(), formatArguments);
        arguments.pop_back();
        arguments.push_back(formatResult);
    }
    
//    BOOL res = [wrappedObject invoke:methodStr arguments:arguments stack:lastStack];
    BOOL res = [NCInvocation invoke:methodStr object:wrappedObject orClass:nil arguments:arguments stack:lastStack];
    
    return res;
}

shared_ptr<NCStackElement> NCCocoaBox::getAttribute(const string & attrName){
    NSObject * wrappedObject = (__bridge NSObject*)m_cocoaObject;
    
    NSString * methodStr = [NSString stringWithUTF8String:attrName.c_str()];
    
    if ([methodStr hasPrefix:@"_"]) {
        //instance variable
        return [NCInvocation instanceVariableForName:methodStr withObject:wrappedObject];
    }
    
    vector<shared_ptr<NCStackElement>> argments;
    vector<shared_ptr<NCStackElement>> resultContainer;
    
//    [wrappedObject invoke:methodStr arguments:argments stack:resultContainer];
    [NCInvocation invoke:methodStr object:wrappedObject orClass:nil arguments:argments stack:resultContainer];
    
    if (resultContainer.size() > 0) {
        return resultContainer[0];
    }
    NSLog(@"attribute %@ not found", methodStr);
    return nullptr;
}

void NCCocoaBox::setAttribute(const string & attrName, shared_ptr<NCStackElement> value){
    
    string firstUpperAttrName = attrName;
    if (firstUpperAttrName[0] >= 'a' && firstUpperAttrName[0] <= 'z') {
        firstUpperAttrName[0] += 'A' -'a';
    }
    
    NSObject * wrappedObject = (__bridge NSObject*)m_cocoaObject;
    
    NSString * methodStr = [NSString stringWithFormat:@"set%@",[NSString stringWithUTF8String:firstUpperAttrName.c_str()]] ;
    
    vector<shared_ptr<NCStackElement>> argments = {value};
    vector<shared_ptr<NCStackElement>> resultContainer;
    
//    [wrappedObject invoke:methodStr arguments:argments stack:resultContainer];
    [NCInvocation invoke:methodStr object:wrappedObject orClass:nil arguments:argments stack:resultContainer];
}

string NCCocoaBox::getDescription(){
    if (!m_cocoaObject) {
        return "NULL";
    }
    NSObject * wrappedObject = (__bridge NSObject*)m_cocoaObject;
    string desc = wrappedObject.description.UTF8String;
    return desc;
}

void NCCocoaBox::br_set(shared_ptr<NCStackElement> & key,shared_ptr<NCStackElement> &value){
    //todo
    //currently nothing happen
    NSLog(@"NCCocoaBox:setting object by [] is not supported for now");
}

shared_ptr<NCStackElement> NCCocoaBox::br_getValue(shared_ptr<NCStackElement> & key){
    NSObject * wrappedObject = (__bridge NSObject*)m_cocoaObject;
    if ([wrappedObject isKindOfClass:[NSArray class]]) {
        NSArray * array = (NSArray *)wrappedObject;
        if (key->toInt() > array.count-1) {
            throw NCRuntimeException(0, "out of range");
        }
        
        auto index = shared_ptr<NCStackIntElement>(new NCStackIntElement(key->toInt()));
        vector<shared_ptr<NCStackElement>> argments = {index};
        vector<shared_ptr<NCStackElement>> resultContainer;
        
//        [wrappedObject invoke:@"objectAtIndex" arguments:argments stack:resultContainer];
        [NCInvocation invoke:@"objectAtIndex" object:wrappedObject orClass:nil arguments:argments stack:resultContainer];
        
        if (resultContainer.size() > 0) {
            return resultContainer[0];
        }
    }
    return nullptr;
}

void NCCocoaBox::enumerate(std::function<bool (shared_ptr<NCStackElement> anObj)> handler){
    NSObject * wrappedObject = (__bridge NSObject*)m_cocoaObject;
    if ([wrappedObject isKindOfClass:[NSArray class]]) {
        NSArray *array = (NSArray*)wrappedObject;
        [array enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            NCCocoaBox * box = new NCCocoaBox(NC_COCOA_BRIDGE(obj));
            NCStackPointerElement * pval = new NCStackPointerElement(shared_ptr<NCObject>(box));
            bool res = handler(shared_ptr<NCStackElement> (pval));
            if (res) {
                *stop = YES;
            }
        }];
    }
}

NCInt NCCocoaBox::toInt(){
    return m_cocoaObject != NULL;
}
