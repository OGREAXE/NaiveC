//
//  nv_operator.hpp
//  NaiveC
//
//  Created by liangzhiyuan on 2021/12/15.
//  Copyright © 2021 Ogreaxe. All rights reserved.
//

#ifndef nv_operator_hpp
#define nv_operator_hpp

#include <stdio.h>
#include <string>

using namespace std;

template <class T>
T doOperatorPrimitive(T left, T right, const string &op){
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
int doOperatorPrimitive(int left, int right, const string &op){
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
int doRelationalOperator(T left, T right, const string &op){
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

#endif /* nv_operator_hpp */
