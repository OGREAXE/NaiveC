//
//  NCCocoaClassProvider.cpp
//  NaiveC
//
//  Created by Liang,Zhiyuan(GIS) on 2018/2/12.
//  Copyright © 2018年 Ogreaxe. All rights reserved.
//

#include "NCCocoaClassProvider.hpp"
#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

#include "NSObject+NCInvocation.h"
#include "NCCocoaClass.hpp"

bool NCCocoaClassProvider::classExist(const std::string & className){
    NSString * nsclassName = [NSString stringWithUTF8String:className.c_str()];
    Class targetClass = NSClassFromString(nsclassName);
    if (targetClass) {
        return true;
    }
    return false;
}

shared_ptr<NCClass> NCCocoaClassProvider::loadClass(const string & className){
    auto cocoaClass = shared_ptr<NCClass> (new NCCocoaClass(className));
    
    return cocoaClass;
}

