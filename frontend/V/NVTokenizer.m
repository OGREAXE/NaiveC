//
//  NVTokenizer.m
//  NaiveC
//
//  Created by liangzhiyuan on 2021/11/17.
//  Copyright © 2021 Ogreaxe. All rights reserved.
//

#import "NVTokenizer.h"

//#define SE "\n"

#define STR_ADD_CHAR(str, c) [str stringByAppendingFormat:@"%c", c]

#define STR_FROM_CHAR(c) STR_ADD_CHAR(@"", c)

#define STR_APPEND(str, s) [str stringByAppendingFormat:@"%@", s]

@implementation NVToken

@end

@implementation NVTokenizer

void addToken(NSMutableArray <NVToken*> *tokens, NSString *token, int i){
    NVToken *aToken = [[NVToken alloc] init];
    aToken.token = token;
    aToken.start = i - token.length;
    aToken.length = token.length;
    
    [tokens addObject:aToken];
}

bool isCharForIdentifier(char c) {
    return  (c >= 'a' && c <= 'z') || (c >= 'A' && c <= 'Z')||c=='_';
}

bool isNumber(char c) {
    return  c >= '0' && c <= '9';
}

bool isOperator(char c) {
    return c == '*' || c == '/' || c == '+' || c == '-' || c == '='
    ||c == '>' || c == '<'|| c == '&'|| c == '|'|| c == '!' ;
}

bool isParenthesis(char c) {
    return c == '(' || c == ')'||c == '{' || c == '}'||c == '[' || c == ']';
}

- (id)initWithString:(NSString *)str {
    self.status = TokenUnknown;
    self.tokens = [NSMutableArray array];
    
    [self tokenize:str];
    
    return self;
}

