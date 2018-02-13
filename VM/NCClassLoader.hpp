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

using namespace std;

class NCClassLoader{
private:
    vector<shared_ptr<NCClassProvider>> classProviders;
public:
    shared_ptr<NCASTNode> loadClass(const string & className);
    
    bool isClassExist(const string & className);
    
    bool addProvider(shared_ptr<NCClassProvider> & provider);
    bool addProvider(NCClassProvider * provider);
};

#endif /* NCClassLoader_hpp */
