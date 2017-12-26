//
//  NCInterpreterController.m
//  NaiveC
//
//  Created by Liang,Zhiyuan(GIS) on 2017/12/25.
//  Copyright © 2017年 Ogreaxe. All rights reserved.
//

#import "NCInterpreterController.h"
#include "NCTokenizer.hpp"
#include "NCParser.hpp"
#include "NCInterpreter.hpp"
#include "Common.h"

@interface NCInterpreterController()
@end

@implementation NCInterpreterController{
    NCTokenizer *_tokenizer;
    NCParser * _parser;
    NCInterpreter * _interpreter;
}

-(id)initWithDataSource:(NCDataSource*)dataSource{
    self = [super init];
    if (self) {
        
    }
    return self;
}

-(void)textDidLoad:(NCDataSource*)dataSource{
    if (!dataSource.text || dataSource.text.length == 0) {
        return;
    }
    
    string str = dataSource.text.UTF8String;
    
    if (!_tokenizer) {
        _tokenizer = new NCTokenizer();
    }
    
    if (!_tokenizer->tokenize(str)) {
        NCLog(@"tokenization fail %@");
        return;
    }
    
    NSMutableArray * tokArray = [NSMutableArray array];
    
    const vector<NCToken> & tokens = _tokenizer->getTokens();
    for (int i=0; i<tokens.size(); i++) {
        const auto & aToken = tokens[i];
        NSValue *tokValue = [NSValue valueWithBytes:&aToken objCType:@encode(struct NCToken)];
        [tokArray addObject:tokValue];
    }
    _tokenArray = tokArray;
    
    if ([self.delegate respondsToSelector:@selector(didFinishTokenization:)]) {
        [self.delegate didFinishTokenization:self];
    }
    
    if (!_parser) {
        _parser = new NCParser();
    }
    if(!_parser->parse(tokens)){
        NCLog(@"parse fail %@");
        return;
    }
    
    if ([self.delegate respondsToSelector:@selector(didFinishParsing:)]) {
        [self.delegate didFinishParsing:self];
    }
}

-(void)textDidChange:(NCDataSource*)dataSource{
    
}

- (BOOL)dataSource:(NCDataSource *)dataSource shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text{
    return YES;
}

@end
