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
#include "NCSourceManager.hpp"

#include "NCException.hpp"
#include "NCLog.hpp"

#include "NPFunction.h"
#include "NCObject.hpp"
#include "NCCocoaBox.hpp"

#include <memory>

#define SAFE_RELEASE(p) {if(p){delete p;p=NULL;}}

using namespace std;

//to do remove JPBoxing dependency!
@interface JPBoxing : NSObject
@property (nonatomic) id obj;
@property (nonatomic) void *pointer;
@property (nonatomic) Class cls;
@property (nonatomic, weak) id weakObj;
@property (nonatomic, assign) id assignObj;
- (id)unbox;
- (void *)unboxPointer;
- (Class)unboxClass;
@end

@interface NCCodeEngine_iOS()
@end

@interface NCCodeEngine_iOS()
@property (nonatomic) NSString * rootDirectory;
@end

@implementation NCCodeEngine_iOS
{
    NCTokenizer *_tokenizer;
    NCParser * _parser;
    NCInterpreter * _interpreter;
    
    shared_ptr<NCSourceManager>  _sourceManager;
}

+ (NCCodeEngine_iOS *)defaultEngine {
    static NCCodeEngine_iOS *_engine = nil;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _engine = [[NCCodeEngine_iOS alloc] init];
    });
    
    return _engine;
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
    
    if (self.mode == NCInterpretorModeModular) {
        [self doInitForModularMode];
    }
}

-(void)doInitForModularMode{
    if (self.rootDirectory) {
        _sourceManager = shared_ptr<NCSourceManager>(new NCSourceManager(self.rootDirectory.UTF8String));
        shared_ptr<NCClassProvider> smr = _sourceManager;
        NCClassLoader::GetInstance()->registerProvider(smr);
    }
}

-(void)uninit{
    SAFE_RELEASE(_tokenizer);
    SAFE_RELEASE(_parser);
    SAFE_RELEASE(_interpreter);
//    SAFE_RELEASE(_sourceManager);
    
    NCClassLoader::releaseInstance();
}

-(BOOL)parseSourceCode:(NSString*)codeText{
    if (!codeText) {
        return NULL;
    }
    
    string str = codeText.UTF8String;
    
    if (!_tokenizer->tokenize(str)) {
        NSLog(@"tokenization fail");
        return NO;
    }
    
    auto tokens = _tokenizer->getTokens();
    
    try{
        if(!_parser->parse(tokens)){
            NSLog(@"parse fail");
            return NO;
        }
    }
    catch (NCParseException & e) {
        string errMsg = "";
        errMsg += e.getErrorMessage();
        
        NCLog(NCLogTypeParser, errMsg.c_str());
    }
    
    return YES;
}

-(BOOL)runWithError:(NSError**)error{
    try {
        _interpreter->invoke_main();
    } catch (NCRuntimeException & e) {
        string errMsg = "VM terminated: ";
        errMsg += e.getErrorMessage();
        
        NCLog(NCLogTypeInterpretor, errMsg.c_str());
    }
    
    return YES;
}

-(id)run:(NSString*)sourceCode arguments:(NSArray *)arguments error:(NSError**)error {
    NSAssert(NO, @"use runWithMethod");
    return nil;
}
    
-(id)runWithMethod:(NPPatchedMethod*)method arguments:(NSArray *)arguments error:(NSError**)error {
    NSString * completedSource = [self completedMainSourceWithBody:method.body];
    [self parseSourceCode:completedSource];
    
    if (_parser->getRoot()->functionList.size() == 0) {
        NCLog(NCLogTypeInterpretor, "parse nothing");
        return nil;
    }
    
    _interpreter->initWithRoot(_parser->getRoot());
    
    try {
        vector<string> argNames;
        
        vector<shared_ptr<NCStackElement>> args;
        
        for (int i = 0; i < arguments.count; i ++) {
            id v = arguments[i];
            
            if ([v isKindOfClass:NPValue.class]) {
                NPValue *v = arguments[i];
                
                NCStackElement *e = v.stackElement;
                args.push_back(shared_ptr<NCStackElement>(e));
            }
            else if ([v isKindOfClass:JPBoxing.class]) {
                JPBoxing *v = arguments[i];
                
                NCStackElement *e = MAKE_COCOA_POINTER(v.weakObj);
                args.push_back(shared_ptr<NCStackElement>(e));
            }
            else if ([v isKindOfClass:NSObject.class]) {
                NCStackElement *e = MAKE_COCOA_POINTER(v);
                args.push_back(shared_ptr<NCStackElement>(e));
            }
            
            
            string name = [method.parameterPairs objectAtIndex:i].name.UTF8String;
            argNames.push_back(name);
        }
        
        vector<shared_ptr<NCStackElement>> lastStack;
        _interpreter->invoke("main", argNames, args, lastStack);
    } catch (NCRuntimeException & e) {
        string errMsg = "VM terminated: ";
        errMsg += e.getErrorMessage();
        
        NCLog(NCLogTypeInterpretor, errMsg.c_str());
    }
    
    return nil;
}

-(BOOL)run:(NSString*)sourceCode error:(NSError**)error{
    [self parseSourceCode:sourceCode];
    
    if (_parser->getRoot()->functionList.size() == 0 && _parser->getRoot()->classList.size() == 0) {
        NCLog(NCLogTypeInterpretor, "parse nothing");
        return NO;
    }
    
    _interpreter->initWithRoot(_parser->getRoot());
    
    try {
        _interpreter->invoke_main();
    } catch (NCRuntimeException & e) {
        string errMsg = "VM terminated: ";
        errMsg += e.getErrorMessage();
        
        NCLog(NCLogTypeInterpretor, errMsg.c_str());
    }
    
    return YES;
}

- (NSString *)completedMainSourceWithBody:(NSString *)body {
    NSString * completedSource = [NSString stringWithFormat:@"void main(){%@\n}",body];
    
    return completedSource;
}

-(BOOL)run:(NSString*)sourceCode mode:(NCInterpretorMode)mode error:(NSError**)error{
    if (mode == NCInterpretorModeCommandLine) {
//        NSString * completedSource = [NSString stringWithFormat:@"void main(){%@\n}",sourceCode];
        NSString * completedSource = [self completedMainSourceWithBody:sourceCode];
        return [self run:completedSource error:error];
    }
    else {
        return [self run:sourceCode error:error];
    }
}

-(void)setRoot:(NSString*)rootDir{
    if (rootDir && rootDir != self.rootDirectory) {
        self.rootDirectory = rootDir;
        [self uninit];
        [self doInit];
    }
}
-(void)setDirty:(NSString*)filename{
    if (_sourceManager) {
        _sourceManager->setFileDirty(filename.UTF8String);
    }
}

@end
