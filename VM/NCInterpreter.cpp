
//
//  NCInterpreter.cpp
//  NaiveC
//
//  Created by 梁志远 on 27/08/2017.
//  Copyright © 2017 Ogreaxe. All rights reserved.
//

#include "NCInterpreter.hpp"
#include "NCStackElement.hpp"
#include "NCClassLoader.hpp"
#include "NCArray.hpp"
#include "NCLog.hpp"
#include "NCException.hpp"
#include "NCHeapMemory.hpp"

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
    localVariableMap[name] = shared_ptr<NCStackElement>(new NCStackPointerElement(pObject.getPointedObject()));
}

shared_ptr<NCStackElement> NCFrame::stack_pop(){
    if(stack_empty()){
        return nullptr;
    }
    auto stackTop = this->stack.back();
    this->stack.pop_back();
    return stackTop;
}

shared_ptr<NCStackElement> NCFrame::stack_popRealValue(){
    auto stackTop = this->stack.back();
    this->stack.pop_back();
    
    if (dynamic_pointer_cast<NCStackVariableElement>(stackTop)) {
        auto var = dynamic_pointer_cast<NCStackVariableElement>(stackTop);
        return var->valueElement;
    }
    
    return stackTop;
}

void NCFrame::stack_push(shared_ptr<NCStackElement> element){
    this->stack.push_back(element);
}

NCInterpreter::NCInterpreter(shared_ptr<NCASTRoot> root){
    this->initWithRoot(root);
}

bool NCInterpreter::initWithRoot(shared_ptr<NCASTRoot> root){
    auto functionDefList = root->functionList;
    for (auto funcDef :functionDefList) {
        NCModuleCache::GetGlobalCache()->addNativeFunction(funcDef);
    }
    
    for (auto classDef :root->classList) {
        NCModuleCache::GetGlobalCache()->addClassDef(classDef);
    }
    
    return true;
}

bool NCInterpreter::isClassName(const string & name){
    if (name == "array") {
        return true;
    }
    
    return false;
}

bool NCInterpreter::invoke(string function, vector<shared_ptr<NCStackElement>> &arguments,vector<shared_ptr<NCStackElement>> & lastStack){
    if (isClassName(function)) {
        return invoke_constructor(function, arguments, lastStack);
    }
    
//    auto findFunc = functionMap.find(function);
//    if (findFunc == functionMap.end()) {
//        return false;
//    }
//
//    auto functionDefinition = (*findFunc).second;
//    auto funcDef = dynamic_cast<NCASTFunctionDefinition*>(functionDefinition.get());
    auto funcDef = NCModuleCache::GetGlobalCache()->getNativeFunction(function);
    if (!funcDef) {
        return false;
    }
    
    auto frame = shared_ptr<NCFrame>(new NCFrame());
    for (int i = 0; i<arguments.size(); i++) {
        auto & var = arguments[i];
        frame->localVariableMap.insert(make_pair(funcDef->parameters[i].name, var));
    }
//    for (auto var :arguments) {
////        frame->localVariableMap.insert(make_pair(var->name, var));
//        
//    }
    
    if(!visit(funcDef->block, *frame))return false;
    if (frame->stack.size()>0) {
        lastStack.push_back((frame->stack.back()));
    }
    return true;
}


bool NCInterpreter::invoke_constructor(string function, vector<shared_ptr<NCStackElement>> &arguments,vector<shared_ptr<NCStackElement>> & lastStack){
    //todo
    
    return false;
}

bool NCInterpreter::visit(shared_ptr<NCASTNode> currentNode, NCFrame & frame){
    bool boolVal;
    return visit(currentNode, frame, &boolVal);
}

bool NCInterpreter::visit(shared_ptr<NCASTNode> node, NCFrame & frame, bool * shouldReturn){
    return visit(node, frame,shouldReturn,nullptr);
}

