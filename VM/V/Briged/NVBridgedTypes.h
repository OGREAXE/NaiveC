//
//  NVBridgedTypes.h
//  NaiveC
//
//  Created by liangzhiyuan on 2021/12/16.
//  Copyright © 2021 Ogreaxe. All rights reserved.
//

#import "NVObject.h"
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

/// UIGeometries holders
///

@interface NVRect : NVObject

@property (nonatomic) CGRect rect;

- (id)initWithCGRect:(CGRect)rect;

@end

@interface NVSize : NVObject

@property (nonatomic) CGSize size;

- (id)initWithCGSize:(CGSize)size;

@end

@interface NVPoint : NVObject

@property (nonatomic) CGPoint point;

- (id)initWithCGPoint:(CGPoint)point;

@end

@interface NVEdgeInsets : NVObject

@property (nonatomic) UIEdgeInsets edgeInsets;

- (id)initWithUIEdgeInsets:(UIEdgeInsets)edgeInsets;

@end

/// other c struct holders
///
@interface NVRange : NVObject

@property (nonatomic) NSRange range;

- (id)initWithNSRange:(NSRange)range;

@end

NS_ASSUME_NONNULL_END
