//
//  NCClassProvider.hpp
//  NaiveC
//
//  Created by Liang,Zhiyuan(GIS) on 2018/2/12.
//  Copyright © 2018年 Ogreaxe. All rights reserved.
//

#ifndef NCClassProvider_hpp
#define NCClassProvider_hpp

#include <stdio.h>
#include <memory>

#include "NCStackElement.hpp"
#include "NCAST.hpp"
#include "NCClass.hpp"

class NCClassProvider{
public:
//    virtual std::shared_ptr<NCASTNode> findClass(const std::string & className) {return nullptr;};
    
    virtual ~NCClassProvider(){};
    
    virtual shared_ptr<NCClass> loadClass(const string & className){return nullptr;};
    
    virtual bool classExist(const std::string & className){return false;}
    
//    virtual bool invokeStaticMethodOnClass(const string & className,const string& methodName, vector<shared_ptr<NCStackElement>> &arguments,vector<shared_ptr<NCStackElement>> & lastStack){return false;};
};

#endif /* NCClassProvider_hpp */
