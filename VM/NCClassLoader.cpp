//
//  NCClassLoader.cpp
//  NaiveC
//
//  Created by Liang,Zhiyuan(GIS) on 2018/2/11.
//  Copyright © 2018年 Ogreaxe. All rights reserved.
//

#include "NCClassLoader.hpp"
#include "NCStackElement.hpp"

NCClassLoader * NCClassLoader::m_pInstance = nullptr;

bool NCClassLoader::isClassExist(const string & className){
    return false;
}

shared_ptr<NCClassProvider> NCClassLoader::findClassProviderForClassName(const string & className){
    for (int i=0; i<classProviders.size(); i++) {
        auto & provider = classProviders[i];
        if (provider->classExist(className)) {
            return provider;
        }
    }
    return nullptr;
}

bool NCClassLoader::invokeStaticMethodOnClass(const string & className,const string& methodName, vector<shared_ptr<NCStackElement>> &arguments,vector<shared_ptr<NCStackElement>> & lastStack){
    auto provider = findClassProviderForClassName(className);
    if (provider) {
        return provider->invokeStaticMethodOnClass(className, methodName, arguments, lastStack);
    }
    return false;
}
