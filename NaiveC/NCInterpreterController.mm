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

@property (nonatomic) NSMutableDictionary * parserDict;

@end

@implementation NCInterpreterController{
    NCTokenizer *_tokenizer;
//    NCParser * _parser;
    NCInterpreter * _interpreter;
}

-(id)init{
    self = [super init];
    if (self) {
        [self doInit];
    }
    return self;
}

-(void)doInit{
    _parserDict = [NSMutableDictionary dictionary];
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
    
    auto tokens = _tokenizer->getTokens();
    
    NCParser * parser = nullptr;
    NSValue * parserValue = [self.parserDict objectForKey:dataSource.sourceId];
    if (!parserValue) {
        parser = new NCParser();
        self.parserDict[dataSource.sourceId] = [NSValue valueWithPointer:parser];
    }
    else {
        parser = (NCParser *)parserValue.pointerValue;
    }

    if(!parser->parse(tokens)){
        NCLog(@"parse fail %@");
        return;
    }
    if ([self.delegate respondsToSelector:@selector(interpreterController:didFinishParsingDataSource:WithParser:)]) {
        [self.delegate interpreterController:self didFinishParsingDataSource:dataSource WithParser:parser];
    }
}

-(void)textDidChange:(NCDataSource*)dataSource{
    
}

- (BOOL)dataSource:(NCDataSource *)dataSource shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text{
    return YES;
}

@end
