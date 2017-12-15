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
    
    virtual shared_ptr<NCStackElement> doOperator(const string&op, shared_ptr<NCStackElement> rightOperand)=0;
    
    virtual int toInt()=0;
    virtual float toFloat()=0;
    virtual string toString()=0;
    
    static shared_ptr<NCStackElement> createStackElement(NCLiteral* literal);
    
    virtual shared_ptr<NCStackElement> copy()=0;
};

struct NCStackIntElement:NCStackElement{
    
    NCStackIntElement(int val):value(val){type="int";}
    int value;
    
    virtual shared_ptr<NCStackElement> doOperator(const string&op, shared_ptr<NCStackElement> rightOperand);
    virtual int toInt();
    virtual float toFloat();
    virtual string toString();
    virtual shared_ptr<NCStackElement> copy();
};

struct NCStackFloatElement:NCStackElement{
    NCStackFloatElement(float val):value(val){type="float";}
    float value;
    
    virtual shared_ptr<NCStackElement> doOperator(const string&op, shared_ptr<NCStackElement> rightOperand);
    virtual int toInt();
    virtual float toFloat();
    virtual string toString();
    virtual shared_ptr<NCStackElement> copy();
};

struct NCStackStringElement:NCStackElement{
    NCStackStringElement(string&str):value(str){type="string";}
    string value;
    
    virtual shared_ptr<NCStackElement> doOperator(const string&op, shared_ptr<NCStackElement> rightOperand);
    virtual int toInt();
    virtual float toFloat();
    virtual string toString();
    virtual shared_ptr<NCStackElement> copy();
    
    bool invokeMethod(string methodName, vector<shared_ptr<NCStackElement>> &arguments,vector<shared_ptr<NCStackElement>> & lastStack);
    bool invokeMethod(string methodName, vector<shared_ptr<NCStackElement>> &arguments);
};

struct NCStackVariableElement:NCStackElement{
    NCStackVariableElement(string name,shared_ptr<NCStackElement> valueElement):name(name),valueElement(valueElement){isArray = false;}
    string name;
    bool isArray;
    shared_ptr<NCStackElement> valueElement;
    
    
    virtual shared_ptr<NCStackElement> doOperator(const string&op, shared_ptr<NCStackElement> rightOperand);
    virtual int toInt();
    virtual float toFloat();
    virtual string toString();
    virtual shared_ptr<NCStackElement> copy();
};

#endif /* NCStackElement_hpp */
