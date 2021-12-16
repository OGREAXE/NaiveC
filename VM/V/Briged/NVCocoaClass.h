//
//  NVCocoaClass.h
//  NaiveC
//
//  Created by liangzhiyuan on 2021/12/15.
//  Copyright © 2021 Ogreaxe. All rights reserved.
//

#import "NVClass.h"

NS_ASSUME_NONNULL_BEGIN

/// to hold the infomation of a cocoa class used
/// for example, when reaching a line : a = [[NSSomeClass alloc] init]
/// a NVCocoaClass object will be created to hold the infomation of NSSomeClass
/// to which later access of NSSomeClass (like alloc) will be delegated
@interface NVCocoaClass : NVClass

@property (nonatomic) NSString *className;

- (id)initWithClassName:(NSString *)className;

@end

NS_ASSUME_NONNULL_END
