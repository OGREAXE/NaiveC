//
//  NCClassInstance.cpp
//  NaiveC
//
//  Created by 梁志远 on 24/09/2017.
//  Copyright © 2017 Ogreaxe. All rights reserved.
//

#include "NCClassInstance.hpp"
#include "NCClassLoader.hpp"

shared_ptr<NCStackElement> NCStackPointerElement::doOperator(const string&op, shared_ptr<NCStackElement> rightOperand){
    
    return rightOperand;
}

int NCStackPointerElement::toInt(){
    return 0;
}
NCFloat NCStackPointerElement::toFloat(){
    return 0;
}
string NCStackPointerElement::toString(){
    return 0;
}

shared_ptr<NCStackElement> NCStackPointerElement::copy(){
    return shared_ptr<NCStackElement>(new NCStackPointerElement(pObject));
}

bool NCStackPointerElement::invokeMethod(string methodName, vector<shared_ptr<NCStackElement>> &arguments,vector<shared_ptr<NCStackElement>> & lastStack){
    auto pStackTop = (lastStack.back()).get();
    
    //fix smart pointer released
    if (dynamic_cast<NCStackPointerElement*>((lastStack.back()).get())) {
        
        auto pPointerElement = dynamic_pointer_cast<NCStackPointerElement> (lastStack.back());
        lastStack.pop_back();
        
        auto pPointer = pPointerElement.get()->getRawObjectPointer();
        
        if (dynamic_cast<NCClassInstance*>(pPointer)) {
            auto classInst = dynamic_cast<NCClassInstance*>(pPointer);
            
            return classInst->invokeMethod(methodName, arguments, lastStack);
        }
    }
    else if (dynamic_cast<NCStackVariableElement*>(pStackTop)) {
        auto pVar = dynamic_cast<NCStackVariableElement*>(pStackTop);
        while (dynamic_cast<NCStackVariableElement*>(pVar->valueElement.get())) {
            pVar = dynamic_cast<NCStackVariableElement*>(pVar->valueElement.get());
        }
        if (dynamic_cast<NCStackPointerElement*>(pVar->valueElement.get())) {
            auto pPointerElement = dynamic_pointer_cast<NCStackPointerElement> (pVar->valueElement);
            lastStack.pop_back();
            
            auto pPointer = pPointerElement.get()->getRawObjectPointer();
            
            if (dynamic_cast<NCClassInstance*>(pPointer)) {
                auto classInst = dynamic_cast<NCClassInstance*>(pPointer);
                
                return classInst->invokeMethod(methodName, arguments, lastStack);
            }
        }
    }
    
    return true;
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


/**
 invoke a method on a 'meta' class
 in oc, it's a class selector

 @param methodName <#methodName description#>
 @param arguments <#arguments description#>
 @param lastStack <#lastStack description#>
 @return <#return value description#>
 */
bool NCStackMetaClassElement::invokeMethod(string methodName, vector<shared_ptr<NCStackElement>> &arguments,vector<shared_ptr<NCStackElement>> & lastStack){
    bool result = NCClassLoader::GetInstance()->invokeStaticMethodOnClass(className, methodName, arguments, lastStack);
    return result;
}

//array accessor
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
