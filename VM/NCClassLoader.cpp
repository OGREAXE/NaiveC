//
//  NCClassLoader.cpp
//  NaiveC
//
//  Created by Liang,Zhiyuan(GIS) on 2018/2/11.
//  Copyright © 2018年 Ogreaxe. All rights reserved.
//

#include "NCClassLoader.hpp"
#include "NCStackElement.hpp"
#include "NCStandardLibraryProvider.hpp"

NCClassLoader * NCClassLoader::m_pInstance = nullptr;

NCClassLoader::NCClassLoader(){
    auto standardLibraryProvider = shared_ptr<NCClassProvider>(new NCStandardLibraryProvider());
    registerProvider(standardLibraryProvider);
}

shared_ptr<NCClass> NCClassLoader::loadClass(const string & className){
    auto provider = findClassProvider(className);
    if (!provider) {
        return nullptr;
    }
    return provider->loadClass(className);
}

bool NCClassLoader::isClassExist(const string & className){
    for (int i=0; i<classProviders.size(); i++) {
        auto & provider = classProviders[i];
        if (provider->classExist(className)) {
            return true;
        }
    }
    return false;
}

shared_ptr<NCClassProvider> NCClassLoader::findClassProvider(const string & className){
    for (int i=0; i<classProviders.size(); i++) {
        auto & provider = classProviders[i];
        if (provider->classExist(className)) {
            return provider;
        }
    }
    return nullptr;
}

bool NCClassLoader::registerProvider(shared_ptr<NCClassProvider> & provider){
    classProviders.push_back(provider);
    return true;
}

bool NCClassLoader::registerProvider(NCClassProvider * provider){
    return false;
}

//bool NCClassLoader::invokeStaticMethodOnClass(const string & className,const string& methodName, vector<shared_ptr<NCStackElement>> &arguments,vector<shared_ptr<NCStackElement>> & lastStack){
//    auto provider = findClassProviderForClassName(className);
//    if (provider) {
//        return provider->invokeStaticMethodOnClass(className, methodName, arguments, lastStack);
//    }
//    return false;
//}

