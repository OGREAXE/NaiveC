//
//  NSCocoaSymbolStore.m
//  NaiveC
//
//  Created by mi on 2024/3/7.
//  Copyright © 2024 Ogreaxe. All rights reserved.
//

#import "NSCocoaSymbolStore.h"
#include <string>
#import <objc/runtime.h>
using namespace std;

@implementation NSNumber (Naive)

void *primitiveKey = NULL;

- (BOOL)isPrimitive {
    id k = objc_getAssociatedObject(self, &primitiveKey);
    return k!= NULL;
}

@end

@implementation NSCocoaSymbolStore

+(id)symbolForString:(string &)name {
    NSString *key = [NSString stringWithUTF8String:name.c_str()];
    return [NSCocoaSymbolStore symbolForName:key];
}

NSNumber *createPrimitive(NSNumber *n) {
    objc_setAssociatedObject(n, &primitiveKey, @YES, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    return n;
}

#define P(n) createPrimitive(n)

+(id)symbolForName:(NSString *)name {
    static NSDictionary *store = @{
        @"DISPATCH_QUEUE_SERIAL":[NSNull new],
        @"DISPATCH_QUEUE_CONCURRENT":DISPATCH_QUEUE_CONCURRENT,
        
        @"DISPATCH_TIME_NOW":P(@DISPATCH_TIME_NOW),
        @"NSEC_PER_SEC":P(@NSEC_PER_SEC),
    };
    
    return store[name];
}

@end
