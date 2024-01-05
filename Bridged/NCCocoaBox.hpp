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

//for nsobject bridging
//used in objective-c source file only
#define NC_COCOA_BRIDGE(aNSObject) (void*)CFBridgingRetain(aNSObject)
#define NC_COCOA_UNBRIDGE(aBridgedNSObject) CFBridgingRelease(aBridgedNSObject)

#define GET_NS_OBJECT  ((__bridge NSObject*)m_cocoaObject) //only for use in derived classes
/*
 wrapper for cocoa objects
 */
class NCCocoaBox :public NCObject, public NCBracketAccessible, public NCFastEnumerable {
protected:
    //wrapped cocoaObject. must use non-arc to ensure correct release?
    void * m_cocoaObject;
public:
    NCCocoaBox(){};
    NCCocoaBox(void * cocoaObject);
    
    NCCocoaBox(const string &str); //wrap as nsstring
    NCCocoaBox(NCInt value); //wrap as nsnumber
    NCCocoaBox(NCFloat value); //wrap as nsnumber
    
    virtual ~NCCocoaBox();
    
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
    
    
    /**
     fast enumeration support

     @param anObj <#anObj description#>
     */
    virtual void enumerate(std::function<bool (shared_ptr<NCStackElement> anObj)> handler);
    
    virtual NCInt toInt();
    
};

#endif /* NCCocoaBox_hpp */
