//
//  NCClassInstance.cpp
//  NaiveC
//
//  Created by 梁志远 on 24/09/2017.
//  Copyright © 2017 Ogreaxe. All rights reserved.
//

#include "NCClassInstance.hpp"

shared_ptr<NCStackElement> NCStackPointerElement::doOperator(const string&op, shared_ptr<NCStackElement> rightOperand){
    
    return rightOperand;
}

int NCStackPointerElement::toInt(){
    return 0;
}
float NCStackPointerElement::toFloat(){
    return 0;
}
string NCStackPointerElement::toString(){
    return 0;
}

shared_ptr<NCStackElement> NCStackPointerElement::copy(){
    return shared_ptr<NCStackElement>(new NCStackPointerElement(pObject));
}

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

//array accessor
shared_ptr<NCStackElement> NCArrayAccessor::doOperator(const string&op, shared_ptr<NCStackElement> rightOperand){
    return arrayInstance->getElementAt(index)->doOperator(op, rightOperand);
}

int NCArrayAccessor::toInt(){
    return arrayInstance->getElementAt(index)->toInt();
}
float NCArrayAccessor::toFloat(){
    return 0;
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
