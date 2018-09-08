//
//  NCStackElement.cpp
//  NaiveC
//
//  Created by 梁志远 on 28/08/2017.
//  Copyright © 2017 Ogreaxe. All rights reserved.
//

#include "NCStackElement.hpp"

template <class T>
T doOperatorPrimitive(T left, T right, const string&op){
    if (op == "+") {
        return left + right;
    }
    else if (op == "-") {
        return left - right;
    }
    else if (op == "*") {
        return left * right;
    }
    else if (op == "/") {
        return left / right;
    }
    else {
        return left;
    }
}

template <>
NCInt doOperatorPrimitive(NCInt left, NCInt right, const string&op){
    if (op == "+") {
        return left + right;
    }
    else if (op == "-") {
        return left - right;
    }
    else if (op == "*") {
        return left * right;
    }
    else if (op == "/") {
        return left / right;
    }
    else if (op == "|") {
        return left | right;
    }
    else if (op == "&") {
        return left & right;
    }
    else {
        return left;
    }
}

template <class T>
NCInt doRelationalOperator(T left, T right, const string&op){
    if (op == "||") {
        return left || right;
    }
    else if (op == "&&") {
        return left && right;
    }
    if (op == ">") {
        return left > right;
    }
    else if (op == "<") {
        return left < right;
    }
    if (op == ">=") {
        return left >= right;
    }
    else if (op == "<=") {
        return left <= right;
    }
    else if (op == "!=") {
        return left != right;
    }
    else if (op == "==") {
        return left == right;
    }
    else {
        return left;
    }
}

shared_ptr<NCStackElement> NCStackElement::createStackElement(NCLiteral* literal){
    if (dynamic_cast<NCIntegerLiteral*>(literal)) {
        auto intLiteral = dynamic_cast<NCIntegerLiteral*>(literal);
        return shared_ptr<NCStackElement>(new NCStackIntElement(intLiteral->getValue()));
    }
    if (dynamic_cast<NCFloatLiteral*>(literal)) {
        auto fLiteral = dynamic_cast<NCFloatLiteral*>(literal);
        return shared_ptr<NCStackElement>(new NCStackFloatElement(fLiteral->getValue()));
    }
    if (dynamic_cast<NCStringLiteral*>(literal)) {
        auto intLiteral = dynamic_cast<NCStringLiteral*>(literal);
        string str = intLiteral->getValue();
        return shared_ptr<NCStackElement>(new NCStackStringElement(str));
    }
    return nullptr;
}

shared_ptr<NCStackElement> NCStackIntElement::doOperator(const string&op, shared_ptr<NCStackElement> rightOperand){
    if (op == "+"||op == "-"||op == "*"||op == "/"||op == "%"||op == "|"||op == "&") {
        NCInt result = doOperatorPrimitive(this->value, rightOperand->toInt(), op);
        return shared_ptr<NCStackElement>(new NCStackIntElement(result));
        
    }
    else if (op == "&&"||op == "||"||op == ">"||op == "<"||op == ">="||op == "<="||op == "!="||op == "==") {
        NCInt result = doRelationalOperator(this->value, rightOperand->toInt(),op);
        return shared_ptr<NCStackElement>(new NCStackIntElement(result));
    }
    return nullptr;
}

shared_ptr<NCStackElement> NCStackFloatElement::doOperator(const string&op, shared_ptr<NCStackElement> rightOperand){
    if (op == "+"||op == "-"||op == "*"||op == "/"||op == "%") {
        NCInt result = doOperatorPrimitive(this->value, rightOperand->toFloat(), op);
        return shared_ptr<NCStackElement>(new NCStackIntElement(result));
        
    }
    else if (op == "&&"||op == "||"||op == ">"||op == "<"||op == ">="||op == "<="||op == "!="||op == "==") {
        NCInt result = doRelationalOperator(this->value, rightOperand->toFloat(),op);
        return shared_ptr<NCStackElement>(new NCStackIntElement(result));
    }
    return nullptr;
}

shared_ptr<NCStackElement> NCStackStringElement::doOperator(const string&op, shared_ptr<NCStackElement> rightOperand){
    if (op == "+") {
        string ret = this->value + rightOperand->toString();
        return shared_ptr<NCStackElement>(new NCStackStringElement(ret));
        
    }
    else if (op == "==") {
        bool equal = (this->value == rightOperand->toString());
        return shared_ptr<NCStackElement>(new NCStackIntElement((int)equal));
        
    }
    else if (op == "!=") {
        bool equal = (this->value == rightOperand->toString());
        return shared_ptr<NCStackElement>(new NCStackIntElement((int)!equal));
        
    }
    else if (op == "&&") {
        return shared_ptr<NCStackElement>(new NCStackIntElement(rightOperand->toInt()));
    }
    return shared_ptr<NCStackElement>(new NCStackIntElement(1));
}

