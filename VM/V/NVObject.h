//
//  NVObject.h
//  NaiveC
//
//  Created by liangzhiyuan on 2021/12/13.
//  Copyright © 2021 Ogreaxe. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NVAST.h"
#import "NVStack.h"

NS_ASSUME_NONNULL_BEGIN

typedef NSException NVException;

@class NVStackElement;
@class NVClassDeclaration;

@interface NVObject : NSObject

@property (nonatomic) NVObject *superObject;

- (BOOL)invokeMethod:(NSString *)methodName
           arguments:(NSArray<NVStackElement *> *)arguments
           lastStack:(NVStack *)lastStack;

- (BOOL)invokeMethod:(NSString *)methodName
           arguments:(NSArray<NVStackElement *> *)arguments;

- (NVStackElement *)getAttribute:(NSString *)attributeName;

- (void)setAttribute:(NSString *)attributeName value:(NVStackElement *)value;

- (NSString *)getDescription;

- (NVInt)toInt;

- (NVObject *)copy;

@end

@interface NVNativeObject : NVObject

@property (nonatomic) NSMutableDictionary<NSString *, NVStackElement *> *fieldMap;
@property (nonatomic) NVClassDeclaration *classDefinition;

@end

/**
 helper objects for lambda capture
 */
@interface NVCapturedObject : NVObject
@property (nonatomic) int signature;
@property (nonatomic) NSString *name;
@property (nonatomic) NVStackElement *object;
@end

/*
 lambda object
 */
@interface NVLambdaObject: NVObject

@property (nonatomic) NVLambdaExpression *lambdaExpression;

@property (nonatomic) NSMutableArray<NVCapturedObject *> *capturedObjects;

- (id)initWithLambdaExpression:(NVLambdaExpression *)lambdaExpr;

- (void)addCaptured:(NVCapturedObject *)capuredObj;

@end


/**
 pointer to an object
 */
@interface NVStackPointerElement: NVStackElement

@property (nonatomic, readonly) NVObject *object;

- (id)initWithObject:(NVObject *)obj;

@end

/*
 abstract interface for access of value with [], such as array[5]
 */
@protocol NVBracketAccessible<NSObject>

- (void)br_set:(NVStackElement *)key value:(NVStackElement *)value;
- (NVStackElement *)br_getValue:(NVStackElement *)key;

@end

/*
 abstract interface for fast enumeration
 */
@protocol NVFastEnumerable<NSObject>
/**
closure return true to break

@param handler <#anObj description#>
*/
- (void)enumerate:(BOOL(^)(NVStackElement *stackElement))handler;

@end

BOOL isPrimitiveType(NSString *type);

@interface NSObject (NVObject)

- (void)throw_exception:(NVException *)e;

@end

NS_ASSUME_NONNULL_END
