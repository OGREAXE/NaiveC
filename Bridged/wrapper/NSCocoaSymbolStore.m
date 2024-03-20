//
//  NSCocoaSymbolStore.m
//  NaiveC
//
//  Created by mi on 2024/3/7.
//  Copyright © 2024 Ogreaxe. All rights reserved.
//

#import "NSCocoaSymbolStore.h"
#import "NCCocoaEnumStore.h"
#import "NCLocalEnumStore.h"
//#include <string>
#import "NSNumber+Naive.h"
#import <objc/runtime.h>
//using namespace std;

@implementation NSNumber (Naive)

void *primitiveKey = NULL;

- (BOOL)isPrimitive {
    id k = objc_getAssociatedObject(self, &primitiveKey);
    return k!= NULL;
}

+ (NSNumber *)createPrimitive:(NSNumber *)n {
    objc_setAssociatedObject(n, &primitiveKey, @YES, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    return n;
}

@end

@implementation NSCocoaSymbolStore

//+(id)symbolForString:(string &d)name {
//    NSString *key = [NSString stringWithUTF8String:name.c_str()];
//    return [NSCocoaSymbolStore symbolForName:key];
//}

+(id)symbolForName:(NSString *)name {
    NSNumber *s = @(1);
    
    BOOL r = [s respondsToSelector:@selector(isPrimitive)];
    
    static NSDictionary *store = nil;
    
    if (!store)
    store =
    @{
        @"DISPATCH_QUEUE_SERIAL":[NSNull new],
        @"DISPATCH_QUEUE_CONCURRENT":DISPATCH_QUEUE_CONCURRENT,
        
        @"DISPATCH_TIME_NOW":P(DISPATCH_TIME_NOW),
        @"NSEC_PER_SEC":P(NSEC_PER_SEC),
        
        @"DISPATCH_QUEUE_PRIORITY_HIGH":P(DISPATCH_QUEUE_PRIORITY_HIGH),
        @"DISPATCH_QUEUE_PRIORITY_DEFAULT":P(DISPATCH_QUEUE_PRIORITY_DEFAULT),
        @"DISPATCH_QUEUE_PRIORITY_LOW":P(DISPATCH_QUEUE_PRIORITY_LOW),
        @"DISPATCH_QUEUE_PRIORITY_BACKGROUND":P(DISPATCH_QUEUE_PRIORITY_BACKGROUND),
        
        @"NSOrderedAscending":P(NSOrderedAscending),
        @"NSOrderedDescending":P(NSOrderedDescending),
        @"NSOrderedSame":P(NSOrderedSame),
    };
    
    id result = store[name];
    
    if (!result) {
        result = [NCCocoaEnumStore enumForName:name];
    }
    
    if (!result) {
        result = [NCLocalEnumStore enumForName:name];
    }
    
    return result;
}

@end
