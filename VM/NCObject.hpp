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
#include <memory>
#include "NCAST.hpp"
#include "NCStackElement.hpp"

class NCObject {
public:
    
//    uint32_t referenceCount;
    virtual ~NCObject(){}
    
    shared_ptr<NCObject> super;
    
//    vector<shared_ptr<NCStackElement>> fields;
    
    virtual bool invokeMethod(string methodName, vector<shared_ptr<NCStackElement>> &arguments,vector<shared_ptr<NCStackElement>> & lastStack){return false;};
    virtual bool invokeMethod(string methodName, vector<shared_ptr<NCStackElement>> &arguments,vector<shared_ptr<NCStackElement>> &formatArguments,vector<shared_ptr<NCStackElement>> & lastStack){return false;};
    
    virtual bool invokeMethod(string methodName, vector<shared_ptr<NCStackElement>> &arguments){return true;}
    
    virtual shared_ptr<NCStackElement> getAttribute(const string & attrName){return nullptr;}
    
    virtual void setAttribute(const string & attrName, shared_ptr<NCStackElement> value){}
    
    virtual string getDescription(){return "NCObject";}
    
    virtual NCObject* copy(){return nullptr;}
    
    virtual NCInt toInt(){return 0;}
};

/**
 invocation delegate, used by native object to re-use interpretor
 */
class NCInvocationDelegate{
    virtual bool invoke(shared_ptr<NCObject> & obj, const string& methodName, vector<shared_ptr<NCStackElement>> &arguments,vector<shared_ptr<NCStackElement>> & lastStack){return false;}
};

/**
 instance of user-defined class
 */
class NCNativeObject : public NCObject, public std::enable_shared_from_this<NCObject> {
public:
    unordered_map<string, shared_ptr<NCStackElement>> m_fieldMap;
    ~NCNativeObject(){
        int a = 0;
    }
    shared_ptr<NCClassDeclaration> classDefinition;
//    shared_ptr<NCInvocationDelegate> invocationDelagate;
    virtual bool invokeMethod(string methodName, vector<shared_ptr<NCStackElement>> &arguments,vector<shared_ptr<NCStackElement>> & lastStack);
    
    virtual shared_ptr<NCStackElement> getAttribute(const string & attrName);
    
    virtual void setAttribute(const string & attrName, shared_ptr<NCStackElement> value);
};

/**
 helper objects for lambda capture
 */
struct NCCapturedObject{
    int signature;
    string name;
    shared_ptr<NCStackElement> object;
};
/*
 lambda object
 */
class NCLambdaObject: public NCObject{
private:
    vector<NCCapturedObject> m_capturedObjects;
    shared_ptr<NCLambdaExpression> m_lambdaExpr;
public:
    NCLambdaObject(shared_ptr<NCLambdaExpression> &lambdaExpr):m_lambdaExpr(lambdaExpr){}
    
    shared_ptr<NCLambdaExpression> & getLambdaExpression(){return m_lambdaExpr;}
    
    vector<NCCapturedObject> & getCapturedObjects(){return m_capturedObjects;}
    
    void addCapture(NCCapturedObject & capturedObj){
        m_capturedObjects.push_back(capturedObj);
    }
    
    virtual NCObject* copy();
};

/**
 pointer to an object
 */
struct NCStackPointerElement:public NCStackElement{
private:
    shared_ptr<NCObject>  m_pObject;
public:
    NCStackPointerElement():m_pObject(NULL){type="pointer";}
    
    NCStackPointerElement(shared_ptr<NCObject> pObject):m_pObject(pObject){
        type="pointer";
    }
    
    NCStackPointerElement(NCObject* pObject){
        type="pointer";
        m_pObject = shared_ptr<NCObject>(pObject);
    }
    
//    NCObject* getNakedPointer(){return pObject;}
    shared_ptr<NCObject> getPointedObject(){return m_pObject;}
    
    virtual shared_ptr<NCStackElement> doOperator(const string&op, shared_ptr<NCStackElement> rightOperand);
    virtual NCInt toInt();
    virtual NCFloat toFloat();
    virtual string toString();
    virtual shared_ptr<NCStackElement> copy();
    
    virtual bool invokeMethod(string methodName, vector<shared_ptr<NCStackElement>> &arguments,vector<shared_ptr<NCStackElement>> & lastStack);
    virtual bool invokeMethod(string methodName, vector<shared_ptr<NCStackElement>> &arguments,vector<shared_ptr<NCStackElement>> &formatArguments,vector<shared_ptr<NCStackElement>> & lastStack);
    
    virtual shared_ptr<NCStackElement> getAttribute(const string & attrName){return m_pObject->getAttribute(attrName);};
    
    virtual void setAttribute(const string & attrName, shared_ptr<NCStackElement> value){m_pObject->setAttribute(attrName, value);}
};

/*
 abstract interface for types that can be accessed by []
 */
class NCBracketAccessible{
public:
    virtual void br_set(shared_ptr<NCStackElement> & key,shared_ptr<NCStackElement> &value)=0;
    virtual shared_ptr<NCStackElement> br_getValue(shared_ptr<NCStackElement> & key)=0;
};

/*
 abstract interface for fast enumeration
 */
class NCFastEnumerable{
public:
    
    /**
     closure return true to break

     @param handler <#anObj description#>
     */
    virtual void enumerate(std::function<bool (shared_ptr<NCStackElement> anObj)> handler) = 0;
};

#endif /* NCObject_hpp */
