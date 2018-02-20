//
//  NCCodeEngine.m
//  NaiveC
//
//  Created by Liang,Zhiyuan(GIS) on 2018/2/16.
//  Copyright © 2018年 Ogreaxe. All rights reserved.
//

#import "NCCodeEngine_iOS.h"

#include "NCInterpreter.hpp"
#include "NCParser.hpp"
#include "NCTokenizer.hpp"

#include "NCClassLoader.hpp"
#include "NCCocoaClassProvider.hpp"

#include <memory>

using namespace std;

@interface NCCodeEngine_iOS()
@end

@implementation NCCodeEngine_iOS
{
    NCTokenizer *_tokenizer;
    NCParser * _parser;
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
    _tokenizer = new NCTokenizer();
    _parser = new NCParser();
    _interpreter = new NCInterpreter();
    
    auto cocoaProvider = shared_ptr<NCClassProvider>(new NCCocoaClassProvider());
    NCClassLoader::GetInstance()->registerProvider(cocoaProvider);
}

-(BOOL)parseSourceCode:(NSString*)codeText{
    if (!codeText) {
        return NULL;
    }
    
    string str = codeText.UTF8String;
    
    if (!_tokenizer->tokenize(str)) {
        NSLog(@"tokenization fail");
        return nil;
    }
    
    auto tokens = _tokenizer->getTokens();
    
    if(!_parser->parse(tokens)){
        NSLog(@"parse fail");
        return NO;
    }
    
    return YES;
}

-(BOOL)run:(NSString*)sourceCode error:(NSError**)error{
    [self parseSourceCode:sourceCode];
    _interpreter->initWithRoot(_parser->getRoot());
    _interpreter->invoke_main();
    return YES;
}

@end