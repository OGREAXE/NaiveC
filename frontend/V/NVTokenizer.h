//
//  NVTokenizer.h
//  NaiveC
//
//  Created by liangzhiyuan on 2021/11/17.
//  Copyright © 2021 Ogreaxe. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

typedef enum TokenStatus {
    TokenUnknown = 0,
    TokenIdentifier,
    TokenNumber,
    TokenString,
    TokenOperator,
    TokenComma,
    TokenParenthesis,  // ()
    TokenSquareBracket,    //   []
    TokenBrace,     // {}
    TokenComment
} NVTokenStatus;

@interface NVToken : NSObject

@property (nonatomic) NSString *token;
@property (nonatomic) int start;
@property (nonatomic) int length;

@end

@interface NVTokenizer : NSObject

@property (nonatomic, readonly) NSMutableArray<NVToken *> *tokens;
@property (nonatomic) NSString *token;
@property (nonatomic) NVTokenStatus status;

- (BOOL)tokenize:(NSString *)code;

@end

NS_ASSUME_NONNULL_END
