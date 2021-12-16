//
//  NVCocoaClass.m
//  NaiveC
//
//  Created by liangzhiyuan on 2021/12/15.
//  Copyright © 2021 Ogreaxe. All rights reserved.
//

#import "NVCocoaClass.h"
#import "NVCocoaBox.h"
#import "NSObject+NVInvocation.h"

@implementation NVCocoaClass

- (id)initWithClassName:(NSString *)className {
    self = [super init];
    
    self.className = className;
    
    return self;
}

- (NVStackPointerElement *)instantiate:(NSArray<NVStackElement *> *)arguments {
    //instantiate NSObject subclass
    Class thisClass = NSClassFromString(self.className);
    id allocedObject = [thisClass alloc];
    
    NVCocoaBox *box = [[NVCocoaBox alloc] initWithObject:allocedObject];
    
    return [[NVStackPointerElement alloc] initWithObject:box];
}

- (BOOL)invokeMethod:(NSString *)methodName
           arguments:(nonnull NSArray<NVStackElement *> *)arguments
           lastStack:(nonnull NVStack *)lastStack {
    
    Class thisClass = NSClassFromString(self.className);
    
    return [NSObject nv_invoke:methodName object:nil orClass:thisClass arguments:arguments stack:lastStack];
}

@end