bool NCInterpreter::visit(shared_ptr<NCASTNode> currentNode, NCFrame & frame, bool * shouldReturn, bool * shouldBreak){
    if(dynamic_cast<NCBlock*>(currentNode.get())) {
        auto node = dynamic_cast<NCBlock*>(currentNode.get());
        for (auto stmt : node->statement_list) {
            *shouldReturn = false;
            
            if (shouldBreak) {
                *shouldBreak = false;
            }
            
            visit(stmt, frame, shouldReturn,shouldBreak);
            
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
        visit(node->expression, frame);
    }
    else if (dynamic_cast<NCVariableDeclarationExpression*>(currentNode.get())) {
        auto node = dynamic_cast<NCVariableDeclarationExpression*>(currentNode.get());
        frame.stack.push_back(shared_ptr<NCStackStringElement> (new NCStackStringElement(node->type)));
        for (auto var :node->variables) {
            visit(var, frame);
        }
    }
    else if (dynamic_cast<VariableDeclarator*>(currentNode.get())) {
        auto node = dynamic_cast<VariableDeclarator*>(currentNode.get());
        
        string type = stackPopString(frame);
        
        if (node->expression) {
            visit(node->expression, frame);
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
//            else if (type == "array") {
//                auto arrayPointerElement = stackPopObjectPointer(frame);
//                frame.insertVariable(name, arrayPointerElement);
//            }
            else {
                auto pointerElement = stackPopObjectPointer(frame);
                frame.insertVariable(name, pointerElement);
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
    else if (dynamic_pointer_cast<NCObjCSendMessageExpr>(currentNode)) {
        auto node = dynamic_pointer_cast<NCObjCSendMessageExpr>(currentNode);
        
        tree_doClassMehothodCall(frame, node->getMehodCall().get());
    }
    else if (dynamic_cast<NCFieldAccessExpr*>(currentNode.get())) {
        auto node = dynamic_cast<NCFieldAccessExpr*>(currentNode.get());
        visit(node->scope, frame);
        if (frame.stack_empty()) {
            return false;
        }
        auto scope = frame.stack_pop();
//        auto attrValue = scope->getAttribute(node->field);
//        frame.stack_push(attrValue);
        
        auto accesor = new NCFieldAccessor(scope, node->field);
        frame.stack_push(shared_ptr<NCStackElement> (accesor));
    }
    else if(dynamic_cast<NCBinaryExpression*>(currentNode.get())){
        auto node = dynamic_cast<NCBinaryExpression*>(currentNode.get());
        
        visit(node->left, frame);
        
        auto leftOperand = frame.stack_pop();
        if (!leftOperand) {
            NCLog(NCLogTypeInterpretor, "left operand null");
            return false;
        }
        
        visit(node->right, frame);
        auto rightOperand = frame.stack_pop();
        if (!rightOperand) {
            NCLog(NCLogTypeInterpretor, "right operand null");
            return false;
        }
        
        frame.stack.push_back(leftOperand->doOperator(node->op,rightOperand));
    }
    else if(dynamic_cast<IfStatement*>(currentNode.get())){
        auto node = dynamic_cast<IfStatement*>(currentNode.get());
        
        auto & condition = node->condition;
        visit(condition, frame);
        
        if (frame.stack.size() > 0) {
            auto stackTop = (frame.stack.back());
            frame.stack.pop_back();
            
            if (stackTop->toInt()) {
                auto & thenBlock = node->thenStatement;
                visit(thenBlock, frame, shouldReturn,shouldBreak);
            }
            else {
                auto & elseBlock = node->elseStatement;
                visit(elseBlock, frame,shouldReturn,shouldBreak);
            }
        }
        else {
            auto & elseBlock = node->elseStatement;
            visit(elseBlock, frame,shouldReturn,shouldBreak);
        }
    }
    else if(dynamic_cast<WhileStatement*>(currentNode.get())){
        auto node = dynamic_cast<WhileStatement*>(currentNode.get());
        
        auto & condition = node->condition;
        
        while (1) {
            visit(condition, frame);
            
            auto stackTop = (frame.stack.back());
            frame.stack.pop_back();
            
            if (stackTop->toInt()) {
                auto & block = node->statement;
                
                bool shouldBreakLocal = false;
                
                visit(block, frame, shouldReturn, &shouldBreakLocal);
                
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
        
        if (node->fastEnumeration) {
            string enumerator = node->fastEnumeration->enumerator;
            auto expr = node->fastEnumeration->expr;
            
            visit(expr, frame);
            
            auto exprVal = stackPopObjectPointer(frame);
            if(!exprVal){return false;}
            auto pointedObject = exprVal->getPointedObject();
            if (dynamic_pointer_cast<NCFastEnumerable>(pointedObject)) {
                auto enumerable = dynamic_pointer_cast<NCFastEnumerable>(pointedObject);
                
                enumerable->enumerate([&](auto element){
                    frame.insertVariable(enumerator, element);
                    
                    auto & block = node->body;
                    
                    bool shouldBreakLocal = false;
                    
                    visit(block, frame, shouldReturn,&shouldBreakLocal);
                    
                    if (*shouldReturn) {
                        shouldBreakLocal = true;
                    }
                    
                    return shouldBreakLocal;
                });
                
//                for (int i=0; i <array->length(); i++) {
//                    auto currentValue = array->getElementAt(i);
//
//                    frame.insertVariable(enumerator, currentValue);
//
//                    auto & block = node->body;
//
//                    bool shouldBreakLocal = false;
//
//                    visit(block, frame, shouldReturn,&shouldBreakLocal);
//
//                    if (*shouldReturn) {
//                        break;
//                    }
//
//                    if (shouldBreakLocal) {
//                        break;
//                    }
//                }
            }
            else {
                return false;
            }
        }
        else {
            for(auto aInit:node->init){
                visit(aInit, frame);
            }
            
            while (1) {
                visit(node->expr, frame);
                
                auto stackTop = (frame.stack.back());
                frame.stack.pop_back();
                
                if (stackTop->toInt()) {
                    auto & block = node->body;
                    
                    bool shouldBreakLocal = false;
                    
                    visit(block, frame, shouldReturn,&shouldBreakLocal);
                    
                    if (*shouldReturn) {
                        break;
                    }
                    
                    if (shouldBreakLocal) {
                        break;
                    }
                    
                    for(auto aUpdate:node->update){
                        visit(aUpdate, frame);
                    }
                }
                else {
                    break;
                }
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
        
        if (dynamic_pointer_cast<NCNameExpression>(primary)) {
            auto _pri = dynamic_pointer_cast<NCNameExpression>(primary);
            _pri->setShouldAddKeyIfKeyNotFound(true);
        }
        
        if(!visit(primary, frame)){
            return false;
        }
        
        auto stackTop = frame.stack_pop();
        
        if (dynamic_cast<NCStackVariableElement*>(stackTop.get())) {
            auto var = dynamic_cast<NCStackVariableElement*>(stackTop.get());
            visit(node->value,frame);
            
            //primitive types, like int ,float and string pass by value
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
            else {
                //pass by pointer
                auto pointerElement = stackPopObjectPointer(frame);
                frame.insertVariable(var->name, pointerElement);
            }
        }
        else if (dynamic_cast<NCAccessor*>(stackTop.get())) {
            auto accessor = dynamic_cast<NCAccessor*>(stackTop.get());
            visit(node->value,frame);
            auto value = frame.stack_popRealValue();
            if (dynamic_cast<NCAccessor*>(value.get())) {
                auto accessorValue = dynamic_cast<NCAccessor*>(value.get());
                accessor->set(accessorValue->value());
            }
            else {
                accessor->set(value);
            }
        }
        else {
            if (dynamic_pointer_cast<NCNameExpression>(primary)) {
                auto nameExpr = dynamic_pointer_cast<NCNameExpression>(primary);
                visit(node->value,frame);
                auto value = frame.stack_pop();
                if (!value) {
                    return false;
                }
                if (dynamic_pointer_cast<NCAccessor>(value)) {
                    auto accessor = dynamic_pointer_cast<NCAccessor>(value);
                    frame.insertVariable(nameExpr->name, accessor->value());
                }else {
                    if (dynamic_pointer_cast<NCObject>(value)) {
                        auto object = dynamic_pointer_cast<NCObject>(value);
                        auto pointer = shared_ptr<NCStackPointerElement>(new NCStackPointerElement(object));
                        
                        frame.insertVariable(nameExpr->name, pointer);
                    }
                    else {
                        frame.insertVariable(nameExpr->name, value);
                    }
                }
            }
        }
        
    }
    else if(dynamic_cast<NCArrayAccessExpr*>(currentNode.get())){
        auto node = dynamic_cast<NCArrayAccessExpr*>(currentNode.get());
        
        visit(node->scope, frame);
        visit(node->expression, frame);
        
        int index = stackPopInt(frame);
        auto pointer = stackPopObjectPointer(frame);
        if (pointer == NULL) {
            throw NCRuntimeException(0, "accessing null array");
        }
        auto obj = pointer->getPointedObject();
        if (dynamic_pointer_cast<NCBracketAccessible>(obj) ) {
            auto accessible = dynamic_pointer_cast<NCBracketAccessible>(obj);
            auto accessor = new NCArrayAccessor(accessible,shared_ptr<NCStackElement>( new NCStackIntElement(index)));
            
            frame.stack.push_back(shared_ptr<NCStackElement>(accessor));
        }
    }
    else if(dynamic_cast<NCArrayInitializer*>(currentNode.get())){
        auto node = dynamic_cast<NCArrayInitializer*>(currentNode.get());
        
        auto pArray = new NCArray();
        
        for (auto element : node->elements) {
            visit(element, frame);
            
            auto value = frame.stack_pop();
            
            pArray->addElement(value);
        }
        
        frame.stack_push(shared_ptr<NCStackPointerElement> ( new NCStackPointerElement( shared_ptr<NCObject>(pArray))));
    }
    else if(dynamic_cast<NCNameExpression*>(currentNode.get())){
        auto node = dynamic_cast<NCNameExpression*>(currentNode.get());
        
        if (node->name == "null") {
            auto nullPtr = shared_ptr<NCStackElement>( new NCStackPointerElement());
            frame.stack.push_back(nullPtr);
            return true;
        }
        
        if ( NCClassLoader::GetInstance()->isClassExist(node->name)) {
            //a 'meta' class
            auto targetClass = NCClassLoader::GetInstance()->loadClass(node->name);
            if (!targetClass) {
                return false;
            }
            
            frame.stack.push_back(targetClass);
            return true;
        }
        
        auto findValue = frame.localVariableMap.find(node->name);
        if (findValue == frame.localVariableMap.end()) {
            if (node->getShouldAddKeyIfKeyNotFound()) {
                auto placeholder = shared_ptr<NCStackElement>(nullptr);
                frame.insertVariable(node->name, placeholder);
                frame.stack.push_back(shared_ptr<NCStackElement>(placeholder));
            }
            else {
                return false;
            }
        }
        else {
            auto var = (*findValue).second;

            //wild pointer ???
//            printf("%d",var->toInt());
            if (dynamic_cast<NCStackVariableElement*>(var.get())) {
                //extract value, avoid variable in variable.
                auto varWrapped = dynamic_pointer_cast<NCStackVariableElement>(var);
                auto payload = varWrapped->valueElement;
                
                frame.stack.push_back(shared_ptr<NCStackElement>(new NCStackVariableElement(node->name, payload)));
                
            }
            else {
                auto varElement = new NCStackVariableElement(node->name, var);
                frame.stack.push_back(shared_ptr<NCStackElement>(varElement));
            }
        }
    }
    else if(dynamic_cast<NCLiteral*>(currentNode.get())){
        auto node = dynamic_cast<NCLiteral*>(currentNode.get());
        //todo
        auto stackElement = NCStackElement::createStackElement(node);
        frame.stack.push_back(stackElement);
    }
    else if(dynamic_cast<NCUnaryExpression*>(currentNode.get())){
        auto node = dynamic_cast<NCUnaryExpression*>(currentNode.get());
        visit(node->expression, frame);
        NCInt unaryResult = stackPopInt(frame);
        if (node->op == "+") {
            
        }
        else if (node->op == "-") {
            frame.stack.push_back(shared_ptr<NCStackIntElement>(new NCStackIntElement(-unaryResult)));
        }
        else if (node->op == "!") {
            if (unaryResult != 0) {
                frame.stack.push_back(shared_ptr<NCStackIntElement>(new NCStackIntElement(0)));
            }
            else{
                frame.stack.push_back(shared_ptr<NCStackIntElement>(new NCStackIntElement(1)));
            }
        }
        
    }
    else if(dynamic_pointer_cast<NCLambdaExpression>(currentNode)){
        auto lambdaExpr = dynamic_pointer_cast<NCLambdaExpression>(currentNode);
        
        auto &capturedSymbols = lambdaExpr->capturedSymbols;
        
        auto lambdaObj = new NCLambdaObject(lambdaExpr);
        
        for (auto & capturedSymbol : capturedSymbols) {
            auto &localVar = frame.localVariableMap[capturedSymbol];
            
            NCCapturedObject capture;
            capture.signature = 0;
            capture.name = capturedSymbol;
            capture.object = localVar;
            
            lambdaObj->addCapture(capture);
        }
        
        auto pLambdaObj = new NCStackPointerElement(lambdaObj);
        frame.stack_push(shared_ptr<NCStackElement>(pLambdaObj));
    }
    else if(dynamic_cast<ReturnStatement*>(currentNode.get())){
        auto node = dynamic_cast<ReturnStatement*>(currentNode.get());
        
        auto exp = node->expression;
        visit(exp, frame);
        *shouldReturn = true;
    }
    return true;
}

bool NCInterpreter::tree_composeArgmemnts(NCFrame & frame,NCMethodCallExpr*node,vector<NCParameter> &parameters, vector<shared_ptr<NCStackElement>>&arguments){
    for (int i = 0; i<parameters.size(); i++) {
        auto & parameter = parameters[i];
        
        auto argExp = node->args[i];
        visit(argExp, frame);
        
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
        else {
            //object pointer
            auto objectPointer = frame.stack_pop();
            arguments.push_back(objectPointer);
        }
    }
    
    return true;
}

bool NCInterpreter::tree_doStaticMehothodCall(NCFrame & frame,NCMethodCallExpr*node){
//    auto findFunc = functionMap.find(node->name);
    auto functionDef = NCModuleCache::GetGlobalCache()->getNativeFunction(node->name);
    if (functionDef) {
        vector<shared_ptr<NCStackElement>> arguments;
        
        auto parameters = functionDef->parameters;
        
        tree_composeArgmemnts(frame,node, parameters, arguments);
        
        return invoke(functionDef->name, arguments, frame.stack);
    }
    else {
        //no user-defined function found, try system library
//        auto find = builtinFunctionMap.find(node->name);
        auto find = NCModuleCache::GetGlobalCache()->getSystemFunction(node->name);
        if (find) {
            auto funcDef = find;
            
            auto parameters = funcDef->parameters;
            
            vector<shared_ptr<NCStackElement>> arguments;
            
            for (int i = 0; i<node->args.size(); i++) {
                if (i>=parameters.size()) {
                    throw NCRuntimeException(0, "arguments exceed expected");
                }
                auto & parameter = parameters[i];

                auto argExp = node->args[i];
                visit(argExp, frame);
                
                if (frame.stack.size() == 0) {
                    throw NCRuntimeException(0, "get argument fail");
                }

                if (parameter->type == "original") {
                    auto value = frame.stack_pop();
                    arguments.push_back(value);
                }
                else if (parameter->type == "int") {
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
                else {
                    //object pointer
                    auto objectPointer = frame.stack_pop();
                    arguments.push_back(objectPointer);
                }
            }
            
            funcDef->invoke(arguments,frame.stack);
            
        }
        else {
            auto cls = NCClassLoader::GetInstance()->loadClass(node->name);
//            auto cls = NCModuleCache::GetGlobalCache()->getClass(node->name);
            
            if (!cls) {
                throw NCRuntimeException(0, "class %s not found", node->name.c_str());
            }
            
            vector<shared_ptr<NCStackElement>> arguments;
            
            initArguments(node->args, arguments, frame);
            
            auto aInstance = cls->instantiate(arguments);
            
            frame.stack.push_back(shared_ptr<NCStackPointerElement> ( aInstance));
        }
    }
    return true;
}

bool NCInterpreter::initArguments(vector<shared_ptr<NCExpression>> &intput_argumentExpressions, vector<shared_ptr<NCStackElement>> & output_arguments, NCFrame&frame){
    for (int i = 0; i<intput_argumentExpressions.size(); i++) {
        auto argExp = intput_argumentExpressions[i];
        visit(argExp, frame);
        
        auto argValue = frame.stack_pop();
        
        output_arguments.push_back(argValue);
    }
    return true;
}

bool NCInterpreter::tree_doClassMehothodCall(NCFrame & frame, NCMethodCallExpr*node){
    visit(node->scope, frame);
    
    auto parametersExpr = node->args;
    
    vector<shared_ptr<NCStackElement>> arguments;
    
    for (int i = 0; i<parametersExpr.size(); i++) {
        auto argExp = node->args[i];
        visit(argExp, frame);
        
//        auto val = frame.stack.back();
//        arguments.push_back(shared_ptr<NCStackElement>(val));
//        frame.stack.pop_back();
        auto val = frame.stack_popRealValue();
        arguments.push_back(val);
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
//    auto pPointer = scope.get()->getNakedPointer();
//
//    if (dynamic_cast<NCObject*>(pPointer)) {
//        auto classInst = dynamic_cast<NCObject*>(pPointer);
//
//        return classInst->invokeMethod(node->name, arguments, frame.stack);
//    }
    
    if (frame.stack_empty()) {
        return false;
    }
    
    auto rScope = frame.stack_pop();
    bool res = rScope->invokeMethod(node->name, arguments, frame.stack);
    
    return res;
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
    
    if (frame.stack.size() <= 0) {
        return 0;
    }
    
    do{
        auto pStackTop = (frame.stack.back()).get();
        
        if (!pStackTop) {
            break;
        }
        
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
        
        auto arrayAccessorElement = dynamic_cast<NCAccessor*>(pStackTop);
        
        if(arrayAccessorElement){
            ret = arrayAccessorElement->toInt();
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
    
    if(frame.stack.size() == 0){return "NULL";}
    
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
        
        auto arrayAccessorElement = dynamic_cast<NCAccessor*>(pStackTop);
        if(arrayAccessorElement){
            ret = arrayAccessorElement->toString();
            break;
        }
        
        ret = pStackTop->toString();
    }while (0);
    
    frame.stack.pop_back();
    return ret;
}

shared_ptr<NCStackPointerElement>  NCInterpreter::stackPopObjectPointer(NCFrame & frame){
    auto pStackTop = frame.stack.back();
    
    //fix smart pointer released
    if (dynamic_pointer_cast<NCStackPointerElement>(pStackTop)) {
        
        auto pRet = dynamic_pointer_cast<NCStackPointerElement> (frame.stack.back());
        frame.stack.pop_back();
        
        return pRet;
    }
    else if (dynamic_pointer_cast<NCStackVariableElement>(pStackTop)) {
        auto pVar = dynamic_pointer_cast<NCStackVariableElement>(pStackTop);
        while (1) {
            if (dynamic_pointer_cast<NCStackPointerElement>(pVar->valueElement)) {
                auto pRet = dynamic_pointer_cast<NCStackPointerElement> (pVar->valueElement);
                
                frame.stack.pop_back();
                
                return pRet;
            }
            else {
                pVar = dynamic_pointer_cast<NCStackVariableElement>(pVar->valueElement);
            }
        }
        
    }
    else if (dynamic_pointer_cast<NCAccessor>(pStackTop)) {
        auto pAccessor = dynamic_pointer_cast<NCAccessor>(pStackTop);
        auto value = pAccessor->value();
        if (dynamic_pointer_cast<NCStackVariableElement>(value)) {
            auto pVar = dynamic_pointer_cast<NCStackVariableElement>(value);
            if (dynamic_pointer_cast<NCStackPointerElement>(pVar->valueElement)) {
                auto pRet = dynamic_pointer_cast<NCStackPointerElement> (pVar->valueElement);
                frame.stack.pop_back();
                return pRet;
            }
        }
        else if (dynamic_pointer_cast<NCStackPointerElement>(value)) {
            auto pRet = dynamic_pointer_cast<NCStackPointerElement> (value);
            frame.stack.pop_back();
            return pRet;
        }
    }
    
    return shared_ptr<NCStackPointerElement> (nullptr);
}
