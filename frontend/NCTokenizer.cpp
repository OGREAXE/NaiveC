//
//  NCTokenizer.cpp
//  MiniC
//
//  Created by 梁志远 on 15/08/2017.
//  Copyright © 2017 Ogreaxe. All rights reserved.
//

#include "NCTokenizer.hpp"


NCTokenizer::NCTokenizer(string&str){
    status = Unknown;
    
    tokenize(str);
}

bool NCTokenizer::tokenize(string&str){
    
    for (int i=0; i<str.size(); i++) {
        char c = str[i];
        
//        if (c == '\n' ||c == ' ') {
//            if (token.length() > 0){
//                tokens.push_back(token);
//            }
//            token = "";
//            status = Unknown;
//            if (c=='\n') {
//                tokens.push_back("\n");
//            }
//        }
//        else
        if (c == ',' && status != String) {
            if (token.length() > 0){
                tokens.push_back(token);
            }
            tokens.push_back(",");
            token = "";
            status = Unknown;
        }
        else if (status == String && c != '"') {
            token += c;
        }
        else if (c == ' ') {
            if (token.length() > 0){
                tokens.push_back(token);
            }
            token = "";
            status = Unknown;
        }
        else if (isCharForIdentifier(c)) {
            if (status != Identifier && token.length() > 0) {
                tokens.push_back(token);
                token = c;
            }
            else{
                token += c;
            }
            status = Identifier;
        }
        else if(isNumber(c)){
            if (status==Identifier && token.length() > 0) {
                token += c;
            }
            else {
                if (status!=Number && token.length() > 0) {
                    tokens.push_back(token);
                    token = c;
                }
                else {
                    token += c;
                }
                status = Number;
            }
        }
        else if(isOperator(c)){
            if (status != Operator ) {
                if (token.length() > 0) {
                    tokens.push_back(token);
                }
                token = c;
                status = Operator;
            }
            else if (token == "="){
                token = "==";
                status = Unknown;
            }
            else if ((token =="<" || token == ">") && c == '='){
                token += "=";
                status = Unknown;
            }
            else if (token =="&" && c =='&'){
                token += "&";
                status = Unknown;
            }
            else if (token =="|"&& c =='|'){
                token += "|";
                status = Unknown;
            }
            else if (token =="+"|token =="-"|token =="*"|token =="/"){
                if (c == '=') {
                    token += "=";
                    status = Unknown;
                }
                else if (c == '+') {
                    token += "+";
                    status = Unknown;
                }
            }
            else if (token =="!"){
                if (c == '=') {
                    token += "=";
                    status = Unknown;
                }
            }
            else {
                printf("operator not matched\n");
                return false;
            }
        }
        else if(isParenthesis(c)){
            if (token.length() > 0) {
                tokens.push_back(token);
            }
            token = c;
            status = Parenthesis;
        }
        else if(c == '"'){
            if (status != String){
                if(token.length() > 0) {
                    tokens.push_back(token);
                }
                token = c;
                status = String;
            }
            else {
                token += c;
                status = Unknown;
            }
        }
        else if(c == '.'){
            if (status == Number){
                if (token.length()>0) {
                    if (token.back() != '.') {
                        token += c;
                    }
                    else {
                        return false;
                    }
                }
            }
            else {
                tokens.push_back(token);
                token = ".";
                status = Unknown;
            }
        }
        
        if (i == str.length()-1) {
            tokens.push_back(token);
            tokens.push_back(" ");
        }
    }
    
    return true;
}

const vector<string> & NCTokenizer::getTokens(){
    return tokens;
}

bool NCTokenizer::isCharForIdentifier(char c) {
    return  (c >= 'a' && c <= 'z') || (c >= 'A' && c <= 'Z');
}

bool NCTokenizer::isNumber(char c) {
    return  c >= '0' && c <= '9';
}

bool NCTokenizer::isOperator(char c) {
    return c == '*' || c == '/' || c == '+' || c == '-' || c == '='
    ||c == '>' || c == '<'|| c == '&'|| c == '|'|| c == '!' ;
}

bool NCTokenizer::isParenthesis(char c) {
    return c == '(' || c == ')'||c == '{' || c == '}'||c == '[' || c == ']';
}

//bool MCTokenizer::isTargetChar(char c) {
//    return isNumber(c)||
//           isOperator(c)||
//    isParenthesis(c);
//}
