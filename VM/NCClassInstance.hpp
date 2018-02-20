//
//  NCClassInstance.hpp
//  NaiveC
//
//  Created by 梁志远 on 24/09/2017.
//  Copyright © 2017 Ogreaxe. All rights reserved.
//

#ifndef NCClassInstance_hpp
#define NCClassInstance_hpp

#include <stdio.h>
#include "NCAST.hpp"
#include "NCStackElement.hpp"

class NCClassInstance {
public:
    
//    uint32_t referenceCount;
    virtual ~NCClassInstance(){}
    
    shared_ptr<NCClassInstance> super;
    
    vector<shared_ptr<NCStackElement>> fields;
    
    virtual bool invokeMethod(string methodName, vector<shared_ptr<NCStackElement>> &arguments,vector<shared_ptr<NCStackElement>> & lastStack)=0;
    virtual bool invokeMethod(string methodName, vector<shared_ptr<NCStackElement>> &arguments){return true;}
    
    virtual shared_ptr<NCStackElement> getAttribute(const string & attrName){return nullptr;};
    
    virtual string getDescription(){return "NCClassInstance";};
};

class NCCustomClassInstance : public NCClassInstance{
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
    NCClassInstance * pObject;
public:
    NCStackPointerElement():pObject(nullptr){type="pointer";}
    
    NCStackPointerElement(NCClassInstance *pObject):pObject(pObject){type="pointer";}
    
    virtual ~NCStackPointerElement(){delete pObject;}
    
//    shared_ptr<NCClassInstance> getObjectPointer(){return shared_ptr<NCClassInstance>(pObject);}
    
    NCClassInstance* getRawObjectPointer(){return pObject;}
    
    virtual shared_ptr<NCStackElement> doOperator(const string&op, shared_ptr<NCStackElement> rightOperand);
    virtual int toInt();
    virtual NCFloat toFloat();
    virtual string toString();
    virtual shared_ptr<NCStackElement> copy();
    
    virtual bool invokeMethod(string methodName, vector<shared_ptr<NCStackElement>> &arguments,vector<shared_ptr<NCStackElement>> & lastStack);
    
    virtual shared_ptr<NCStackElement> getAttribute(const string & attrName){return pObject->getAttribute(attrName);};
};

typedef NCClassInstance NCObject;

#endif /* NCClassInstance_hpp */
