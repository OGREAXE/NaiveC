//
//  NCTokenizer.cpp
//  MiniC
//
//  Created by 梁志远 on 15/08/2017.
//  Copyright © 2017 Ogreaxe. All rights reserved.
//

#include "NCTokenizer.hpp"

void addToken(shared_ptr<vector<NCToken>> &tokens,string token, int i){
    NCToken aToken;
    aToken.token = token;
    aToken.start = i -token.length();
    aToken.length = token.length();
    
    tokens->push_back(aToken);
}

NCTokenizer::NCTokenizer(string&str){
    status = Unknown;
    tokens = shared_ptr<vector<NCToken>>(new vector<NCToken>());
    tokenize(str);
}

#define IS_STATUS_COMMENT (status == Comment || status == CommentWrap)

bool NCTokenizer::tokenize(const string&str){
    
    tokens->clear();
    token = "";
    
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
        if (c=='\n') {
            if (status == Comment) {
                status = Unknown;
                continue;
            } else if (status == CommentWrap) {
                continue;
            } else {
                if (token.length() > 0){
                    addToken(tokens, token, i);
                }
                status = Unknown;
                token = "";
            }
        }
        else if (c == 0x5c){ // is '\'
            if (IS_STATUS_COMMENT) {
                if (token.length() > 0){
                    addToken(tokens, token, i);
                }
            }
        }
        else if(c=='*' && i+1 <str.size() && str[i+1]=='/' && status == CommentWrap){
            i++;
            status = Unknown;
        }
        else if(IS_STATUS_COMMENT){
            continue;
        }
        else if(c=='/' && i+1 <str.size() && str[i+1]=='/' && status != String){
            if (token.length() > 0){
                addToken(tokens, token, i);
            }
            status = Comment;
            token = "";
        }
        else if(c=='/' && i+1 <str.size() && str[i+1]=='*' && status != String){
            if (token.length() > 0){
                addToken(tokens, token, i);
            }
            status = CommentWrap;
            token = "";
        }
        else if (c == ','  && status != String) {
            if (token.length() > 0){
//                tokens.push_back(token);
                addToken(tokens, token, i);
            }
//            tokens.push_back(",");
            addToken(tokens, ",", i);
            token = "";
            status = Unknown;
        }
        else if (c == ';'  && status != String) {
            if (token.length() > 0){
                addToken(tokens, token, i);
            }
            token = "";
            status = Unknown;
        }
        else if (status == String && c != '"') {
            token += c;
        }
        else if (c == ' ') {
            if (token.length() > 0){
//                tokens.push_back(token);
                addToken(tokens, token, i);
            }
            token = "";
            status = Unknown;
        }
        else if (isCharForIdentifier(c)) {
            if (status == Number) {
                //for 0x123abc
                token += c;
            }
            else if (status != Identifier && token.length() > 0) {
//                tokens.push_back(token);
                addToken(tokens, token, i);
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
//                    tokens.push_back(token);
                    addToken(tokens, token, i);
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
//                    tokens.push_back(token);
                    addToken(tokens, token, i);
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
                else if (token == "+" && c == '+') {
                    token += "+";
                    status = Unknown;
                }
                else if (token == "-" && c == '-') {
                    token += "-";
                    status = Unknown;
                } else /*if (token == "*" && c == '>')*/ {
                    //something like <abc *>
                    addToken(tokens, token, i);
                    
                    string sc = "";
                    sc += c;
                    addToken(tokens, sc, i);
                    token = "";
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
//                tokens.push_back(token);
                addToken(tokens, token, i);
            }
            token = c;
            status = Parenthesis;
        }
        else if(c == '"'){
            if (i > 0 && str[i-1] == 0x5c) { // is \ , " is part of the string
                token += c;
            }
            else if (status != String){
                if(token.length() > 0) {
//                    tokens.push_back(token);
                    addToken(tokens, token, i);
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
//                tokens.push_back(token);
                if (token.length()>0) {
                    addToken(tokens, token, i);
                }
                token = ".";
                status = Unknown;
            }
        }
        else if(c == ':'){
            if (token.length()>0) {
                addToken(tokens, token, i);
            }
            token = ":";
            status = Unknown;
        }
        else if(c == '^'){
            if (token.length()>0) {
                addToken(tokens, token, i);
            }
            token = "^";
            status = Unknown;
        }
        else if(c == '@'){
            if (token.length()>0) {
                addToken(tokens, token, i);
            }
            token = "@";
            status = Unknown;
        }
        else if (c == '\'') {
            if (token.length()>0) {
                addToken(tokens, token, i);
            }
            
            if (i + 1 < str.size()) {
                int charNum = str[i+1];
                token = std::to_string(charNum);
                addToken(tokens, token, i);
                token = "";
                i += 2;
            }
            
            status = Unknown;
        }
        else if(c == '\xe2'){
            //work arouond for strange double - input in iOS
            addToken(tokens, "--", i);
            status = Unknown;
        }
        
        if (i == str.length()-1) {
            if (token.length() > 0) {
                addToken(tokens, token, i);
            }
#define NC_EOF ""
            addToken(tokens, NC_EOF, i);
        }
    }
    
    status = Unknown;
    
    preprocessTokens();
    
    return true;
}

shared_ptr<const vector<NCToken>> NCTokenizer::getTokens(){
    return tokens;
}

#define WEAKIFY "XM_WS"
#define STRONGIFY "XM_SS"

void NCTokenizer::preprocessTokens() {
    auto processed = shared_ptr<vector<NCToken>>(new vector<NCToken>());
    
    int index = 0;
    
    while (index < tokens->size()) {
        auto t = (*tokens)[index];
        
        if (t.token == WEAKIFY) {
            addToken(processed, "__weak", 0);
            
            addToken(processed, "typeof(self)", 0);
            
            auto ws = (*tokens)[index + 2];
            
            addToken(processed, ws.token, 0);
            
            addToken(processed, "=", 0);
            
            addToken(processed, "self", 0);
            
            index += 4;
        } else if (t.token == STRONGIFY) {
            addToken(processed, "__strong", 0);
            
            addToken(processed, "typeof(self)", 0);
            
            auto ss = (*tokens)[index + 2];
            
            addToken(processed, ss.token, 0);
            
            addToken(processed, "=", 0);
            
            auto ws = (*tokens)[index + 4];
            
            addToken(processed, ws.token, 0);
            
            index += 6;
        } else {
            addToken(processed, t.token, 0);
            index ++;
        }
    }
    
    tokens = processed;
}

bool NCTokenizer::isCharForIdentifier(char c) {
    return  (c >= 'a' && c <= 'z') || (c >= 'A' && c <= 'Z')||c=='_';
}

bool NCTokenizer::isNumber(char c) {
    return  c >= '0' && c <= '9';
}

bool NCTokenizer::isOperator(char c) {
    return c == '*' || c == '/' || c == '+' || c == '-' || c == '='
    ||c == '>' || c == '<'|| c == '&'|| c == '|'|| c == '!'|| c == '?'||c == '%' ;
}

bool NCTokenizer::isParenthesis(char c) {
    return c == '(' || c == ')'||c == '{' || c == '}'||c == '[' || c == ']';
}

//bool MCTokenizer::isTargetChar(char c) {
//    return isNumber(c)||
//           isOperator(c)||
//    isParenthesis(c);
//}
