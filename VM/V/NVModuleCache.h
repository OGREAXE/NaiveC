//
//  NVModuleCache.h
//  NaiveC
//
//  Created by liangzhiyuan on 2021/12/14.
//  Copyright © 2021 Ogreaxe. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@class NVASTFunctionDefinition;
@class NVBuiltinFunction;
@class NVClassDeclaration;
@class NVClass;

@interface NVModuleCache : NSObject

+ (instancetype)globalCache;

/*
 functions
 */
- (void)addNativeFunction:(NVASTFunctionDefinition *)funcDef;

- (NVASTFunctionDefinition *)nativeFunctionDefinitionForName:(NSString *)name;

- (void)addSystemFunction:(NVBuiltinFunction *)builtinFunction;

- (NVBuiltinFunction *)systemFunctionDefinitionForName:(NSString *)name;

- (BOOL)findSystemFunctionForName:(NSString *)name;

/*
 class
 */

- (void)addClassDefinition:(NVClassDeclaration *)classDef;

- (NVClassDeclaration *)classDefinitionForName:(NSString *)name;

- (NVClass *)classForName:(NSString *)name;

- (BOOL)removeModuleWithName:(NSString *)name;

@end

NS_ASSUME_NONNULL_END
