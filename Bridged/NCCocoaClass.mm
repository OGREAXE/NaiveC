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
//#import "NSObject+NCInvocation.h"
#import "NCInvocation.h"

#include "NCCocoaToolkit.hpp"
#include "NCCocoaBox.hpp"

#include "NCStringFormatter.hpp"
#import "NCCocoaMapper.h"

//#import "NSCocoaSymbolStore.h"

shared_ptr<NCStackElement> NCCocoaClass::instantiate(vector<shared_ptr<NCStackElement>> &arguments){
    
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
    } else if (this->name == "dispatch_queue_create") {
        if (arguments.size() == 2) {
            auto arg0 = arguments[0]->toString();
            auto arg1 = arguments[1]->toObject();
            
            auto box = dynamic_pointer_cast<NCCocoaBox>(arg1);
            
            dispatch_queue_attr_t attr = NULL;
            
            if (box) {
                attr = GET_NS_OBJECT_P(box);
                
                if ([attr isKindOfClass:NSNull.class]) {
                    attr = NULL;
                }
            }
            
            dispatch_queue_t q = dispatch_queue_create(arg0.c_str(), attr);
//            auto outbox = MAKE_COCOA_BOX(q);
            auto outbox = new NCCocoaBox();
            LINK_COCOA_BOX(outbox, q);
            
            return shared_ptr<NCStackPointerElement>(new NCStackPointerElement(outbox));
        }
    } else if (this->name == "dispatch_time") {
        if (arguments.size() == 2) {
            auto arg0 = arguments[0]->toInt();
            auto arg1 = arguments[1]->toInt();
            
            dispatch_time_t time = dispatch_time(arg0,  arg1);
            
            return shared_ptr<NCStackElement>(new NCStackIntElement(time));
        }
    } else if (this->name == "dispatch_after") {
        if (arguments.size() == 3) {
            auto arg0 = arguments[0]->toInt();
            auto arg1 = arguments[1]->toObject();
            auto arg2 = arguments[2]->toObject();
            
            auto box1 = dynamic_pointer_cast<NCCocoaBox>(arg1);
            
            dispatch_queue_t q = NULL;
            
            if (box1) {
                q = GET_NS_OBJECT_P(box1);
            }
            
            auto box2 = dynamic_pointer_cast<NCCocoaBox>(arg2);
            
            dispatch_block_t block = NULL;
            
            if (box2) {
                //
                block = GET_NS_OBJECT_P(box2);
                dispatch_after(arg0, q, block);
            } else {
                auto lambda = dynamic_pointer_cast<NCLambdaObject>(arg2);
                
                dispatch_after(arg0, q, ^{
                    vector<shared_ptr<NCStackElement>> arg;
                    vector<shared_ptr<NCStackElement>> stack;
                    lambda->invokeMethod("invoke", arg, stack);
                });
            }
            
        }
    } else if (this->name == "dispatch_async") {
        if (arguments.size() == 2) {
            auto arg0 = arguments[0]->toObject();
            auto arg1 = arguments[1]->toObject();
            
            auto box0 = dynamic_pointer_cast<NCCocoaBox>(arg0);
            
            dispatch_queue_t q = NULL;
            
            if (box0) {
                q = GET_NS_OBJECT_P(box0);
            }
            
            auto box1 = dynamic_pointer_cast<NCCocoaBox>(arg1);
            
            dispatch_block_t block = NULL;
            
            if (box1) {
                //
                block = GET_NS_OBJECT_P(box1);
                dispatch_async(q, block);
            } else {
                auto lambda = dynamic_pointer_cast<NCLambdaObject>(arg1);
                
                dispatch_async(q, ^{
                    vector<shared_ptr<NCStackElement>> arg;
                    vector<shared_ptr<NCStackElement>> stack;
                    lambda->invokeMethod("invoke", arg, stack);
                });
            }
            
        }
    } else if (this->name == "dispatch_get_main_queue") {
        dispatch_queue_t q = dispatch_get_main_queue();
//        auto outbox = MAKE_COCOA_BOX(q);
        NCCocoaBox * outbox = new NCCocoaBox();
        LINK_COCOA_BOX(outbox, q);
        
        return shared_ptr<NCStackPointerElement>(new NCStackPointerElement(outbox));
    }
    
    //instantiate NSObject subclass
    NSString * thisClassName =  [NSString stringWithUTF8String:this->name.c_str()];
    Class thisClass = NSClassFromString(thisClassName);
    id allocedObject = [thisClass alloc];
    
//    NCCocoaBox * box = new NCCocoaBox(NC_COCOA_BRIDGE(allocedObject));
    NCCocoaBox * box = new NCCocoaBox();
    LINK_COCOA_BOX(box, allocedObject);
    
    return shared_ptr<NCStackPointerElement>(new NCStackPointerElement(shared_ptr<NCObject>(box)));
}

bool NCCocoaClass::invokeMethod(string methodName, vector<shared_ptr<NCStackElement>> &arguments,vector<shared_ptr<NCStackElement>> & lastStack){
    
//    NSString * methodStr = [NSString stringWithUTF8String:methodName.c_str()];
//    
//    NSString * thisClassName =  [NSString stringWithUTF8String:this->name.c_str()];
//    Class thisClass = NSClassFromString(thisClassName);
//    
//    return [NCInvocation invoke:methodStr object:nil orClass:thisClass arguments:arguments stack:lastStack];
    
    vector<shared_ptr<NCStackElement>> formatArguments;
    
    return invokeMethod(methodName, arguments, formatArguments, lastStack);
}

bool NCCocoaClass::invokeMethod(string methodName, vector<shared_ptr<NCStackElement>> &arguments,vector<shared_ptr<NCStackElement>> &formatArguments,vector<shared_ptr<NCStackElement>> & lastStack) {
    NSString * methodStr = [NSString stringWithUTF8String:methodName.c_str()];
    
    NSString * thisClassName =  [NSString stringWithUTF8String:this->name.c_str()];
    Class thisClass = NSClassFromString(thisClassName);
    
    if (formatArguments.size()) {
        auto formatResult = stringWithFormat(arguments.back(), formatArguments);
        arguments.pop_back();
        arguments.push_back(formatResult);
    }
    
    return [NCInvocation invoke:methodStr object:nil orClass:thisClass arguments:arguments stack:lastStack];
}
