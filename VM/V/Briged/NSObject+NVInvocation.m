//
//  NSObject+NVInvocation.m
//  NaiveC
//
//  Created by liangzhiyuan on 2021/12/15.
//  Copyright © 2021 Ogreaxe. All rights reserved.
//

#import "NSObject+NVInvocation.h"
#import <UIKit/UIKit.h>
#import <objc/runtime.h>
#import <objc/message.h>
#import "NVObject.h"
#import "NVCocoaBox.h"
#import "NVBridgedTypes.h"

#define COMP_ENCODE(type, type2) (strcmp(type,@encode(type2)) == 0)

@implementation NSObject (NVInvocation)

+(BOOL)nv_invoke:(NSString*)methodName object:(NSObject*)aObject orClass:(Class)aClass arguments:(NSArray<NVStackElement *> *)arguments stack:(NVStack *)lastStack {
    
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
                res = [NSObject nv_private_invoke:aMethod target:aObject?aObject:aClass arguments:arguments stack:lastStack];
                free(methodList);
                return res;
            }
        }
        
        free(methodList);
        targetClass = targetClass.superclass;
    }
    
    NSString * notfoundMsg = [NSString stringWithFormat:@"method:%@ not found",methodName];
    NSLog(@"notfoundMsg %@", methodName);
    
    return res;
}

