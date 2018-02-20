//
//  NCCocoaClass.cpp
//  NaiveC
//
//  Created by Liang,Zhiyuan(GIS) on 2018/2/18.
//  Copyright © 2018年 Ogreaxe. All rights reserved.
//

#include "NCCocoaClass.hpp"
#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "NSObject+NCInvocation.h"

shared_ptr<NCStackPointerElement> NCCocoaClass::instantiate(vector<shared_ptr<NCStackElement>> &arguments){
    //todo
    return nullptr;
}

bool NCCocoaClass::invokeMethod(string methodName, vector<shared_ptr<NCStackElement>> &arguments,vector<shared_ptr<NCStackElement>> & lastStack){
    
    NSString * methodStr = [NSString stringWithUTF8String:methodName.c_str()];
    
    NSString * thisClassName =  [NSString stringWithUTF8String:this->name.c_str()];
    Class thisClass = NSClassFromString(thisClassName);
    
    return [NSObject invoke:methodStr object:nil orClass:thisClass arguments:arguments stack:lastStack];
}
