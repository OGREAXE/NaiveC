//
//  NVFrame.m
//  NaiveC
//
//  Created by liangzhiyuan on 2021/12/13.
//  Copyright © 2021 Ogreaxe. All rights reserved.
//

#import "NVFrame.h"
#import "NVObject.h"

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
    if([self stack_empty]){
        return nil;
    }
    
    return [self.stack pop];
}

- (NVStackElement *)stack_popRealValue {
    NVStackElement *stackTop = [self.stack pop];
    
    if ([stackTop isKindOfClass:NVStackVariableElement.class]) {
        NVStackVariableElement *var = (NVStackVariableElement *)stackTop;
        return var.valueElement;
    }
    
    return stackTop;
}

- (void)stack_push:(NVStackElement *)element {
    [self.stack addObject:element];
}

- (bool)stack_empty {
    return self.stack.count == 0;
}

- (int)stack_popInt {
    if (self.stack.count <= 0) {
        return 0;
    }
    
    NVStackElement *stackTop = [self.stack pop];
    
    return [stackTop toInt];
}

- (float)stack_popFloat {
    if (self.stack.count <= 0) {
        return 0;
    }
    
    NVStackElement *stackTop = [self.stack pop];
    
    return [stackTop toFloat];
}

- (NSString *)stack_popString {
    if (self.stack.count <= 0) {
        return @"";
    }
    
    NVStackElement *stackTop = [self.stack pop];
    
    return [stackTop toString];
}

- (NVStackElement *)stack_popType:(NSString *)type {
    if ([type isEqualToString:@"int"]) {
        int val = [self stack_popInt];
        return [[NVStackIntElement alloc] initWithInt:val];
    } else if ([type isEqualToString:@"float"]) {
        float val = [self stack_popFloat];
        return [[NVStackFloatElement alloc] initWithFloat:val];
    } else if ([type isEqualToString:@"int"]) {
        NSString *val = [self stack_popString];
        return [[NVStackStringElement alloc] initWithString:val];
    }
    
    return nil;
}

- (NVStackPointerElement *)stack_popObjectPointer {
    NVStackElement *pStackTop = self.stack.top;
    
    //fix smart pointer released
    if ([pStackTop isKindOfClass:NVStackPointerElement.class]) {
        return (NVStackPointerElement *)[self.stack pop];
    }
    else if ([pStackTop isKindOfClass:NVStackVariableElement.class]) {
        NVStackVariableElement *pVar = (NVStackVariableElement *)pStackTop;
        
        while (1) {
            if ([pVar.valueElement isKindOfClass:NVStackPointerElement.class]) {
                NVStackPointerElement *pRet = (NVStackPointerElement *)(pVar.valueElement);
                
                [self.stack pop];
                
                return pRet;
            }
            else {
                pVar = (NVStackVariableElement *)(pVar.valueElement);
            }
        }
        
    }
    else if ([pStackTop isKindOfClass:NVAccessor.class]) {
        NVAccessor *pAccessor = (NVAccessor *)(pStackTop);
        NVStackElement *value = pAccessor.value;
        
        if ([value isKindOfClass:NVStackVariableElement.class]) {
            NVStackVariableElement *pVar = (NVStackVariableElement *)value;
            
            if ([pVar.valueElement isKindOfClass:NVStackPointerElement.class]) {
                NVStackPointerElement *pRet = (NVStackPointerElement *)(pVar.valueElement);
                [self.stack pop];
                return pRet;
            }
        }
        else if ([value isKindOfClass:NVStackPointerElement.class]) {
            NVStackPointerElement *pRet = (NVStackPointerElement *)value;
            [self.stack pop];
            return pRet;
        }
    }
    
    return [[NVStackPointerElement alloc] init];
}

@end