- (BOOL)tokenize:(NSString *)str{
    [self.tokens removeAllObjects];
    self.token = @"";
    
    for (int i=0; i<str.length; i++) {
        char c = [str characterAtIndex:i];
        
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
        if (c == '\n') {
            if (self.status == TokenComment) {
                self.status = TokenUnknown;
                continue;
            } else {
                if (self.token.length > 0){
                    addToken(self.tokens, self.token, i);
                }
                self.status = TokenUnknown;
                self.token = @"";
            }
        } else if (c == 0x5c){ // is '\'
            if (self.status == TokenComment) {
                if (self.token.length > 0){
                    addToken(self.tokens, self.token, i);
                }
            }
        } else if (self.status == TokenComment){
            continue;
        } else if (c=='/' && i+1 <str.length
                   && [str characterAtIndex:i+1]=='/'
                   && self.status != TokenString) {
            if (self.token.length > 0) {
                addToken(self.tokens, self.token, i);
            }
            self.status = TokenComment;
            self.token = @"";
        }
        else if (c == ','  && self.status != TokenString) {
            if (self.token.length > 0) {
//                tokens.push_back(token);
                addToken(self.tokens, self.token, i);
            }
//            tokens.push_back(",");
            addToken(self.tokens, @",", i);
            self.token = @"";
            self.status = TokenUnknown;
        } else if (c == ';'  && self.status != TokenString) {
            if (self.token.length > 0) {
                addToken(self.tokens, self.token, i);
            }
            self.token = @"";
            self.status = TokenUnknown;
        } else if (self.status == TokenString && c != '"') {
//            self.token += c;
            self.token = STR_ADD_CHAR(self.token, c);
        } else if (c == ' ') {
            if (self.token.length > 0) {
//                tokens.push_back(token);
                addToken(self.tokens, self.token, i);
            }
            self.token = @"";
            self.status = TokenUnknown;
        } else if (isCharForIdentifier(c)) {
            if (self.status != TokenIdentifier && self.token.length > 0) {
//                tokens.push_back(token);
                addToken(self.tokens, self.token, i);
//                self.token = c;
                self.token = STR_FROM_CHAR(c);
            } else{
//                self.token += c;
                self.token = STR_ADD_CHAR(self.token, c);
            }
            self.status = TokenIdentifier;
        } else if(isNumber(c)) {
            if (self.status == TokenIdentifier && self.token.length > 0) {
//                self.token += c;
                self.token = STR_ADD_CHAR(self.token, c);
            } else {
                if (self.status != TokenNumber && self.token.length > 0) {
//                    tokens.push_back(token);
                    addToken(self.tokens, self.token, i);
                    self.token =  STR_FROM_CHAR(c);
                } else {
                    self.token = [self.token stringByAppendingFormat:@"%c", c];
                }
                self.status = TokenNumber;
            }
        } else if(isOperator(c)) {
            if (self.status != TokenOperator ) {
                if (self.token.length > 0) {
//                    tokens.push_back(token);
                    addToken(self.tokens, self.token, i);
                }
                self.token = STR_FROM_CHAR(c);
                self.status = TokenOperator;
            } else if ([self.token isEqualToString: @"="]){
                self.token = @"==";
                self.status = TokenUnknown;
            } else if (([self.token isEqualToString:@"<"] || [self.token isEqualToString:@">"]) && c == '='){
//                self.token += "=";
                self.token = STR_APPEND(self.token, @"=");
                self.status = TokenUnknown;
            } else if ([self.token isEqualToString:@"&"] && c =='&'){
//                self.token += "&";
                self.token = STR_APPEND(self.token, @"&");
                self.status = TokenUnknown;
            } else if ([self.token isEqualToString:@"|"] && c =='|'){
//                self.token += "|";
                self.token = STR_APPEND(self.token, @"|");
                self.status = TokenUnknown;
            } else if ([self.token isEqualToString:@"+"]
                       | [self.token isEqualToString:@"-"]
                       | [self.token isEqualToString:@"*"]
                       | [self.token isEqualToString:@"/"]){
                if (c == '=') {
//                    self.token += "=";
                    self.token = STR_APPEND(self.token, @"=");
                    self.status = TokenUnknown;
                } else if (c == '+') {
//                    self.token += "+";
                    self.token = STR_APPEND(self.token, @"+");
                    self.status = TokenUnknown;
                }
            } else if ([self.token isEqualToString:@"!"]){
                if (c == '=') {
//                    self.token += "=";
                    self.token = STR_APPEND(self.token, @"=");
                    self.status = TokenUnknown;
                }
            } else {
                printf("operator not matched\n");
                return false;
            }
        } else if(isParenthesis(c)){
            if (self.token.length > 0) {
//                tokens.push_back(token);
                addToken(self.tokens, self.token, i);
            }
            self.token = STR_FROM_CHAR(c);
            self.status = TokenParenthesis;
        } else if(c == '"'){
            if (i > 0 && [str characterAtIndex:i-1] == 0x5c) { // is \ , " is part of the string
//                self.token += c;
                self.token = STR_ADD_CHAR(self.token, c);
            } else if (self.status != TokenString) {
                if(self.token.length > 0) {
//                    tokens.push_back(token);
                    addToken(self.tokens, self.token, i);
                }
                self.token = STR_FROM_CHAR(c);
                self.status = TokenString;
            } else {
//                self.token += c;
                self.token = STR_ADD_CHAR(self.token, c);
                self.status = TokenUnknown;
            }
        } else if(c == '.') {
            if (self.status == TokenNumber){
                if (self.token.length>0) {
//                    if (self.token.back() != '.') {
                    if ([self.token characterAtIndex:self.token.length - 1] != '.') {
//                        self.token += c;
                        self.token = STR_ADD_CHAR(self.token, c);
                    }
                    else {
                        return false;
                    }
                }
            } else {
//                tokens.push_back(token);
                if (self.token.length>0) {
                    addToken(self.tokens, self.token, i);
                }
                self.token = @".";
                self.status = TokenUnknown;
            }
        } else if(c == ':') {
            if (self.token.length>0) {
                addToken(self.tokens, self.token, i);
            }
            self.token = @":";
            self.status = TokenUnknown;
        } else if(c == '^') {
            if (self.token.length>0) {
                addToken(self.tokens, self.token, i);
            }
            self.token = @"^";
            self.status = TokenUnknown;
        }
        
        if (i == str.length - 1) {
            if (self.token.length > 0) {
                addToken(self.tokens, self.token, i);
            }
#define NC_EOF @""
            addToken(self.tokens, NC_EOF, i);
        }
    }
    
    return true;
}

//shared_ptr<const vector<NCToken>> NCTokenizer::getTokens(){
//    return tokens;
//}

@end
