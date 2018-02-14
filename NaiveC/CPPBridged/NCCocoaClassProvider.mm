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

bool NCCocoaClassProvider::classExist(const std::string & className){
    NSString * nsclassName = [NSString stringWithUTF8String:className.c_str()];
    Class targetClass = NSClassFromString(nsclassName);
    if (targetClass) {
        return true;
    }
    return false;
}

bool NCCocoaClassProvider::invokeStaticMethodOnClass(const string & className,const string& methodName, vector<shared_ptr<NCStackElement>> &arguments,vector<shared_ptr<NCStackElement>> & lastStack){
    return false;
}
