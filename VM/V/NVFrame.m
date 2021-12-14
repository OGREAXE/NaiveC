//
//  NVFrame.m
//  NaiveC
//
//  Created by liangzhiyuan on 2021/12/13.
//  Copyright © 2021 Ogreaxe. All rights reserved.
//

#import "NVFrame.h"

@implementation NVFrame

- (void)insertVariable:(NSString *)name intValue:(int)value {
    [self.localVariableMap setObject:[[NVStackIntElement alloc] initWithInt:value]
                               forKey:name];
}

- (void)insertVariable:(NSString *)name floatValue:(float)value {
    [self.localVariableMap setObject:[[NVStackFloatElement alloc] initWithFloat:value]
                               forKey:name];
}

- (void)insertVariable:(NSString *)name stringValue:(NSString *)value {
    [self.localVariableMap setObject:[[NVStackStringElement alloc] initWithString:value]
                               forKey:name];
}

- (void)insertVariable:(NSString *)name stackElement:(NVStackElement *)pObject {
    [self.localVariableMap setObject:pObject
                               forKey:name];
}

- (void)insertVariable:(NSString *)name stackPointerElement:(NVStackPointerElement *)pObject {
    
}

- (NVStackElement *)stack_pop {
    
}

- (NVStackElement *)stack_popRealValue {
    
}

- (void)stack_push:(NVStackElement *)element {
    
}

- (bool)stack_empty {
    
}

- (int)stack_popInt {
    
}

- (float)stack_popFloat {
    
}

- (NSString *)stack_popString {
    
}

- (NVStackPointerElement *)stack_popObjectPointer {
    
}

@end
