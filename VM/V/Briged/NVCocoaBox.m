//
//  NVCocoaBox.m
//  NaiveC
//
//  Created by liangzhiyuan on 2021/12/15.
//  Copyright © 2021 Ogreaxe. All rights reserved.
//

#import "NVCocoaBox.h"
#import "NSObject+NVInvocation.h"
#import "NVStack.h"

@interface NVCocoaBox ()

//@property (nonatomic) NSObject *cocoaObject;

@end

@implementation NVCocoaBox

- (id)initWithObject:(NSObject *)object {
    self = [super init];
    
    self.cocoaObject = object;
    
    return self;
}

- (BOOL)invokeMethod:(NSString *)methodName
           arguments:(NSArray<NVStackElement *> *)arguments
           lastStack:(NVStack *)lastStack {
    if (!self.cocoaObject) {
        return NO;
    }
    
    return [self.cocoaObject nv_invoke:methodName
                             arguments:arguments
                                 stack:lastStack];
}

- (BOOL)invokeMethod:(NSString *)methodName
           arguments:(NSArray<NVStackElement *> *)arguments {
    return [self.cocoaObject nv_invoke:methodName arguments:arguments stack:nil];
}

- (NVStackElement *)getAttribute:(NSString *)attributeName {
    NVStack *resultContainerStack = [[NVStack alloc] init];
    
    NSString *methodName = attributeName;
    
    BOOL res = [self.cocoaObject nv_invoke:methodName arguments:nil stack:resultContainerStack];
    
    if (res && resultContainerStack.count > 0) {
        return resultContainerStack.top;
    }
    
    NSLog(@"attribute %@ not found", methodName);
    return nil;
}

- (void)setAttribute:(NSString *)attributeName value:(NVStackElement *)value {
    if (attributeName.length <= 0) {
        NVException *e = [NSException exceptionWithName:@"NVCocoaBox_exception" reason:@"attribute name empty" userInfo:nil];
        [self throw_exception:e];
        return;
    }
    
    NSString *firstUppercaseChar = [[attributeName uppercaseString] substringToIndex:1];
    
    NSString * methodName = [NSString stringWithFormat:@"set%@%@", firstUppercaseChar, [attributeName substringFromIndex:1]];
    
    NVStack *resultContainerStack = [[NVStack alloc] init];
    
    [self.cocoaObject nv_invoke:methodName arguments:nil stack:resultContainerStack];
}

- (NSString *)getDescription {
    return [self.cocoaObject description];
}

- (NVInt)toInt {
    return self.cocoaObject != NULL;
}

- (NVObject *)copy {
    return [[NVCocoaBox alloc] initWithObject:self.cocoaObject];
}

- (void)br_set:(NVStackElement *)key value:(NVStackElement *)value {
    if ([self.cocoaObject respondsToSelector:@selector(br_set:value:)]) {
        [self.cocoaObject performSelector:@selector(br_set:value:) withObject:key withObject:value];
    } else {
        NVException *e = [NSException exceptionWithName:@"NVCocoaBox" reason:@"set with [] is not supported" userInfo:nil];
        [self throw_exception:e];
    }
}

- (NVStackElement *)br_getValue:(NVStackElement *)key {
    if ([self.cocoaObject respondsToSelector:@selector(br_getValue)]) {
        return [self.cocoaObject performSelector:@selector(br_getValue)];
    } else {
        NVException *e = [NSException exceptionWithName:@"NVCocoaBox" reason:@"get with [] is not supported" userInfo:nil];
        [self throw_exception:e];
        
        return nil;
    }
}

@end

@implementation NVCocoaClassBox

- (id)initWithClass:(Class)aClass {
    self = [super init];
    
    self.cocoaClass = aClass;
    
    return self;
}

- (NSString *)getDescription {
    return NSStringFromClass(self.class);
}

@end

@implementation NVStackPointerElement (NVCocoaBox)

- (NSObject *)toNSObject {
   if (!self.object) {
       NVException *e = [NSException exceptionWithName:@"NVStackPointerElement" reason:@"pointer is nil" userInfo:nil];
       [self throw_exception:e];
       
       return nil;
   }
   
   NVCocoaBox *cocoaBox = (NVCocoaBox *)self.object;
   
   if (![cocoaBox isKindOfClass:NVCocoaBox.class]) {
       NVException *e = [NSException exceptionWithName:@"NVStackPointerElement" reason:@"pointer is nil" userInfo:nil];
       [self throw_exception:e];
       
       return nil;
   }
    
    return cocoaBox.cocoaObject;
}

@end
