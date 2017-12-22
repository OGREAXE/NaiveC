//
//  NCInterpreter.cpp
//  NaiveC
//
//  Created by 梁志远 on 27/08/2017.
//  Copyright © 2017 Ogreaxe. All rights reserved.
//

#include "NCInterpreter.hpp"
#include "NCStackElement.hpp"

void NCFrame::insertVariable(string&name, int value){
    localVariableMap[name] = shared_ptr<NCStackElement>(new NCStackIntElement(value));
}
void NCFrame::insertVariable(string&name, float value){
    localVariableMap[name] = shared_ptr<NCStackElement>(new NCStackFloatElement(value));
    
}
void NCFrame::insertVariable(string&name, string& value){
    localVariableMap[name] = shared_ptr<NCStackElement>(new NCStackStringElement(value));
}

void NCFrame::insertVariable(string&name, shared_ptr<NCStackElement> pObject){
    localVariableMap[name] = pObject;
}

void NCFrame::insertVariable(string&name, NCStackPointerElement & pObject){
    localVariableMap[name] = shared_ptr<NCStackElement>(new NCStackPointerElement(pObject.getRawObjectPointer()));
}



NCInterpreter::NCInterpreter(shared_ptr<NCASTRoot> root){
    auto functionDefList = root->functionList;
    for (auto funcDef :functionDefList) {
        auto func = dynamic_cast<NCASTFunctionDefinition*>(funcDef.get());
        functionMap[func->name] = funcDef;
    }
    
    intBuiltiFunctionMap();
}

bool NCInterpreter::isClassName(const string & name){
    if (name == "array") {
        return true;
    }
    
    return false;
}

void NCInterpreter::intBuiltiFunctionMap(){
    auto printFunction = new NCBuiltinPrint();
    builtinFunctionMap[printFunction->name] = shared_ptr<NCBuiltinFunction>(printFunction);
}

bool NCInterpreter::invoke(string function, vector<shared_ptr<NCStackElement>> &arguments,vector<shared_ptr<NCStackElement>> & lastStack){
    if (isClassName(function)) {
        return invoke_constructor(function, arguments, lastStack);
    }
    
    auto findFunc = functionMap.find(function);
    if (findFunc == functionMap.end()) {
        return false;
    }
    
    auto functionDefinition = (*findFunc).second;
    auto funcDef = dynamic_cast<NCASTFunctionDefinition*>(functionDefinition.get());
    
    auto frame = shared_ptr<NCFrame>(new NCFrame());
    for (int i = 0; i<arguments.size(); i++) {
        auto & var = arguments[i];
        frame->localVariableMap.insert(make_pair(funcDef->parameters[i].name, var));
    }
//    for (auto var :arguments) {
////        frame->localVariableMap.insert(make_pair(var->name, var));
//        
//    }
    
    if(!walkTree(funcDef->block, *frame))return false;
    if (frame->stack.size()>0) {
        lastStack.push_back((frame->stack.back()));
    }
    return true;
}


bool NCInterpreter::invoke_constructor(string function, vector<shared_ptr<NCStackElement>> &arguments,vector<shared_ptr<NCStackElement>> & lastStack){
    //todo
    if (function == "array") {
        
        
    }
    return false;
}

bool NCInterpreter::walkTree(shared_ptr<NCASTNode> currentNode, NCFrame & frame){
    bool boolVal;
    return walkTree(currentNode, frame, &boolVal);
}

bool NCInterpreter::walkTree(shared_ptr<NCASTNode> node, NCFrame & frame, bool * shouldReturn){
    return walkTree(node, frame,shouldReturn,nullptr);
}

