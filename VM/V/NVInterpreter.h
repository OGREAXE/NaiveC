//
//  NVInterpreter.h
//  NaiveC
//
//  Created by liangzhiyuan on 2021/12/13.
//  Copyright © 2021 Ogreaxe. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NVStack.h"

NS_ASSUME_NONNULL_BEGIN

@class NVExpression;
@class NVStackElement;
@class NVFrame;
@class NVMethodCallExpr;
@class NVBuiltinFunction;
@class NVNativeObject;

@interface NVInterpreter : NSObject

+ (instancetype)defaultInterperter;

- (id)initWithRoot:(NVASTRoot *)root;

- (BOOL)invoke:(NSString *)functionName;

- (BOOL)invoke:(NSString *)functionName
     lastStack:(NVStack *)lastStack;

- (BOOL)invoke:(NSString *)functionName
     arguments:(NSArray<NVStackElement *> *)arguments
     lastStack:(NVStack *)lastStack;

- (BOOL)invoke:(NSString *)functionName
         scope:(NVNativeObject *)scope
     arguments:(NSArray<NVStackElement *> *)arguments
     lastStack:(NVStack *)lastStack;

- (BOOL)visit:(NVASTNode *)node frame:(NVFrame *)frame;

- (void)addFunction:(NVBuiltinFunction *)function;

@end

NS_ASSUME_NONNULL_END
