//
//  NCArray.hpp
//  NaiveC
//
//  Created by Liang,Zhiyuan(GIS) on 2018/2/18.
//  Copyright © 2018年 Ogreaxe. All rights reserved.
//

#ifndef NCArray_hpp
#define NCArray_hpp

#include <stdio.h>
#include "NCObject.hpp"

#define NC_CLASSNAME_ARRAY "array"

class NCArray : public NCObject, public NCBracketAccessible{
private:
    vector<shared_ptr<NCStackElement>> innerArray;
public:
    virtual bool invokeMethod(string methodName, vector<shared_ptr<NCStackElement>> &arguments,vector<shared_ptr<NCStackElement>> & lastStack);
    virtual bool invokeMethod(string methodName, vector<shared_ptr<NCStackElement>> &arguments);
    
    shared_ptr<NCStackElement> getElementAt(int i){return innerArray[i];}
    void addElement(shared_ptr<NCStackElement>&e){innerArray.push_back(e);};
    
    virtual shared_ptr<NCStackElement> getAttribute(const string & attrName);
    
    virtual void br_set(shared_ptr<NCStackElement> & key,shared_ptr<NCStackElement> &value);
    virtual shared_ptr<NCStackElement> br_getValue(shared_ptr<NCStackElement> & key);
};

/**
 accessor for array, represented as anArray[index]
 */
struct NCArrayAccessor:NCAccessor{
private:
    shared_ptr<NCBracketAccessible> m_accessible;
    shared_ptr<NCStackElement> m_key;
//    int index;
public:
    NCArrayAccessor(shared_ptr<NCBracketAccessible>  accessible, shared_ptr<NCStackElement> key):m_accessible(accessible),m_key(key){}
    
    virtual shared_ptr<NCStackElement> doOperator(const string&op, shared_ptr<NCStackElement> rightOperand);
    virtual int toInt();
    virtual NCFloat toFloat();
    virtual string toString();
    virtual shared_ptr<NCStackElement> copy();
    
//    virtual void set(int index,shared_ptr<NCStackElement> value);
    virtual void set(shared_ptr<NCStackElement> value);
    virtual shared_ptr<NCStackElement> value();
    
    virtual bool invokeMethod(string methodName, vector<shared_ptr<NCStackElement>> &arguments,vector<shared_ptr<NCStackElement>> & lastStack);
    
    virtual shared_ptr<NCStackElement> getAttribute(const string & attrName);
    
    virtual void setAttribute(const string & attrName, shared_ptr<NCStackElement> value);
};

#endif /* NCArray_hpp */
