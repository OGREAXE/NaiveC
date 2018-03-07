//
//  NCClass.cpp
//  NaiveC
//
//  Created by Liang,Zhiyuan(GIS) on 2018/2/17.
//  Copyright © 2018年 Ogreaxe. All rights reserved.
//

#include "NCClass.hpp"

shared_ptr<NCStackPointerElement>  NCNativeClass::instantiate(vector<shared_ptr<NCStackElement>> &arguments){
    return nullptr;
}

bool NCNativeClass::invokeMethod(string methodName, vector<shared_ptr<NCStackElement>> &arguments,vector<shared_ptr<NCStackElement>> & lastStack){
    return false;
}
