//
//  NSCocoaSymbolStore.m
//  NaiveC
//
//  Created by mi on 2024/3/7.
//  Copyright © 2024 Ogreaxe. All rights reserved.
//

#import "NSCocoaSymbolStore.h"
#include <string>

using namespace std;

@implementation NSCocoaSymbolStore

+(id)symbolForString:(string &)name {
    NSString *key = [NSString stringWithUTF8String:name.c_str()];
    return [NSCocoaSymbolStore symbolForName:key];
}

+(id)symbolForName:(NSString *)name {
    static NSDictionary *store = @{
        @"DISPATCH_QUEUE_SERIAL":[NSNull new],
        @"DISPATCH_QUEUE_CONCURRENT":DISPATCH_QUEUE_CONCURRENT,
        
        @"DISPATCH_TIME_NOW":@DISPATCH_TIME_NOW,
        @"NSEC_PER_SEC":@NSEC_PER_SEC,
    };
    
    return store[name];
}

- (void)load {
    [NSCocoaSymbolStore test];
}

+(void)test {
    NSValue *v = [NSCocoaSymbolStore symbolForName:@"DISPATCH_QUEUE_SERIAL"];
    
    dispatch_queue_attr_t attr = (dispatch_queue_attr_t)v.pointerValue;
}

@end
