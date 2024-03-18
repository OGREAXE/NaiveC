//
//  NCStandardLibraryProvider.cpp
//  NaiveC
//
//  Created by Liang,Zhiyuan(GIS) on 2018/2/18.
//  Copyright © 2018年 Ogreaxe. All rights reserved.
//

#include "NCStandardLibraryProvider.hpp"

#include <unordered_set>
#include "NCStandardClass.hpp"

shared_ptr<NCClass> NCStandardLibraryProvider::loadClass(const string & className){
    auto standardClass = shared_ptr<NCClass> (new NCStandardClass(className));
    
    return standardClass;
}

bool NCStandardLibraryProvider::classExist(const std::string & className){
//    static unordered_set<string> all_library_classes = {NC_CLASSNAME_ARRAY};
//    
//    auto findClass = all_library_classes.find(className);
//    if (findClass != all_library_classes.end()) {
//        return true;
//    }
    return false;
}
