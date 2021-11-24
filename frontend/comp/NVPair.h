//
//  NVPair.h
//  NaiveC
//
//  Created by liangzhiyuan on 2021/11/23.
//  Copyright © 2021 Ogreaxe. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NVPair <__covariant ObjectTypeA, __covariant ObjectTypeB> : NSObject

+ (void)makePair:(ObjectTypeA)obja objectB:(ObjectTypeB)objectB;

@property (nonatomic, readonly) ObjectTypeA first;
@property (nonatomic, readonly) ObjectTypeB second;

@end

NS_ASSUME_NONNULL_END
