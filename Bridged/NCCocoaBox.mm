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
    return nullptr;
}
