//
//  NCObject.hpp
//  NaiveC
//
//  Created by 梁志远 on 24/09/2017.
//  Copyright © 2017 Ogreaxe. All rights reserved.
//

#ifndef NCObject_hpp
#define NCObject_hpp

#include <stdio.h>
#include "NCAST.hpp"
#include "NCStackElement.hpp"

class NCObject {
public:
    
//    uint32_t referenceCount;
    virtual ~NCObject(){}
    
    shared_ptr<NCObject> super;
    
    vector<shared_ptr<NCStackElement>> fields;
    
    virtual bool invokeMethod(string methodName, vector<shared_ptr<NCStackElement>> &arguments,vector<shared_ptr<NCStackElement>> & lastStack){return false;};
    virtual bool invokeMethod(string methodName, vector<shared_ptr<NCStackElement>> &arguments){return true;}
    
    virtual shared_ptr<NCStackElement> getAttribute(const string & attrName){return nullptr;}
    
    virtual void setAttribute(const string & attrName, shared_ptr<NCStackElement> value){}
    
    virtual string getDescription(){return "NCObject";};
};

class NCOriginalObject : public NCObject{
public:
    shared_ptr<NCClassDeclaration> classDefinition;
    
    virtual bool invokeMethod(string methodName, vector<shared_ptr<NCStackElement>> &arguments,vector<shared_ptr<NCStackElement>> & lastStack);
};

///////

/**
 pointer to a class
 */
struct NCStackPointerElement:public NCStackElement{
private:
    NCObject * pObject;
public:
    NCStackPointerElement():pObject(nullptr){type="pointer";}
    
    NCStackPointerElement(NCObject *pObject):pObject(pObject){type="pointer";}
    
    virtual ~NCStackPointerElement(){delete pObject;}
    
//    shared_ptr<NCObject> getObjectPointer(){return shared_ptr<NCObject>(pObject);}
    
    NCObject* getRawObjectPointer(){return pObject;}
    
    virtual shared_ptr<NCStackElement> doOperator(const string&op, shared_ptr<NCStackElement> rightOperand);
    virtual int toInt();
    virtual NCFloat toFloat();
    virtual string toString();
    virtual shared_ptr<NCStackElement> copy();
    
    virtual bool invokeMethod(string methodName, vector<shared_ptr<NCStackElement>> &arguments,vector<shared_ptr<NCStackElement>> & lastStack);
    
    virtual shared_ptr<NCStackElement> getAttribute(const string & attrName){return pObject->getAttribute(attrName);};
    
    virtual void setAttribute(const string & attrName, shared_ptr<NCStackElement> value){pObject->setAttribute(attrName, value);}
};

typedef NCObject NCObject;

#endif /* NCObject_hpp */
