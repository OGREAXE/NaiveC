//
//  NVLiteral+VM.h
//  NaiveC
//
//  Created by liangzhiyuan on 2021/12/15.
//  Copyright © 2021 Ogreaxe. All rights reserved.
//

#import "NVAST.h"

NS_ASSUME_NONNULL_BEGIN

@class NVStackElement;

@interface NVLiteral (VM)

- (NVStackElement *)toStackElement;

@end

@interface NVIntegerLiteral (VM)

@end

@interface NVFloatLiteral (VM)

@end

@interface NVStringLiteral (VM)

@end

NS_ASSUME_NONNULL_END
