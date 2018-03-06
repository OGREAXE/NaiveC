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
#include "NCCocoaToolkit.hpp"

#include "NCAST.hpp"
#include "NCLog.hpp"

@implementation NSObject (NCInvocation)

+(BOOL)invoke:(NSString*)methodName object:(NSObject*)aObject orClass:(Class)aClass arguments:(vector<shared_ptr<NCStackElement>> &)arguments stack:(vector<shared_ptr<NCStackElement>>& )lastStack{
    unsigned int methodCount = 0;
    
    Method * methodList = NULL;
    
    Class targetClass = NULL;
    
    if (aObject) {
        targetClass = aObject.class;
    }
    else if(aClass){
        targetClass = object_getClass(aClass);
    }
    else {
        return NO;
    }
    
    BOOL res = NO;
    while (targetClass) {
        methodList = class_copyMethodList(targetClass, &methodCount);
        for (int i=0; i<methodCount; i++) {
            Method aMethod = methodList[i];
            
            NSString * selectorString = NSStringFromSelector(method_getName(aMethod));
            
            NSString * convertedString = [self convertSelectorString:selectorString];
            
            if([methodName isEqualToString:convertedString]){
                res = [NSObject private_invoke:aMethod target:aObject?aObject:aClass arguments:arguments stack:lastStack];
                free(methodList);
                return res;
            }
        }
        
        free(methodList);
        targetClass = targetClass.superclass;
    }
    
    NSString * notfoundMsg = [NSString stringWithFormat:@"method:%@ not found",methodName];
    NCLog(NCLogTypeInterpretor, notfoundMsg.UTF8String);
    
    return res;
}

+(BOOL)private_invoke:(Method)method target:(id)target arguments:(vector<shared_ptr<NCStackElement>> &)arguments stack:(vector<shared_ptr<NCStackElement>>& )lastStack{
    int argCount = method_getNumberOfArguments(method);
    
    if(argCount != arguments.size() + 2){
        NSLog(@"argument count not matched");
        return NO;
    }
    
    SEL selector = method_getName(method);
    NSMethodSignature * signature = [target methodSignatureForSelector:selector];
    
    NSInvocation *invocation = [NSInvocation invocationWithMethodSignature:signature];
    [invocation setSelector:selector];
    [invocation setTarget:target];
    
    for(int i=0;i<argCount-2;i++){
#define TYPE_BUFFER_SIZE 128
        char argumentType[TYPE_BUFFER_SIZE];
        
        int argPos = i+2;
        method_getArgumentType(method, argPos, argumentType, TYPE_BUFFER_SIZE);
        
//#define COMP_ENCODE(type, type2) (type[0] == (@encode(type2))[0] && type[1] == (@encode(type2))[1])
#define COMP_ENCODE(type, type2) (strcmp(type,@encode(type2)) == 0)
        
        if(COMP_ENCODE(argumentType, int)){
            unsigned long long num = arguments[i]->toInt();
            [invocation setArgument:&num atIndex:argPos];
        }
        else if(COMP_ENCODE(argumentType, unsigned int)){
            unsigned int num = arguments[i]->toInt();
            [invocation setArgument:&num atIndex:argPos];
        }
        else if(COMP_ENCODE(argumentType, long)){
            long num = arguments[i]->toInt();
            [invocation setArgument:&num atIndex:argPos];
        }
        else if(COMP_ENCODE(argumentType, unsigned long)){
            unsigned long num = arguments[i]->toInt();
            [invocation setArgument:&num atIndex:argPos];
        }
        else if(COMP_ENCODE(argumentType, long long)){
            long long num = arguments[i]->toInt();
            [invocation setArgument:&num atIndex:argPos];
        }
        else if(COMP_ENCODE(argumentType, unsigned long long)){
            unsigned long long num = arguments[i]->toInt();
            [invocation setArgument:&num atIndex:argPos];
        }
        else if(COMP_ENCODE(argumentType, float)){
            float num = arguments[i]->toFloat();
            [invocation setArgument:&num atIndex:argPos];
        }
        else if(COMP_ENCODE(argumentType, double)){
            double num = arguments[i]->toFloat();
            [invocation setArgument:&num atIndex:argPos];
        }
        else if(COMP_ENCODE(argumentType, BOOL)){
            BOOL bval = arguments[i]->toInt();
            [invocation setArgument:&bval atIndex:argPos];
        }
        else if(COMP_ENCODE(argumentType, CGRect)){
            auto argi = arguments[i];
            if(dynamic_pointer_cast<NCStackPointerElement>(arguments[i])){
                auto pFrameContainer = dynamic_pointer_cast<NCStackPointerElement>(arguments[i]);
                auto pObject = pFrameContainer->getPointedObject();
                if(pObject && dynamic_pointer_cast<NCRect>(pObject)){
                    auto pFrame = dynamic_pointer_cast<NCRect>(pObject);
                    CGRect frame = CGRectMake(pFrame->getX(), pFrame->getY(), pFrame->getWidth(), pFrame->getHeight());
                    [invocation setArgument:&frame atIndex:argPos];
                }
            }
        }
//        else if(strcmp(argumentType,@encode(CGSize)) == 0){
        else if(COMP_ENCODE(argumentType, CGSize)){
            if(dynamic_pointer_cast<NCStackPointerElement>(arguments[i])){
                auto pFrameContainer = dynamic_pointer_cast<NCStackPointerElement>(arguments[i]);
                auto pObject = pFrameContainer->getPointedObject();
                if(pObject && dynamic_pointer_cast<NCSize>(pObject)){
                    auto pSize = dynamic_pointer_cast<NCSize>(pObject);
                    CGSize size = CGSizeMake(pSize->getWidth(), pSize->getHeight());
                    [invocation setArgument:&size atIndex:argPos];
                }
            }
        }
//        else if(strcmp(argumentType,@encode(CGPoint)) == 0){
        else if(COMP_ENCODE(argumentType, CGPoint)){
            if(dynamic_pointer_cast<NCStackPointerElement>(arguments[i])){
                auto pFrameContainer = dynamic_pointer_cast<NCStackPointerElement>(arguments[i]);
                auto pObject = pFrameContainer->getPointedObject();
                if(pObject && dynamic_pointer_cast<NCPoint>(pObject)){
                    auto pPoint = dynamic_pointer_cast<NCPoint>(pObject);
                    CGSize point = CGSizeMake(pPoint->getX(), pPoint->getY());
                    [invocation setArgument:&point atIndex:argPos];
                }
            }
        }
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
                auto payloadObj = pointerContainer->getPointedObject();
                if(payloadObj && dynamic_pointer_cast<NCCocoaBox>(payloadObj)){
                    auto cocoabox = dynamic_pointer_cast<NCCocoaBox>(payloadObj);
                    id cocoaObj = (id)CFBridgingRelease(cocoabox->getContent());
                    realObj = cocoaObj;
                    
                }
            }
            [invocation setArgument:&realObj atIndex:argPos];
        }
        else {
            id argnil = NULL;
            [invocation setArgument:&argnil atIndex:argPos];
        }
    }
    
    [invocation invoke];
    
    const char * returnType = signature.methodReturnType;
    
