//
//  NSObject+NCInvocation.m
//  NaiveC
//
//  Created by Liang,Zhiyuan(GIS) on 2018/2/15.
//  Copyright © 2018年 Ogreaxe. All rights reserved.
//

#import "NSObject+NCInvocation.h"
#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <objc/runtime.h>
#import <objc/message.h>

#include "NCCocoaBox.hpp"

@implementation NSObject (NCInvocation)

+(BOOL)invoke:(NSString*)methodName object:(NSObject*)aObject orClass:(Class)aClass arguments:(vector<shared_ptr<NCStackElement>> &)arguments stack:(vector<shared_ptr<NCStackElement>>& )lastStack{
    unsigned int methodCount = 0;
    
    Method * methodList = NULL;
    if (aObject) {
        methodList = class_copyMethodList(aObject.class, &methodCount);
    }
    else if(aClass){
        methodList = class_copyMethodList(object_getClass(aClass), &methodCount);
    }
    else {
        return NO;
    }
    
//    Method * methodList = class_copyMethodList(target.class, &methodCount);
    
    for (int i=0; i<methodCount; i++) {
        Method aMethod = methodList[i];
        
        NSString * selectorString = NSStringFromSelector(method_getName(aMethod));
        
        NSString * convertedString = [self convertSelectorString:selectorString];
        
        if([methodName isEqualToString:convertedString]){
            BOOL res = [NSObject private_invoke:aMethod target:aObject?aObject:aClass arguments:arguments stack:lastStack];
            
            return res;
        }
    }
    
    return NO;
}

+(BOOL)private_invoke:(Method)method target:(id)target arguments:(vector<shared_ptr<NCStackElement>> &)arguments stack:(vector<shared_ptr<NCStackElement>>& )lastStack{
    int argCount = method_getNumberOfArguments(method);
    
    if(argCount != arguments.size() + 2){
        NSLog(@"argument count not matched");
        return NO;
    }
    
    SEL selector = method_getName(method);
    NSMethodSignature * signature = [target methodSignatureForSelector:selector];
    
    NSInvocation *inv = [NSInvocation invocationWithMethodSignature:signature];
    [inv setSelector:selector];
    [inv setTarget:target];
    
    for(int i=0;i<argCount-2;i++){
        char argumentType[16];
        method_getArgumentType(method, i, argumentType, 16);
        
        int argPos = i+2;
        
#define COMP_ENCODE(type, type2) (type[0] == (@encode(type2))[0] && type[1] == (@encode(type2))[1])
        if(COMP_ENCODE(argumentType, int) ||
           COMP_ENCODE(argumentType, unsigned int )||
           COMP_ENCODE(argumentType, long) ||
           COMP_ENCODE(argumentType, unsigned long )||
           COMP_ENCODE(argumentType, long long ) ||
           COMP_ENCODE(argumentType, unsigned long long )){
            NSNumber * num = [NSNumber numberWithInt:arguments[i]->toInt()];
            [inv setArgument:&num atIndex:argPos];
        }
        else if(COMP_ENCODE(argumentType, float) ||
                COMP_ENCODE(argumentType, double)){
            NSNumber * num = [NSNumber numberWithDouble:arguments[i]->toFloat()];
            [inv setArgument:&num atIndex:argPos];
        }
//        else if(COMP_ENCODE(argumentType, NSString)){
//            NSString * str = [NSString stringWithUTF8String:arguments[i]->toString().c_str()];
//            [inv setArgument:&str atIndex:argPos];
//        }
        else if(COMP_ENCODE(argumentType, id)){
            auto& stackElement = arguments[i];
            id realObj = NULL;
            if(dynamic_pointer_cast<NCStackStringElement>(stackElement)){
                auto pstr = dynamic_pointer_cast<NCStackStringElement>(stackElement);
                NSString * nsstr = [NSString stringWithUTF8String: pstr->toString().c_str()];
                realObj = nsstr;
            }
            else if(dynamic_pointer_cast<NCStackPointerElement>(stackElement)){
                auto pointerContainer = dynamic_pointer_cast<NCStackPointerElement>(stackElement);
                auto payloadObj = pointerContainer->getRawObjectPointer();
                if(payloadObj && dynamic_cast<NCCocoaBox*>(payloadObj)){
                    auto cocoabox = dynamic_cast<NCCocoaBox*>(payloadObj);
//                    NSObject * cocoaObj = (NSObject*)CFBridgingRelease(cocoabox->getCocoaObject());
                    id cocoaObj = (id)CFBridgingRelease(cocoabox->getCocoaObject());
                    realObj = cocoaObj;
                    
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
    
    NCCocoaBox * box = new NCCocoaBox((void*)CFBridgingRetain(result));
    
    NCStackPointerElement * pRet = new NCStackPointerElement(box);
    
    lastStack.push_back(shared_ptr<NCStackElement>(pRet));
    
    return YES;
}
/*
 covert from A:B:C to A_B_C
 */
+(NSString *) convertSelectorString:(NSString *) selectorString{
//    NSArray * comps = [selectorString componentsSeparatedByString:@":"];
//    NSMutableString * str = [NSMutableString string];
//    [comps enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
//        [str appendString:obj];
//        if(idx != comps.count-1){
//            [str appendString:@"_"];
//        }
//    }];
//    return str;
    
    NSString * converted = [selectorString stringByReplacingOccurrencesOfString:@":" withString:@"_"];
    if ([converted characterAtIndex:converted.length-1] == '_') {
        converted = [converted substringToIndex:converted.length-1];
    }
    return converted;
}

-(BOOL)invoke:(NSString*)methodName arguments:(vector<shared_ptr<NCStackElement>> &)arguments stack:(vector<shared_ptr<NCStackElement>>& )lastStack{
    
    return [NSObject invoke:methodName object:self orClass:nil arguments:arguments stack:lastStack];
}

-(shared_ptr<NCStackElement>)attributeForName:(const string & )attrName{
    return nullptr;
}

@end