NCInt NCStackIntElement::toInt(){
    return this->value;
}
NCFloat NCStackIntElement::toFloat(){
    return this->value;
}
string NCStackIntElement::toString(){
    return to_string(this->value);
}

NCInt NCStackFloatElement::toInt(){
    return this->value;
}
NCFloat NCStackFloatElement::toFloat(){
    return this->value;
}
string NCStackFloatElement::toString(){
    return to_string(this->value);
}

NCInt NCStackStringElement::toInt(){
    return stoi(this->value);
}
NCFloat NCStackStringElement::toFloat(){
    return stof(this->value);
}
string NCStackStringElement::toString(){
    return this->value;
}

bool NCStackStringElement::invokeMethod(string methodName, vector<shared_ptr<NCStackElement>> &arguments,vector<shared_ptr<NCStackElement>> & lastStack){
    if (methodName == "length") {
        lastStack.push_back(shared_ptr<NCStackElement>(new NCStackIntElement(value.size())));
    }
    else if (methodName == "charAt") {
        auto indx = arguments[0]->toInt();
        string res;
        res.push_back(value[indx]);
        lastStack.push_back(shared_ptr<NCStackElement>(new NCStackStringElement(res)));
    }
    else if (methodName == "subString") {
        if (arguments.size() == 1) {
            
        }
        else if (arguments.size() == 2) {
            auto start = arguments[0]->toInt();
            auto count = arguments[1]->toInt();
            string res = value.substr(start,count);
            lastStack.push_back(shared_ptr<NCStackElement>(new NCStackStringElement(res)));
        }
    }
    
    return true;
}
bool NCStackStringElement::invokeMethod(string methodName, vector<shared_ptr<NCStackElement>> &arguments){
    return true;
}

shared_ptr<NCStackElement> NCStackIntElement::copy(){
    return shared_ptr<NCStackElement>(new NCStackIntElement(this->value));
}

shared_ptr<NCStackElement> NCStackFloatElement::copy(){
    return shared_ptr<NCStackElement>(new NCStackFloatElement(this->value));
}

shared_ptr<NCStackElement> NCStackStringElement::copy(){
    return shared_ptr<NCStackElement>(new NCStackStringElement(this->value));
}

shared_ptr<NCStackElement> NCStackVariableElement::doOperator(const string&op, shared_ptr<NCStackElement> rightOperand){
    return valueElement->doOperator(op, rightOperand);
}
NCInt NCStackVariableElement::toInt(){
    return valueElement->toInt();
}
NCFloat NCStackVariableElement::toFloat(){
    return valueElement->toFloat();
}
string NCStackVariableElement::toString(){
    if(!valueElement){
        return "NULL";
    }
    return valueElement->toString();
}
shared_ptr<NCStackElement> NCStackVariableElement::copy(){
    auto aCopy = new NCStackVariableElement(this->name,this->valueElement);
    aCopy->isArray = this->isArray;
    return shared_ptr<NCStackElement>(aCopy);
}

bool NCStackVariableElement::invokeMethod(string methodName, vector<shared_ptr<NCStackElement>> &arguments,vector<shared_ptr<NCStackElement>> & lastStack){
    return this->valueElement->invokeMethod(methodName, arguments, lastStack);
}

/*NCFieldAccessor
 */
void NCFieldAccessor::set(shared_ptr<NCStackElement> value){
    this->scope->setAttribute(this->attributeName, value);
}

shared_ptr<NCStackElement> NCFieldAccessor::value(){
    return scope->getAttribute(this->attributeName);
}

string NCFieldAccessor::toString(){
    auto val = value();
    if (!val) {
        return "NULL";
    }
    return val->toString();
}

shared_ptr<NCStackElement> NCFieldAccessor::getAttribute(const string & attrName){
    auto val = value();
    if (!val) {
        return nullptr;
    }
    return val->getAttribute(attrName);
}

void NCFieldAccessor::setAttribute(const string & attrName, shared_ptr<NCStackElement> value){
    auto val = this->value();
    val->setAttribute(attrName, value);
}

shared_ptr<NCStackElement> NCFieldAccessor::doOperator(const string&op, shared_ptr<NCStackElement> rightOperand){
    return this->value()->doOperator(op, rightOperand);
}
