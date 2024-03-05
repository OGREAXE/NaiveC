//
//  NCBuiltinFunctionStore.cpp
//  NaiveC
//
//  Created by Liang,Zhiyuan(GIS) on 2018/2/27.
//  Copyright © 2018年 Ogreaxe. All rights reserved.
//

#include "NCBuiltinFunctionStore.hpp"

NCBuiltinFunctionStore::NCBuiltinFunctionStore(){
    auto fPrintObj = shared_ptr<NCBuiltinFunction>(new NCBuiltinPrint());
    addFunction(fPrintObj);
    
    auto fNSLogObj = shared_ptr<NCBuiltinFunction>(new NCBuiltinNSLog());
    addFunction(fNSLogObj);
    
    auto fGetObj = shared_ptr<NCBuiltinFunction>(new NCBuiltinGetObject());
    addFunction(fGetObj);
    
    auto fQueryObj = shared_ptr<NCBuiltinFunction>(new NCBuiltinQueryView());
    addFunction(fQueryObj);
    
    auto fQueryObjs = shared_ptr<NCBuiltinFunction>(new NCBuiltinQueryViews());
    
    addFunction(fQueryObjs);
    
    auto fSearchPath = shared_ptr<NCBuiltinFunction>(new NCBuiltin_NSSearchPathForDirectoriesInDomains());
    
    addFunction(fSearchPath);
    
    //        auto fGetAdaptorValue = shared_ptr<NCBuiltinFunction>(new NCBuiltinGetAdaptorValue());
    //        addFunction(fGetAdaptorValue);
}

bool NCBuiltinFunctionStore::addFunction(shared_ptr<NCBuiltinFunction> & func){
    m_builtinFunctionMap[func->name] = func;
    return true;
}

bool NCBuiltinFunctionStore::findFunction(const string & name){
    auto find = m_builtinFunctionMap.find(name);
    return find != m_builtinFunctionMap.end();
}

shared_ptr<NCBuiltinFunction> NCBuiltinFunctionStore::getFunction(const string & name){
    auto find = m_builtinFunctionMap.find(name);
    if (find == m_builtinFunctionMap.end()) {
        return nullptr;
    }
    return (*find).second;
    }
