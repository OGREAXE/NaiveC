//
//  NVClassLoader.m
//  NaiveC
//
//  Created by liangzhiyuan on 2021/12/15.
//  Copyright © 2021 Ogreaxe. All rights reserved.
//

#import "NVClassLoader.h"
#import "NVClassProvider.h"

@interface NVClassLoader ()

@property (nonatomic) NSMutableArray<NVClassProvider *> *classProviders;

@end

@implementation NVClassLoader

+ (instancetype)sharedLoader {
    static dispatch_once_t once;
    static id instance;
    dispatch_once(&once, ^{
        instance = [self new];
    });
    return instance;
}

- (NVClass *)loadClass:(NSString *)className {
    NVClassProvider *provider = [self findClassProvider:className];
    
    if (!provider) {
        return nil;
    }
    
    return [provider loadClass:className];
}

- (NVClassProvider *)findClassProvider:(NSString *)className {
    for (int i = 0; i < self.classProviders.count; i ++) {
        NVClassProvider *provider = self.classProviders[i];
        
        if ([provider classExist:className]) {
            return provider;
        }
    }
    
    return nil;
}

- (BOOL)isClassExist:(NSString *)className {
    for (int i = 0; i < self.classProviders.count; i++) {
        NVClassProvider *provider = self.classProviders[i];
        
        if ([provider classExist:className]) {
            return YES;
        }
    }
    
    return NO;
}

- (BOOL)registerProvider:(NVClassProvider *)provider {
    [self.classProviders addObject:provider];
    
    return YES;
}

-(NSMutableArray<NVClassProvider *> *)classProviders {
    if (!_classProviders) {
        _classProviders = [NSMutableArray array];
    }
    
    return _classProviders;
}

@end
