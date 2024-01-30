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

@interface NPValue ()
@property (nonatomic) NCStackElement *stackElement;
@end

@implementation NPValue

extern NCStackElement *CreateStackElementFromRect(CGRect rect);

+ (NPValue *)numberWithNumber:(NSNumber *)number type:(char)type{
    NPValue *n = [NPValue new];
    do {
#define NP_MAKE_STACK_ELEMENT(_typeChar, _call, nctype, elementType) \
    if (type == _typeChar) {  \
        nctype v = [number _call]; \
        n.stackElement = new elementType(v); \
        break;  \
    }\
        
        NP_MAKE_STACK_ELEMENT('c', charValue, NCInt, NCStackIntElement)
//        JP_FWD_ARG_CASE('C', unsigned char)
        NP_MAKE_STACK_ELEMENT('c', unsignedCharValue, NCInt, NCStackIntElement)
//        JP_FWD_ARG_CASE('s', short)
        NP_MAKE_STACK_ELEMENT('c', shortValue, NCInt, NCStackIntElement)
//        JP_FWD_ARG_CASE('S', unsigned short)
        NP_MAKE_STACK_ELEMENT('c', unsignedShortValue, NCInt, NCStackIntElement)
//        JP_FWD_ARG_CASE('i', int)
        NP_MAKE_STACK_ELEMENT('c', intValue, NCInt, NCStackIntElement)
//        JP_FWD_ARG_CASE('I', unsigned int)
        NP_MAKE_STACK_ELEMENT('c', unsignedIntValue, NCInt, NCStackIntElement)
//        JP_FWD_ARG_CASE('l', long)
        NP_MAKE_STACK_ELEMENT('c', longValue, NCInt, NCStackIntElement)
//        JP_FWD_ARG_CASE('L', unsigned long)
        NP_MAKE_STACK_ELEMENT('c', unsignedLongValue, NCInt, NCStackIntElement)
//        JP_FWD_ARG_CASE('q', long long)
        NP_MAKE_STACK_ELEMENT('c', longLongValue, NCInt, NCStackIntElement)
//        JP_FWD_ARG_CASE('Q', unsigned long long)
        NP_MAKE_STACK_ELEMENT('c', unsignedLongLongValue, NCInt, NCStackIntElement)
//        JP_FWD_ARG_CASE('f', float)
        NP_MAKE_STACK_ELEMENT('c', floatValue, NCFloat, NCStackFloatElement)
//        JP_FWD_ARG_CASE('d', double)
        NP_MAKE_STACK_ELEMENT('c', doubleValue, NCFloat, NCStackFloatElement)
//        JP_FWD_ARG_CASE('B', BOOL)
        NP_MAKE_STACK_ELEMENT('c', boolValue, NCInt, NCStackIntElement)
    } while(0);
    
    return n;
}

+ (NPValue *)valueWithRect:(CGRect)rect {
    NPValue *v = [NPValue new];
    NCRect *ncRect = new NCRect(rect.origin.x, rect.origin.y, rect.size.width, rect.size.height);
    v.stackElement = new NCStackPointerElement(ncRect);
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

- (id)toObject {
    return NULL;
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

@implementation NPFunction

- (NPValue *)callWithArguments:(NSArray<NPValue*> *)args {
    NSError *error;
    id ret = [[NCCodeEngine_iOS defaultEngine] runWithMethod:self.method arguments:args error:&error];
    return NULL;
}

@end
