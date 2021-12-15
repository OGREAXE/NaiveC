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

@interface NVArray : NVObject <NVBracketAccessible, NVFastEnumerable>
- (void)addElement:(NVStackElement *)element;
- (NVStackElement *)getAttribute:(NSString *)attributeName;
@end

@interface NVArrayAccessor : NVAccessor

@property (nonatomic) id<NVBracketAccessible> accessible;
@property (nonatomic) NVStackElement *key;

- (id)initWithAccessible:(id<NVBracketAccessible>)accessible key:(NVStackElement *)key;

@end

NS_ASSUME_NONNULL_END
