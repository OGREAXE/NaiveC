//
//  NCStackElement.hpp
//  NaiveC
//
//  Created by 梁志远 on 28/08/2017.
//  Copyright © 2017 Ogreaxe. All rights reserved.
//

#ifndef NCStackElement_hpp
#define NCStackElement_hpp

#include <stdio.h>
#include "NCAST.hpp"

struct NCStackElement{
    NCStackElement(){}
    virtual ~NCStackElement(){}
    string type;
    
    virtual shared_ptr<NCStackElement> doOperator(const string&op, shared_ptr<NCStackElement> rightOperand){return nullptr;};
    
    virtual NCInt toInt(){return 0;};
    virtual NCFloat toFloat(){return 0;};
    virtual string toString(){return "";};
    
    static shared_ptr<NCStackElement> createStackElement(NCLiteral* literal);
    
    virtual shared_ptr<NCStackElement> copy(){return nullptr;};
    
    virtual bool invokeMethod(string methodName, vector<shared_ptr<NCStackElement>> &arguments,vector<shared_ptr<NCStackElement>> & lastStack){return false;}
    virtual bool invokeMethod(string methodName, vector<shared_ptr<NCStackElement>> &arguments){return false;}
    
    virtual shared_ptr<NCStackElement> getAttribute(const string & attrName){return nullptr;}
    
    virtual void setAttribute(const string & attrName, shared_ptr<NCStackElement> value){}
};

struct NCStackIntElement:NCStackElement{
    
    NCStackIntElement(NCInt val):value(val){type="int";}
    NCInt value;
    
    virtual shared_ptr<NCStackElement> doOperator(const string&op, shared_ptr<NCStackElement> rightOperand);
    virtual NCInt toInt();
    virtual NCFloat toFloat();
    virtual string toString();
    virtual shared_ptr<NCStackElement> copy();
};

struct NCStackFloatElement:NCStackElement{
    NCStackFloatElement(float val):value(val){type="float";}
    NCFloat value;
    
    virtual shared_ptr<NCStackElement> doOperator(const string&op, shared_ptr<NCStackElement> rightOperand);
    virtual NCInt toInt();
    virtual NCFloat toFloat();
    virtual string toString();
    virtual shared_ptr<NCStackElement> copy();
};

struct NCStackStringElement:NCStackElement{
    NCStackStringElement(string&str):value(str){type="string";}
    string value;
    
    virtual shared_ptr<NCStackElement> doOperator(const string&op, shared_ptr<NCStackElement> rightOperand);
    virtual NCInt toInt();
    virtual NCFloat toFloat();
    virtual string toString();
    virtual shared_ptr<NCStackElement> copy();
    
    virtual bool invokeMethod(string methodName, vector<shared_ptr<NCStackElement>> &arguments,vector<shared_ptr<NCStackElement>> & lastStack);
    virtual bool invokeMethod(string methodName, vector<shared_ptr<NCStackElement>> &arguments);
};

struct NCStackVariableElement:NCStackElement{
    NCStackVariableElement(string name,shared_ptr<NCStackElement> valueElement):name(name),valueElement(valueElement){isArray = false;}
    string name;
    bool isArray;
    shared_ptr<NCStackElement> valueElement;
    
    
    virtual shared_ptr<NCStackElement> doOperator(const string&op, shared_ptr<NCStackElement> rightOperand);
    virtual NCInt toInt();
    virtual NCFloat toFloat();
    virtual string toString();
    virtual shared_ptr<NCStackElement> copy();
    
    virtual bool invokeMethod(string methodName, vector<shared_ptr<NCStackElement>> &arguments,vector<shared_ptr<NCStackElement>> & lastStack);
    
    virtual shared_ptr<NCStackElement> getAttribute(const string & attrName){
        if(valueElement){
            return valueElement->getAttribute(attrName);
        }
        else {
            return nullptr;
        }
    };
    
    virtual void setAttribute(const string & attrName, shared_ptr<NCStackElement> value){valueElement->setAttribute(attrName,value);}
};

/*
 NCAccessor, base class for NCFieldAccessor and NCArrayAccessor
 */
class NCAccessor :public NCStackElement{
public:
    virtual void set(shared_ptr<NCStackElement> value){};
    virtual shared_ptr<NCStackElement> value(){return nullptr;};
};

class NCFieldAccessor: public NCAccessor{
private:
    shared_ptr<NCStackElement> scope;
    string attributeName;
public:
    NCFieldAccessor(shared_ptr<NCStackElement> & scope,
                    const string & attributeName):scope(scope), attributeName(attributeName){}
    
    virtual void set(shared_ptr<NCStackElement> value);
    virtual shared_ptr<NCStackElement> value();
    
    virtual string toString();
    
    virtual shared_ptr<NCStackElement> getAttribute(const string & attrName);
    
    virtual void setAttribute(const string & attrName, shared_ptr<NCStackElement> value);
    
    virtual shared_ptr<NCStackElement> doOperator(const string&op, shared_ptr<NCStackElement> rightOperand);
};

#endif /* NCStackElement_hpp */
