//
//  NSObject+NCInvocation.m
//  NaiveC
//
//  Created by Liang,Zhiyuan(GIS) on 2018/2/15.
//  Copyright © 2018年 Ogreaxe. All rights reserved.
//

#import "NCInvocation.h"
#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <objc/runtime.h>
#import <objc/message.h>

#include "NCCocoaBox.hpp"
#include "NCCocoaToolkit.hpp"

#include "NCAST.hpp"
#include "NCLog.hpp"
#include "NCInterpreter.hpp"

#import "NPEngine.h"
#import "NPFunction.h"

#import "NCCocoaMapper.h"
#import "NSCocoaSymbolStore.h"

@interface NPFunction(CodeEngine)
@property (nonatomic) NCLambdaObject *blockObj;
@end

static NCInterpreter *g_interpretor = new NCInterpreter();

#define COMP_ENCODE(type, type2) (strcmp(type,@encode(type2)) == 0)

enum {
    CTBlockDescriptionFlagsHasCopyDispose = (1 << 25),
    CTBlockDescriptionFlagsHasCtor = (1 << 26), // helpers have C++ code
    CTBlockDescriptionFlagsIsGlobal = (1 << 28),
    CTBlockDescriptionFlagsHasStret = (1 << 29), // IFF BLOCK_HAS_SIGNATURE
    CTBlockDescriptionFlagsHasSignature = (1 << 30)
};
typedef int CTBlockDescriptionFlags;

struct __block_descriptor_1 {
    unsigned long int reserved;
    unsigned long int Block_size;
    
    // optional helper functions
    void (*copy_helper)(void *dst, void *src);     // IFF (1<<25)
    void (*dispose_helper)(void *src);             // IFF (1<<25)
    // required ABI.2010.3.16
    const char *signature;                         // IFF (1<<30)
    
}
//__block_descriptor_1 = { 0, sizeof(struct __block_literal_1)}
;

struct __block_descriptor_2 {
    unsigned long int reserved;
    unsigned long int Block_size;
    
    // required ABI.2010.3.16
    const char *signature;                         // IFF (1<<30)
};

struct __block_literal_1 {
    void *isa;
    int flags;
    int reserved;
    int (*invoke)(struct __block_literal_1 *, ...);
//    void *invoke;
    struct __block_descriptor_1 *descriptor;
    void * stored_obj;
};

static const char *block_signature(id blockObj)
{
    struct __block_literal_1 *block = (__bridge struct __block_literal_1 *)blockObj;
    struct __block_descriptor_1 *descriptor = block->descriptor;

    int copyDisposeFlag = 1 << 25;
    int signatureFlag = 1 << 30;

    assert(block->flags & signatureFlag);
    
    if(block->flags & copyDisposeFlag) {
        return descriptor->signature;
    } else {
        struct __block_descriptor_2 *descriptor2 = (struct __block_descriptor_2 *)descriptor;
        return descriptor2->signature;
    }
}

struct __block_descriptor_1 _descriptor = { 0, sizeof(struct __block_literal_1)};

