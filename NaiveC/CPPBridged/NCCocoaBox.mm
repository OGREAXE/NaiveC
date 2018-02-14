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

/**
 the OC wrapper for C++ wrapper ...
 */
@interface NCCocoaObject:NSObject

@property NSObject * realObject;

/**
 currently method name in C++ side is represented in the form A_B_C in response to OC side A:B:C format

 @param methodName <#methodName description#>
 @param arguments <#arguments description#>
 @param lastStack <#lastStack description#>
 @return <#return value description#>
 */
-(BOOL)invoke:(NSString*)methodName arguments:(vector<shared_ptr<NCStackElement>> &)arguments stack:(vector<shared_ptr<NCStackElement>>& )lastStack;

-(shared_ptr<NCStackElement>)attributeForName:(const string & )attrName;

@end

@implementation NCCocoaObject

-(BOOL)invoke:(NSString*)methodName arguments:(vector<shared_ptr<NCStackElement>> &)arguments stack:(vector<shared_ptr<NCStackElement>>& )lastStack{
    
    unsigned int methodCount = 0;
    Method * methodList = class_copyMethodList(self.realObject.class, &methodCount);
    
    for (int i=0; i<methodCount; i++) {
        Method aMethod = methodList[i];
        
        NSString * selectorString = NSStringFromSelector(method_getName(aMethod));
        
        NSString * convertedString = [self convertSelectorString:selectorString];
        
        if([methodName isEqualToString:convertedString]){
            BOOL res = [self private_invoke:aMethod arguments:arguments stack:lastStack];
            return res;
        }
    }
    
    return NO;
}

-(BOOL)private_invoke:(Method)method arguments:(vector<shared_ptr<NCStackElement>> &)arguments stack:(vector<shared_ptr<NCStackElement>>& )lastStack{
    int argCount = method_getNumberOfArguments(method);
    
    if(argCount != arguments.size()){
        NSLog(@"argument count not matched");
        return NO;
    }
    
    SEL selector = method_getName(method);
    NSMethodSignature * signature = [NSMethodSignature methodSignatureForSelector:selector];
    
    NSInvocation *inv = [NSInvocation invocationWithMethodSignature:signature];
    [inv setSelector:selector];
    [inv setTarget:self.realObject];
    
    
    for(int i=0;i<argCount;i++){
        char argumentType[16];
        method_getArgumentType(method, i, argumentType, 16);
        
        int argPos = i+2;
        
#define COMP_ENCODE(type, type2) (type[0] == (@encode(type2))[0] && type[1] == (@encode(type2))[1])
        if(COMP_ENCODE(argumentType, int) ||
           COMP_ENCODE(argumentType, long long )){
            NSNumber * num = [NSNumber numberWithInt:arguments[i]->toInt()];
            [inv setArgument:&num atIndex:argPos];
        }
        else if(COMP_ENCODE(argumentType, float) ||
           COMP_ENCODE(argumentType, double)){
            NSNumber * num = [NSNumber numberWithInt:arguments[i]->toInt()];
            [inv setArgument:&num atIndex:argPos];
        }
        else if(COMP_ENCODE(argumentType, NSString)){
            NSString * str = [NSString stringWithUTF8String:arguments[i]->toString().c_str()];
            [inv setArgument:&str atIndex:argPos];
        }
        else if(COMP_ENCODE(argumentType, id)){
            auto& stackElement = arguments[i];
            id realObj = NULL;
            if(dynamic_pointer_cast<NCStackPointerElement>(stackElement)){
                auto pointerContainer = dynamic_pointer_cast<NCStackPointerElement>(stackElement);
                auto payloadObj = pointerContainer->getRawObjectPointer();
                if(dynamic_cast<NCCocoaBox*>(payloadObj)){
                    auto cocoabox = dynamic_cast<NCCocoaBox*>(payloadObj);
                    NCCocoaObject * cocoaObj = (NCCocoaObject*)CFBridgingRelease(cocoabox->getCocoaObject());
                    realObj = cocoaObj.realObject;
                    
                }
            }
            [inv setArgument:&realObj atIndex:argPos];
        }
        else {
            id argnil = NULL;
            [inv setArgument:&argnil atIndex:argPos];
        }
    }
    
    [inv invoke];
    
    __unsafe_unretained id result;
    
    [inv getReturnValue:&result];
    
    NCCocoaObject * retCocoaObj = [[NCCocoaObject alloc] init];
    retCocoaObj.realObject = result;
    
    NCCocoaBox * box = new NCCocoaBox((void*)CFBridgingRetain(retCocoaObj));
    
    NCStackPointerElement * pRet = new NCStackPointerElement(box);
    
    lastStack.push_back(shared_ptr<NCStackElement>(pRet));
    
    return YES;
}

-(shared_ptr<NCStackElement>)attributeForName:(const string & )attrName{
    return nullptr;
}

/*
 covert from A:B:C to A_B_C
 */
-(NSString *) convertSelectorString:(NSString *) selectorString{
    NSArray * comps = [selectorString componentsSeparatedByString:@":"];
    NSMutableString * str = [NSMutableString string];
    [comps enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
     [str appendString:obj];
     if(idx != comps.count-1){
     [str appendString:@"_"];
     }
     }];
    return str;
}

@end

#pragma mark cocoaBox implementation

NCCocoaBox::NCCocoaBox(void * pCocoaObject){
    NSObject * object = (__bridge NCCocoaObject*)pCocoaObject;
    
    NCCocoaObject * cocoaWrapper = [[NCCocoaObject alloc] init];
    cocoaWrapper.realObject = object;
    
    m_cocoaObject = (void*)CFBridgingRetain(cocoaWrapper);
}
bool NCCocoaBox::invokeMethod(string methodName, vector<shared_ptr<NCStackElement>> &arguments,vector<shared_ptr<NCStackElement>> & lastStack){
    if (m_cocoaObject == nullptr) {
        return false;
    }
    
    NCCocoaObject * wrappedObject = (__bridge NCCocoaObject*)m_cocoaObject;
    
    NSString * methodStr = [NSString stringWithUTF8String:methodName.c_str()];
    
    BOOL res = [wrappedObject invoke:methodStr arguments:arguments stack:lastStack];
    
    return res;
}

shared_ptr<NCStackElement> NCCocoaBox::getAttribute(const string & attrName){
    return nullptr;
}