//    if(strcmp(returnType,@encode(void)) == 0){
    if(COMP_ENCODE(returnType, void)){
        return YES;
    }
//    else if(strcmp(returnType,@encode(id)) == 0){
    if(COMP_ENCODE(returnType, id)){
        __unsafe_unretained id result;
        
        [invocation getReturnValue:&result];
        
        NCCocoaBox * box = new NCCocoaBox((void*)CFBridgingRetain(result));
        
        NCStackPointerElement * pRet = new NCStackPointerElement(shared_ptr<NCObject>( box));
        
        lastStack.push_back(shared_ptr<NCStackElement>(pRet));
        
        return YES;
    }
    else {
        NSUInteger length = signature.methodReturnLength;
        void * buffer = (void *)malloc(length);
        [invocation getReturnValue:buffer];
        
        if(COMP_ENCODE(returnType, BOOL)){
            BOOL *pret = (BOOL *)buffer;
            lastStack.push_back(shared_ptr<NCStackIntElement>(new NCStackIntElement( (*pret))));
        }
        else if(COMP_ENCODE(returnType, unsigned int )){
            unsigned int *pret = (unsigned int *)buffer;
            lastStack.push_back(shared_ptr<NCStackIntElement>(new NCStackIntElement( (*pret))));
        }
        else if(COMP_ENCODE(returnType, int)){
            int *pret = (int *)buffer;
            lastStack.push_back(shared_ptr<NCStackIntElement>(new NCStackIntElement( (*pret))));
        }
        else if(COMP_ENCODE(returnType, unsigned long )){
            unsigned long *pret = (unsigned long *)buffer;
            lastStack.push_back(shared_ptr<NCStackIntElement>(new NCStackIntElement( (*pret))));
        }
        else if(COMP_ENCODE(returnType, long)){
            long *pret = ( long *)buffer;
            lastStack.push_back(shared_ptr<NCStackIntElement>(new NCStackIntElement( (*pret))));
        }
        else if(COMP_ENCODE(returnType, unsigned long long)){
            unsigned long long *pret = ( unsigned long long *)buffer;
            lastStack.push_back(shared_ptr<NCStackIntElement>(new NCStackIntElement( (*pret))));
        }
        else if(COMP_ENCODE(returnType, long long)){
            long long *pret = (long long *)buffer;
            lastStack.push_back(shared_ptr<NCStackIntElement>(new NCStackIntElement( (*pret))));
        }
        else if(COMP_ENCODE(returnType, double)){
            double *pret = (double *)buffer;
            lastStack.push_back(shared_ptr<NCStackFloatElement>(new NCStackFloatElement( (*pret))));
        }
        else if(COMP_ENCODE(returnType, float)){
            float *pret = (float *)buffer;
            lastStack.push_back(shared_ptr<NCStackFloatElement>(new NCStackFloatElement( (*pret))));
        }
        else if(COMP_ENCODE(returnType, CGRect)){
            CGRect *pret = (CGRect *)buffer;
            NCRect * pframe = new NCRect(pret->origin.x,pret->origin.y,pret->size.width,pret->size.height);
            lastStack.push_back(shared_ptr<NCStackPointerElement>(new NCStackPointerElement(pframe)));
        }
        else if(COMP_ENCODE(returnType, CGSize)){
            CGSize *pret = (CGSize *)buffer;
            NCSize * pSize = new NCSize(pret->width,pret->height);
            lastStack.push_back(shared_ptr<NCStackPointerElement>(new NCStackPointerElement(pSize)));
        }
        else if(COMP_ENCODE(returnType, CGPoint)){
            CGPoint *pret = (CGPoint *)buffer;
            NCPoint * pPoint = new NCPoint(pret->x,pret->y);
            lastStack.push_back(shared_ptr<NCStackPointerElement>(new NCStackPointerElement(pPoint)));
        }
    }
    
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
    if ([selectorString characterAtIndex:selectorString.length-1] == ':') {
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
