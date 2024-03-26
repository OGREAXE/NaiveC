//
//  NPPatchedClass.m
//  NaiveStudio
//
//  Created by mi on 2024/1/30.
//  Copyright © 2024 Liang,Zhiyuan(GIS). All rights reserved.
//

#import "NPPatchedClass.h"

@implementation NPParamterPair

@end

@implementation NPPatchedMethod

- (BOOL)isClassMethod {
    if (self.declaration.length) {
        return [self.declaration characterAtIndex:0] == '+';
    }
    
    return NO;
}

- (NSArray<NSString *> *)argTypes {
    NSMutableArray *array = [NSMutableArray array];
    
    for (int i = 0; i < self.parameterPairs.count; i ++) {
        [array addObject:self.parameterPairs[i].type];
    }
    
    return array;
}

@end

@implementation NPPatchedProperty

@end

@implementation NPPatchedClass

@end
