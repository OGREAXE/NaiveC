//
//  NPMethodSignature.h
//  NaiveStudio
//
//  Created by mi on 2024/2/5.
//  Copyright © 2024 Liang,Zhiyuan(GIS). All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ffi.h"

NS_ASSUME_NONNULL_BEGIN

@interface NPMethodSignature : NSObject

@property (nonatomic, readonly) NSString *types;
@property (nonatomic, readonly) NSArray *argumentTypes;
@property (nonatomic, readonly) NSString *returnType;

- (instancetype)initWithObjCTypes:(NSString *)objCTypes;
- (instancetype)initWithBlockTypeNames:(NSString *)typeNames;

+ (ffi_type *)ffiTypeWithEncodingChar:(const char *)c;
+ (NSString *)typeEncodeWithTypeName:(NSString *)typeName;

@end

NS_ASSUME_NONNULL_END
