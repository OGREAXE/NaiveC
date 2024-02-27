//
//  NPFunction.h
//  NaivePatch
//
//  Created by mi on 2024/1/22.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
//#include "NCStackElement.hpp"
#import "NPPatchedClass.h"

NS_ASSUME_NONNULL_BEGIN

#define NPNumber(number, type) number//[NPValue numberWithNumber:number type:type]

@interface NPValue : NSObject

+ (NPValue *)numberWithNumber:(NSNumber *)number type:(char)type;

+ (NPValue *)valueWithRect:(CGRect)rect;
+ (NPValue *)valueWithPoint:(CGPoint)point;
+ (NPValue *)valueWithSize:(CGSize)size;
+ (NPValue *)valueWithRange:(NSRange)range;
+ (NPValue *)valueWithInset:(UIEdgeInsets)inset;

@property (nonatomic) NSString *types;

//@property (nonatomic, readonly) NCStackElement *stackElement;

- (id)toObject;
- (CGRect)toRect;
- (CGPoint)toPoint;
- (CGSize)toSize;
- (NSRange)toRange;

@end

@interface NPFunction : NSObject

//@property (nonatomic) NSString *code;

@property (nonatomic) NPPatchedMethod *method;

- (NPValue *)callWithArguments:(NSArray<NPValue*> *)args;

@end

NS_ASSUME_NONNULL_END
