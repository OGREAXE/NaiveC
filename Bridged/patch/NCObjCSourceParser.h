//
//  NCObjCSourceParser.h
//  NaivePatch
//
//  Created by mi on 2024/1/19.
//

#import <Foundation/Foundation.h>
#import "NPPatchedClass.h"

NS_ASSUME_NONNULL_BEGIN

@interface NCObjCSourceParser : NSObject

- (NSArray<NPPatchedClass *> *)extractPatchMethodFromContent:(NSString *)content;

@end

NS_ASSUME_NONNULL_END
