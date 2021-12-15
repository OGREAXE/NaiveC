//
//  NVClassLoader.h
//  NaiveC
//
//  Created by liangzhiyuan on 2021/12/15.
//  Copyright © 2021 Ogreaxe. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NVClass.h"

NS_ASSUME_NONNULL_BEGIN

@class NVClassProvider;

@interface NVClassLoader : NSObject

+ (instancetype)sharedLoader;

- (NVClass *)loadClass:(NSString *)className;

- (BOOL)isClassExist:(NSString *)className;

- (BOOL)registerProvider:(NVClassProvider *)provider;

@end

NS_ASSUME_NONNULL_END
