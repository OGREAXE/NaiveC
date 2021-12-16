//
//  NVCocoaBox.h
//  NaiveC
//
//  Created by liangzhiyuan on 2021/12/15.
//  Copyright © 2021 Ogreaxe. All rights reserved.
//

#import "NVObject.h"

NS_ASSUME_NONNULL_BEGIN

/// holds a cocoa object
@interface NVCocoaBox : NVObject <NVBracketAccessible, NVFastEnumerable>

@property (nonatomic) NSObject *cocoaObject;

- (id)initWithObject:(NSObject *)object;

@end

/// holds a meta class object
@interface NVCocoaClassBox : NVObject

@property (nonatomic) Class cocoaClass;

- (id)initWithClass:(Class)aClass;

@end

@interface NVStackPointerElement (NVCocoaBox)

- (NSObject *)toNSObject;

@end

NS_ASSUME_NONNULL_END
