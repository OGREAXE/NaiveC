//
//  NCObject.cpp
//  NaiveC
//
//  Created by 梁志远 on 24/09/2017.
//  Copyright © 2017 Ogreaxe. All rights reserved.
//

#include "NCObject.hpp"
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
    return m_pObject->getDescription();
}

shared_ptr<NCStackElement> NCStackPointerElement::copy(){
    return shared_ptr<NCStackElement>(new NCStackPointerElement(m_pObject));
}

bool NCStackPointerElement::invokeMethod(string methodName, vector<shared_ptr<NCStackElement>> &arguments,vector<shared_ptr<NCStackElement>> & lastStack){
    auto pStackTop = (lastStack.back()).get();
    
    //fix smart pointer released
    if (dynamic_cast<NCStackPointerElement*>((lastStack.back()).get())) {
        
        auto pPointerElement = dynamic_pointer_cast<NCStackPointerElement> (lastStack.back());
        lastStack.pop_back();
        
        auto pObject = pPointerElement->getPointedObject();
        
        return pObject->invokeMethod(methodName, arguments, lastStack);
    }
    else if (dynamic_cast<NCStackVariableElement*>(pStackTop)) {
        auto pVar = dynamic_cast<NCStackVariableElement*>(pStackTop);
        while (dynamic_cast<NCStackVariableElement*>(pVar->valueElement.get())) {
            pVar = dynamic_cast<NCStackVariableElement*>(pVar->valueElement.get());
        }
        if (dynamic_cast<NCStackPointerElement*>(pVar->valueElement.get())) {
            auto pPointerElement = dynamic_pointer_cast<NCStackPointerElement> (pVar->valueElement);
            lastStack.pop_back();
            
            auto pPointedObject = pPointerElement->getPointedObject();
            
            return pPointedObject->invokeMethod(methodName, arguments, lastStack);
        }
    }
    
    return true;
}


///**
// invoke a method on a 'meta' class
// in oc, it's a class selector
//
// @param methodName <#methodName description#>
// @param arguments <#arguments description#>
// @param lastStack <#lastStack description#>
// @return <#return value description#>
// */
//bool NCStackMetaClassElement::invokeMethod(string methodName, vector<shared_ptr<NCStackElement>> &arguments,vector<shared_ptr<NCStackElement>> & lastStack){
//    bool result = NCClassLoader::GetInstance()->invokeStaticMethodOnClass(className, methodName, arguments, lastStack);
//    return result;
//}
