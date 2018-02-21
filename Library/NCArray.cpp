//
//  NCArray.cpp
//  NaiveC
//
//  Created by Liang,Zhiyuan(GIS) on 2018/2/18.
//  Copyright © 2018年 Ogreaxe. All rights reserved.
//

#include "NCArray.hpp"

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
    return nullptr;
}


/*
 enable bracket access support
 */
void NCArray::br_set(shared_ptr<NCStackElement> & key,shared_ptr<NCStackElement> &value){
    if (dynamic_pointer_cast<NCStackIntElement>(key)) {
        auto kIndex = dynamic_pointer_cast<NCStackIntElement>(key)->value;
        innerArray[kIndex] = value;
    }
}

shared_ptr<NCStackElement> NCArray::br_getValue(shared_ptr<NCStackElement> & key){
    if (dynamic_pointer_cast<NCStackIntElement>(key)) {
        auto kIndex = dynamic_pointer_cast<NCStackIntElement>(key)->value;
        return innerArray[kIndex];
    }
    else {
        return nullptr;
    }
}

/*
 array accessor definitions
 */
shared_ptr<NCStackElement> NCArrayAccessor::doOperator(const string&op, shared_ptr<NCStackElement> rightOperand){
    return this->value()->doOperator(op, rightOperand);
}

int NCArrayAccessor::toInt(){
    return this->value()->toInt();
}
NCFloat NCArrayAccessor::toFloat(){
    return this->value()->toFloat();
}
string NCArrayAccessor::toString(){
    return this->value()->toString();
}

shared_ptr<NCStackElement> NCArrayAccessor::copy(){
    return shared_ptr<NCStackElement>(nullptr);
}

void NCArrayAccessor::set(shared_ptr<NCStackElement> value){
    m_accessible->br_set(m_key, value);
}

shared_ptr<NCStackElement> NCArrayAccessor::value(){
    return m_accessible->br_getValue(m_key);
}

bool NCArrayAccessor::invokeMethod(string methodName, vector<shared_ptr<NCStackElement>> &arguments,vector<shared_ptr<NCStackElement>> & lastStack){
    return this->value()->invokeMethod(methodName, arguments, lastStack);
}
