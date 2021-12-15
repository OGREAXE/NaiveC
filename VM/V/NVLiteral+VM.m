//
//  NVLiteral+VM.m
//  NaiveC
//
//  Created by liangzhiyuan on 2021/12/15.
//  Copyright © 2021 Ogreaxe. All rights reserved.
//

#import "NVLiteral+VM.h"
#import "NVStack.h"

@implementation NVLiteral (VM)

@end

@implementation NVIntegerLiteral (VM)

- (NVStackElement *)toStackElement {
    return [[NVStackIntElement alloc] initWithInt:self.value];
}

@end

@implementation NVFloatLiteral (VM)

- (NVStackElement *)toStackElement {
    return [[NVStackFloatElement alloc] initWithFloat:self.value];
}

@end

@implementation NVStringLiteral (VM)

- (NVStackElement *)toStackElement {
    return [[NVStackStringElement alloc] initWithString:self.str];
}

@end
