//
//  NCObjectGenerator.hpp
//  NaiveC
//
//  Created by Liang,Zhiyuan(GIS) on 2018/2/13.
//  Copyright © 2018年 Ogreaxe. All rights reserved.
//

#ifndef NCObjectGenerator_hpp
#define NCObjectGenerator_hpp

#include <stdio.h>
#include <string>
#include <memory>
#include <vector>

#include "NCStackElement.hpp"
#include "NCClassInstance.hpp"
#include "NCObjectGenerator.hpp"

using namespace std;

class NCObjectGenerator {
    virtual shared_ptr<NCStackPointerElement> createObject(const string & name, vector<shared_ptr<NCStackElement>> argments) = 0;
};

#endif /* NCObjectGenerator_hpp */
