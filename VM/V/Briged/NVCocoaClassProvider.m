//
//  NVCocoaClassProvider.m
//  NaiveC
//
//  Created by liangzhiyuan on 2021/12/15.
//  Copyright © 2021 Ogreaxe. All rights reserved.
//

#import "NVCocoaClassProvider.h"
#import "NVCocoaClass.h"

@implementation NVCocoaClassProvider

- (BOOL)classExist:(NSString *)className {
//
//    if (className == NC_CLASSNAME_FRAME
//        ||className == NC_CLASSNAME_SIZE
//        ||className == NC_CLASSNAME_POINT
//        ||className == "CGRectMake"
//        ||className == "CGPointMake"
//        ||className == "CGSizeMake"
//        ||className == "UIEdgeInsetsMake") {
//        return true;
//    }
//
    
    Class targetClass = NSClassFromString(className);
    if (targetClass) {
        return YES;
    }
    
    return NO;
}

- (NVClass *)loadClass:(NSString *)className {
    NVCocoaClass *cocoaClass = [[NVCocoaClass alloc] initWithClassName:className];
    
    return cocoaClass;
}
@end
