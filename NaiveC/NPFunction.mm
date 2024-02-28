//
//  NPFunction.m
//  NaivePatch
//
//  Created by mi on 2024/1/22.
//

#import "NPFunction.h"
#include "NCStackElement.hpp"
#include "NCCocoaToolkit.hpp"
#import "NCCodeEngine_iOS.h"
#include "NCCocoaBox.hpp"

@interface NPValue ()
@property (nonatomic) shared_ptr<NCStackElement> stackElement;

@property (nonatomic) id object;

@property (nonatomic) NSString *objectType;

@end

@implementation NPValue

extern NCStackElement *CreateStackElementFromRect(CGRect rect);

+ (NPValue *)numberWithNumber:(NSNumber *)number type:(char)type{
    NPValue *n = [NPValue new];
    do {
#define NP_MAKE_STACK_ELEMENT(_typeChar, _call, nctype, elementType) \
    if (type == _typeChar) {  \
        nctype v = [number _call]; \
        n.stackElement = shared_ptr<NCStackElement>(new elementType(v)); \
        break;  \
    }\
//        JP_FWD_ARG_CASE('c', unsigned char)
        NP_MAKE_STACK_ELEMENT('c', charValue, NCInt, NCStackIntElement)
//        JP_FWD_ARG_CASE('C', unsigned char)
        NP_MAKE_STACK_ELEMENT('C', unsignedCharValue, NCInt, NCStackIntElement)
//        JP_FWD_ARG_CASE('s', short)
        NP_MAKE_STACK_ELEMENT('s', shortValue, NCInt, NCStackIntElement)
//        JP_FWD_ARG_CASE('S', unsigned short)
        NP_MAKE_STACK_ELEMENT('S', unsignedShortValue, NCInt, NCStackIntElement)
//        JP_FWD_ARG_CASE('i', int)
        NP_MAKE_STACK_ELEMENT('i', intValue, NCInt, NCStackIntElement)
//        JP_FWD_ARG_CASE('I', unsigned int)
        NP_MAKE_STACK_ELEMENT('I', unsignedIntValue, NCInt, NCStackIntElement)
//        JP_FWD_ARG_CASE('l', long)
        NP_MAKE_STACK_ELEMENT('l', longValue, NCInt, NCStackIntElement)
//        JP_FWD_ARG_CASE('L', unsigned long)
        NP_MAKE_STACK_ELEMENT('L', unsignedLongValue, NCInt, NCStackIntElement)
//        JP_FWD_ARG_CASE('q', long long)
        NP_MAKE_STACK_ELEMENT('q', longLongValue, NCInt, NCStackIntElement)
//        JP_FWD_ARG_CASE('Q', unsigned long long)
        NP_MAKE_STACK_ELEMENT('Q', unsignedLongLongValue, NCInt, NCStackIntElement)
//        JP_FWD_ARG_CASE('f', float)
        NP_MAKE_STACK_ELEMENT('f', floatValue, NCFloat, NCStackFloatElement)
//        JP_FWD_ARG_CASE('d', double)
        NP_MAKE_STACK_ELEMENT('d', doubleValue, NCFloat, NCStackFloatElement)
//        JP_FWD_ARG_CASE('B', BOOL)
        NP_MAKE_STACK_ELEMENT('B', boolValue, NCInt, NCStackIntElement)
    } while(0);
    
    return n;
}

+ (NPValue *)valueWithRect:(CGRect)rect {
    NPValue *v = [NPValue new];
    NCRect *ncRect = new NCRect(rect.origin.x, rect.origin.y, rect.size.width, rect.size.height);
    v.stackElement = shared_ptr<NCStackPointerElement>(new NCStackPointerElement(ncRect));
    return NULL;
}

+ (NPValue *)valueWithPoint:(CGPoint)point {
    return NULL;
}

+ (NPValue *)valueWithSize:(CGSize)size {
    return NULL;
}

+ (NPValue *)valueWithRange:(NSRange)range {
    return NULL;
}

+ (NPValue *)valueWithInset:(UIEdgeInsets)inset {
    return NULL;
}

NSObject *NSObjectFromStackElement(NCStackElement *e) {
    auto p = dynamic_cast<NCStackPointerElement *>(e);
    
    if (!p) return NULL;
    
    auto box = dynamic_cast<NCCocoaBox *>(p->getPointedObject().get());
    
    if (!box) return NULL;
    
    auto c = box->getContent();
    
    NSObject *nso = (__bridge NSObject*)c;
    
    return nso;
}

- (id)toObject {
//    do{
//        auto pStackTop = self.stackElement.get();
//        
//        auto intElement = dynamic_cast<NCStackIntElement*>(pStackTop);
//        
//        if(intElement){
//            return @(intElement->value);
//            break;
//        }
//        
//        auto floatElement = dynamic_cast<NCStackFloatElement*>(pStackTop);
//        
//        if(floatElement){
//            return @(floatElement->value);
//            break;
//        }
//        
//        id nsObj = NSObjectFromStackElement(pStackTop);
//        
//        if (nsObj) {
//            return nsObj;
//        }
//    } while (0);
//    
//    return NULL;
    
    return self.object;
}

- (void)genObject {
    do{
        auto pStackTop = self.stackElement.get();
        
        auto intElement = dynamic_cast<NCStackIntElement*>(pStackTop);
        
        if(intElement){
            self.object = @(intElement->value);
            self.objectType = @"q";
            break;
        }
        
        auto floatElement = dynamic_cast<NCStackFloatElement*>(pStackTop);
        
        if(floatElement){
            self.object = @(floatElement->value);
            self.objectType = @"d";
            break;
        }
        
        id nsObj = NSObjectFromStackElement(pStackTop);
        
        if (nsObj) {
            self.object = nsObj;
            self.objectType = @"@";
        }
    } while (0);
}

- (CGRect)toRect {
    return CGRectZero;
}

- (CGPoint)toPoint {
    return CGPointZero;
}

- (CGSize)toSize {
    return CGSizeZero;
}

- (NSRange)toRange {
    return NSMakeRange(0, 0);
}

@end

@interface NPFunction()

@property (nonatomic) NCLambdaObject *blockObj;

@end

@implementation NPFunction

- (NPValue *)callWithArguments:(NSArray<NPValue*> *)args {
    NSError *error;
    NPValue *ret = [[NCCodeEngine_iOS defaultEngine] runWithFunction:self arguments:args error:&error];
    [ret genObject];
    return ret;
}

@end
