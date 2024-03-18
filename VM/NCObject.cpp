//
//  NCObject.cpp
//  NaiveC
//
//  Created by 梁志远 on 24/09/2017.
//  Copyright © 2017 Ogreaxe. All rights reserved.
//

#include "NCObject.hpp"
#include "NCClassLoader.hpp"
#include "NCInterpreter.hpp"
#include "NCException.hpp"

static NCInterpreter * g_subInterpretor = nullptr;

bool NCNativeObject::invokeMethod(string methodName, vector<shared_ptr<NCStackElement>> &arguments,vector<shared_ptr<NCStackElement>> & lastStack){
    if (!g_subInterpretor) {
        g_subInterpretor = new NCInterpreter();
    }
//    auto res = g_subInterpretor->invoke(methodName, arguments, lastStack);
//    return res;
    auto func = classDefinition->methods[methodName];
    
    string msg = "method not found: " + methodName;
    NCAssert(func, msg);
    auto funcDef = func->method;
    
    auto frame = shared_ptr<NCFrame>(new NCFrame());
    for (int i = 0; i<arguments.size(); i++) {
        auto & var = arguments[i];
        frame->localVariableMap.insert(make_pair(funcDef->parameters[i].name, var));
    }
    frame->localVariableMap.insert(make_pair("self",  shared_ptr<NCStackElement>(new NCStackPointerElement(shared_from_this()))));
    
    if(!g_subInterpretor->visit(funcDef->block, *frame))return false;
    if (frame->stack.size()>0) {
        lastStack.push_back((frame->stack.back()));
    }
    
    return true;
}

shared_ptr<NCStackElement> NCNativeObject::getAttribute(const string & attrName){
    auto val = this->m_fieldMap[attrName];
    return val;
}

void NCNativeObject::setAttribute(const string & attrName, shared_ptr<NCStackElement> value){
    this->m_fieldMap[attrName] = value;
}

shared_ptr<NCStackElement> NCStackPointerElement::doOperator(const string&op, shared_ptr<NCStackElement> rightOperand){
    if (op == "==") {
        if (rightOperand->type == "int") {
            NCInt ret =( this->toInt() == rightOperand->toInt());
            return shared_ptr<NCStackElement>(new NCStackIntElement(ret));
        }
    } else  if (op == "||") {
        NCInt left = toInt();
        NCInt right = rightOperand->toInt();
        
        return shared_ptr<NCStackElement>(new NCStackIntElement(left || right));
        
    }
    return rightOperand;
}

NCInt NCStackPointerElement::toInt(){
    if( !m_pObject)return 0;
    else {
        return m_pObject->toInt();
    }
}
NCFloat NCStackPointerElement::toFloat(){
    return 0;
}
string NCStackPointerElement::toString(){
    return m_pObject->getDescription();
}

shared_ptr<NCObject> NCStackPointerElement::toObject() {
    return this->getPointedObject();
}

shared_ptr<NCStackElement> NCStackPointerElement::copy(){
    return shared_ptr<NCStackElement>(new NCStackPointerElement(m_pObject));
}

bool NCStackPointerElement::invokeMethod(string methodName, vector<shared_ptr<NCStackElement>> &arguments,vector<shared_ptr<NCStackElement>> & lastStack){
//    auto pStackTop = (lastStack.back()).get();
    
    //fix smart pointer released
//    if (dynamic_cast<NCStackPointerElement*>((lastStack.back()).get())) {
//
//        auto pPointerElement = dynamic_pointer_cast<NCStackPointerElement> (lastStack.back());
//        lastStack.pop_back();
//
//        auto pObject = pPointerElement->getPointedObject();
//
//        return pObject->invokeMethod(methodName, arguments, lastStack);
//    }
//    else if (dynamic_cast<NCStackVariableElement*>(pStackTop)) {
//        auto pVar = dynamic_cast<NCStackVariableElement*>(pStackTop);
//        while (dynamic_cast<NCStackVariableElement*>(pVar->valueElement.get())) {
//            pVar = dynamic_cast<NCStackVariableElement*>(pVar->valueElement.get());
//        }
//        if (dynamic_cast<NCStackPointerElement*>(pVar->valueElement.get())) {
//            auto pPointerElement = dynamic_pointer_cast<NCStackPointerElement> (pVar->valueElement);
//            lastStack.pop_back();
//
//            auto pPointedObject = pPointerElement->getPointedObject();
//
//            return pPointedObject->invokeMethod(methodName, arguments, lastStack);
//        }
//    }
    auto res = m_pObject->invokeMethod(methodName, arguments, lastStack);
    
    return res;
}

bool NCStackPointerElement::invokeMethod(string methodName, vector<shared_ptr<NCStackElement>> &arguments,vector<shared_ptr<NCStackElement>> &formatArguments,vector<shared_ptr<NCStackElement>> & lastStack) {
    auto res = m_pObject->invokeMethod(methodName, arguments, formatArguments, lastStack);
    
    return res;
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

 bool NCLambdaObject::invokeMethod(string methodName, vector<shared_ptr<NCStackElement>> &arguments,vector<shared_ptr<NCStackElement>> & lastStack) {
     auto frame = shared_ptr<NCFrame>(new NCFrame());
     
     for (int i = 0; i < arguments.size(); i++) {
         auto & var = arguments[i];
         frame->localVariableMap.insert(make_pair(m_lambdaExpr->parameters[i].name, var));
     }
     
     for (int i = 0; i < m_capturedObjects.size(); i++) {
         auto & cap = m_capturedObjects[i];
         frame->localVariableMap.insert(make_pair(cap.name, cap.object));
     }
     
     if (!g_subInterpretor->visit(m_lambdaExpr->blockStmt, *frame))return false;
     if (frame->stack.size() > 0) {
         lastStack.push_back((frame->stack.back()));
     }
     
     return true;
}

NCObject* NCLambdaObject::copy(){
    auto copy = new NCLambdaObject(m_lambdaExpr);
    
    for (auto c : m_capturedObjects) {
        NCCapturedObject capture;
        capture.signature = 0;
        capture.name = c.name;
        capture.object = c.object;
        
        copy->addCapture(capture);
    }
    return copy;
}
