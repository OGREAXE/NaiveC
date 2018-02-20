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
class NCCocoaBox :public NCClassInstance {
private:
    //wrapped cocoaObject. must use non-arc to ensure correct release?
    void * m_cocoaObject;
public:
    NCCocoaBox(void * cocoaObject);
    
    virtual bool invokeMethod(string methodName, vector<shared_ptr<NCStackElement>> &arguments,vector<shared_ptr<NCStackElement>> & lastStack);
    
    virtual shared_ptr<NCStackElement> getAttribute(const string & attrName);
    
    void * getCocoaObject(){return m_cocoaObject;}
    
    
    virtual string getDescription();
};

#endif /* NCCocoaBox_hpp */
