//
//  NSArray+NVObject.m
//  NaiveC
//
//  Created by liangzhiyuan on 2021/12/16.
//  Copyright © 2021 Ogreaxe. All rights reserved.
//

#import "NSArray+NVObject.h"
#import "NVObject.h"
#import "NVCocoaBox.h"

@implementation NSArray (NVObject)

- (void)br_set:(NVStackElement *)key value:(NVStackElement *)value {
    NVException *e = [NSException exceptionWithName:@"NSArray" reason:@"array is not mutable" userInfo:nil];
    [self throw_exception:e];
}

- (NVStackElement *)br_getValue:(NVStackElement *)key {
    if (![key isKindOfClass:NVStackIntElement.class]) {
        NVException *e = [NSException exceptionWithName:@"NSArray" reason:@"accessing array with index is not numeric" userInfo:nil];
        
        [self throw_exception:e];
        return nil;
    }
    
    int index = [key toInt];
    
    if (index > self.count - 1 || index <= 0) {
        NVException *e = [NSException exceptionWithName:@"NSArray" reason:@"out of range" userInfo:nil];
        [self throw_exception:e];
        return nil;
    }
    
    NVCocoaBox *cocoaBox = [[NVCocoaBox alloc] initWithObject:self[index]];
    
    return [[NVStackPointerElement alloc] initWithObject:cocoaBox];
}

@end

@implementation NSMutableArray (NVObject)

- (void)br_set:(NVStackElement *)key value:(NVStackElement *)value {
    if (![key isKindOfClass:NVStackIntElement.class]) {
        NVException *e = [NSException exceptionWithName:@"NSMutableArray" reason:@"accessing array with index is not numeric" userInfo:nil];
        
        [self throw_exception:e];
        return;
    }
    
    int index = [key toInt];
    
    if (index > self.count - 1 || index <= 0) {
        NVException *e = [NSException exceptionWithName:@"NSMutableArray" reason:@"out of range" userInfo:nil];
        [self throw_exception:e];
        return;
    }
    
    if (![value isKindOfClass:NVStackPointerElement.class]) {
        NVException *e = [NSException exceptionWithName:@"NSMutableArray" reason:@"value must be a NSObject pointer" userInfo:nil];
        [self throw_exception:e];
        return;
    }
    
    NVStackPointerElement *pointer = (NVStackPointerElement *)value;
    
    self[index] = [pointer toNSObject];
}

@end
