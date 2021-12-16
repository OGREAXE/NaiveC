//
//  NSObject+NVInvocation.h
//  NaiveC
//
//  Created by liangzhiyuan on 2021/12/15.
//  Copyright © 2021 Ogreaxe. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NVStack.h"

NS_ASSUME_NONNULL_BEGIN

@interface NSObject (NVInvocation)

+(BOOL)nv_invoke:(NSString*)methodName object:(NSObject*)aObject orClass:(Class)aClass arguments:(NSArray<NVStackElement *> *)arguments stack:(NVStack *)lastStack;

-(BOOL)nv_invoke:(NSString*)methodName arguments:(NSArray<NVStackElement *> *)arguments  stack:(NVStack *)lastStack ;

- (NVStackElement *)attributeForName:(NSString *)attrName;

@end

NS_ASSUME_NONNULL_END
