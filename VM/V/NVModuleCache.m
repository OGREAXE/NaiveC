//
//  NVModuleCache.m
//  NaiveC
//
//  Created by liangzhiyuan on 2021/12/14.
//  Copyright © 2021 Ogreaxe. All rights reserved.
//

#import "NVModuleCache.h"
#import "NVAST.h"

@interface NVModuleCache ()

@property (nonatomic) NSMutableDictionary<NSString *, NVASTFunctionDefinition *> *functionMap;

@end

@implementation NVModuleCache

- (NSMutableDictionary<NSString *, NVASTFunctionDefinition *> *)functionMap {
    if (!_functionMap) {
        _functionMap = [NSMutableDictionary dictionary];
    }
    
    return _functionMap;
}

+ (instancetype)globalCache {
    static dispatch_once_t once;
    static id instance;
    dispatch_once(&once, ^{
        instance = [self new];
    });
    return instance;
}

- (void)addNativeFunction:(NVASTFunctionDefinition *)funcDef {
    self.functionMap[funcDef.name] = funcDef;
}

- (NVASTFunctionDefinition *)nativeFunctionDefinitionForName:(NSString *)name {
    return self.functionMap[name];
}

- (void)addSystemFunction:(NVBuiltinFunction *)builtinFunction {
    
}

- (NVBuiltinFunction *)systemFunctionDefinitionForName:(NSString *)name {
    return nil;
}

- (BOOL)findSystemFunctionForName:(NSString *)name {
    return NO;
}

@end
