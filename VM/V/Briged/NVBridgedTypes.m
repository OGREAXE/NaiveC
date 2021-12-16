//
//  NVBridgedTypes.m
//  NaiveC
//
//  Created by liangzhiyuan on 2021/12/16.
//  Copyright © 2021 Ogreaxe. All rights reserved.
//

#import "NVBridgedTypes.h"

@implementation NVRect

- (id)initWithCGRect:(CGRect)rect {
    self = [super init];
    
    self.rect = rect;
    
    return self;
}

@end

@implementation NVSize

- (id)initWithCGSize:(CGSize)size {
    self = [super init];
    
    self.size = size;
    
    return self;
}

@end

@implementation NVPoint

- (id)initWithCGPoint:(CGPoint)point {
    self = [super init];
    
    self.point = point;
    
    return self;
}

@end

@implementation NVEdgeInsets

- (id)initWithUIEdgeInsets:(UIEdgeInsets)edgeInsets {
    self = [super init];
    
    self.edgeInsets = edgeInsets;
    
    return self;
}

@end

/// other c struct holders
///
@implementation NVRange

- (id)initWithNSRange:(NSRange)range {
    self = [super init];
    
    self.range = range;
    
    return self;
}

@end
