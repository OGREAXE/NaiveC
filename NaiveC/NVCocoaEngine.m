//
//  NVCocoaEngine.m
//  NaiveC
//
//  Created by liangzhiyuan on 2021/12/16.
//  Copyright © 2021 Ogreaxe. All rights reserved.
//

#import "NVCocoaEngine.h"
#import "NVTokenizer.h"
#import "NVInterpreter.h"
#import "NVParser.h"

@interface NVCocoaEngine ()

@property (nonatomic) NVTokenizer *tokenizer;

@property (nonatomic) NVInterpreter *interpreter;

@property (nonatomic) NVParser *parser;

@end

@implementation NVCocoaEngine

- (NVTokenizer *)tokenizer {
    if (!_tokenizer) {
        _tokenizer = [[NVTokenizer alloc] init];
    }
    
    return _tokenizer;
}

- (NVInterpreter *)interpreter {
    if (!_interpreter) {
        _interpreter = [[NVInterpreter alloc] init];
    }
    
    return _interpreter;
}

- (NVParser *)parser {
    if (!_parser) {
        _parser = [[NVParser alloc] init];
    }
    
    return _parser;
}

//used in project
- (void)setRoot:(NSString*)rootDir {
    
}

- (void)setDirty:(NSString*)filename {
    
}

- (BOOL)run {
    return NO;
}

- (BOOL)runWithError:(NSError**)error {
    return NO;
}

//play ground only
//run a piece of code
- (BOOL)run:(NSString*)sourceCode error:(NSError**)error {
    [self parseSourceCode:sourceCode];
    
    [self.interpreter initWithRoot:self.parser.root];
    
    NVStack *stack = [[NVStack alloc] init];
    
    if ([self.interpreter invoke:@"main" lastStack:stack]) {
        NVStackElement *result = stack.top;
        
        NSLog(@"result is %@", [result toString]);
    }
    
    return NO;
}

- (BOOL)run:(NSString*)sourceCode
      mode:(NCInterpretorMode)mode
     error:(NSError**)error {
    if (mode == NCInterpretorModeCommandLine) {
        NSString * completedSource = [NSString stringWithFormat:@"int main(){%@\n}",sourceCode];
        return [self run:completedSource error:error];
    }
    else {
        return [self run:sourceCode error:error];
    }
}

-(BOOL)parseSourceCode:(NSString*)codeText{
    if (!codeText) {
        return NULL;
    }
    
    if (![self.tokenizer tokenize:codeText]) {
        NSLog(@"tokenization fail");
        return NO;
    }
    
    NSMutableArray *tokens = self.tokenizer.tokens;

    if(![self.parser parse:tokens]){
        NSLog(@"parse fail");
        return NO;
    }
    
    return YES;
}

@end
