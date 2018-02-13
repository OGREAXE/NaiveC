//
//  NCBridgedOcObject.hpp
//  NaiveC
//
//  Created by Liang,Zhiyuan(GIS) on 2018/2/12.
//  Copyright © 2018年 Ogreaxe. All rights reserved.
//

#ifndef NCBridgedOcObject_hpp
#define NCBridgedOcObject_hpp

#include <stdio.h>
#include "NCClassInstance.hpp"

class NCBridgedOcObject :NCClassInstance {
    
    virtual bool invokeMethod(string methodName, vector<shared_ptr<NCStackElement>> &arguments,vector<shared_ptr<NCStackElement>> & lastStack);
    
    virtual shared_ptr<NCStackElement> getAttribute(const string & attrName){return nullptr;};
};

#endif /* NCBridgedOcObject_hpp */
