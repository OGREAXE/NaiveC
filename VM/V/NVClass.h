//
//  NVClass.h
//  NaiveC
//
//  Created by liangzhiyuan on 2021/12/14.
//  Copyright © 2021 Ogreaxe. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NVStack.h"

NS_ASSUME_NONNULL_BEGIN

@class NVStackPointerElement;

@interface NVClass : NVStackElement

- (NVStackPointerElement *)instantiate:(NSArray<NVStackElement *> *)arguments;

/**
 invoke a class method (static method) on this class
 
 @param methodName <#methodName description#>
 @param arguments <#arguments description#>
 @param lastStack <#lastStack description#>
 @return <#return value description#>
 */
- (BOOL)invokeMethod:(NSString *)methodName
           arguments:(nonnull NSArray<NVStackElement *> *)arguments
           lastStack:(nonnull NVStack *)lastStack;

@end

NS_ASSUME_NONNULL_END
