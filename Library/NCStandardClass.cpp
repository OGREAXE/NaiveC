//
//  NCStandardClass.cpp
//  NaiveC
//
//  Created by Liang,Zhiyuan(GIS) on 2018/2/18.
//  Copyright © 2018年 Ogreaxe. All rights reserved.
//

#include "NCStandardClass.hpp"

shared_ptr<NCStackElement> NCStandardClass::instantiate(vector<shared_ptr<NCStackElement>> &arguments){
//    if(this->name == NC_CLASSNAME_ARRAY){
//        auto pInstance = shared_ptr<NCStackPointerElement>( new NCStackPointerElement(shared_ptr<NCObject>(new NCArray())));
//        return pInstance;
//    }
    return nullptr;
}

bool NCStandardClass::invokeMethod(string methodName, vector<shared_ptr<NCStackElement>> &arguments,vector<shared_ptr<NCStackElement>> & lastStack){
    //todo
    return false;
}
