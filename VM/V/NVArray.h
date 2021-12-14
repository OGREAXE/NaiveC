//
//  NVArray.h
//  NaiveC
//
//  Created by liangzhiyuan on 2021/12/14.
//  Copyright © 2021 Ogreaxe. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NVObject.h"

NS_ASSUME_NONNULL_BEGIN

@interface NVArray : NSObject <NVBracketAccessible, NVFastEnumerable>

@end

@interface NVArrayAccessor : NVAccessor

- (id)initWithAccessible:(id<NVBracketAccessible>)accessible key:(NVStackElement *)key;

@end

NS_ASSUME_NONNULL_END