int __block_invoke_1(struct __block_literal_1 *_block, ...) {
    NCLambdaObject * lambdaObj = (NCLambdaObject*)(_block->stored_obj);
    auto lambdaExpr = lambdaObj->getLambdaExpression();
    
    vector<shared_ptr<NCStackElement>> argmuments;
    
    va_list vl;
    va_start(vl,_block);
//    for (int i=0; i<[signature numberOfArguments]; i++) {
//        const char * argumentType = [signature getArgumentTypeAtIndex:i];
    
    for (int i=0; i<lambdaExpr->parameters.size(); i++) {
        auto argumentType = lambdaExpr->parameters[i].type;
    
#define COMP_TYPE(t0, t1) (t0=="int")
        if(COMP_TYPE(argumentType, NSInteger)){
            NCInt val=va_arg(vl,NSInteger);
            argmuments.push_back(shared_ptr<NCStackIntElement>(new NCStackIntElement(val)));
        }
        else if(COMP_TYPE(argumentType, NSUInteger)){
            NCInt val=va_arg(vl,NSUInteger);
            argmuments.push_back(shared_ptr<NCStackIntElement>(new NCStackIntElement(val)));
        }
        else if(COMP_TYPE(argumentType, int)){
            NCInt val=va_arg(vl,int);
            argmuments.push_back(shared_ptr<NCStackIntElement>(new NCStackIntElement(val)));
        }
        else if(COMP_TYPE(argumentType, unsigned int)){
            unsigned int val=va_arg(vl,unsigned int);
            argmuments.push_back(shared_ptr<NCStackIntElement>(new NCStackIntElement(val)));
        }
        else if(COMP_TYPE(argumentType, long)){
            long val=va_arg(vl,long);
            argmuments.push_back(shared_ptr<NCStackIntElement>(new NCStackIntElement(val)));
        }
        else if(COMP_TYPE(argumentType, unsigned long)){
            unsigned long val=va_arg(vl,unsigned long);
            argmuments.push_back(shared_ptr<NCStackIntElement>(new NCStackIntElement(val)));
        }
        else if(COMP_TYPE(argumentType, long long)){
            long long val=va_arg(vl,long long);
            argmuments.push_back(shared_ptr<NCStackIntElement>(new NCStackIntElement(val)));
        }
        else if(COMP_TYPE(argumentType, unsigned long long)){
            unsigned long long val=va_arg(vl,unsigned long long);
            argmuments.push_back(shared_ptr<NCStackIntElement>(new NCStackIntElement(val)));
        }
        else if(COMP_TYPE(argumentType, float)){
            float val=va_arg(vl,float);
            argmuments.push_back(shared_ptr<NCStackFloatElement>(new NCStackFloatElement(val)));
        }
        else if(COMP_TYPE(argumentType, double)){
            double val=va_arg(vl,double);
            argmuments.push_back(shared_ptr<NCStackFloatElement>(new NCStackFloatElement(val)));
        }
        else if(COMP_TYPE(argumentType, BOOL)||COMP_TYPE(argumentType, bool)){
            BOOL val=va_arg(vl,BOOL);
            argmuments.push_back(shared_ptr<NCStackIntElement>(new NCStackIntElement(val)));
        }
        else if(COMP_TYPE(argumentType, CGRect)){
            CGRect val=va_arg(vl,CGRect);
            auto rc = new NCRect(val.origin.x,val.origin.y,val.size.width,val.size.height);
            
            argmuments.push_back(shared_ptr<NCStackPointerElement>(new NCStackPointerElement(rc)));
        }
        else if(COMP_TYPE(argumentType, CGSize)){
            CGSize val=va_arg(vl,CGSize);
            auto size = new NCSize(val.width,val.height);
            
            argmuments.push_back(shared_ptr<NCStackPointerElement>(new NCStackPointerElement(size)));
        }
        else if(COMP_TYPE(argumentType, CGPoint)){
            CGPoint val=va_arg(vl,CGPoint);
            auto point = new NCPoint(val.x,val.y);
            
            argmuments.push_back(shared_ptr<NCStackPointerElement>(new NCStackPointerElement(point)));
        }
        else if(COMP_TYPE(argumentType, NSRange)){
            NSRange val=va_arg(vl,NSRange);
            auto range = new NCRange(val.location,val.length);
            argmuments.push_back(shared_ptr<NCStackPointerElement>(new NCStackPointerElement(range)));
        }
        else if(COMP_TYPE(argumentType, UIEdgeInsets)){
            UIEdgeInsets val=va_arg(vl,UIEdgeInsets);
            auto insets = new NCEdgeInset(val.top,val.left,val.bottom,val.right);
            argmuments.push_back(shared_ptr<NCStackPointerElement>(new NCStackPointerElement(insets)));
        }
        else if(COMP_TYPE(argumentType, id)){
            //nsobject
            id val=va_arg(vl,id);

//            NCCocoaBox * box = new NCCocoaBox(NC_COCOA_BRIDGE(val));
            NCCocoaBox * box = new NCCocoaBox();
            LINK_COCOA_BOX(box, val);
            
            NCStackPointerElement * pBox = new NCStackPointerElement(shared_ptr<NCObject>( box));
            argmuments.push_back(shared_ptr<NCStackElement>(pBox));
        } else if(COMP_TYPE(argumentType, Class)){
            //class
            id val = va_arg(vl,Class);

            NCOcClass * pCls = new NCOcClass((__bridge void *)(val));
            NCStackPointerElement * pElement = new NCStackPointerElement(shared_ptr<NCObject>(pCls));
            argmuments.push_back(shared_ptr<NCStackElement>(pElement));
        }
//        else if (strcmp("@?", argumentType)==0){
//            //block. not support yet
//        }
        else {
            //none match
        }
    }
    va_end(vl);
    
    NCFrame frame;
    
    for (int i=0; i<argmuments.size(); i++) {
        auto para = lambdaExpr->parameters[i];
        frame.insertVariable(para.name, argmuments[i]);
    }
    //insert captured objects
    auto capturedObjs = lambdaObj->getCapturedObjects();
    for (auto & captured : capturedObjs) {
//        frame.insertVariable(captured.name, captured.object);
    }
    
    g_interpretor->visit(lambdaExpr->blockStmt, frame);
    /*
    va_list vl;
    
    va_start(vl,_block);
    for (int i=0;i<1;i++)
    {
        int val=va_arg(vl,int);
        printf (" val is %d",val);
    }
    va_end(vl);
     */
    
    return 1;
}

