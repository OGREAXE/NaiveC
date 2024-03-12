
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
#include "NCNSArrayWrapper.hpp"
#include "NCNSDictionaryWrapper.hpp"

void NCFrame::insertVariable(string&name, NCInt value){
    localVariableMap[name] = shared_ptr<NCStackElement>(new NCStackIntElement(value));
}

void NCFrame::insertVariable(string&name, NCFloat value){
    localVariableMap[name] = shared_ptr<NCStackElement>(new NCStackFloatElement(value));
}

void NCFrame::insertVariable(string&name, NCInt value, const string &opcode) {
    NCInt newValue = localVariableMap[name]->toInt();
    
    if (opcode == "+=") {
        newValue += value;
    } else if (opcode == "-=") {
        newValue -= value;
    } else if (opcode == "*=") {
        newValue *= value;
    } else if (opcode == "/=") {
        newValue /= value;
    }
    
    localVariableMap[name] = shared_ptr<NCStackElement>(new NCStackIntElement(newValue));
}

void NCFrame::insertVariable(string&name, NCFloat value, const string &opcode) {
    NCFloat newValue = localVariableMap[name]->toFloat();
    
    if (opcode == "+=") {
        newValue += value;
    } else if (opcode == "-=") {
        newValue -= value;
    } else if (opcode == "*=") {
        newValue *= value;
    } else if (opcode == "/=") {
        newValue /= value;
    }
    
    localVariableMap[name] = shared_ptr<NCStackElement>(new NCStackFloatElement(newValue));
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

bool NCInterpreter::invoke(string function, vector<shared_ptr<NCStackElement>> &arguments,vector<shared_ptr<NCStackElement>> & lastStack) {
    vector<string> v;
    return invoke(function, v, arguments, lastStack);
}

bool NCInterpreter::invoke(string function, vector<string> &argumentNames, vector<shared_ptr<NCStackElement>> &arguments,vector<shared_ptr<NCStackElement>> & lastStack)
 {
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
        
        auto name = argumentNames.size()?argumentNames[i]:funcDef->parameters[i].name;
        frame->localVariableMap.insert(make_pair(name, var));
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
                NCInt value = stackPopInt(frame);
                frame.insertVariable(name, value);
            }
            else if (type == "float") {
                NCFloat value = stackPopFloat(frame);
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
                if (!frame.stack.size()) return false;
                
                auto back =  frame.stack.back();
                
                if (dynamic_cast<NCStackVariableElement *>(back.get())) {
                    auto pointerElement = stackPopObjectPointer(frame);
                    frame.insertVariable(name, pointerElement);
                } else {
                    auto top = frame.stack_pop();
                    frame.insertVariable(name, top);
                }
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
    else if (dynamic_pointer_cast<NCObjcSelectorExpr>(currentNode)) {
        auto node = dynamic_pointer_cast<NCObjcSelectorExpr>(currentNode);
        
        auto box = NCCocoaBox::selectorFromString(node->selectorString);
        
        frame.stack_push(shared_ptr<NCStackElement>(new NCStackPointerElement(box)));
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
        frame.stack_push(shared_ptr<NCStackElement>(accesor));
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
    else if(dynamic_cast<NCConditionalExpression*>(currentNode.get())){
        auto node = dynamic_cast<NCConditionalExpression*>(currentNode.get());
        
        visit(node->condition, frame);
        
        auto conditionalResult = frame.stack_pop();
        if (!conditionalResult) {
            NCLog(NCLogTypeInterpretor, "conditional expression result null");
            return false;
        }
        
        if (conditionalResult->toInt()) {
            //true
            if (node->expressionIfTrue) {
                visit(node->expressionIfTrue, frame);
                
                auto resultOfTrue = frame.stack_pop();
                if (!resultOfTrue) {
                    NCLog(NCLogTypeInterpretor, "conditional expression result if true null");
                    return false;
                }
                
                frame.stack.push_back(resultOfTrue);
                
            } else {
                frame.stack.push_back(conditionalResult);
            }
        } else {
            visit(node->expressionIfFalse, frame);
            
            auto resultOfFalse = frame.stack_pop();
            if (!resultOfFalse) {
                NCLog(NCLogTypeInterpretor, "conditional expression result if false null");
                return false;
            }
            
            frame.stack.push_back(resultOfFalse);
        }
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
                frame.insertVariable(var->name, stackPopInt(frame), node->op);
            }
            else if (var->valueElement->type == "float") {
                frame.insertVariable(var->name, stackPopFloat(frame), node->op);
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
        else if (dynamic_pointer_cast<NCAccessor>(stackTop)) {
            auto accessor = dynamic_pointer_cast<NCAccessor>(stackTop);
            visit(node->value,frame);
            auto value = frame.stack_popRealValue();
            if (dynamic_pointer_cast<NCAccessor>(value)) {
                auto accessorValue = dynamic_pointer_cast<NCAccessor>(value);
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
                
                shared_ptr<NCStackElement> stackVal = nullptr;
                
                if (dynamic_pointer_cast<NCAccessor>(value)) {
                    auto accessor = dynamic_pointer_cast<NCAccessor>(value);
                    stackVal = accessor->value();
//                    frame.insertVariable(nameExpr->name, accessor->value());
                } else {
                    if (dynamic_pointer_cast<NCObject>(value)) {
                        auto object = dynamic_pointer_cast<NCObject>(value);
                        auto pointer = shared_ptr<NCStackPointerElement>(new NCStackPointerElement(object));
                        stackVal = pointer;
//                        frame.insertVariable(nameExpr->name, pointer);
                    }
                    else {
                        stackVal = value;
//                        frame.insertVariable(nameExpr->name, value);
                    }
                }
                
                if (stackVal) {
                    if (frame.localVariableMap.find("self") != frame.localVariableMap.end() && nameExpr->name[0] == '_') {
                        //objective c set ivar
                        frame.localVariableMap["self"]->setAttribute(nameExpr->name, stackVal);
                    } else {
                        frame.insertVariable(nameExpr->name, stackVal);
                    }
                }
            }
        }
        
    }
    else if(dynamic_cast<NCArrayAccessExpr*>(currentNode.get())){
        auto node = dynamic_cast<NCArrayAccessExpr*>(currentNode.get());
        
        visit(node->scope, frame);
        visit(node->expression, frame);
        
//        int index = stackPopInt(frame);
        auto argument = frame.stack.back();
        frame.stack.pop_back();
        
        auto pointer = stackPopObjectPointer(frame);
        if (pointer == NULL) {
            throw NCRuntimeException(0, "accessing null array");
        }
        auto obj = pointer->getPointedObject();
        if (dynamic_pointer_cast<NCBracketAccessible>(obj) ) {
            auto accessible = dynamic_pointer_cast<NCBracketAccessible>(obj);
            auto accessor = new NCIndexedAccessor(accessible,argument);
            
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
    else if(dynamic_cast<NCObjcStringExpr*>(currentNode.get())){
        auto strExp = dynamic_cast<NCObjcStringExpr*>(currentNode.get());
        auto box = new NCCocoaBox(strExp->content);
        
        frame.stack_push(shared_ptr<NCStackPointerElement> (new NCStackPointerElement(shared_ptr<NCCocoaBox>(box))));
    }
    else if(dynamic_cast<NCObjcArrayInitializer*>(currentNode.get())){
        auto node = dynamic_cast<NCObjcArrayInitializer*>(currentNode.get());
        
        auto pArray = new NCNSArrayWrapper();
        
        auto arrInit = node->arrayInitializer;
        
        if (arrInit) {
            for (auto element : arrInit->elements) {
                visit(element, frame);
                
                auto value = frame.stack_popRealValue();
                
                pArray->addElement(value);
            }
            
            frame.stack_push(shared_ptr<NCStackPointerElement> ( new NCStackPointerElement( shared_ptr<NCObject>(pArray))));
        }
        else {
            NCLog(NCLogTypeInterpretor, "array init fail");
        }
        
    }
    else if(dynamic_cast<NCObjcDictionaryInitializer*>(currentNode.get())){
        auto node = dynamic_cast<NCObjcDictionaryInitializer*>(currentNode.get());
        
        auto pDict = new NCNSDictionaryWrapper();
        
        for (auto kv : node->keyValueList) {
            
            visit(kv.first, frame);
            auto keyResult = frame.stack_popRealValue();
            
            visit(kv.second, frame);
            auto valueResult = frame.stack_popRealValue();
            
            pDict->br_set(keyResult, valueResult);
        }
        
        frame.stack_push(shared_ptr<NCStackPointerElement> ( new NCStackPointerElement( shared_ptr<NCObject>(pDict))));
    }
    else if(dynamic_cast<NCObjcNumberExpr*>(currentNode.get())){
        auto node = dynamic_cast<NCObjcNumberExpr*>(currentNode.get());
        
        visit(node->expression, frame);
        
        auto value = frame.stack_popRealValue();
        
        NCCocoaBox *pBox = nullptr;
        
        do {
            auto fval = dynamic_cast<NCStackFloatElement *>(value.get());
            
            if (fval) {
                pBox = new NCCocoaBox(fval->value);
                break;
            }
            
            auto ival = dynamic_cast<NCStackIntElement *>(value.get());
            
            if (ival) {
                pBox = new NCCocoaBox(ival->value);
                break;
            }
            
        } while(0);
    
        if (pBox) {
            frame.stack_push(shared_ptr<NCStackPointerElement> (new NCStackPointerElement(shared_ptr<NCCocoaBox>(pBox))));
        }
    }
    else if(dynamic_cast<NCNameExpression*>(currentNode.get())){
        auto node = dynamic_cast<NCNameExpression*>(currentNode.get());
        
        if (node->name == "null" || node->name == "NULL" || node->name == "nil") {
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
                //objective c ivar
                if (node->name[0] == '_'){
                    auto selfInstance = frame.localVariableMap["self"];
                    auto ivar = selfInstance->getAttribute(node->name);
                    
                    if (ivar) {
                        frame.stack.push_back(shared_ptr<NCStackElement>(ivar));
                        return true;
                    }
                } else if (node->name == "super") {
                    auto superInstance = frame.localVariableMap["super"];
                    
                    if (superInstance == nullptr) {
                        auto selfInstance = frame.localVariableMap["self"];
                        
                        auto pCocoa = dynamic_pointer_cast<NCCocoaBox>(selfInstance->toObject());
                        
                        if (pCocoa) {
                            auto cocoaCopy = pCocoa->copy();
                            dynamic_cast<NCCocoaBox *>(cocoaCopy)->isSuper = true;
                            frame.localVariableMap["super"] = shared_ptr<NCStackPointerElement>(new NCStackPointerElement(cocoaCopy));
                            
                            superInstance = frame.localVariableMap["super"];
                        }
                    }
                    
                    if (superInstance) {
                        frame.stack.push_back(superInstance);
                        return true;
                    }
                } else {
                    auto globalObj = m_symStore->objectForName(node->name);
                    
                    if (globalObj) {
                        frame.stack.push_back(globalObj);
                        return true;
                    }
                }
                
                NCLogInterpretor("can't find variable %s", node->name.c_str());
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
                if (i>=parameters.size() && !funcDef->isVariableArguments) {
                    throw NCRuntimeException(0, "arguments exceed expected");
                }
                auto & parameter = parameters[i];

                auto argExp = node->args[i];
                visit(argExp, frame);
                
                if (frame.stack.size() == 0) {
                    throw NCRuntimeException(0, "get argument fail");
                }
                
                if (funcDef->isVariableArguments) {
                    auto value = frame.stack_pop();
                    arguments.push_back(value);
                }
                else if (parameter->type == "original") {
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
            
            if (cls) {
                vector<shared_ptr<NCStackElement>> arguments;
                
                if (!initArguments(node->args, arguments, frame)) {
                    return false;
                }
                
                auto aInstance = cls->instantiate(arguments);
                
                frame.stack.push_back(shared_ptr<NCStackElement> ( aInstance));
            } else {
                //block invoke?
                if (frame.localVariableMap.find(node->name) != frame.localVariableMap.end()) {
                    auto block = frame.localVariableMap[node->name];
                    
                    vector<shared_ptr<NCStackElement>> arguments;
                    
                    initArguments(node->args, arguments, frame);
                    
                    block->invokeMethod("invoke", arguments, frame.stack);
                }
                else {
                    //every candidate has been tried and fail. exit
                    throw NCRuntimeException(0, "class %s not found", node->name.c_str());
                }
            }
        }
    }
    return true;
}

bool NCInterpreter::initArguments(vector<shared_ptr<NCExpression>> &intput_argumentExpressions, vector<shared_ptr<NCStackElement>> & output_arguments, NCFrame&frame){
    for (int i = 0; i<intput_argumentExpressions.size(); i++) {
        auto argExp = intput_argumentExpressions[i];
        visit(argExp, frame);
        
        auto argValue = frame.stack_pop();
        
        if (!argValue) return false;
        
        output_arguments.push_back(argValue);
    }
    return true;
}

bool NCInterpreter::tree_doClassMehothodCall(NCFrame & frame, NCMethodCallExpr*node){
    visit(node->scope, frame);
    
    auto parametersExpr = node->args;
    
    vector<shared_ptr<NCStackElement>> arguments;
    
    vector<shared_ptr<NCStackElement>> formtArguments;
    
    for (int i = 0; i<parametersExpr.size(); i++) {
        auto argExp = node->args[i];
        visit(argExp, frame);

        auto val = frame.stack_popRealValue();
        arguments.push_back(val);
    }
    
    for (int i = 0; i < node->formatArgs.size(); i ++) {
        auto argExp = node->formatArgs[i];
        visit(argExp, frame);

        auto val = frame.stack_popRealValue();
        formtArguments.push_back(val);
    }
    
    if (frame.stack_empty()) {
        return false;
    }
    
    auto rScope = frame.stack_pop();
    bool res = rScope->invokeMethod(node->name, arguments, formtArguments, frame.stack);
    
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

NCInt NCInterpreter::stackPopInt(NCFrame & frame){
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
        
        break;
        
    }while (1);
    
    frame.stack.pop_back();
    return ret;
}

NCFloat NCInterpreter::stackPopFloat(NCFrame & frame){
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
    if (frame.stack.size() == 0) return nullptr;
    
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
