//
//  NVParser.m
//  NaiveC
//
//  Created by liangzhiyuan on 2021/11/18.
//  Copyright © 2021 Ogreaxe. All rights reserved.
//

#import "NVParser.h"

@interface NVParser ()

@end

@implementation NVParser

- (id)init {
    self = [super init];
    self.index = 0;
    return self;
}

- (NSArray<NSString *> *)keywords {
    static NSArray<NSString *> *g_keywords = nil;
    if (!g_keywords) {
        g_keywords = @[
            //types
            @"int",@"float",@"string",@"void",
            //operator
            @"=",@"+=",@"-=",@"*=",@"/=",@"++",
            @"+",@"-",@"*",@"/",
            @"%",@".",@"|",@"&",@"||",@"&&",@"!",
            //paren
            @"{",@"}",@"(",@")",@"[",@"]",
            //comma
            @",",
            @"^",
            //statement
            @"if",@"else",
            @"while",@"for",
            @"break",@"continue",
            @"return",
        ];
    }
    
    return g_keywords;
}

@end
