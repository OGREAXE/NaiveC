//
//  NCModuleCache.hpp
//  NaiveC
//
//  Created by Liang,Zhiyuan(GIS) on 2018/3/7.
//  Copyright © 2018年 Ogreaxe. All rights reserved.
//

#ifndef NCModuleCache_hpp
#define NCModuleCache_hpp

#include <stdio.h>
#include <unordered_map>

#include "NCAST.hpp"
#include "NCBuiltinFunction.hpp"
#include "NCStackElement.hpp"
#include "NCObject.hpp"
#include "NCBuiltinFunctionStore.hpp"
#include "NCClassLoader.hpp"

#include "NCClass.hpp"

using namespace std;

/*
 loads and holds class def, function def for interpretor to look in
 */
class NCModuleCache{
public:
    static NCModuleCache* GetGlobalCache()
    {
        if ( m_pInstance == NULL )
            m_pInstance = new NCModuleCache();
        return m_pInstance;
    }
    
    void addNativeFunction(shared_ptr<NCASTFunctionDefinition> & funcDef){
        m_functionMap[funcDef->name] = funcDef;
    }
    
    shared_ptr<NCASTFunctionDefinition> getNativeFunction(const string &name){
        auto findFunc = m_functionMap.find(name);
        if (findFunc!=m_functionMap.end()) {
            auto functionDef = (*findFunc).second;
            return functionDef;
        }
        else {
            return nullptr;
        }
    }
    
    void addSystemFunction(shared_ptr<NCBuiltinFunction> & func){
        m_builtinFunctionStore.addFunction(func);
    }
    
    bool findSystemFunction(const string &name){
        return m_builtinFunctionStore.findFunction(name);
    }
    
    shared_ptr<NCBuiltinFunction> getSystemFunction(const string &name){
        return m_builtinFunctionStore.getFunction(name);
    }
    
    void addClassDef(shared_ptr<NCClassDeclaration>& classDef){
        m_classDefMap[classDef->name] = classDef;
    }
    
    shared_ptr<NCClassDeclaration> getClassDef(const string &name){
        auto find = m_classDefMap.find(name);
        if (find!=m_classDefMap.end()) {
            auto classdef = (*find).second;
            return classdef;
        }
        else {
            return nullptr;
        }
    }
    
    shared_ptr<NCClass> getClass(const string &name){
        //query buffer
        auto find = m_classMap.find(name);
        if (find!=m_classMap.end()) {
            auto cls = (*find).second;
            return cls;
        }
        
        //query class def, then set buffer
        auto clsDef = getClassDef(name);
        if(clsDef){
            auto cls = shared_ptr<NCClass>(new NCNativeClass(clsDef));
            m_classMap[name] = cls;
            return cls;
        }
        
        //try loading;
        auto exCls = NCClassLoader::GetInstance()->loadClass(name);
        if(exCls){
            m_classMap[name] = exCls;
            return exCls;
        }
        
        return nullptr;
    
    }
    
private:
    NCModuleCache(){
    }
    
    static NCModuleCache * m_pInstance;
    
private:
    unordered_map<string, shared_ptr<NCASTFunctionDefinition>> m_functionMap;
    
    NCBuiltinFunctionStore m_builtinFunctionStore;
    
    unordered_map<string, shared_ptr<NCClassDeclaration>> m_classDefMap;
    
    unordered_map<string, shared_ptr<NCClass>> m_classMap;
};
    
#endif /* NCModuleCache_hpp */
