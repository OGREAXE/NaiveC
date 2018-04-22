//
//  NCHeapMemory.cpp
//  NaiveC
//
//  Created by Liang,Zhiyuan(GIS) on 2018/4/20.
//  Copyright © 2018年 Ogreaxe. All rights reserved.
//

#include "NCHeapMemory.hpp"
#include <thread>

using namespace std;

void NCHeapMemory::setElement(const string&key,  shared_ptr<NCStackElement> & element){
    lock_guard<mutex> lock(m_mutex);
    
    elementMap[key] = element;
}

shared_ptr<NCStackElement> NCHeapMemory::getElement(const string&key){
    lock_guard<mutex> lock(m_mutex);
    
    auto element = elementMap[key];
    
    return element;
}
