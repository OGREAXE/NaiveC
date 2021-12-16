//
//  NVClassProvider.h
//  NaiveC
//
//  Created by liangzhiyuan on 2021/12/15.
//  Copyright © 2021 Ogreaxe. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@class NVClass;

@interface NVClassProvider : NSObject

- (NVClass *)loadClass:(NSString *)className;

- (BOOL)classExist:(NSString *)className;

@end

NS_ASSUME_NONNULL_END
