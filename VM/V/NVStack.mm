//
//  NVStackElement.m
//  NaiveC
//
//  Created by liangzhiyuan on 2021/12/13.
//  Copyright © 2021 Ogreaxe. All rights reserved.
//

#import "NVStack.h"
#import "NVLiteral+VM.h"
#include "nv_operator.hpp"

//float doOperatorPrimitive(float left, float right, NSString *op){
//    if ([op isEqualToString:@"+"]) {
//        return left + right;
//    }
//    else if ([op isEqualToString:@"-"]) {
//        return left - right;
//    }
//    else if ([op isEqualToString:@"*"]) {
//        return left * right;
//    }
//    else if ([op isEqualToString:@"/"]) {
//        return left / right;
//    }
//    else {
//        return left;
//    }
//}

@implementation NVStackElement

+ (NVStackElement *)stackElementWithLiteral:(NVLiteral*)literal {
    return [literal toStackElement];
}

- (NVStackElement *)doOperator:(NSString *)op rightOperand:(NVStackElement *)rightOperand {
    if ([op isEqualToString:@"+"]
        ||[op isEqualToString:@"-"]
        ||[op isEqualToString:@"*"]
        ||[op isEqualToString:@"/"]
        ||[op isEqualToString:@"%"]
        ||[op isEqualToString:@"|"]
        ||[op isEqualToString:@"&"]) {
        
        return [self doOperatorPrimitive:op rightOperand:rightOperand];
    }
    else if ([op isEqualToString:@"&&"]
             ||[op isEqualToString:@"||"]
             ||[op isEqualToString:@">"]
             ||[op isEqualToString:@"<"]
             ||[op isEqualToString:@">="]
             ||[op isEqualToString:@"<="]
             ||[op isEqualToString:@"!="]
             ||[op isEqualToString:@"=="]) {
        return [self doRelationalOperator:op rightOperand:rightOperand];
    }
    
    return nil;
}

- (NVStackElement *)doOperatorPrimitive:(NSString *)op rightOperand:(NVStackElement *)rightOperand {
    return nil;
}

- (NVStackElement *)doRelationalOperator:(NSString *)op rightOperand:(NVStackElement *)rightOperand {
    return nil;
}

@end

@implementation NVStackIntElement

- (id)initWithInt:(int)value {
    self = [super init];
    self.value = value;
    return self;
}

- (NVInt)toInt {
    return self.value;
}

- (NVFloat)toFloat {
    return self.value;
}

- (NSString *)toString {
    return [NSString stringWithFormat:@"%d", self.value];
}

- (NVStackElement *)doOperatorPrimitive:(NSString *)op rightOperand:(NVStackElement *)rightOperand {
    const string opStr([op UTF8String]);
    int result = doOperatorPrimitive(self.value, [rightOperand toInt], opStr);
    return [[NVStackIntElement alloc] initWithInt:result];
}

- (NVStackElement *)doRelationalOperator:(NSString *)op rightOperand:(NVStackElement *)rightOperand {
    const string opStr([op UTF8String]);
    int result = doRelationalOperator(self.value, [rightOperand toInt], opStr);
    return [[NVStackIntElement alloc] initWithInt:result];
}

- (NVStackElement *)copy {
    return [[NVStackIntElement alloc] initWithInt:self.value];
}

@end

@implementation NVStackFloatElement

- (id)initWithFloat:(float)value {
    self = [super init];
    self.value = value;
    return self;
}

- (NVInt)toInt {
    return self.value;
}

- (NVFloat)toFloat {
    return self.value;
}

- (NSString *)toString {
    return [NSString stringWithFormat:@"%.5f", self.value];
}

- (NVStackElement *)doOperatorPrimitive:(NSString *)op rightOperand:(NVStackElement *)rightOperand {
    const string opStr([op UTF8String]);
    int result = doOperatorPrimitive(self.value, [rightOperand toFloat], opStr);
    return [[NVStackFloatElement alloc] initWithFloat:result];
}

- (NVStackElement *)doRelationalOperator:(NSString *)op rightOperand:(NVStackElement *)rightOperand {
    const string opStr([op UTF8String]);
    int result = doRelationalOperator(self.value, [rightOperand toFloat], opStr);
    return [[NVStackIntElement alloc] initWithInt:result];
}

