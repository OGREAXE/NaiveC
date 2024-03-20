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
#include <sstream> //for std::stringstream
#import "NCCocoaMapper.h"
#import "NSCocoaSymbolStore.h"
#import "NSNumber+Naive.h"

#pragma mark cocoaBox implementation

//NCCocoaBox::NCCocoaBox(void * pCocoaObject){
//    m_cocoaObject = pCocoaObject;
//}

NCCocoaBox::NCCocoaBox(const string &str) {
    NSString *nsstr = [NSString stringWithUTF8String:str.c_str()];
//    m_cocoaObject = NC_COCOA_BRIDGE(nsstr);
    LINK_COCOA_BOX(this, nsstr);
} //wrap as nsstring

NCCocoaBox::NCCocoaBox(NCInt value) {
    NSNumber *num = [NSNumber numberWithLongLong:value];
//    m_cocoaObject = NC_COCOA_BRIDGE(num);
    LINK_COCOA_BOX(this, num);
} //wrap as nsnumber

NCCocoaBox::NCCocoaBox(NCFloat value) {
    NSNumber *num = [NSNumber numberWithFloat:value];
//    m_cocoaObject = NC_COCOA_BRIDGE(num);
    LINK_COCOA_BOX(this, num);
}//wrap as nsnumber

NCCocoaBox::~NCCocoaBox(){
//    NC_COCOA_UNBRIDGE(m_cocoaObject);
    UNLINK_COCOA_BOX(this);
}

string NCCocoaBox::getKey() {
    if (!m_key.size()) {
        const void * address = static_cast<const void*>(this);
        std::stringstream ss;
        ss << address;
        m_key = ss.str();
    }
    
    return m_key;
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

NCCocoaBox *NCCocoaBox::selectorFromString(const string &str) {
    auto box = new NCCocoaBox(str);
    
//    NSString *selectorStr = [NSString stringWithUTF8String:str.c_str()];
//                             
//    SEL selector = NSSelectorFromString(selectorStr);
//    
//    box->m_cocoaObject = (void *)(selector);
    
    return box;
}

bool NCCocoaBox::invokeMethod(string methodName, vector<shared_ptr<NCStackElement>> &arguments, vector<shared_ptr<NCStackElement>> &formatArguments,vector<shared_ptr<NCStackElement>> & lastStack) {
    
    id wrappedObject = GET_NS_OBJECT;
    
    if (wrappedObject == nullptr) {
        return false;
    }
    
//    NSObject * wrappedObject = (__bridge NSObject*)m_cocoaObject;
    
    NSString * methodStr = [NSString stringWithUTF8String:methodName.c_str()];
    
    if (formatArguments.size()) {
        auto formatResult = stringWithFormat(arguments.back(), formatArguments);
        arguments.pop_back();
        arguments.push_back(formatResult);
    }
    
//    BOOL res = [wrappedObject invoke:methodStr arguments:arguments stack:lastStack];
    BOOL res = isSuper?
    [NCInvocation invokeSuper:methodStr object:wrappedObject orClass:nil arguments:arguments stack:lastStack]:
    [NCInvocation invoke:methodStr object:wrappedObject orClass:nil arguments:arguments stack:lastStack];
    
    return res;
}

shared_ptr<NCStackElement> NCCocoaBox::getAttribute(const string & attrName){
    NSObject * wrappedObject = GET_NS_OBJECT;
    
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
    
    NSObject * wrappedObject = GET_NS_OBJECT;
    
    if (attrName[0] == '_') {
        [NCInvocation setInstanceVariable:value forName:[NSString stringWithUTF8String:attrName.c_str()] withObject:wrappedObject];
        return;
    }
    
    string firstUpperAttrName = attrName;
    if (firstUpperAttrName[0] >= 'a' && firstUpperAttrName[0] <= 'z') {
        firstUpperAttrName[0] += 'A' -'a';
    }
    
    NSString * methodStr = [NSString stringWithFormat:@"set%@",[NSString stringWithUTF8String:firstUpperAttrName.c_str()]] ;
    
    vector<shared_ptr<NCStackElement>> argments = {value};
    vector<shared_ptr<NCStackElement>> resultContainer;
    
//    [wrappedObject invoke:methodStr arguments:argments stack:resultContainer];
    [NCInvocation invoke:methodStr object:wrappedObject orClass:nil arguments:argments stack:resultContainer];
}

string NCCocoaBox::getDescription(){
    
    NSObject * wrappedObject = GET_NS_OBJECT;
    
    if (!wrappedObject) {
        return "NULL";
    }
    
    string desc = wrappedObject.description.UTF8String;
    return desc;
}

void NCCocoaBox::br_set(shared_ptr<NCStackElement> & key,shared_ptr<NCStackElement> &value){
    //todo
    //currently nothing happen
    NSLog(@"NCCocoaBox:setting object by [] is not supported for now");
}

shared_ptr<NCStackElement> NCCocoaBox::br_getValue(shared_ptr<NCStackElement> & key){
    NSObject * wrappedObject = GET_NS_OBJECT;
    
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
    NSObject * wrappedObject = GET_NS_OBJECT;
    
    if ([wrappedObject isKindOfClass:[NSArray class]]) {
        NSArray *array = (NSArray*)wrappedObject;
        [array enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            
            NCCocoaBox * box = new NCCocoaBox();
            LINK_COCOA_BOX(box, obj);
            
            NCStackPointerElement * pval = new NCStackPointerElement(shared_ptr<NCObject>(box));
            bool res = handler(shared_ptr<NCStackElement> (pval));
            if (res) {
                *stop = YES;
            }
        }];
    }
}

NCInt NCCocoaBox::toInt(){
    id obj = GET_NS_OBJECT;
    
    if ([obj isKindOfClass:NSNumber.class]) {
        NSNumber *n = obj;
        
        if (n.isPrimitive) {
            return n.longLongValue;
        }
//        return ((NSNumber *)obj).longLongValue;
    }
    
    return GET_NS_OBJECT != NULL;
}

NCObject* NCCocoaBox::copy() {
//    return new NCCocoaBox(this->m_cocoaObject);
    auto cp = new NCCocoaBox();
    
    LINK_COCOA_BOX(cp, GET_NS_OBJECT);
    
    return cp;
}
