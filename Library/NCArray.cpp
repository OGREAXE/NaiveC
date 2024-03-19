//
//  NCArray.cpp
//  NaiveC
//
//  Created by Liang,Zhiyuan(GIS) on 2018/2/18.
//  Copyright © 2018年 Ogreaxe. All rights reserved.
//

#include "NCArray.hpp"
#include "NCException.hpp"

bool NCArray::invokeMethod(string methodName, vector<shared_ptr<NCStackElement>> &arguments,vector<shared_ptr<NCStackElement>> & lastStack){
    
    if (methodName == "get") {
        auto res = innerArray[arguments[0]->toInt()];
        lastStack.push_back(res);
    }
    else if (methodName == "add") {
        innerArray.push_back(arguments[0]);
    }
    else if(methodName == "set"){
        innerArray[arguments[0]->toInt()] = arguments[1];
    }
    else if(methodName == "length"){
        lastStack.push_back(shared_ptr<NCStackElement>(new NCStackIntElement(innerArray.size())));
    }
    
    return true;
}

bool NCArray::invokeMethod(string methodName, vector<shared_ptr<NCStackElement>> &arguments){
    if (methodName == "get") {
        
    }
    else if (methodName == "add") {
        innerArray.push_back(arguments[0]);
    }
    else if(methodName == "set"){
        innerArray[arguments[0]->toInt()] = arguments[1];
    }
    
    return true;
}

shared_ptr<NCStackElement> NCArray::getAttribute(const string & attrName){
    if (attrName == "count") {
        long length = innerArray.size();
        return shared_ptr<NCStackElement>(new NCStackIntElement(length));
    }
    else{
        throw NCRuntimeException(0, " attribute %s not found on NCArray", attrName.c_str());
    }
    return nullptr;
}


/*
 enable bracket access support
 */
void NCArray::br_set(shared_ptr<NCStackElement> & key,shared_ptr<NCStackElement> &value){
    if (dynamic_pointer_cast<NCStackIntElement>(key)) {
        auto kIndex = dynamic_pointer_cast<NCStackIntElement>(key)->value;
        if (kIndex > innerArray.size()-1) {
            throw NCRuntimeException(0, "out of range");
        }
        innerArray[kIndex] = value;
    }
}

shared_ptr<NCStackElement> NCArray::br_getValue(shared_ptr<NCStackElement> & key){
    if (dynamic_pointer_cast<NCStackIntElement>(key)) {
        auto kIndex = dynamic_pointer_cast<NCStackIntElement>(key)->value;
        if (kIndex > innerArray.size()-1) {
            throw NCRuntimeException(0, "out of range");
        }
        return innerArray[kIndex];
    }
    else {
        return nullptr;
    }
}


/**
 fast enumeration
 */
void NCArray::enumerate(std::function<bool (shared_ptr<NCStackElement> anObj)> handler){
    for (int i=0; i <length(); i++) {
        auto currentValue = getElementAt(i);
        
        if (handler(currentValue)) {
            break;
        }
    }
}

/*
 array accessor definitions
 */
shared_ptr<NCStackElement> NCIndexedAccessor::doOperator(const string&op, shared_ptr<NCStackElement> rightOperand){
    return this->value()->doOperator(op, rightOperand);
}

NCInt NCIndexedAccessor::toInt(){
    auto v = this->value();
    
    if (!v)return 0;
    
    return v->toInt();
}
NCFloat NCIndexedAccessor::toFloat(){
    auto v = this->value();
    
    if (!v)return 0;
    
    return v->toFloat();
}
string NCIndexedAccessor::toString(){
    auto v = this->value();
    
    if (!v)return "";
    
    return v->toString();
}

shared_ptr<NCStackElement> NCIndexedAccessor::copy(){
    return shared_ptr<NCStackElement>(nullptr);
}

void NCIndexedAccessor::set(shared_ptr<NCStackElement> value){
    m_accessible->br_set(m_key, value);
}

shared_ptr<NCStackElement> NCIndexedAccessor::value(){
    return m_accessible->br_getValue(m_key);
}

bool NCIndexedAccessor::invokeMethod(string methodName, vector<shared_ptr<NCStackElement>> &arguments,vector<shared_ptr<NCStackElement>> & lastStack){
    return this->value()->invokeMethod(methodName, arguments, lastStack);
}

shared_ptr<NCStackElement> NCIndexedAccessor::getAttribute(const string & attrName){
    return this->value()->getAttribute(attrName);
}

void NCIndexedAccessor::setAttribute(const string & attrName, shared_ptr<NCStackElement> value){
    this->value()->setAttribute(attrName, value);
}