@implementation NCInvocation

+(BOOL)invoke:(NSString*)methodName object:(NSObject*)aObject orClass:(Class)aClass arguments:(vector<shared_ptr<NCStackElement>> &)arguments stack:(vector<shared_ptr<NCStackElement>>& )lastStack {
    return [self invoke:methodName object:aObject orClass:aClass arguments:arguments stack:lastStack isSuper:NO];
}

+(BOOL)invokeSuper:(NSString*)methodName object:(NSObject*)aObject orClass:(Class)aClass arguments:(vector<shared_ptr<NCStackElement>> &)arguments stack:(vector<shared_ptr<NCStackElement>>& )lastStack {
    return [self invoke:methodName object:aObject orClass:aClass arguments:arguments stack:lastStack isSuper:YES];
}

+(BOOL)invoke:(NSString*)methodName object:(NSObject*)aObject orClass:(Class)aClass arguments:(vector<shared_ptr<NCStackElement>> &)arguments stack:(vector<shared_ptr<NCStackElement>>& )lastStack isSuper:(BOOL)isSuper {
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
                res = [self private_invoke:aMethod 
                                    target:aObject?aObject:aClass
                                 arguments:arguments
                                     stack:lastStack
                                   isSuper:isSuper];
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

+ (BOOL)private_invoke:(Method)method target:(id)target arguments:(vector<shared_ptr<NCStackElement>> &)arguments stack:(vector<shared_ptr<NCStackElement>>& )lastStack  isSuper:(BOOL)isSuper {
    int argCount = method_getNumberOfArguments(method);
    
    if(argCount > arguments.size() + 2){
//        NSLog(@"argument count not matched");
        NCLog(NCLogTypeInterpretor, "argument count not matched");
        return NO;
    }
    
    bool isBlock = [target isKindOfClass:NSClassFromString(@"NSBlock")];
    
    SEL selector = method_getName(method);
    NSMethodSignature * signature = [target methodSignatureForSelector:selector];
    
    if (isBlock) {
        NSString *blockSignature = objc_getAssociatedObject(target, "_block_signature");
        if (blockSignature){
            //this block is generated by genCallbackBlock() in NPEngine
            signature = [NSMethodSignature signatureWithObjCTypes:blockSignature.UTF8String];
        } else {
            const char *pSign = block_signature(target);
            
            if (pSign) {
                // is normal block
                signature = [NSMethodSignature signatureWithObjCTypes:pSign];
            }
        }
    }
    
    if (isSuper) {
        NSString *selectorName = NSStringFromSelector(selector);
        
        Class cls = object_getClass(target);
        Class superCls = [cls superclass];
        
        NSString *superSelectorName = [NSString stringWithFormat:@"NP_SUPER_%@", selectorName];
        SEL superSelector = NSSelectorFromString(superSelectorName);
        
        Method superMethod = class_getInstanceMethod(superCls, selector);
        IMP superIMP = method_getImplementation(superMethod);
        
        class_addMethod(cls, superSelector, superIMP, method_getTypeEncoding(superMethod));
        
        selector = superSelector;
    }
    
    NSInvocation *invocation = [NSInvocation invocationWithMethodSignature:signature];
    [invocation setSelector:selector];
    [invocation setTarget:target];
    
    int argOffset = 2; //normal selector takes self at #1 and sel at #2
    
    if (isBlock) {
        argOffset = 1; //block takes block itself at #1
    }
    
    for(int i = 0;i < argCount - argOffset;i++){
#define TYPE_BUFFER_SIZE 128
        char argumentType[TYPE_BUFFER_SIZE];
        
        int argPos = i + argOffset;
//        method_getArgumentType(method, argPos, argumentType, TYPE_BUFFER_SIZE);
        
//        if (isBlock) 
        {
            strcpy(argumentType, [signature getArgumentTypeAtIndex:argPos]);
        }
        
        if (!arguments[i]) {
            NSString * notfoundMsg = [NSString stringWithFormat:@"argument:%d is null",i];
            NCLog(NCLogTypeInterpretor, notfoundMsg.UTF8String);
            
            return NO;
        }
        
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
        else if(COMP_ENCODE(argumentType, NSRange)){
            if(dynamic_pointer_cast<NCStackPointerElement>(arguments[i])){
                auto pFrameContainer = dynamic_pointer_cast<NCStackPointerElement>(arguments[i]);
                auto pObject = pFrameContainer->getPointedObject();
                if(pObject && dynamic_pointer_cast<NCRange>(pObject)){
                    auto pRange = dynamic_pointer_cast<NCRange>(pObject);
                    NSRange range = NSMakeRange(pRange->getLocation(), pRange->getLength());
                    [invocation setArgument:&range atIndex:argPos];
                }
            }
        }
        else if(COMP_ENCODE(argumentType, UIEdgeInsets)){
            if(dynamic_pointer_cast<NCStackPointerElement>(arguments[i])){
                auto pFrameContainer = dynamic_pointer_cast<NCStackPointerElement>(arguments[i]);
                auto pObject = pFrameContainer->getPointedObject();
                if(pObject && dynamic_pointer_cast<NCEdgeInset>(pObject)){
                    auto pInsets = dynamic_pointer_cast<NCEdgeInset>(pObject);
                    UIEdgeInsets insets = UIEdgeInsetsMake(pInsets->getTop(), pInsets->getLeft(), pInsets->getBottom(), pInsets->getRight());
                    [invocation setArgument:&insets atIndex:argPos];
                }
            }
        }
        else if(COMP_ENCODE(argumentType, UIEdgeInsets)){
            if(dynamic_pointer_cast<NCStackPointerElement>(arguments[i])){
                auto pFrameContainer = dynamic_pointer_cast<NCStackPointerElement>(arguments[i]);
                auto pObject = pFrameContainer->getPointedObject();
                if(pObject && dynamic_pointer_cast<NCEdgeInset>(pObject)){
                    auto pInsets = dynamic_pointer_cast<NCEdgeInset>(pObject);
                    UIEdgeInsets insets = UIEdgeInsetsMake(pInsets->getTop(), pInsets->getLeft(), pInsets->getBottom(), pInsets->getRight());
                    [invocation setArgument:&insets atIndex:argPos];
                }
            }
        } 
        else if(COMP_ENCODE(argumentType, id)){
            auto& stackElement = arguments[i];
            id realObj = NULL;
//            if(dynamic_pointer_cast<NCStackStringElement>(stackElement)){
//                auto pstr = dynamic_pointer_cast<NCStackStringElement>(stackElement);
//                NSString * nsstr = [NSString stringWithUTF8String: pstr->toString().c_str()];
//                realObj = nsstr;
//            }
//            else if(dynamic_pointer_cast<NCStackPointerElement>(stackElement)){
//                auto pointerContainer = dynamic_pointer_cast<NCStackPointerElement>(stackElement);
//                auto payloadObj = pointerContainer->getPointedObject();
//                if(payloadObj && dynamic_pointer_cast<NCCocoaBox>(payloadObj)){
//                    auto cocoabox = dynamic_pointer_cast<NCCocoaBox>(payloadObj);
////                    id cocoaObj = (id)CFBridgingRelease(cocoabox->getContent());
//                    id cocoaObj = GET_NS_OBJECT_P(cocoabox);
//                    realObj = cocoaObj;
//                    
//                }
//            }
            
            auto payloadObj = stackElement->toObject();
            
            if (payloadObj && dynamic_pointer_cast<NCCocoaBox>(payloadObj)){
                auto cocoabox = dynamic_pointer_cast<NCCocoaBox>(payloadObj);
                
                realObj = GET_NS_OBJECT_P(cocoabox);
            }
            
            [invocation setArgument:&realObj atIndex:argPos];
        }
        else if(COMP_ENCODE(argumentType, Class)){
            if(dynamic_pointer_cast<NCStackPointerElement>(arguments[i])){
                auto pFrameContainer = dynamic_pointer_cast<NCStackPointerElement>(arguments[i]);
                auto pObject = pFrameContainer->getPointedObject();
                if(pObject && dynamic_pointer_cast<NCOcClass>(pObject)){
                    auto pCls = dynamic_pointer_cast<NCOcClass>(pObject);
                    Class aCls = (__bridge Class)pCls->getClass;
                    [invocation setArgument:&aCls atIndex:argPos];
                }
            }
        }
        else if(COMP_ENCODE(argumentType, SEL)){
            auto pointer = dynamic_pointer_cast<NCStackPointerElement>(arguments[i]);
            
            if (pointer) {
                auto selStr = pointer->toString();
                
                SEL selector = NSSelectorFromString([NSString stringWithUTF8String:selStr.c_str()]);
                
                [invocation setArgument:&selector atIndex:argPos];
            }
        }
        else if (strcmp("@?", argumentType)==0){
            auto pointerContainer = dynamic_pointer_cast<NCStackPointerElement>(arguments[i]);
            
            BOOL buildBlockSuccess = YES;
            do{
                if (!pointerContainer) {
                    buildBlockSuccess = NO;
                    break;
                }
                
                auto lambaObj = dynamic_pointer_cast<NCLambdaObject>(pointerContainer->getPointedObject());
                
                if (!lambaObj) {
                    buildBlockSuccess = NO;
                    break;
                }
                
//                NCLambdaObject * lambdaObjectCopy = new NCLambdaObject(lambaObj->getLambdaExpression());
//                auto lambdaObjectCopy = lambaObj->copy();
                
//                auto block_literal_1 = new __block_literal_1;
//                block_literal_1->isa = _NSConcreteGlobalBlock;
//                block_literal_1->flags = CTBlockDescriptionFlagsIsGlobal;
//                block_literal_1->invoke =  __block_invoke_1;
//                block_literal_1->stored_obj = (void*)lambdaObjectCopy;
//                [invocation setArgument:&block_literal_1 atIndex:argPos];
                
                auto lambdaExpr = lambaObj->getLambdaExpression();
                
                NSMutableArray *args = [NSMutableArray array];
                
                [args addObject:@"block"];
                
                for (int i=0; i<lambdaExpr->parameters.size(); i++) {
                    auto argumentType = lambdaExpr->parameters[i].type;
                    NSString *typeStr = [NSString stringWithUTF8String:argumentType.c_str()];
                    
                    [args addObject:typeStr];
                }
                
                id genBlock = [NPEngine genCallbackBlock:args];
                
                NPFunction *func = [[NPFunction alloc] init];
                func.blockObj = lambaObj.get();
                
                objc_setAssociatedObject(genBlock, "_JSValue", func, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
                
                [invocation setArgument:&genBlock atIndex:argPos];
            }
            while (0);
            
            if (!buildBlockSuccess) {
                id argnil = NULL;
                [invocation setArgument:&argnil atIndex:argPos];
            }
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
//        __unsafe_unretained id result;
//        [invocation getReturnValue:&result];
        NSString *selStr = NSStringFromSelector(selector);
        
        NCCocoaBox * box = new NCCocoaBox();
        
        if ([selStr hasPrefix:@"init"] || [selStr isEqualToString:@"new"]) {
            //init/new doesn't put returned value into autoreleaspool, so use id to let ARC generate release correctly
            id result;
            [invocation getReturnValue:&result];
            
            LINK_COCOA_BOX(box, result);
        } else {
            //otherwise do not retain anything to avoid over-releasing
            __unsafe_unretained id result;
            [invocation getReturnValue:&result];
            
            LINK_COCOA_BOX(box, result);
        }

        NCStackPointerElement * pRet = new NCStackPointerElement(shared_ptr<NCObject>(box));
        
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
        else if(COMP_ENCODE(returnType, NSRange)){
            NSRange *pret = (NSRange *)buffer;
            NCRange * pRange = new NCRange(pret->location,pret->length);
            lastStack.push_back(shared_ptr<NCStackPointerElement>(new NCStackPointerElement(pRange)));
        }
        else if(COMP_ENCODE(returnType, UIEdgeInsets)){
            UIEdgeInsets *pret = (UIEdgeInsets *)buffer;
            NCEdgeInset * pInsets = new NCEdgeInset(pret->top,pret->left,pret->bottom,pret->right);
            lastStack.push_back(shared_ptr<NCStackPointerElement>(new NCStackPointerElement(pInsets)));
        }
        else if(COMP_ENCODE(returnType, Class)){
            Class *pCls = (Class*)buffer;
            Class cls = *pCls;
            auto pOcCls = new NCOcClass((__bridge void *)cls);
            lastStack.push_back(shared_ptr<NCStackPointerElement>(new NCStackPointerElement(pOcCls)));
        }
    }
    
    return YES;
}

/*
 covert from A:B:C to A_B_C
 */
+ (NSString *) convertSelectorString:(NSString *) selectorString{
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

- (BOOL)invoke:(NSString*)methodName arguments:(vector<shared_ptr<NCStackElement>> &)arguments stack:(vector<shared_ptr<NCStackElement>>& )lastStack{
    
    return [self.class invoke:methodName object:self orClass:nil arguments:arguments stack:lastStack];
}

- (shared_ptr<NCStackElement>)attributeForName:(const string & )attrName{
    return nullptr;
}

+ (shared_ptr<NCStackElement>)instanceVariableForName:(NSString*)ivarName withObject:(NSObject*)aObject {
    NSObject *val = [aObject valueForKey:ivarName];
    
    if (!val) return nullptr;
    
    shared_ptr<NCStackElement> ret = nullptr;
    
    if ([val isKindOfClass:NSNumber.class]) {
        NSNumber *numberVal = (NSNumber *)val;
        
        const char *type = numberVal.objCType;
        
        if(COMP_ENCODE(type, BOOL)){
            BOOL pret = numberVal.boolValue;
            ret = shared_ptr<NCStackElement>(new NCStackIntElement(pret));
        }
        else if(COMP_ENCODE(type, unsigned int)){
            unsigned int pret = numberVal.unsignedIntValue;
            ret = shared_ptr<NCStackElement>(new NCStackIntElement(pret));
        }
        else if(COMP_ENCODE(type, int)){
            int pret = numberVal.intValue;
            ret = shared_ptr<NCStackElement>(new NCStackIntElement(pret));
        }
        else if(COMP_ENCODE(type, unsigned long)){
            unsigned long pret = numberVal.unsignedLongValue;
            ret = shared_ptr<NCStackElement>(new NCStackIntElement(pret));
        }
        else if(COMP_ENCODE(type, long)){
            long pret = numberVal.longValue;
            ret = shared_ptr<NCStackElement>(new NCStackIntElement(pret));
        }
        else if(COMP_ENCODE(type, unsigned long long)){
            unsigned long long pret = numberVal.unsignedLongLongValue;
            ret = shared_ptr<NCStackElement>(new NCStackIntElement(pret));
        }
        else if(COMP_ENCODE(type, long long)){
            long long pret = numberVal.longLongValue;
            ret = shared_ptr<NCStackElement>(new NCStackIntElement(pret));
        }
        else if(COMP_ENCODE(type, double)){
            double pret = numberVal.doubleValue;
            ret = shared_ptr<NCStackElement>(new NCStackIntElement(pret));
        }
        else if(COMP_ENCODE(type, float)){
            float pret = numberVal.floatValue;
            ret = shared_ptr<NCStackElement>(new NCStackIntElement(pret));
        }
        
    } else if ([val isKindOfClass:NSValue.class]) {
        NSValue *value = (NSValue *)val;
        
        const char *type = value.objCType;
        
        if(COMP_ENCODE(type, CGRect)){
            CGRect pret = value.CGRectValue;
            NCRect * pframe = new NCRect(pret.origin.x,pret.origin.y,pret.size.width,pret.size.height);
            ret = shared_ptr<NCStackPointerElement>(new NCStackPointerElement(pframe));
        }
        else if(COMP_ENCODE(type, CGSize)){
            CGSize pret = value.CGSizeValue;
            NCSize * pSize = new NCSize(pret.width,pret.height);
            ret = shared_ptr<NCStackPointerElement>(new NCStackPointerElement(pSize));
        }
        else if(COMP_ENCODE(type, CGPoint)){
            CGPoint pret = value.CGPointValue;
            NCPoint * pPoint = new NCPoint(pret.x,pret.y);
            ret = shared_ptr<NCStackPointerElement>(new NCStackPointerElement(pPoint));
        }
        else if(COMP_ENCODE(type, NSRange)){
            NSRange pret = value.rangeValue;
            NCRange * pRange = new NCRange(pret.location,pret.length);
            ret = shared_ptr<NCStackPointerElement>(new NCStackPointerElement(pRange));
        }
        else if(COMP_ENCODE(type, UIEdgeInsets)){
            UIEdgeInsets pret = value.UIEdgeInsetsValue;
            NCEdgeInset * pInsets = new NCEdgeInset(pret.top,pret.left,pret.bottom,pret.right);
            ret = shared_ptr<NCStackPointerElement>(new NCStackPointerElement(pInsets));
        }
    } else if ([val isKindOfClass:NSValue.class]) {
        Class pCls = (Class)val;
        auto pOcCls = new NCOcClass((__bridge void *)pCls);
        ret = shared_ptr<NCStackPointerElement>(new NCStackPointerElement(pOcCls));
    } else {
        //id
//        NCCocoaBox * box = new NCCocoaBox(NC_COCOA_BRIDGE(val));
        
        NCCocoaBox * box = new NCCocoaBox();
        LINK_COCOA_BOX(box, val);
        
        ret = shared_ptr<NCStackPointerElement>(new NCStackPointerElement(shared_ptr<NCObject>(box)));
    }
    
    return ret;
}

NSObject *NSObjectFromStackElement(NCStackElement *e) {
    auto p = dynamic_cast<NCStackPointerElement *>(e);
    
    if (!p) return NULL;
    
//    auto box = dynamic_cast<NCCocoaBox *>(p->getPointedObject().get());
    
    auto box = dynamic_pointer_cast<NCCocoaBox>(p->getPointedObject());
    
    if (!box) return NULL;
    
//    auto c = box->getContent();
//    
//    NSObject *nso = (__bridge NSObject*)c;
    
//    return nso;
    
    return GET_NS_OBJECT_P(box);
}

+ (NSDictionary *)genObjectWithStackElement:(shared_ptr<NCStackElement>)element {
    NSString *objectType;
    id object;
    
    do{
        auto pStackTop = element.get();
 
        auto intElement = dynamic_cast<NCStackIntElement*>(pStackTop);
        
        if(intElement){
            object = @(intElement->value);
            objectType = @"q";
            break;
        }
        
        auto floatElement = dynamic_cast<NCStackFloatElement*>(pStackTop);
        
        if(floatElement){
            object = @(floatElement->value);
            objectType = @"d";
            break;
        }
        
        id nsObj = NSObjectFromStackElement(pStackTop);
        
        if (nsObj) {
            if ([nsObj isKindOfClass:NSNumber.class]) {
                NSNumber *num = nsObj;
                
                if (num.isPrimitive) {
                    object = num;
                    objectType = [NSString stringWithUTF8String:num.objCType];
                    break;
                }
            }
            
            object = nsObj;
            objectType = @"@";
        }
    } while (0);
    
    if (objectType && object) {
        return @{@"type":objectType,
                 @"object":object};
    }
    
    return NULL;
}

+ (void)setInstanceVariable:(shared_ptr<NCStackElement>)ivar forName:(NSString*)ivarName withObject:(NSObject*)aObject {
    id val = [NCInvocation genObjectWithStackElement:ivar][@"object"];
    
    if (val) {
        [aObject setValue:val forKey:ivarName];
    }
}

@end