- (NVStackElement *)copy {
    return [[NVStackFloatElement alloc] initWithFloat:self.value];
}

@end


@implementation NVStackStringElement

- (id)initWithString:(NSString *)str {
    self = [super init];
    self.str = str;
    return self;
}

- (NVInt)toInt {
    return self.str.intValue;
}

- (NVFloat)toFloat {
    return self.str.floatValue;
}

- (NSString *)toString {
    return self.str;
}

- (NVStackElement *)doOperator:(NSString *)op rightOperand:(NVStackElement *)rightOperand {
    if ([op isEqualToString:@"+"]) {
        NSString *ret = [NSString stringWithFormat:@"%@%@", self.str, [rightOperand toString]];
        return [[NVStackStringElement alloc] initWithString:ret];
        
    }
    else if ([op isEqualToString:@"=="]) {
        BOOL equal = [self.str isEqualToString:[rightOperand toString]];
        return [[NVStackIntElement alloc] initWithInt:equal];
    }
    else if ([op isEqualToString:@"!="]) {
        BOOL equal = [self.str isEqualToString:[rightOperand toString]];
        return [[NVStackIntElement alloc] initWithInt:!equal];
        
    }
    else if ([op isEqualToString:@"&&"]) {
        return [[NVStackIntElement alloc] initWithInt:[rightOperand toInt]];
    }
    
    return [[NVStackIntElement alloc] initWithInt:1];
}

- (NVStackElement *)copy {
    return [[NVStackStringElement alloc] initWithString:self.str];
}

@end

@implementation NVStackVariableElement

- (id)initWithName:(NSString *)name value:(NVStackElement *)value {
    self = [super init];
    
    self.name = name;
    self.valueElement = value;
    
    return self;
}

- (NVStackElement *)getAttribute:(NSString *)attrName {
    if (self.valueElement) {
        return [self.valueElement getAttribute:attrName];
    }
    
    return nil;
}

- (void)setAttribute:(NSString *)attributeName value:(NVStackElement *)value {
    [self.valueElement setAttribute:attributeName value:value];
}

- (NVInt)toInt {
    return [self.valueElement toInt];
}

- (NVFloat)toFloat {
    return [self.valueElement toFloat];
}

- (NSString *)toString {
    return [self.valueElement toString];
}

- (NVStackElement *)copy {
    NVStackVariableElement *aCopy = [[NVStackVariableElement alloc] initWithName:self.name value:self.valueElement];
    aCopy.isArray = self.isArray;
    
    return aCopy;
}


- (BOOL)invokeMethod:(NSString *)methodName arguments:(NSArray<NVStackElement *> *)arguments lastStack:(NVStack *)lastStack {
    return [self.valueElement invokeMethod:methodName arguments:arguments lastStack:lastStack];
}

@end

@implementation NVAccessor

-(void)set:(NVStackElement *)value {
    
}

@end

@implementation NVFieldAccessor

- (id)initWithScope:(NVStackElement *)scope attributeName:(NSString *)attributeName {
    self = [super init];
    
    self.scope = scope;
    self.attributeName = attributeName;
    
    return self;
}

- (void)set:(NVStackElement *)value {
    [self.scope setAttribute:self.attributeName value:value];
}

- (NVStackElement *)value {
    return [self.scope getAttribute:self.attributeName];
}

- (NVStackElement *)getAttribute:(NSString *)attrName {
    NVStackElement *val = [self value];
    
    if (!val) {
        return nil;
    }
    
    return [val getAttribute:attrName];
}

- (void)setAttribute:(NSString *)attributeName value:(NVStackElement *)value {
    NVStackElement *val = [self value];
    
    [val setAttribute:attributeName value:value];
}

- (NVInt)toInt {
    return [self.value toInt];
}

- (NVFloat)toFloat {
    return [self.value toFloat];
}

- (NSString *)toString {
    if (!self.value) {
        return @"NULL";
    }
    
    return [self.value toString];
}

- (NVStackElement *)doOperator:(NSString *)op rightOperand:(NVStackElement *)rightOperand {
    return [self.value doOperator:op rightOperand:rightOperand];
}


- (BOOL)invokeMethod:(NSString *)methodName arguments:(NSArray<NVStackElement *> *)arguments lastStack:(NVStack *)lastStack {
    return [self.value invokeMethod:methodName arguments:arguments lastStack:lastStack];
}

@end
