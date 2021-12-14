//
//  NVFrame.h
//  NaiveC
//
//  Created by liangzhiyuan on 2021/12/13.
//  Copyright © 2021 Ogreaxe. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NVStack.h"

NS_ASSUME_NONNULL_BEGIN

@class NVStackPointerElement;
@class NVNativeObject;

@interface NVFrame : NSObject

@property (nonatomic) NSMutableDictionary<NSString *, NVStackElement *> *localVariableMap;
@property (nonatomic) NVStack *stack;
@property (nonatomic) NSArray<NVNativeObject *> *scope;
@property (nonatomic) BOOL objectScopeFlag;

- (void)insertVariable:(NSString *)name intValue:(int)value;
- (void)insertVariable:(NSString *)name floatValue:(float)value;
- (void)insertVariable:(NSString *)name stringValue:(NSString *)value;
- (void)insertVariable:(NSString *)name stackElement:(NVStackElement *)pObject;
- (void)insertVariable:(NSString *)name stackPointerElement:(NVStackPointerElement *)pObject;

- (NVStackElement *)stack_pop;
- (NVStackElement *)stack_popRealValue;

- (void)stack_push:(NVStackElement *)element;
- (bool)stack_empty;

- (int)stack_popInt;
- (float)stack_popFloat;
- (NSString *)stack_popString;
- (NVStackPointerElement *)stack_popObjectPointer;

@end

NS_ASSUME_NONNULL_END
