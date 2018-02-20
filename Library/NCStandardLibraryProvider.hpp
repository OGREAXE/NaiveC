//
//  NCStandardLibraryProvider.hpp
//  NaiveC
//
//  Created by Liang,Zhiyuan(GIS) on 2018/2/18.
//  Copyright © 2018年 Ogreaxe. All rights reserved.
//

#ifndef NCStandardLibraryProvider_hpp
#define NCStandardLibraryProvider_hpp

#include <stdio.h>

#include "NCClassProvider.hpp"

class NCStandardLibraryProvider:public NCClassProvider{
    
    virtual shared_ptr<NCClass> loadClass(const string & className);
    
    virtual bool classExist(const std::string & className);
};

#endif /* NCStandardLibraryProvider_hpp */
