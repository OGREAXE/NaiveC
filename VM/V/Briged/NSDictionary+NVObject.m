//
//  NSDictionary+NVObject.m
//  NaiveC
//
//  Created by liangzhiyuan on 2021/12/16.
//  Copyright © 2021 Ogreaxe. All rights reserved.
//

#import "NSDictionary+NVObject.h"
#import "NVObject.h"
#import "NVCocoaBox.h"

@implementation NSDictionary (NVObject)

- (void)br_set:(NVStackElement *)key value:(NVStackElement *)value {
    NVException *e = [NSException exceptionWithName:@"NSDictionary" reason:@"dictionary is not mutable" userInfo:nil];
    [self throw_exception:e];
}

- (NVStackElement *)br_getValue:(NVStackElement *)key {
    if (![key isKindOfClass:NVStackPointerElement.class]) {
        NVException *e = [NSException exceptionWithName:@"NSDictionary" reason:@"accessing dictionary with unsupported key" userInfo:nil];
        [self throw_exception:e];
        return nil;
    }
    
    NVStackPointerElement *pKey = (NVStackPointerElement *)key;
    NSObject *cocoaKey = [pKey toNSObject];
    
    if (!cocoaKey) {
        NVException *e = [NSException exceptionWithName:@"NSDictionary" reason:@"key is illegal" userInfo:nil];
        [self throw_exception:e];
        return nil;
    }
    
    NVCocoaBox *cocoaBox = [[NVCocoaBox alloc] initWithObject:self[cocoaKey]];
    
    return [[NVStackPointerElement alloc] initWithObject:cocoaBox];
}

@end

@implementation NSMutableDictionary (NVObject)

- (void)br_set:(NVStackElement *)key value:(NVStackElement *)value {
    if (![key isKindOfClass:NVStackPointerElement.class]) {
        NVException *e = [NSException exceptionWithName:@"NSMutableDictionary" reason:@"setting dictionary with unsupported key" userInfo:nil];
        [self throw_exception:e];
        return;
    }
    
    if (![value isKindOfClass:NVStackPointerElement.class]) {
        NVException *e = [NSException exceptionWithName:@"NSMutableDictionary" reason:@"setting dictionary with unsupported value" userInfo:nil];
        [self throw_exception:e];
        return;
    }
    
    NVStackPointerElement *pKey = (NVStackPointerElement *)key;
    NSObject *cocoaKey = [pKey toNSObject];
    
    if (!cocoaKey) {
        NVException *e = [NSException exceptionWithName:@"NSMutableDictionary" reason:@"key is illegal" userInfo:nil];
        [self throw_exception:e];
        return;
    }
    
    if ([cocoaKey conformsToProtocol:@protocol(NSCopying)]) {
        NVException *e = [NSException exceptionWithName:@"NSMutableDictionary" reason:@"key is NSCopying" userInfo:nil];
        [self throw_exception:e];
        return;
    }
    
    id<NSCopying> theRealKey = (id<NSCopying>)cocoaKey;
    
    NSObject *cocoaValue = [(NVStackPointerElement *)value toNSObject];
    
    if (!cocoaValue) {
        NVException *e = [NSException exceptionWithName:@"NSMutableDictionary" reason:@"value is illegal" userInfo:nil];
        [self throw_exception:e];
        return;
    }
    
    self[theRealKey] = cocoaValue;
}

@end
