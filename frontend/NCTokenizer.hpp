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
    Comment
} TokenizerStatus;

struct NCToken{
    string token;
    int start;
    int length;
};

class NCTokenizer{
private:
//    vector<string> tokens;
    shared_ptr<vector<NCToken>> tokens;
    string token;
    TokenizerStatus status;
public:
    NCTokenizer():status(Unknown){tokens = shared_ptr<vector<NCToken>>(new vector<NCToken>());};
    NCTokenizer(string&str);
    bool tokenize(string&str);
    shared_ptr<const vector<NCToken>> getTokens();
//    const vector<NCToken> & getTokens();
protected:
    
    bool isCharForIdentifier(char c);
    bool isNumber(char c);
    bool isOperator(char c);
    bool isParenthesis(char c);
//    bool isTargetChar(char c);
};

#endif /* NCTokenizer_hpp */
