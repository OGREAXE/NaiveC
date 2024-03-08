//
//  NCCocoaClass.hpp
//  NaiveC
//
//  Created by Liang,Zhiyuan(GIS) on 2018/2/18.
//  Copyright © 2018年 Ogreaxe. All rights reserved.
//

#ifndef NCCocoaClass_hpp
#define NCCocoaClass_hpp

#include <stdio.h>

#include <stdio.h>
#include <string>

#include "NCClass.hpp"

class NCCocoaClass : public NCClass{
public:
    NCCocoaClass(const std::string&name):NCClass(name){}
    
    
    /**
     for NSObjects, calling this only give you [class alloc]
     you should call init explicitly

     @param arguments <#arguments description#>
     @return <#return value description#>
     */
    virtual shared_ptr<NCStackElement> instantiate(vector<shared_ptr<NCStackElement>> &arguments);
    
    virtual bool invokeMethod(string methodName, vector<shared_ptr<NCStackElement>> &arguments,vector<shared_ptr<NCStackElement>> & lastStack);
    
//    bool invokeMethod(const NCMethodCallExpr &call, vector<shared_ptr<NCStackElement>> &arguments,vector<shared_ptr<NCStackElement>> &lastStack);
    
    bool invokeMethod(string methodName, vector<shared_ptr<NCStackElement>> &arguments,vector<shared_ptr<NCStackElement>> &formatArguments,vector<shared_ptr<NCStackElement>> & lastStack);
};

#endif /* NCCocoaClass_hpp */
