//
//  NCInterpreter.cpp
//  NaiveC
//
//  Created by 梁志远 on 27/08/2017.
//  Copyright © 2017 Ogreaxe. All rights reserved.
//

#include "NCInterpreter.hpp"

void NCFrame::insertVariable(string&name, int value){
    localVariableMap[name] = shared_ptr<NCStackElement>(new NCStackIntElement(value));
}
void NCFrame::insertVariable(string&name, float value){
    localVariableMap[name] = shared_ptr<NCStackElement>(new NCStackFloatElement(value));
    
}
void NCFrame::insertVariable(string&name, string& value){
    localVariableMap[name] = shared_ptr<NCStackElement>(new NCStackStringElement(value));
    
}

NCInterpreter::NCInterpreter(shared_ptr<NCASTRoot> root){
    auto functionDefList = root->functionList;
    for (auto funcDef :functionDefList) {
        auto func = dynamic_cast<NCASTFunctionDefinition*>(funcDef.get());
        functionMap[func->name] = funcDef;
    }
    
    intBuiltiFunctionMap();
}

void NCInterpreter::intBuiltiFunctionMap(){
    auto printFunction = new NCBuiltinPrint();
    builtinFunctionMap[printFunction->name] = shared_ptr<NCBuiltinFunction>(printFunction);
}

bool NCInterpreter::invoke(string function, vector<shared_ptr<NCStackElement>> &arguments,vector<shared_ptr<NCStackElement>> & lastStack){
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

bool NCInterpreter::walkTree(shared_ptr<NCASTNode> currentNode, NCFrame & frame){
    bool boolVal;
    return walkTree(currentNode, frame, &boolVal);
}

bool NCInterpreter::walkTree(shared_ptr<NCASTNode> currentNode, NCFrame & frame, bool * shouldReturn){
    if(dynamic_cast<NCBlock*>(currentNode.get())) {
        auto node = dynamic_cast<NCBlock*>(currentNode.get());
        for (auto stmt : node->statement_list) {
            *shouldReturn = false;
            walkTree(stmt, frame, shouldReturn);
            if (*shouldReturn) {
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
            
            if (type == "int") {
                int value = stackPopInt(frame);
                frame.insertVariable(node->id.first, value);
            }
            else if (type == "float") {
                float value = stackPopFloat(frame);
                frame.insertVariable(node->id.first, value);
            }
            else if (type == "string") {
                string value = stackPopString(frame);
                frame.insertVariable(node->id.first, value);
            }
            else if (type == "array") {
                
            }
        }
    }
    else if (dynamic_cast<NCMethodCallExpr*>(currentNode.get())) {
        auto node = dynamic_cast<NCMethodCallExpr*>(currentNode.get());
        auto findFunc = functionMap.find(node->name);
        if (findFunc!=functionMap.end()) {
            auto functionDef = (dynamic_cast<NCASTFunctionDefinition*>((*findFunc).second.get()));
            
            vector<shared_ptr<NCStackElement>> arguments;
            
            auto parameters = functionDef->parameters;
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
            walkTree(thenBlock, frame, shouldReturn);
        }
        else {
            auto & elseBlock = node->elseStatement;
            walkTree(elseBlock, frame,shouldReturn);
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
                walkTree(block, frame, shouldReturn);
                if (*shouldReturn) {
                    break;
                }
            }
            else {
                break;
            }
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
            if (!var->isArray) {
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
            }
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
            auto varElement = new NCStackVariableElement(node->name, var->copy());
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
    }while (0);
    
    frame.stack.pop_back();
    return ret;
}
