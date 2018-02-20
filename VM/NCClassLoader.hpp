//
//  NCClassLoader.hpp
//  NaiveC
//
//  Created by Liang,Zhiyuan(GIS) on 2018/2/11.
//  Copyright © 2018年 Ogreaxe. All rights reserved.
//

#ifndef NCClassLoader_hpp
#define NCClassLoader_hpp

#include <stdio.h>
#include <string>
#include <memory>
#include "NCAST.hpp"
#include "NCClassProvider.hpp"
#include "NCClass.hpp"

using namespace std;

class NCClassLoader{
public:
    static NCClassLoader* GetInstance()
    {
        if ( m_pInstance == NULL )
            m_pInstance = new NCClassLoader();
        return m_pInstance;
    }
private:
    NCClassLoader();
    static NCClassLoader * m_pInstance;
    
private:
    vector<shared_ptr<NCClassProvider>> classProviders;
    
    shared_ptr<NCClassProvider> findClassProvider(const string & className);
public:
//    shared_ptr<NCASTNode> loadClass(const string & className);
    shared_ptr<NCClass> loadClass(const string & className);
    
//    bool invokeStaticMethodOnClass(const string & className,const string& methodName, vector<shared_ptr<NCStackElement>> &arguments,vector<shared_ptr<NCStackElement>> & lastStack);
    
    bool isClassExist(const string & className);
    
    bool registerProvider(shared_ptr<NCClassProvider> & provider);
    bool registerProvider(NCClassProvider * provider);
};

#endif /* NCClassLoader_hpp */
