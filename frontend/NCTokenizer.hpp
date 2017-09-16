//
//  NCTokenizer.hpp
//  MiniC
//
//  Created by 梁志远 on 15/08/2017.
//  Copyright © 2017 Ogreaxe. All rights reserved.
//

#ifndef NCTokenizer_hpp
#define NCTokenizer_hpp

#include <stdio.h>
#include <string>
#include <vector>

using namespace std;

typedef enum TokenizerStatus {
    Unknown = 0,
    Identifier,
    Number,
    String,
    Operator,
    Comma,
    Parenthesis,  // ()
    SquareBracket,    //   []
    Brace,     // {}
} TokenizerStatus;

class NCTokenizer{
private:
    vector<string> tokens;
    string token;
    TokenizerStatus status;
public:
    NCTokenizer(string&str);
    const vector<string> & getTokens();
protected:
    bool tokenize(string&str);
    
    bool isCharForIdentifier(char c);
    bool isNumber(char c);
    bool isOperator(char c);
    bool isParenthesis(char c);
//    bool isTargetChar(char c);
};

#endif /* NCTokenizer_hpp */
