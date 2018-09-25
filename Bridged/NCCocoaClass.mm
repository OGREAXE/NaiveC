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

#include "NCCocoaToolkit.hpp"
#include "NCCocoaBox.hpp"

shared_ptr<NCStackPointerElement> NCCocoaClass::instantiate(vector<shared_ptr<NCStackElement>> &arguments){
    
    if (this->name == NC_CLASSNAME_FRAME || this->name == "CGRectMake") {
        if (arguments.size() == 4) {
            auto x = arguments[0]->toFloat();
            auto y = arguments[1]->toFloat();
            auto width = arguments[2]->toFloat();
            auto height = arguments[3]->toFloat();
            
            return shared_ptr<NCStackPointerElement>(new NCStackPointerElement(shared_ptr<NCObject>(new NCRect(x, y, width, height))));
        }
        else {
            return shared_ptr<NCStackPointerElement>(new NCStackPointerElement(shared_ptr<NCObject>(new NCRect())));
        }
    }
    else if (this->name == NC_CLASSNAME_SIZE || this->name == "CGSizeMake") {
        if (arguments.size() == 2) {
            auto width = arguments[0]->toFloat();
            auto height = arguments[1]->toFloat();
            
            return shared_ptr<NCStackPointerElement>(new NCStackPointerElement(shared_ptr<NCObject>(new NCSize(width, height))));
        }
        else {
            return shared_ptr<NCStackPointerElement>(new NCStackPointerElement(shared_ptr<NCObject>(new NCSize())));
        }
    }
    else if (this->name == NC_CLASSNAME_POINT || this->name == "CGPointMake") {
        if (arguments.size() == 2) {
            auto x = arguments[0]->toFloat();
            auto y = arguments[1]->toFloat();
            
            return shared_ptr<NCStackPointerElement>(new NCStackPointerElement(shared_ptr<NCObject>(new NCPoint(x, y))));
        }
        else {
            return shared_ptr<NCStackPointerElement>(new NCStackPointerElement(shared_ptr<NCObject>(new NCPoint())));
        }
    }
    else if (this->name == NC_CLASSNAME_RANGE || this->name == "NSMakeRange") {
        if (arguments.size() == 2) {
            auto loc = arguments[0]->toInt();
            auto len = arguments[1]->toInt();
            
            return shared_ptr<NCStackPointerElement>(new NCStackPointerElement(shared_ptr<NCObject>(new NCRange(loc, len))));
        }
        else {
            return shared_ptr<NCStackPointerElement>(new NCStackPointerElement(shared_ptr<NCObject>(new NCRange())));
        }
    }
    else if (this->name == NC_CLASSNAME_EDGEINSET || this->name == "UIEdgeInsetsMake") {
        if (arguments.size() == 4) {
            auto top = arguments[0]->toInt();
            auto left = arguments[1]->toInt();
            auto bottom = arguments[2]->toInt();
            auto right = arguments[3]->toInt();
            
            return shared_ptr<NCStackPointerElement>(new NCStackPointerElement(shared_ptr<NCObject>(new NCEdgeInset(top,left,bottom,right))));
        }
        else {
            return shared_ptr<NCStackPointerElement>(new NCStackPointerElement(shared_ptr<NCObject>(new NCEdgeInset())));
        }
    }
    
    //instantiate NSObject subclass
    NSString * thisClassName =  [NSString stringWithUTF8String:this->name.c_str()];
    Class thisClass = NSClassFromString(thisClassName);
    id allocedObject = [thisClass alloc];
    
    NCCocoaBox * box = new NCCocoaBox((void*)CFBridgingRetain(allocedObject));
    
    return shared_ptr<NCStackPointerElement>(new NCStackPointerElement(shared_ptr<NCObject>(box)));
}

bool NCCocoaClass::invokeMethod(string methodName, vector<shared_ptr<NCStackElement>> &arguments,vector<shared_ptr<NCStackElement>> & lastStack){
    
    NSString * methodStr = [NSString stringWithUTF8String:methodName.c_str()];
    
    NSString * thisClassName =  [NSString stringWithUTF8String:this->name.c_str()];
    Class thisClass = NSClassFromString(thisClassName);
    
    return [NSObject invoke:methodStr object:nil orClass:thisClass arguments:arguments stack:lastStack];
}
