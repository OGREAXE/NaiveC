//
//  NCSourceFinder.hpp
//  NaiveC
//
//  Created by Liang,Zhiyuan(GIS) on 2018/3/5.
//  Copyright © 2018年 Ogreaxe. All rights reserved.
//

#ifndef NCSourceFinder_hpp
#define NCSourceFinder_hpp

#include <stdio.h>
#include "NCClassProvider.hpp"

class NCSourceFinder :NCClassProvider {
public:
    virtual bool classExist(const std::string & className);
    
    virtual shared_ptr<NCClass> loadClass(const string & className);
};

#endif /* NCSourceFinder_hpp */
