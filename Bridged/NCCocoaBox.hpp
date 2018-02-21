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
#include "NCObject.hpp"

/*
 wrapper for cocoa objects
 */
class NCCocoaBox :public NCObject, public NCBracketAccessible {
private:
    //wrapped cocoaObject. must use non-arc to ensure correct release?
    void * m_cocoaObject;
public:
    NCCocoaBox(void * cocoaObject);
    
    virtual bool invokeMethod(string methodName, vector<shared_ptr<NCStackElement>> &arguments,vector<shared_ptr<NCStackElement>> & lastStack);
    
    virtual shared_ptr<NCStackElement> getAttribute(const string & attrName);
    
    virtual void setAttribute(const string & attrName, shared_ptr<NCStackElement> value);
    
    void * getContent(){return m_cocoaObject;}
    
    virtual string getDescription();
    
    /*
     bracket access support
     */
    virtual void br_set(shared_ptr<NCStackElement> & key,shared_ptr<NCStackElement> &value);
    virtual shared_ptr<NCStackElement> br_getValue(shared_ptr<NCStackElement> & key);
};

#endif /* NCCocoaBox_hpp */
