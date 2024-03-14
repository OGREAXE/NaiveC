//
//  NSCocoaSymbolStore.h
//  NaiveC
//
//  Created by mi on 2024/3/7.
//  Copyright © 2024 Ogreaxe. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSNumber (Naive)

@property (nonatomic) BOOL isPrimitive;

@end

@interface NSCocoaSymbolStore : NSObject
+(id)symbolForName:(NSString *)name;
@end

NS_ASSUME_NONNULL_END
