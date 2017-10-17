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
    return shared_ptr<NCStackElement>(nullptr);
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
