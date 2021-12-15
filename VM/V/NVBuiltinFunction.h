//
//  NVBuiltinFunction.h
//  NaiveC
//
//  Created by liangzhiyuan on 2021/12/15.
//  Copyright © 2021 Ogreaxe. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@class NVStack;
@class NVParameter;
@class NVStack;
@class NVStackElement;

@interface NVBuiltinFunction : NSObject

@property (nonatomic) BOOL hasReturn;
@property (nonatomic) NSString *name;
@property (nonatomic) NSArray<NVParameter *> *parameters; //formal parameters

- (BOOL)invoke:(NSArray<NVStackElement *> *)arguments lastStack:(NVStack *)lastStack;

//if has no return
- (BOOL)invoke:(NSArray<NVStackElement *> *)arguments;

@end

NS_ASSUME_NONNULL_END