+ (BOOL)nv_private_invoke:(Method)method target:(id)target arguments:(NSArray<NVStackElement *> *)arguments stack:(NVStack *)lastStack{
    
    int argCount = method_getNumberOfArguments(method);
    
    if (argCount != arguments.count + 2) {
        NSLog(@"argument count not matched");
        return NO;
    }
    
    SEL selector = method_getName(method);
    NSMethodSignature * signature = [target methodSignatureForSelector:selector];
    
    NSInvocation *invocation = [NSInvocation invocationWithMethodSignature:signature];
    [invocation setSelector:selector];
    [invocation setTarget:target];
    
    for(int i = 0;i < argCount - 2; i++){
#define TYPE_BUFFER_SIZE 128
        char argumentType[TYPE_BUFFER_SIZE];
        
        int argPos = i+2;
        method_getArgumentType(method, argPos, argumentType, TYPE_BUFFER_SIZE);
        
        if(COMP_ENCODE(argumentType, int)){
            unsigned long long num = [arguments[i] toInt];
            [invocation setArgument:&num atIndex:argPos];
        }
        else if(COMP_ENCODE(argumentType, unsigned int)){
            unsigned int num = [arguments[i] toInt];
            [invocation setArgument:&num atIndex:argPos];
        }
        else if(COMP_ENCODE(argumentType, long)){
            long num = [arguments[i] toInt];
            [invocation setArgument:&num atIndex:argPos];
        }
        else if(COMP_ENCODE(argumentType, unsigned long)){
            unsigned long num = [arguments[i] toInt];
            [invocation setArgument:&num atIndex:argPos];
        }
        else if(COMP_ENCODE(argumentType, long long)){
            long long num = [arguments[i] toInt];
            [invocation setArgument:&num atIndex:argPos];
        }
        else if(COMP_ENCODE(argumentType, unsigned long long)){
            unsigned long long num = [arguments[i] toInt];
            [invocation setArgument:&num atIndex:argPos];
        }
        else if(COMP_ENCODE(argumentType, float)){
            float num = [arguments[i] toFloat];
            [invocation setArgument:&num atIndex:argPos];
        }
        else if(COMP_ENCODE(argumentType, double)){
            double num = [arguments[i] toFloat];
            [invocation setArgument:&num atIndex:argPos];
        }
        else if(COMP_ENCODE(argumentType, BOOL)){
            BOOL bval = [arguments[i] toInt];
            [invocation setArgument:&bval atIndex:argPos];
        }
        else if(COMP_ENCODE(argumentType, CGRect)){
            if ([arguments[i] isKindOfClass:NVStackPointerElement.class]){
                NVStackPointerElement *pFrameContainer = (NVStackPointerElement *)(arguments[i]);
                NVObject *pObject = pFrameContainer.object;
                
                if ([pObject isKindOfClass:NVRect.class]){
                    NVRect *pFrame = (NVRect *)(pObject);
                    CGRect frame = pFrame.rect;
                    
                    [invocation setArgument:&frame atIndex:argPos];
                }
            }
        }
        else if(COMP_ENCODE(argumentType, CGSize)){
            if ([arguments[i] isKindOfClass:NVStackPointerElement.class]){
                NVStackPointerElement *pFrameContainer = (NVStackPointerElement *)(arguments[i]);
                NVObject *pObject = pFrameContainer.object;
                
                if ([pObject isKindOfClass:NVSize.class]){
                    NVSize *pSize = (NVSize *)(pObject);
                    CGSize size = pSize.size;
                    
                    [invocation setArgument:&size atIndex:argPos];
                }
            }
        }
        else if(COMP_ENCODE(argumentType, CGPoint)){
            if ([arguments[i] isKindOfClass:NVStackPointerElement.class]){
                NVStackPointerElement *pFrameContainer = (NVStackPointerElement *)(arguments[i]);
                NVObject *pObject = pFrameContainer.object;
                
                if ([pObject isKindOfClass:NVPoint.class]){
                    NVPoint *pPoint = (NVPoint *)(pObject);
                    CGPoint point = pPoint.point;
                    
                    [invocation setArgument:&point atIndex:argPos];
                }
            }
        }
        else if(COMP_ENCODE(argumentType, NSRange)){
            if ([arguments[i] isKindOfClass:NVStackPointerElement.class]){
                NVStackPointerElement *pFrameContainer = (NVStackPointerElement *)(arguments[i]);
                NVObject *pObject = pFrameContainer.object;
                
                if ([pObject isKindOfClass:NVRange.class]){
                    NVRange *pRange = (NVRange *)(pObject);
                    NSRange range = pRange.range;
                    
                    [invocation setArgument:&range atIndex:argPos];
                }
            }
        }
        else if(COMP_ENCODE(argumentType, UIEdgeInsets)){
            if ([arguments[i] isKindOfClass:NVStackPointerElement.class]){
                NVStackPointerElement *pFrameContainer = (NVStackPointerElement *)(arguments[i]);
                NVObject *pObject = pFrameContainer.object;
                
                if ([pObject isKindOfClass:NVEdgeInsets.class]){
                    NVEdgeInsets *pEdgeInsets = (NVEdgeInsets *)(pObject);
                    UIEdgeInsets edgeInsets = pEdgeInsets.edgeInsets;
                    
                    [invocation setArgument:&edgeInsets atIndex:argPos];
                }
            }
        }
        else if(COMP_ENCODE(argumentType, id)){
            NVStackElement *stackElement = arguments[i];
            id realObj = NULL;
            
            if([stackElement isKindOfClass:NVStackStringElement.class]){
                NVStackStringElement *pstr = (NVStackStringElement *)stackElement;
                realObj = pstr.str;
            }
            else if([stackElement isKindOfClass:NVStackPointerElement.class]){
                NVStackPointerElement *pointerContainer = (NVStackPointerElement *)stackElement;
                NSObject *payloadObj = pointerContainer.object;
                
                if ([payloadObj isKindOfClass:NVCocoaBox.class]) {
                    NVCocoaBox  *cocoabox = (NVCocoaBox *)payloadObj;
                    realObj = cocoabox.cocoaObject;
                }
            }
            
            [invocation setArgument:&realObj atIndex:argPos];
        }
        else if(COMP_ENCODE(argumentType, Class)){
            if([arguments[i] isKindOfClass:NVStackPointerElement.class]){
                NVStackPointerElement *pFrameContainer = (NVStackPointerElement *)(arguments[i]);
                NVObject *pObject = pFrameContainer.object;
                if ([pObject isKindOfClass:NVCocoaClassBox.class]){
                    NVCocoaClassBox *pCls = (NVCocoaClassBox *)(pObject);
                    Class aCls = pCls.cocoaClass;
                    [invocation setArgument:&aCls atIndex:argPos];
                }
            }
        }
//        else if (strcmp("@?", argumentType)==0){
//            auto pointerContainer = dynamic_pointer_cast<NCStackPointerElement>(arguments[i]);
//
//            BOOL buildBlockSuccess = YES;
//            do{
//                if (!pointerContainer) {
//                    buildBlockSuccess = NO;
//                    break;
//                }
//
//                auto lambaObj = dynamic_pointer_cast<NCLambdaObject>(pointerContainer->getPointedObject());
//
//                if (!lambaObj) {
//                    buildBlockSuccess = NO;
//                    break;
//                }
//                auto lambdaObjectCopy = lambaObj->copy();
//
//                auto block_literal_1 = new __block_literal_1;
//                block_literal_1->isa = _NSConcreteGlobalBlock;
//                block_literal_1->flags = CTBlockDescriptionFlagsIsGlobal;
//                block_literal_1->invoke =  __block_invoke_1;
//                block_literal_1->stored_obj = (void*)lambdaObjectCopy;
//
//                [invocation setArgument:&block_literal_1 atIndex:argPos];
//            }
//            while (0);
//
//            if (!buildBlockSuccess) {
//                id argnil = NULL;
//                [invocation setArgument:&argnil atIndex:argPos];
//            }
//        }
        else {
            id argnil = NULL;
            [invocation setArgument:&argnil atIndex:argPos];
        }
    }
    
    [invocation invoke];
    
    const char * returnType = signature.methodReturnType;
    
    if(COMP_ENCODE(returnType, void)){
        return YES;
    }
    if(COMP_ENCODE(returnType, id)){
        __unsafe_unretained id result;
        
        [invocation getReturnValue:&result];
        
        NVCocoaBox * box = [[NVCocoaBox alloc] initWithObject:result];
        NVStackPointerElement *pRet = [[NVStackPointerElement alloc]
                                       initWithObject:box];
        
        [lastStack addObject:pRet];
        
        return YES;
    }
    else {
        NSUInteger length = signature.methodReturnLength;
        void * buffer = (void *)malloc(length);
        [invocation getReturnValue:buffer];
        
        if(COMP_ENCODE(returnType, BOOL)){
            BOOL *pret = (BOOL *)buffer;
            [lastStack addObject:[[NVStackIntElement alloc] initWithInt:(*pret)]];
        }
        else if(COMP_ENCODE(returnType, unsigned int )){
            unsigned int *pret = (unsigned int *)buffer;
            [lastStack addObject:[[NVStackIntElement alloc] initWithInt:(*pret)]];
        }
        else if(COMP_ENCODE(returnType, int)){
            int *pret = (int *)buffer;
            [lastStack addObject:[[NVStackIntElement alloc] initWithInt:(*pret)]];
        }
        else if(COMP_ENCODE(returnType, unsigned long )){
            unsigned long *pret = (unsigned long *)buffer;
            [lastStack addObject:[[NVStackIntElement alloc] initWithInt:(*pret)]];
        }
        else if(COMP_ENCODE(returnType, long)){
            long *pret = ( long *)buffer;
            [lastStack addObject:[[NVStackIntElement alloc] initWithInt:(*pret)]];
        }
        else if(COMP_ENCODE(returnType, unsigned long long)){
            unsigned long long *pret = ( unsigned long long *)buffer;
            [lastStack addObject:[[NVStackIntElement alloc] initWithInt:(*pret)]];
        }
        else if(COMP_ENCODE(returnType, long long)){
            long long *pret = (long long *)buffer;
            [lastStack addObject:[[NVStackIntElement alloc] initWithInt:(*pret)]];
        }
        else if(COMP_ENCODE(returnType, double)){
            double *pret = (double *)buffer;
            [lastStack addObject:[[NVStackFloatElement alloc] initWithFloat:(*pret)]];
        }
        else if(COMP_ENCODE(returnType, float)){
            float *pret = (float *)buffer;
            [lastStack addObject:[[NVStackFloatElement alloc] initWithFloat:(*pret)]];
        }
        else if(COMP_ENCODE(returnType, CGRect)){
            CGRect *pret = (CGRect *)buffer;
            NVRect *pframe = [[NVRect alloc] initWithCGRect:*pret];
 
            [lastStack addObject:[[NVStackPointerElement alloc] initWithObject:pframe]];
        }
        else if(COMP_ENCODE(returnType, CGSize)){
            CGSize *pret = (CGSize *)buffer;
            NVSize *pSize = [[NVSize alloc] initWithCGSize:*pret];
            
            [lastStack addObject:[[NVStackPointerElement alloc] initWithObject:pSize]];
        }
        else if(COMP_ENCODE(returnType, CGPoint)){
            CGPoint *pret = (CGPoint *)buffer;
            NVPoint *pPoint = [[NVPoint alloc] initWithCGPoint:*pret];
            
            [lastStack addObject:[[NVStackPointerElement alloc] initWithObject:pPoint]];
        }
        else if(COMP_ENCODE(returnType, NSRange)){
            NSRange *pret = (NSRange *)buffer;
            NVRange *pRange = [[NVRange alloc] initWithNSRange:*pret];
            
            [lastStack addObject:[[NVStackPointerElement alloc] initWithObject:pRange]];
        }
        else if(COMP_ENCODE(returnType, UIEdgeInsets)){
            UIEdgeInsets *pret = (UIEdgeInsets *)buffer;
            NVEdgeInsets *pInsets = [[NVEdgeInsets alloc] initWithUIEdgeInsets:*pret];
            
            [lastStack addObject:[[NVStackPointerElement alloc] initWithObject:pInsets]];
        }
        else if(COMP_ENCODE(returnType, Class)){
            Class *pret = (Class*)buffer;
            NVCocoaClassBox *pClass = [[NVCocoaClassBox alloc] initWithClass:*pret];
            
            [lastStack addObject:[[NVStackPointerElement alloc] initWithObject:pClass]];
        }
    }
    
    return YES;
}

/*
 covert from A:B:C to A_B_C
 */
+ (NSString *)convertSelectorString:(NSString *)selectorString {
    NSString * converted = [selectorString stringByReplacingOccurrencesOfString:@":" withString:@"_"];
    if ([selectorString characterAtIndex:selectorString.length - 1] == ':') {
        converted = [converted substringToIndex:converted.length-1];
    }
    
    return converted;
}

- (BOOL)nv_invoke:(NSString*)methodName arguments:(NSArray<NVStackElement *> *)arguments  stack:(NVStack *)lastStack {
    return [self nv_invoke:methodName arguments:arguments stack:lastStack];
}

- (NVStackElement *)attributeForName:(NSString *)attrName {
    return nil;
}

@end