bool NCInterpreter::walkTree(shared_ptr<NCASTNode> currentNode, NCFrame & frame, bool * shouldReturn, bool * shouldBreak){
    if(dynamic_cast<NCBlock*>(currentNode.get())) {
        auto node = dynamic_cast<NCBlock*>(currentNode.get());
        for (auto stmt : node->statement_list) {
            *shouldReturn = false;
            
            if (shouldBreak) {
                *shouldBreak = false;
            }
            
            walkTree(stmt, frame, shouldReturn,shouldBreak);
            
            if (*shouldReturn) {
                break;
            }
            
            if (shouldBreak && *shouldBreak) {
                break;
            }
        }
    }
    else if(dynamic_cast<NCBlockStatement*>(currentNode.get())) {
        auto node = dynamic_cast<NCBlockStatement*>(currentNode.get());
        walkTree(node->expression, frame);
    }
    else if (dynamic_cast<NCVariableDeclarationExpression*>(currentNode.get())) {
        auto node = dynamic_cast<NCVariableDeclarationExpression*>(currentNode.get());
        frame.stack.push_back(shared_ptr<NCStackStringElement> (new NCStackStringElement(node->type)));
        for (auto var :node->variables) {
            walkTree(var, frame);
        }
    }
    else if (dynamic_cast<VariableDeclarator*>(currentNode.get())) {
        auto node = dynamic_cast<VariableDeclarator*>(currentNode.get());
        
        string type = stackPopString(frame);
        
        if (node->expression) {
            walkTree(node->expression, frame);
            string name = node->id_str();
            if (type == "int") {
                int value = stackPopInt(frame);
                frame.insertVariable(name, value);
            }
            else if (type == "float") {
                float value = stackPopFloat(frame);
                frame.insertVariable(name, value);
            }
            else if (type == "string") {
                string value = stackPopString(frame);
                frame.insertVariable(name, value);
            }
            else if (type == "array") {
                auto arrayPointerElement = stackPopObjectPointer(frame);
                frame.insertVariable(name, arrayPointerElement);
            }
        }
    }
    else if (dynamic_cast<NCMethodCallExpr*>(currentNode.get())) {
        auto node = dynamic_cast<NCMethodCallExpr*>(currentNode.get());
        
        if (node->scope) {
            tree_doClassMehothodCall(frame, node);
        }
        else {
            tree_doStaticMehothodCall(frame, node);
        }
    }
    else if(dynamic_cast<NCBinaryExpression*>(currentNode.get())){
        auto node = dynamic_cast<NCBinaryExpression*>(currentNode.get());
        
        walkTree(node->left, frame);
        auto leftOperand = (frame.stack.back());
        frame.stack.pop_back();
        
        walkTree(node->right, frame);
        auto rightOperand = (frame.stack.back());
        frame.stack.pop_back();
        
        frame.stack.push_back(leftOperand->doOperator(node->op,rightOperand));
    }
    else if(dynamic_cast<IfStatement*>(currentNode.get())){
        auto node = dynamic_cast<IfStatement*>(currentNode.get());
        
        auto & condition = node->condition;
        walkTree(condition, frame);
        
        auto stackTop = (frame.stack.back());
        frame.stack.pop_back();
        
        if (stackTop->toInt()) {
            auto & thenBlock = node->thenStatement;
            walkTree(thenBlock, frame, shouldReturn,shouldBreak);
        }
        else {
            auto & elseBlock = node->elseStatement;
            walkTree(elseBlock, frame,shouldReturn,shouldBreak);
        }
    }
    else if(dynamic_cast<WhileStatement*>(currentNode.get())){
        auto node = dynamic_cast<WhileStatement*>(currentNode.get());
        
        auto & condition = node->condition;
        
        while (1) {
            walkTree(condition, frame);
            
            auto stackTop = (frame.stack.back());
            frame.stack.pop_back();
            
            if (stackTop->toInt()) {
                auto & block = node->statement;
                
                bool shouldBreakLocal = false;
                
                walkTree(block, frame, shouldReturn, &shouldBreakLocal);
                
                if (*shouldReturn) {
                    break;
                }
                
                if (shouldBreakLocal) {
                    break;
                }
            }
            else {
                break;
            }
        }
    }
    else if(dynamic_cast<ForStatement*>(currentNode.get())){
        auto node = dynamic_cast<ForStatement*>(currentNode.get());
        
        for(auto aInit:node->init){
            walkTree(aInit, frame);
        }
        
        while (1) {
            walkTree(node->expr, frame);
            
            auto stackTop = (frame.stack.back());
            frame.stack.pop_back();
            
            if (stackTop->toInt()) {
                auto & block = node->body;
                
                bool shouldBreakLocal = false;
                
                walkTree(block, frame, shouldReturn,&shouldBreakLocal);
                
                if (*shouldReturn) {
                    break;
                }
                
                if (shouldBreakLocal) {
                    break;
                }
                
                for(auto aUpdate:node->update){
                    walkTree(aUpdate, frame);
                }
            }
            else {
                break;
            }
        }
    }
    else if(dynamic_cast<BreakStatement*>(currentNode.get())){
        if (shouldBreak) {
            *shouldBreak = true;
        }
    }
    else if(dynamic_cast<NCAssignExpr*>(currentNode.get())){
        auto node = dynamic_cast<NCAssignExpr*>(currentNode.get());
        //todo
        auto primary = node->expr;
        walkTree(primary, frame);
        
        auto stackTop = (frame.stack.back());
        frame.stack.pop_back();
        
        if (dynamic_cast<NCStackVariableElement*>(stackTop.get())) {
            auto var = dynamic_cast<NCStackVariableElement*>(stackTop.get());
            walkTree(node->value,frame);
            if (var->valueElement->type == "int") {
                frame.insertVariable(var->name, stackPopInt(frame));
            }
            else if (var->valueElement->type == "float") {
                frame.insertVariable(var->name, stackPopFloat(frame));
            }
            else if (var->valueElement->type == "string") {
                string str = stackPopString(frame);
                frame.insertVariable(var->name, str);
            }
            else if (var->valueElement->type == "array") {
                auto pStackTop = frame.stack.back();
                auto obj = frame.localVariableMap[var->name].get();
                if (dynamic_cast<NCArrayInstance*>(obj)) {
                    frame.stack.pop_back();
                    auto arrayInst = dynamic_cast<NCArrayInstance*>(obj);
                    auto scope = frame.stack.back();
                    vector<shared_ptr<NCStackElement> > arguments = {scope};
                    arrayInst->invokeMethod("set", arguments, frame.stack);
                }
            
            }
        }
        else if (dynamic_cast<NCArrayAccessor*>(stackTop.get())) {
            auto accessor = dynamic_cast<NCArrayAccessor*>(stackTop.get());
            walkTree(node->value,frame);
            auto value = frame.stack.back();
            frame.stack.pop_back();
            accessor->set(value);
        }
        
    }
    else if(dynamic_cast<NCArrayAccessExpr*>(currentNode.get())){
        auto node = dynamic_cast<NCArrayAccessExpr*>(currentNode.get());
        
        walkTree(node->scope, frame);
        walkTree(node->expression, frame);
        
        int index = stackPopInt(frame);
        auto  _arrayPointer = stackPopObjectPointer(frame)->getRawObjectPointer();
        if (dynamic_cast<NCArrayInstance*>(_arrayPointer) ) {
            auto pArr = dynamic_cast<NCArrayInstance*>(_arrayPointer);
            auto accessor = new NCArrayAccessor(pArr,index);
            
            frame.stack.push_back(shared_ptr<NCStackElement>(accessor));
        }
    }
    else if(dynamic_cast<NCNameExpression*>(currentNode.get())){
        auto node = dynamic_cast<NCNameExpression*>(currentNode.get());
        //todo
        auto findValue = frame.localVariableMap.find(node->name);
        if (findValue == frame.localVariableMap.end()) {
            return false;
        }
        else {
            auto var = (*findValue).second;

            //wild pointer ???
//            printf("%d",var->toInt());
            auto varElement = new NCStackVariableElement(node->name, var);
//            auto varElement = new NCStackVariableElement(node->name, var->copy());
            frame.stack.push_back(shared_ptr<NCStackElement>(varElement));
        }
    }
    else if(dynamic_cast<NCLiteral*>(currentNode.get())){
        auto node = dynamic_cast<NCLiteral*>(currentNode.get());
        //todo
        auto stackElement = NCStackElement::createStackElement(node);
        frame.stack.push_back(stackElement);
    }
    else if(dynamic_cast<ReturnStatement*>(currentNode.get())){
        auto node = dynamic_cast<ReturnStatement*>(currentNode.get());
        
        auto exp = node->expression;
        walkTree(exp, frame);
    }
    return true;
}

