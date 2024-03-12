//
//  NCCocoaMapper.h
//  NaiveC
//
//  Created by mi on 2024/3/11.
//  Copyright © 2024 Ogreaxe. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NCCocoaMapper : NSObject

+ (NCCocoaMapper *)shared;

- (id)objectForNCKey:(NSString *)key;

- (id)objectForNCKeyString:(const char *)key;

- (void)setObject:(id)obj withNCKey:(NSString *)key;

- (void)setObject:(id)obj withNCKeyString:(const char *)key;

- (void)removeObjectWithNCKey:(const char *)key;

- (void)clear;

@end

NS_ASSUME_NONNULL_END
