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

class NCArrayInstance : public NCObject{
private:
    vector<shared_ptr<NCStackElement>> innerArray;
public:
    virtual bool invokeMethod(string methodName, vector<shared_ptr<NCStackElement>> &arguments,vector<shared_ptr<NCStackElement>> & lastStack);
    virtual bool invokeMethod(string methodName, vector<shared_ptr<NCStackElement>> &arguments);
    
    shared_ptr<NCStackElement> getElementAt(int i){return innerArray[i];}
    void addElement(shared_ptr<NCStackElement>&e){innerArray.push_back(e);};
    
    virtual shared_ptr<NCStackElement> getAttribute(const string & attrName);
};

typedef NCArrayInstance NCArray;


/**
 accessor for array, represented as anArray[index]
 */
struct NCArrayAccessor:NCStackElement{
private:
    NCArrayInstance * arrayInstance;
    int index;
public:
    NCArrayAccessor(NCArrayInstance*arrInst, int index):arrayInstance(arrInst),index(index){}
    
    virtual shared_ptr<NCStackElement> doOperator(const string&op, shared_ptr<NCStackElement> rightOperand);
    virtual int toInt();
    virtual NCFloat toFloat();
    virtual string toString();
    virtual shared_ptr<NCStackElement> copy();
    
    void set(int index,shared_ptr<NCStackElement> value);
    void set(shared_ptr<NCStackElement> value);
    shared_ptr<NCStackElement> value(){return arrayInstance->getElementAt(index);}
    
    virtual bool invokeMethod(string methodName, vector<shared_ptr<NCStackElement>> &arguments,vector<shared_ptr<NCStackElement>> & lastStack);
};

#endif /* NCArray_hpp */
