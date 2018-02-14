//
//  NCCocoaBox.hpp
//  NaiveC
//
//  Created by Liang,Zhiyuan(GIS) on 2018/2/13.
//  Copyright © 2018年 Ogreaxe. All rights reserved.
//

#ifndef NCCocoaBox_hpp
#define NCCocoaBox_hpp

#include <stdio.h>
#include "NCClassInstance.hpp"

/*
 wrapper for cocoa objects
 */
class NCCocoaBox :NCClassInstance {
private:
    //wrapped cocoaObject. must use non-arc to ensure correct release?
    void * cocoaObject;
public:
    NCCocoaBox(void * cocoaObject):cocoaObject(cocoaObject){};
    
    virtual bool invokeMethod(string methodName, vector<shared_ptr<NCStackElement>> &arguments,vector<shared_ptr<NCStackElement>> & lastStack);
    
    virtual shared_ptr<NCStackElement> getAttribute(const string & attrName);
};

#endif /* NCCocoaBox_hpp */
