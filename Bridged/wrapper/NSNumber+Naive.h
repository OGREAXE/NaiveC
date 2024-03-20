//
//  NSNumber+Naive.h
//  Naive-C
//
//  Created by 梁志远 on 2024/3/20.
//  Copyright © 2024 Ogreaxe. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

#define P(n) [NSNumber createPrimitive:@(n)]

@interface NSNumber (Naive)

@property (nonatomic, readonly) BOOL isPrimitive;

+ (NSNumber *)createPrimitive:(NSNumber *)n;

@end

NS_ASSUME_NONNULL_END
