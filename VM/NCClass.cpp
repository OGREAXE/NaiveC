//
//  NCClass.cpp
//  NaiveC
//
//  Created by Liang,Zhiyuan(GIS) on 2018/2/17.
//  Copyright © 2018年 Ogreaxe. All rights reserved.
//

#include "NCClass.hpp"
#include "NCInterpreter.hpp"
#include "NCException.hpp"

static NCInterpreter * g_interpretor = new NCInterpreter();

NCNativeClass::NCNativeClass(shared_ptr<NCClassDeclaration> & classDef):NCClass(classDef->name),m_classDef(classDef){
  
}

shared_ptr<NCStackElement>  NCNativeClass::instantiate(vector<shared_ptr<NCStackElement>> &arguments){
    auto newObject = new NCNativeObject();
    newObject->classDefinition = m_classDef;
    
    for (auto aField:m_classDef->fields) {
        NCFrame frame;
        g_interpretor->visit(aField->declarator, frame);
        if (!frame.stack_empty()) {
            auto value = frame.stack_pop();
            newObject->m_fieldMap[aField->name] = value;
        }
    }
    
    auto constructor = m_classDef->methods[m_classDef->name];
    if (!constructor) {
        return shared_ptr<NCStackPointerElement>(new NCStackPointerElement(shared_ptr<NCObject> (newObject)));
    }
    
    auto constructorDef = constructor->method;
    
    auto frame = shared_ptr<NCFrame>(new NCFrame());
    for (int i = 0; i<arguments.size(); i++) {
        auto & var = arguments[i];
//        frame->localVariableMap.insert(make_pair(constructorDef->parameters[i].name, var));
        frame->insertVariable(constructorDef->parameters[i].name, var);
    }
    
    frame->objectScopeFlag = true;
    
//    frame->localVariableMap.insert(make_pair("self",  shared_ptr<NCStackElement>(new NCStackPointerElement(shared_ptr<NCObject> (newObject)))));
    frame->insertVariable("self", shared_ptr<NCStackElement>(new NCStackPointerElement(shared_ptr<NCObject> (newObject))));
    
    if(!g_interpretor->visit(constructorDef->block, *frame)){
        throw NCRuntimeException(0, "fail to instantiate object %s", m_classDef->name.c_str());
    }
    
    return shared_ptr<NCStackPointerElement>(new NCStackPointerElement(shared_ptr<NCObject> (newObject)));
}

bool NCNativeClass::invokeMethod(string methodName, vector<shared_ptr<NCStackElement>> &arguments,vector<shared_ptr<NCStackElement>> & lastStack){
    return false;
}
