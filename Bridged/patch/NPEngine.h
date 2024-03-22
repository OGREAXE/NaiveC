//
//  NPEngine.h
//  NaivePatch
//
//  Created by mi on 2024/1/22.
//

#import <Foundation/Foundation.h>
#import "NCObjCSourceParser.h"

NS_ASSUME_NONNULL_BEGIN

@interface NPEngine : NSObject

+ (void)patchWithCode:(NSString *)code;

+ (void)defineClasses:(NSArray<NPPatchedClass *> *)classes;

+ (NSDictionary *)defineClass:(NSString *)classDeclaration
              instanceMethods:(NSArray<NPPatchedMethod *> *)instanceMethods
                 classMethods:(NSArray<NPPatchedMethod *> *)classMethods;

+ (void)defineStruct:(NSDictionary *)defineDict;

+ (NSMutableDictionary *)registeredStruct;

+ (id)genCallbackBlock:(NSArray *)argTypes;

+ (NPPatchedProperty *)patchedPropertyForName:(NSString *)methodName withClass:(Class)cls;

@end

@interface JPBoxing : NSObject
@property (nonatomic) id obj;
@property (nonatomic) void *pointer;
@property (nonatomic) Class cls;
@property (nonatomic, weak) id weakObj;
@property (nonatomic, assign) id assignObj;
- (id)unbox;
- (void *)unboxPointer;
- (Class)unboxClass;
@end


NS_ASSUME_NONNULL_END
