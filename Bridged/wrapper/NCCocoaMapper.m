//
//  NCCocoaMapper.m
//  NaiveC
//
//  Created by mi on 2024/3/11.
//  Copyright © 2024 Ogreaxe. All rights reserved.
//

#import "NCCocoaMapper.h"

@interface NCCocoaMapper()

@property (nonatomic) NSMutableDictionary *objectMap;

@end

@implementation NCCocoaMapper

+ (NCCocoaMapper *)shared
{
    static dispatch_once_t onceToken;
    static NCCocoaMapper *manager = nil;
    dispatch_once(&onceToken, ^{
        manager = [[NCCocoaMapper alloc] init];
    });
    
    return manager;
}

- (NSMutableDictionary *)objectMap {
    if (!_objectMap) {
        _objectMap = [[NSMutableDictionary alloc] init];
    }
    
    return _objectMap;
}

- (id)objectForNCKey:(NSString *)key {
    return self.objectMap[key];
}

- (id)objectForNCKeyString:(const char *)key {
    return self.objectMap[[NSString stringWithUTF8String:key]];
}

- (void)setObject:(id)obj withNCKey:(NSString *)key {
    self.objectMap[key] = obj;
}

- (void)setObject:(id)obj withNCKeyString:(const char *)key {
    self.objectMap[[NSString stringWithUTF8String:key]] = obj;
}

- (void)removeObjectWithNCKey:(const char *)key {
    [self.objectMap removeObjectForKey:[NSString stringWithUTF8String:key]];
}

- (void)clear {
    [self.objectMap removeAllObjects];
}

@end
