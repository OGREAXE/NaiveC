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

#import "NSObject+NCInvocation.h"

#pragma mark cocoaBox implementation

NCCocoaBox::NCCocoaBox(void * pCocoaObject){
    m_cocoaObject = pCocoaObject;
}
bool NCCocoaBox::invokeMethod(string methodName, vector<shared_ptr<NCStackElement>> &arguments,vector<shared_ptr<NCStackElement>> & lastStack){
    if (m_cocoaObject == nullptr) {
        return false;
    }
    
    NSObject * wrappedObject = (__bridge NSObject*)m_cocoaObject;
    
    NSString * methodStr = [NSString stringWithUTF8String:methodName.c_str()];
    
    BOOL res = [wrappedObject invoke:methodStr arguments:arguments stack:lastStack];
    
    return res;
}

shared_ptr<NCStackElement> NCCocoaBox::getAttribute(const string & attrName){
    NSObject * wrappedObject = (__bridge NSObject*)m_cocoaObject;
    
    NSString * methodStr = [NSString stringWithUTF8String:attrName.c_str()];
    
    vector<shared_ptr<NCStackElement>> argments;
    vector<shared_ptr<NCStackElement>> resultContainer;
    
    [wrappedObject invoke:methodStr arguments:argments stack:resultContainer];
    
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
    
    [wrappedObject invoke:methodStr arguments:argments stack:resultContainer];
}

string NCCocoaBox::getDescription(){
    NSObject * wrappedObject = (__bridge NSObject*)m_cocoaObject;
    string desc = wrappedObject.description.UTF8String;
    return desc;
}

void NCCocoaBox::br_set(shared_ptr<NCStackElement> & key,shared_ptr<NCStackElement> &value){
    //todo
    //currently nothing happen
    NSLog(@"NCCocoaBox:setting object by bracket is not supported now");
}

shared_ptr<NCStackElement> NCCocoaBox::br_getValue(shared_ptr<NCStackElement> & key){
    NSObject * wrappedObject = (__bridge NSObject*)m_cocoaObject;
    if ([wrappedObject isKindOfClass:[NSArray class]]) {
        auto index = shared_ptr<NCStackIntElement>(new NCStackIntElement(key->toInt()));
        vector<shared_ptr<NCStackElement>> argments = {index};
        vector<shared_ptr<NCStackElement>> resultContainer;
        
        [wrappedObject invoke:@"objectAtIndex" arguments:argments stack:resultContainer];
        
        if (resultContainer.size() > 0) {
            return resultContainer[0];
        }
    }
    return nullptr;
}
