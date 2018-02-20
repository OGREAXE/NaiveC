//
//  NCCocoaClassProvider.hpp
//  NaiveC
//
//  Created by Liang,Zhiyuan(GIS) on 2018/2/12.
//  Copyright © 2018年 Ogreaxe. All rights reserved.
//

#ifndef NCCocoaClassProvider_hpp
#define NCCocoaClassProvider_hpp

#include <stdio.h>
#include "NCClassProvider.hpp"

class NCCocoaClassProvider :public NCClassProvider {
    virtual bool classExist(const std::string & className);
    
    virtual shared_ptr<NCClass> loadClass(const string & className);
    
//    virtual bool invokeStaticMethodOnClass(const string & className,const string& methodName, vector<shared_ptr<NCStackElement>> &arguments,vector<shared_ptr<NCStackElement>> & lastStack);
};

#endif /* NCCocoaClassProvider_hpp */
