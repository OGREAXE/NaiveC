//
//  NCObjectFactory.hpp
//  NaiveC
//
//  Created by Liang,Zhiyuan(GIS) on 2018/2/13.
//  Copyright © 2018年 Ogreaxe. All rights reserved.
//

#ifndef NCObjectFactory_hpp
#define NCObjectFactory_hpp

#include <stdio.h>
#include <string>
#include <memory>
#include <vector>

#include "NCStackElement.hpp"
#include "NCClassInstance.hpp"
#include "NCObjectGenerator.hpp"

using namespace std;

class NCObjectFactory {
private:
    vector<shared_ptr<NCObjectGenerator>> m_generators;
public:
    shared_ptr<NCStackPointerElement> createObject(const string & name, const vector<shared_ptr<NCStackElement>>& argments);
    void addGenerator(shared_ptr<NCObjectGenerator> & aGenerator);
};

#endif /* NCObjectFactory_hpp */
