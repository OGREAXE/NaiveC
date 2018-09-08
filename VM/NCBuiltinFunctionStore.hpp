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
    NCBuiltinFunctionStore();
    
    bool addFunction(shared_ptr<NCBuiltinFunction> & func);
    
    bool findFunction(const string & name);
    
    shared_ptr<NCBuiltinFunction> getFunction(const string & name);
};

#endif /* NCBuiltinFunctionStore_hpp */
