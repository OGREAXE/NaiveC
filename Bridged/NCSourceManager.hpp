//
//  NCSourceManager.hpp
//  NaiveC
//
//  Created by Liang,Zhiyuan(GIS)2 on 18/9/18.
//  Copyright © 2018年 Ogreaxe. All rights reserved.
//

#ifndef NCSourceManager_hpp
#define NCSourceManager_hpp

#include <stdio.h>
#include <string>
#include <vector>
#include "NCClassProvider.hpp"
#include "NCInterpreter.hpp"
#include "NCParser.hpp"
#include "NCTokenizer.hpp"

#include "NCClassLoader.hpp"
#include "NCCocoaClassProvider.hpp"

#include "NCException.hpp"
#include "NCLog.hpp"

#include <memory>
#include <unordered_map>

class NCSourceManager:public NCClassProvider{
private:
    std::string rootDirectory;
    
    NCTokenizer *_tokenizer;
    NCParser * _parser;
    NCInterpreter * _interpreter;
    
    std::unordered_map<std::string, std::vector<std::string>> moduleNameMap;
private:
    NCSourceManager();
    
    shared_ptr<NCASTRoot> parseSourceFile(const std::string & source);
    
    void reload();
    
    void loadFile(const string & filename);
public:
    NCSourceManager(const string & rootDir);
    
    //module is class or static function
    std::string getFileNameByModule(const std::string & moduleName);
    
    std::vector<std::string> getModulesByFileName(const std::string & fileName);
    
    void setFileDirty(const std::string & fileName);
    
    virtual shared_ptr<NCClass> loadClass(const string & className);
    
    virtual bool classExist(const std::string & className);
};

#endif /* NCSourceManager_hpp */
