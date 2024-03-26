//
//  NPPatchedClass.h
//  NaiveStudio
//
//  Created by mi on 2024/1/30.
//  Copyright © 2024 Liang,Zhiyuan(GIS). All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NPParamterPair : NSObject

@property (nonatomic) NSString *formal;

@property (nonatomic) NSString *type;

@property (nonatomic) NSString *name;

@end

@interface NPPatchedMethod : NSObject

@property (nonatomic, readonly) BOOL isClassMethod;

@property (nonatomic) NSArray<NPParamterPair *> *parameterPairs;

@property (nonatomic) NSString *declaration;

@property (nonatomic) NSString *selector;

@property (nonatomic) NSString *body;

@property (nonatomic) NSString *returnType;

@end

@interface NPPatchedProperty : NSObject

@property (nonatomic) BOOL isPointer;

@property (nonatomic) NSString *type;

@property (nonatomic) NSString *name;

@end

@interface NPPatchedClass : NSObject

@property (nonatomic, copy) NSString *name;

@property (nonatomic) NSArray<NPPatchedProperty *> *patchedProperties;

@property (nonatomic) NSArray<NPPatchedMethod *> *patchedMethods;

@property (nonatomic) NSArray<NPPatchedMethod *> *patchedClassMethods;

@end

NS_ASSUME_NONNULL_END
