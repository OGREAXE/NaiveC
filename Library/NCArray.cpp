//
//  NCArray.cpp
//  NaiveC
//
//  Created by Liang,Zhiyuan(GIS) on 2018/2/18.
//  Copyright © 2018年 Ogreaxe. All rights reserved.
//

#include "NCArray.hpp"


bool NCArrayInstance::invokeMethod(string methodName, vector<shared_ptr<NCStackElement>> &arguments,vector<shared_ptr<NCStackElement>> & lastStack){
    
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

bool NCArrayInstance::invokeMethod(string methodName, vector<shared_ptr<NCStackElement>> &arguments){
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

shared_ptr<NCStackElement> NCArrayInstance::getAttribute(const string & attrName){
    if (attrName == "count") {
        long length = innerArray.size();
        return shared_ptr<NCStackElement>(new NCStackIntElement(length));
    }
    return nullptr;
}

/*
 array accessor definitions
 */
shared_ptr<NCStackElement> NCArrayAccessor::doOperator(const string&op, shared_ptr<NCStackElement> rightOperand){
    return arrayInstance->getElementAt(index)->doOperator(op, rightOperand);
}

int NCArrayAccessor::toInt(){
    return arrayInstance->getElementAt(index)->toInt();
}
NCFloat NCArrayAccessor::toFloat(){
    return arrayInstance->getElementAt(index)->toFloat();
}
string NCArrayAccessor::toString(){
    return arrayInstance->getElementAt(index)->toString();
}

shared_ptr<NCStackElement> NCArrayAccessor::copy(){
    return shared_ptr<NCStackElement>(nullptr);
}

void NCArrayAccessor::set(shared_ptr<NCStackElement> value){
    set(index, value);
}
void NCArrayAccessor::set(int index,shared_ptr<NCStackElement> value){
    vector<shared_ptr<NCStackElement>> argments;
    argments.push_back(shared_ptr<NCStackElement>(new NCStackIntElement(index)));
    argments.push_back(value);
    arrayInstance->invokeMethod("set", argments);
}

bool NCArrayAccessor::invokeMethod(string methodName, vector<shared_ptr<NCStackElement>> &arguments,vector<shared_ptr<NCStackElement>> & lastStack){
    return arrayInstance->getElementAt(index)->invokeMethod(methodName, arguments, lastStack);
}
