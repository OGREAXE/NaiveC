//
//  NVArray.m
//  NaiveC
//
//  Created by liangzhiyuan on 2021/12/14.
//  Copyright © 2021 Ogreaxe. All rights reserved.
//

#import "NVArray.h"
#import "NSObject+NVInvocation.h"

@interface NVArray ()

@property (nonatomic) NSMutableArray<NVStackElement *> *innerArray;

@end

@implementation NVArray

- (NSMutableArray<NVStackElement *> *)innerArray {
    if (!_innerArray) {
        _innerArray = [NSMutableArray array];
    }
    
    return _innerArray;
}

- (void)addElement:(NVStackElement *)element {
    [self.innerArray addObject:element];
}

- (NVStackElement *)getAttribute:(NSString *)attributeName {
    NVStack *stack = [[NVStack alloc] init];
    [self invokeMethod:attributeName arguments:nil lastStack:stack];
    return stack.top;
}

- (BOOL)invokeMethod:(NSString *)methodName arguments:(NSArray<NVStackElement *> *)arguments lastStack:(NVStack *)lastStack {
    if ([methodName isEqualToString:@"get"]) {
        int index = [arguments[0] toInt];
        
        if (index > self.innerArray.count - 1) {
            return NO;
        }
        
        NVStackElement *res = self.innerArray[index];
        [lastStack addObject:res];
    }
    else if ([methodName isEqualToString:@"add"]) {
        [self.innerArray addObject:arguments[0]];
    }
    else if([methodName isEqualToString:@"set"]){
//        innerArray[arguments[0]->toInt()] = arguments[1];
        
        if (arguments.count != 2) {
            return NO;
        }
        
        int index = [arguments[0] toInt];
        
        if (index > self.innerArray.count - 1) {
            return NO;
        }
        
        self.innerArray[index] = arguments[1];
    }
    else if([methodName isEqualToString:@"length"]){
        [lastStack addObject:[[NVStackIntElement alloc] initWithInt:self.innerArray.count]];
    }
    else {
        return [self nv_invoke:methodName arguments:arguments stack:lastStack];
    }
    
    return YES;
}

- (BOOL)invokeMethod:(NSString *)methodName arguments:(NSArray<NVStackElement *> *)arguments {
    return [self invokeMethod:methodName arguments:arguments lastStack:nil];
}

//- (NVStackElement *)getAttribute:(NSString *)attributeName {
//    if ([attributeName isEqualToString:@"count"]) {
//        NSInteger length = _innerArray.count;
//        return [[NVStackIntElement alloc] initWithInt:length];
//    }
//    else {
//       NSString *reason = [NSString stringWithFormat:@"attribute %@ not found on NCArray", attributeName];
//        NVException *e = [NSException exceptionWithName:@"NVArray_exception" reason:reason userInfo:nil];
//        [self throw_exception:e];
//    }
//
//    return nil;
//}

- (void)br_set:(NVStackElement *)key value:(NVStackElement *)value {
    if ([key isKindOfClass:NVStackIntElement.class]) {
        int index = ((NVStackIntElement *)key).value;
        
        if (index > self.innerArray.count - 1) {
            NVException *e = [NSException exceptionWithName:@"NVArray_exception" reason:@"out of range" userInfo:nil];
            [self throw_exception:e];
        }
        
        self.innerArray[index] = value;
    } else {
        NVException *e = [NSException exceptionWithName:@"NVArray_exception" reason:@"index is not numeric" userInfo:nil];
        [self throw_exception:e];
    }
}

- (NVStackElement *)br_getValue:(NVStackElement *)key {
    if ([key isKindOfClass:NVStackIntElement.class]) {
        int index = ((NVStackIntElement *)key).value;
        
        if (index > self.innerArray.count - 1) {
            NVException *e = [NSException exceptionWithName:@"NVArray_exception" reason:@"out of range" userInfo:nil];
            [self throw_exception:e];
        }
        
        return self.innerArray[index];
    } else {
        NVException *e = [NSException exceptionWithName:@"NVArray_exception" reason:@"index is not numeric" userInfo:nil];
        [self throw_exception:e];
        
        return nil;
    }
}

/**
 fast enumeration
 */
- (void)enumerate:(BOOL(^)(NVStackElement *stackElement))handler {
    for (int i = 0; i < self.innerArray.count; i++) {
        NVStackElement *currentValue = self.innerArray[i];
        
        if (handler(currentValue)) {
            break;
        }
    }
}

- (NSString *)getDescription {
    if (self.innerArray.count <= 0) {
        return @"NVArray";
    }
    
    NSMutableString *desc = [NSMutableString stringWithFormat:@"NVArray:{%@",
                             [self.innerArray[0] toString]];
    
    for (int i = 1; i < self.innerArray.count; i ++) {
        [desc appendFormat:@",%@",[self.innerArray[i] toString]];
    }
    
    [desc appendFormat:@"}"];
    
    return desc;
}

@end

@implementation NVArrayAccessor

- (id)initWithAccessible:(id<NVBracketAccessible>)accessible key:(NVStackElement *)key {
    self = [super init];
    
    self.accessible = accessible;
    self.key = key;
    
    return self;
}

- (NVStackElement *)doOperator:(NSString *)op rightOperand:(NVStackElement *)rightOperand {
    return [self.value doOperator:op rightOperand:rightOperand];
}

- (NVInt)toInt {
    return [self.value toInt];
}

- (NVFloat)toFloat {
    return [self.value toFloat];
}

- (NSString *)toString {
    return [self.value toString];
}

- (NVStackElement *)copy {
    return [self.value copy];
}

- (void)set:(NVStackElement *)value {
    [self.accessible br_set:self.key value:value];
}

- (NVStackElement *)value {
    return [self.accessible br_getValue:self.key];
}

- (BOOL)invokeMethod:(NSString *)methodName arguments:(NSArray<NVStackElement *> *)arguments {
    return [self.value invokeMethod:methodName arguments:arguments];
}

- (BOOL)invokeMethod:(NSString *)methodName arguments:(NSArray<NVStackElement *> *)arguments lastStack:(NVStack *)lastStack {
    return [self.value invokeMethod:methodName arguments:arguments lastStack:lastStack];
}

- (NVStackElement *)getAttribute:(NSString *)attrName {
    return [self.value getAttribute:attrName];
}

- (void)setAttribute:(NSString *)attributeName value:(NVStackElement *)value {
    [self.value setAttribute:attributeName value:value];
}

@end
