//
//  NCClass.cpp
//  NaiveC
//
//  Created by Liang,Zhiyuan(GIS) on 2018/2/17.
//  Copyright © 2018年 Ogreaxe. All rights reserved.
//

#include "NCClass.hpp"
#include "NCInterpreter.hpp"

static NCInterpreter * g_interpretor = new NCInterpreter();

NCNativeClass::NCNativeClass(shared_ptr<NCClassDeclaration> & classDef):NCClass(classDef->name),m_classDef(classDef){
    for (int i=0; i<classDef->members.size(); i++) {
        auto & member = classDef->members[i];
        
        if (dynamic_pointer_cast<NCMethodDeclaration>(member)) {
            auto aMethod = dynamic_pointer_cast<NCMethodDeclaration>(member);
            m_methodMap[aMethod->method->name] = aMethod;
        }
        else if (dynamic_pointer_cast<NCFieldDeclaration>(member)) {
            auto aField = dynamic_pointer_cast<NCFieldDeclaration>(member);
            NCFrame frame;
            g_interpretor->visit(aField->declarator, frame);
            if (!frame.stack_empty()) {
                auto value = frame.stack_pop();
                m_fieldMap[aField->name] = value;
            }
        }
        
    }
}

shared_ptr<NCStackPointerElement>  NCNativeClass::instantiate(vector<shared_ptr<NCStackElement>> &arguments){
    return nullptr;
}

bool NCNativeClass::invokeMethod(string methodName, vector<shared_ptr<NCStackElement>> &arguments,vector<shared_ptr<NCStackElement>> & lastStack){
    return false;
}
