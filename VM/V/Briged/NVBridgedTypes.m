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

- (NVStackElement *)getAttribute:(NSString *)attributeName {
    if ([attributeName isEqualToString:@"size"]) {
        CGSize size = self.rect.size;
        NVSize *nvSize = [[NVSize alloc] initWithCGSize:size];
        
        return [[NVStackPointerElement alloc] initWithObject:nvSize];
    } else if ([attributeName isEqualToString:@"point"]) {
        CGPoint point = self.rect.origin;
        NVPoint *nvPoint = [[NVPoint alloc] initWithCGPoint:point];
        
        return [[NVStackPointerElement alloc] initWithObject:nvPoint];
    }
    
    return nil;
}

@end

@implementation NVSize

- (id)initWithCGSize:(CGSize)size {
    self = [super init];
    
    self.size = size;
    
    return self;
}

- (NVStackElement *)getAttribute:(NSString *)attributeName {
    if ([attributeName isEqualToString:@"width"]) {
        return [[NVStackFloatElement alloc] initWithFloat:self.size.width];
    } else if ([attributeName isEqualToString:@"height"]) {
        return [[NVStackFloatElement alloc] initWithFloat:self.size.height];
    }
    
    return nil;
}

@end

@implementation NVPoint

- (id)initWithCGPoint:(CGPoint)point {
    self = [super init];
    
    self.point = point;
    
    return self;
}

- (NVStackElement *)getAttribute:(NSString *)attributeName {
    if ([attributeName isEqualToString:@"x"]) {
        return [[NVStackFloatElement alloc] initWithFloat:self.point.x];
    } else if ([attributeName isEqualToString:@"y"]) {
        return [[NVStackFloatElement alloc] initWithFloat:self.point.y];
    }
    
    return nil;
}

@end

@implementation NVEdgeInsets

- (id)initWithUIEdgeInsets:(UIEdgeInsets)edgeInsets {
    self = [super init];
    
    self.edgeInsets = edgeInsets;
    
    return self;
}

- (NVStackElement *)getAttribute:(NSString *)attributeName {
    if ([attributeName isEqualToString:@"top"]) {
        return [[NVStackFloatElement alloc] initWithFloat:self.edgeInsets.top];
    } else if ([attributeName isEqualToString:@"left"]) {
        return [[NVStackFloatElement alloc] initWithFloat:self.edgeInsets.left];
    } else if ([attributeName isEqualToString:@"bottom"]) {
        return [[NVStackFloatElement alloc] initWithFloat:self.edgeInsets.bottom];
    } else if ([attributeName isEqualToString:@"right"]) {
        return [[NVStackFloatElement alloc] initWithFloat:self.edgeInsets.right];
    }
    
    return nil;
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

- (NVStackElement *)getAttribute:(NSString *)attributeName {
    if ([attributeName isEqualToString:@"location"]) {
        return [[NVStackFloatElement alloc] initWithFloat:self.range.location];
    } else if ([attributeName isEqualToString:@"length"]) {
        return [[NVStackFloatElement alloc] initWithFloat:self.range.length];
    }
    
    return nil;
}

@end
