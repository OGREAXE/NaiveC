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

#include "NCAST.hpp"

class NCClassProvider{
    virtual std::shared_ptr<NCASTNode> findClass(const std::string & className) = 0;
};

#endif /* NCClassProvider_hpp */
