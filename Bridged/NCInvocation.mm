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

struct __block_descriptor_1 _descriptor = { 0, sizeof(struct __block_literal_1)};

int __block_invoke_1(struct __block_literal_1 *_block, ...) {
//    if (!(CTBlockDescriptionFlagsHasSignature & _block->flags)) {
//        //block doesn't have signature, which means we don't know how to assemble arguments.
//        return 0;
//    }
//
//    const char *_sig = NULL;
//
//    if(CTBlockDescriptionFlagsHasCopyDispose & _block->flags){
//        _sig = ((__block_descriptor_1 *)_block->descriptor)->signature;
//    }
//    else {
//        _sig = ((__block_descriptor_2 *)_block->descriptor)->signature;
//    }
//
//    NSMethodSignature * signature = [NSMethodSignature signatureWithObjCTypes:_sig];
    
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

            NCCocoaBox * box = new NCCocoaBox(NC_COCOA_BRIDGE(val));
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
                res = [self private_invoke:aMethod target:aObject?aObject:aClass arguments:arguments stack:lastStack];
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
    
    if(argCount > arguments.size() + 2){
//        NSLog(@"argument count not matched");
        NCLog(NCLogTypeInterpretor, "argument count not matched");
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
//                    id cocoaObj = (id)CFBridgingRelease(cocoabox->getContent());
                    id cocoaObj = SAFE_GET_BOX_CONTENT(cocoabox);
                    realObj = cocoaObj;
                    
                }
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
                auto lambdaObjectCopy = lambaObj->copy();
                
                auto block_literal_1 = new __block_literal_1;
                block_literal_1->isa = _NSConcreteGlobalBlock;
                block_literal_1->flags = CTBlockDescriptionFlagsIsGlobal;
//                block_literal_1->invoke = (void*)(int (*) (__block_literal_1 *, ...) ) __block_invoke_1;
                block_literal_1->invoke =  __block_invoke_1;
                
//                block_literal_1->descriptor = &_descriptor;
//                id str =@"hello world";
//                block_literal_1->stored_obj = (void*)CFBridgingRetain(str);
                
                block_literal_1->stored_obj = (void*)lambdaObjectCopy;
                
                [invocation setArgument:&block_literal_1 atIndex:argPos];
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
        __unsafe_unretained id result;
        
        [invocation getReturnValue:&result];
        
        NCCocoaBox * box = new NCCocoaBox(NC_COCOA_BRIDGE(result));
        
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
    
    return [self.class invoke:methodName object:self orClass:nil arguments:arguments stack:lastStack];
}

-(shared_ptr<NCStackElement>)attributeForName:(const string & )attrName{
    return nullptr;
}

@end
