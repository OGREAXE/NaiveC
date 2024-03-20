//
//  NCLocalEnumStore.h
//  NaiveC
//
//  Created by mi on 2024/3/19.
//  Copyright © 2024 Ogreaxe. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NSNumber+Naive.h"

NS_ASSUME_NONNULL_BEGIN

@interface NCLocalEnumStore : NSObject
+(id)enumForName:(NSString *)name;
@end

NS_ASSUME_NONNULL_END
