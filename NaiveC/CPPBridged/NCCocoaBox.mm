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

bool NCCocoaBox::invokeMethod(string methodName, vector<shared_ptr<NCStackElement>> &arguments,vector<shared_ptr<NCStackElement>> & lastStack){
    if (cocoaObject == nullptr) {
        return false;
    }
    
    NSObject * nsObject = (__bridge NSObject*)cocoaObject;
    
    NSString * methodStr = [NSString stringWithUTF8String:methodName.c_str()];
    
    unsigned int methodCount = 0;
    Method * methodList = class_copyMethodList(NSObject.class, &methodCount);
    
    return true;
}

shared_ptr<NCStackElement> NCCocoaBox::getAttribute(const string & attrName){
    return nullptr;
}