bool NCInterpreter::tree_composeArgmemnts(NCFrame & frame,NCMethodCallExpr*node,vector<NCParameter> &parameters, vector<shared_ptr<NCStackElement>>&arguments){
    for (int i = 0; i<parameters.size(); i++) {
        auto & parameter = parameters[i];
        
        auto argExp = node->args[i];
        walkTree(argExp, frame);
        
        if (parameter.type == "int") {
            auto value = stackPopInt(frame);
            auto argValue = new NCStackIntElement(value);
            arguments.push_back(shared_ptr<NCStackElement>(argValue));
        }
        else if (parameter.type == "float") {
            auto value = stackPopFloat(frame);
            auto argValue = new NCStackFloatElement(value);
            arguments.push_back(shared_ptr<NCStackElement>(argValue));
        }
        else if (parameter.type == "string") {
            auto value = stackPopString(frame);
            auto argValue = new NCStackStringElement(value);
            arguments.push_back(shared_ptr<NCStackElement>(argValue));
        }
    }
    
    return true;
}

bool NCInterpreter::tree_doStaticMehothodCall(NCFrame & frame,NCMethodCallExpr*node){
    auto findFunc = functionMap.find(node->name);
    if (findFunc!=functionMap.end()) {
        auto functionDef = (dynamic_cast<NCASTFunctionDefinition*>((*findFunc).second.get()));
        
        vector<shared_ptr<NCStackElement>> arguments;
        
        auto parameters = functionDef->parameters;
//        for (int i = 0; i<parameters.size(); i++) {
//            auto & parameter = parameters[i];
//
//            auto argExp = node->args[i];
//            walkTree(argExp, frame);
//
//            if (parameter.type == "int") {
//                auto value = stackPopInt(frame);
//                auto argValue = new NCStackIntElement(value);
//                arguments.push_back(shared_ptr<NCStackElement>(argValue));
//            }
//            else if (parameter.type == "float") {
//                auto value = stackPopFloat(frame);
//                auto argValue = new NCStackFloatElement(value);
//                arguments.push_back(shared_ptr<NCStackElement>(argValue));
//            }
//            else if (parameter.type == "string") {
//                auto value = stackPopString(frame);
//                auto argValue = new NCStackStringElement(value);
//                arguments.push_back(shared_ptr<NCStackElement>(argValue));
//            }
//        }
        
        tree_composeArgmemnts(frame,node, parameters, arguments);
        
        return invoke(functionDef->name, arguments, frame.stack);
    }
    else {
        //no user-defined function found, try system library
        auto find = builtinFunctionMap.find(node->name);
        if (find != builtinFunctionMap.end()) {
            auto funcDef = (*find).second;
            
            auto parameters = funcDef->parameters;
            
            vector<shared_ptr<NCStackElement>> arguments;
            
            for (int i = 0; i<parameters.size(); i++) {
                auto & parameter = parameters[i];

                auto argExp = node->args[i];
                walkTree(argExp, frame);

                if (parameter->type == "int") {
                    auto value = stackPopInt(frame);
                    auto argValue = new NCStackIntElement(value);
                    arguments.push_back(shared_ptr<NCStackElement>(argValue));
                }
                else if (parameter->type == "float") {
                    auto value = stackPopFloat(frame);
                    auto argValue = new NCStackFloatElement(value);
                    arguments.push_back(shared_ptr<NCStackElement>(argValue));
                }
                else if (parameter->type == "string") {
                    auto value = stackPopString(frame);
                    auto argValue = new NCStackStringElement(value);
                    arguments.push_back(shared_ptr<NCStackElement>(argValue));
                }
            }
            
            if (funcDef->hasReturn) {
                
            }
            else {
                funcDef->invoke(arguments);
            }
        }
        else {
            //constructor?
            if (node->name == "array") {
                auto pArray = new NCArrayInstance();
                frame.stack.push_back(shared_ptr<NCStackPointerElement> ( new NCStackPointerElement(pArray)));
            }
        }
    }
    return true;
}

