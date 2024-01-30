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

@end

@implementation NPPatchedClass

@end
