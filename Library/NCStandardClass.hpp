//
//  NCStandardClass.hpp
//  NaiveC
//
//  Created by Liang,Zhiyuan(GIS) on 2018/2/18.
//  Copyright © 2018年 Ogreaxe. All rights reserved.
//

#ifndef NCStandardClass_hpp
#define NCStandardClass_hpp

#include <stdio.h>
#include <string>

#include "NCClass.hpp"
#include "NCArray.hpp"

class NCStandardClass : public NCClass{
public:
    NCStandardClass(const std::string&name):NCClass(name){}
    
    virtual shared_ptr<NCStackPointerElement> instantiate(vector<shared_ptr<NCStackElement>> &arguments);
    
    virtual bool invokeMethod(string methodName, vector<shared_ptr<NCStackElement>> &arguments,vector<shared_ptr<NCStackElement>> & lastStack);
};

#endif /* NCStandardClass_hpp */