bool NCInterpreter::tree_doClassMehothodCall(NCFrame & frame, NCMethodCallExpr*node){
    walkTree(node->scope, frame);
    
    auto parametersExpr = node->args;
    
    vector<shared_ptr<NCStackElement>> arguments;
    
    for (int i = 0; i<parametersExpr.size(); i++) {
        auto argExp = node->args[i];
        walkTree(argExp, frame);
        
        auto val = frame.stack.back();
        arguments.push_back(shared_ptr<NCStackElement>(val));
        
        frame.stack.pop_back();
    }
    
//    auto pStackTop = (frame.stack.back()).get();
//    auto varElement = dynamic_cast<NCStackVariableElement*>(pStackTop);
//    if(varElement){
//        auto strElement = dynamic_cast<NCStackStringElement*>(varElement->valueElement.get());
//        if(strElement){
//            //string is not pointer, require dealing with specially
//            return strElement->invokeMethod(node->name, arguments, frame.stack);;
//        }
//    }
//
//    auto pArrayAccessor = dynamic_cast<NCArrayAccessor*>(pStackTop);
//    if (pArrayAccessor) {
//        //???
//    }
//
//    auto scope = stackPopObjectPointer(frame);
//
////    auto pPointer = scope.get()->getObjectPointer().get();
//    auto pPointer = scope.get()->getRawObjectPointer();
//
//    if (dynamic_cast<NCClassInstance*>(pPointer)) {
//        auto classInst = dynamic_cast<NCClassInstance*>(pPointer);
//
//        return classInst->invokeMethod(node->name, arguments, frame.stack);
//    }
    
    (frame.stack.back())->invokeMethod(node->name, arguments, frame.stack);
    
    return true;
}

