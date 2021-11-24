//
//  NVParser.h
//  NaiveC
//
//  Created by liangzhiyuan on 2021/11/18.
//  Copyright © 2021 Ogreaxe. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NVAST.h"
#import "NVTokenizer.h"

NS_ASSUME_NONNULL_BEGIN

@interface NVParser : NSObject

@property (nonatomic) NVASTRoot *pRoot;

@property (nonatomic) NSArray<NVToken *> *tokens;

@property (nonatomic) int index;
@property (nonatomic) NSString *word;

@end

NS_ASSUME_NONNULL_END
