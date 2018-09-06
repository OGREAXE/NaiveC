//
//  NCBuiltinFunctionStore.hpp
//  NaiveC
//
//  Created by Liang,Zhiyuan(GIS) on 2018/2/27.
//  Copyright © 2018年 Ogreaxe. All rights reserved.
//

#ifndef NCBuiltinFunctionStore_hpp
#define NCBuiltinFunctionStore_hpp

#include <stdio.h>
#include <map>

#include "NCBuiltinFunction.hpp"

class NCBuiltinFunctionStore{
private:
    std::unordered_map<string, shared_ptr<NCBuiltinFunction>> m_builtinFunctionMap;
public:
    NCBuiltinFunctionStore(){
        auto fPrintObj = shared_ptr<NCBuiltinFunction>(new NCBuiltinPrint());
        addFunction(fPrintObj);
        
        auto fGetObj = shared_ptr<NCBuiltinFunction>(new NCBuiltinGetObject());
        addFunction(fGetObj);
        
        auto fQueryObj = shared_ptr<NCBuiltinFunction>(new NCBuiltinQueryView());
        addFunction(fQueryObj);
        
//        auto fGetAdaptorValue = shared_ptr<NCBuiltinFunction>(new NCBuiltinGetAdaptorValue());
//        addFunction(fGetAdaptorValue);
    }
    
    bool addFunction(shared_ptr<NCBuiltinFunction> & func){
        m_builtinFunctionMap[func->name] = func;
        return true;
    }
    
    bool findFunction(const string & name){
        auto find = m_builtinFunctionMap.find(name);
        return find != m_builtinFunctionMap.end();
    }
    
    shared_ptr<NCBuiltinFunction> getFunction(const string & name){
        auto find = m_builtinFunctionMap.find(name);
        if (find == m_builtinFunctionMap.end()) {
            return nullptr;
        }
        return (*find).second;
    }
};

#endif /* NCBuiltinFunctionStore_hpp */