bool NCInterpreter::isStackTopInt(NCFrame & frame){
    return dynamic_cast<NCStackIntElement*>((frame.stack.back()).get()) == nullptr;
}

bool NCInterpreter::isStackTopFloat(NCFrame & frame){
    return dynamic_cast<NCStackFloatElement*>((frame.stack.back()).get()) == nullptr;
}

bool NCInterpreter::isStackTopString(NCFrame & frame){
    return dynamic_cast<NCStackStringElement*>((frame.stack.back()).get()) == nullptr;
}

int NCInterpreter::stackPopInt(NCFrame & frame){
    int ret = 0;
    
    do{
        auto pStackTop = (frame.stack.back()).get();
        
        auto intElement = dynamic_cast<NCStackIntElement*>(pStackTop);
        
        if(intElement){
            ret = intElement->value;
            break;
        }
        
        auto floatElement = dynamic_cast<NCStackFloatElement*>(pStackTop);
        
        if(floatElement){
            ret = floatElement->value;
            break;
        }
        
        auto stringElement = dynamic_cast<NCStackStringElement*>(pStackTop);
        
        if(stringElement){
            ret = stoi(stringElement->value);
            break;
        }
        
        auto varElement = dynamic_cast<NCStackVariableElement*>(pStackTop);
        
        if(varElement){
            ret = varElement->toInt();
            break;
        }
        
    }while (1);
    
    frame.stack.pop_back();
    return ret;
}

float NCInterpreter::stackPopFloat(NCFrame & frame){
//    auto stackTop= dynamic_cast<NCStackFloatElement*>((*frame.stack.end()).get());
//    float ret = stackTop->value;
//    frame.stack.pop_back();
//    return ret;
    
    float ret = 0;
    
    do{
        auto pStackTop = (frame.stack.back()).get();
        
        auto floatElement = dynamic_cast<NCStackFloatElement*>(pStackTop);
        
        if(floatElement){
            ret = floatElement->value;
            break;
        }
        
        auto intElement = dynamic_cast<NCStackIntElement*>(pStackTop);
        
        if(intElement){
            ret = intElement->value;
            break;
        }
        
        auto stringElement = dynamic_cast<NCStackStringElement*>(pStackTop);
        
        if(stringElement){
            ret = stof(stringElement->value);
            break;
        }
        
        auto varElement = dynamic_cast<NCStackVariableElement*>(pStackTop);
        
        if(varElement){
            ret = varElement->toFloat();
            break;
        }
        
    }while (0);
    
    frame.stack.pop_back();
    return ret;
}

string NCInterpreter::stackPopString(NCFrame & frame){
    string ret = "";
    
    do{
        auto pStackTop = (frame.stack.back()).get();
        
        auto stringElement = dynamic_cast<NCStackStringElement*>(pStackTop);
        
        if(stringElement){
            ret = stringElement->value;
            break;
        }
        
        auto intElement = dynamic_cast<NCStackIntElement*>(pStackTop);
        
        if(intElement){
            ret = to_string(intElement->value);
            break;
        }
        
        auto floatElement = dynamic_cast<NCStackFloatElement*>(pStackTop);
        
        if(floatElement){
            ret = to_string(floatElement->value);
            break;
        }
        
        auto varElement = dynamic_cast<NCStackVariableElement*>(pStackTop);
        
        if(varElement){
            ret = varElement->toString();
            break;
        }
        
        auto arrayAccessorElement = dynamic_cast<NCArrayAccessor*>(pStackTop);
        if(arrayAccessorElement){
            ret = arrayAccessorElement->toString();
            break;
        }
    }while (0);
    
    frame.stack.pop_back();
    return ret;
}

shared_ptr<NCStackPointerElement>  NCInterpreter::stackPopObjectPointer(NCFrame & frame){
    auto pStackTop = (frame.stack.back()).get();
    
    //fix smart pointer released
    if (dynamic_cast<NCStackPointerElement*>(pStackTop)) {
        
        auto pRet = dynamic_pointer_cast<NCStackPointerElement> (frame.stack.back());
        frame.stack.pop_back();
        
        return pRet;
    }
    else if (dynamic_cast<NCStackVariableElement*>(pStackTop)) {
        auto pVar = dynamic_cast<NCStackVariableElement*>(pStackTop);
        if (dynamic_cast<NCStackPointerElement*>(pVar->valueElement.get())) {
            auto pRet = dynamic_pointer_cast<NCStackPointerElement> (pVar->valueElement);
            
            frame.stack.pop_back();
            
            return pRet;
        }
    }
    
    return shared_ptr<NCStackPointerElement> (nullptr);
}
