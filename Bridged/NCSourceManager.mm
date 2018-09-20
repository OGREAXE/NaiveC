//
//  NCSourceManager.cpp
//  NaiveC
//
//  Created by Liang,Zhiyuan(GIS)2 on 18/9/18.
//  Copyright © 2018年 Ogreaxe. All rights reserved.
//

#include "NCSourceManager.hpp"
#include "NCException.hpp"
#include "NCLog.hpp"

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

using namespace std;

NCSourceManager::NCSourceManager(){
    
}

NCSourceManager::NCSourceManager(const string & rootDir){
    _tokenizer = new NCTokenizer();
    _parser = new NCParser();
    _interpreter = new NCInterpreter();
    
    this->rootDirectory = rootDir;
    
    reload();
}

void NCSourceManager::reload(){
    NSString * rootStr = [NSString stringWithUTF8String:rootDirectory.c_str()];
    
    NSError * error = nil;
    NSArray * files = [[NSFileManager defaultManager]  contentsOfDirectoryAtPath:rootStr error:&error];
    if (error) {
        NSString * userInfoStr = [NSString stringWithFormat:@"%@",error.userInfo];
        throw NCRuntimeException((int)error.code, "error init source manager :%s",userInfoStr.UTF8String);
    }
    
    [files enumerateObjectsUsingBlock:^(NSString *  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        loadFile(obj.UTF8String);
    }];
}

void NCSourceManager::loadFile(const string & filename){
    auto fullpathStr = rootDirectory + filename;
//    NSString * rootStr = [NSString stringWithUTF8String:rootDirectory.c_str()];
//    NSString * fileFullPath = [rootStr stringByAppendingString:obj];
    NSString * fileFullPath = [NSString stringWithUTF8String:fullpathStr.c_str()];
    NSString * content = [NSString stringWithContentsOfFile:fileFullPath encoding:NSUTF8StringEncoding error:nil];
    auto root = parseSourceFile(content.UTF8String);
    
    std::vector<std::string> moduleList;
    
    auto functionDefList = root->functionList;
    for (auto funcDef :functionDefList) {
        NCModuleCache::GetGlobalCache()->addNativeFunction(funcDef);
        
        moduleList.push_back(funcDef->name);
    }
    
    for (auto classDef :root->classList) {
        NCModuleCache::GetGlobalCache()->addClassDef(classDef);
        moduleList.push_back(classDef->name);
    }
    
    this->moduleNameMap.insert(make_pair(filename, moduleList));
}

shared_ptr<NCASTRoot> NCSourceManager::parseSourceFile(const std::string & source){
    if (!_tokenizer->tokenize(source)) {
        NCLog(NCLogTypeParser,"tokenization fail");
        return nullptr;
    }
    
    auto tokens = _tokenizer->getTokens();
    
    try{
        if(!_parser->parse(tokens)){
            NCLog(NCLogTypeParser,"parse fail");
            return nullptr;
        }
    }
    catch (NCParseException & e) {
        string errMsg = "";
        errMsg += e.getErrorMessage();
        
        NCLog(NCLogTypeParser, errMsg.c_str());
        
        return nullptr;
    }
    
    return _parser->getRoot();
}

shared_ptr<NCClass> NCSourceManager::loadClass(const string & className){
    return NCModuleCache::GetGlobalCache()->getClass(className);
}

bool NCSourceManager::classExist(const std::string & className){
    return NCModuleCache::GetGlobalCache()->getClass(className)!=nullptr;
}

std::string NCSourceManager::getFileNameByModule(const std::string & moduleName){
    return nullptr;
}

std::vector<std::string> NCSourceManager::getModulesByFileName(const std::string & fileName){
    auto find = moduleNameMap.find(fileName);
    
    if (find != moduleNameMap.end()) {
        return find->second;
    }
    
    std::vector<std::string> modules;
    return modules;
}

void NCSourceManager::setFileDirty(const std::string & fileName){
    auto modules = getModulesByFileName(fileName);
    
    for(auto m:modules){
        NCModuleCache::GetGlobalCache()->removeModule(m);
    }
    
    loadFile(fileName);
}
