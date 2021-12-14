//
//  NVStackElement.h
//  NaiveC
//
//  Created by liangzhiyuan on 2021/12/13.
//  Copyright © 2021 Ogreaxe. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NVAST.h"

NS_ASSUME_NONNULL_BEGIN

@interface NVStackElement : NSObject

@property (nonatomic) NSString *type;

- (NVStackElement *)doOperator:(NSString *)op rightOperand:(NVStackElement *)rightOperand;

- (NVInt)toInt;
- (NVFloat)toFloat;
- (NSString *)toString;

- (NVStackElement *)createStackElement:(NVLiteral*)literal;

- (NVStackElement *)copy;

- (BOOL)invokeMethod:(NSString *)methodName stackElement:(NSArray<NVStackElement *> *)arguments;
- (BOOL)invokeMethod:(NSString *)methodName stackElement:(NSArray<NVStackElement *> *)arguments lastStack:(NSArray<NVStackElement *> *)lastStack;

- (NVStackElement *)getAttribute:(NSString *)attrName;
- (void)setAttribute:(NSString *)attributeName value:(NVStackElement *)value;

@end

//typedef NSMutableArray<NVStackElement *> NVStack;

@interface NVStack : NSObject

@property (nonatomic, readonly) NSInteger count;

@property (nonatomic, readonly) NVStackElement *top;

- (void)addObject:(NVStackElement *)object;

- (void)removeAllObjects;

- (NVStackElement *)pop;

@end

@interface NVStackIntElement : NVStackElement
- (id)initWithInt:(int)value;
@end

@interface NVStackFloatElement : NVStackElement
- (id)initWithFloat:(int)value;
@end

@interface NVStackStringElement : NVStackElement
- (id)initWithString:(NSString *)str;
@end

@interface NVStackVariableElement : NVStackElement

@property (nonatomic) NSString *name;
@property (nonatomic) BOOL isArray;
@property (nonatomic) NVStackElement *valueElement;

- (id)initWithName:(NSString *)name value:(NVStackElement *)value;

@end

@interface NVAccessor : NVStackElement
@property (nonatomic, readonly) NVStackElement *value;
-(void)set:(NVStackElement *)value;
@end

@interface NVFieldAccessor : NVAccessor
- (id)initWithScope:(NVStackElement *)scope attributeName:(NSString *)attributeName;
@end

NS_ASSUME_NONNULL_END
