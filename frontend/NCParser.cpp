//
//  MCParser.cpp
//  MiniC
//
//  Created by 梁志远 on 15/08/2017.
//  Copyright © 2017 Ogreaxe. All rights reserved.
//

#include "NCParser.hpp"
#include <functional>
#include <sstream>
#include <unordered_set>


static unordered_set<string> keywords =
{
    //types
    "int","float","string","void",
    //operator
    "=","+=","-=","*=","/=","++",
    "+","-","*","/",
    "%",".","|","&","||","&&","!",
    //paren
    "{","}","(",")","[","]",
    //comma
    ",",
    //statement
    "if","else",
    "while","for",
    "break","continue",
    "return",
};

#define SE "\n"

#define MAKE_SMART_PTR(ret) ret

NCParser::NCParser(shared_ptr<const vector<NCToken>>& tokens):index(0){
    bool res = parse(tokens);
}
    
bool NCParser::parse(shared_ptr<const vector<NCToken>>& tokens){
    this->tokens = tokens;
    
    for (int i=0; i<tokens->size(); i++) {
        auto tok = (*tokens)[i];
        printf("%s  ",tok.token.c_str());
    }
    
    index = 0;
    word = (*tokens)[0].token;
    
    pRoot = shared_ptr<NCASTRoot>(new NCASTRoot());
    
    bool parseOK = false;
    do{
        parseOK = false;
        pushIndex();
        
        auto pFunc = function_definition();
        if (pFunc) {
            pRoot->functionList.push_back(pFunc);
            parseOK = true;
            continue;
        }
        
        popIndex();
        auto pClass = class_definition();
        if (pClass) {
            pRoot->classList.push_back(pClass);
            parseOK = true;
            continue;
        }

    }while (parseOK);
    
    printf("parse %lu classes\n", pRoot->classList.size());
    printf("parse %lu functions\n", pRoot->functionList.size());
    
    return true;
}

string NCParser::nextWord(){
     return (*tokens)[++index].token;
}

string NCParser::priviousWord(){
    return (*tokens)[--index].token;
}

void NCParser::pushIndex(){
    tempIndex = index;
}
void NCParser::popIndex(){
    index = tempIndex;
    word = (*tokens)[index].token;
}

MCParserReturnType NCParser::class_definition(){
    auto functionDecl = new NCClassDeclaration();
    
    if (word != "class") {
        return nullptr;
    }
    word = nextWord();
    
    if (!isIdentifier(word)) {
        return nullptr;
    }
    functionDecl->name = word;
    word = nextWord();
    
    if (word == ":") {
        word = nextWord();
        
        if (!isIdentifier(word)) {
            return nullptr;
        }
        functionDecl->parent = word;
        word = nextWord();
    }
    
    if (!class_body(functionDecl->members)) {
        return nullptr;
    }
    
    return shared_ptr<NCClassDeclaration>(functionDecl);
}

bool NCParser::class_body(vector<shared_ptr<NCBodyDeclaration>> & members){
    if (word != "{") {
        return false;
    }
    
    word = nextWord();
    while (word!="}") {
        auto member = class_body_declaration();
        if (!member) {
            return false;
        }
    }
    
    word = nextWord();
    return true;
}

shared_ptr<NCBodyDeclaration> NCParser::class_body_declaration(){
    pushIndex();
    auto funcDef = function_definition();
    if (funcDef) {
        auto methodDef = new NCMethodDeclaration();
        methodDef->method = funcDef;
        return shared_ptr<NCMethodDeclaration>(methodDef);
    }
    
    popIndex();
    auto fieldDecl = variable_declaration_expression();
    if (fieldDecl) {
        auto field = new NCFieldDeclaration();
        field->declarator = fieldDecl;
        return shared_ptr<NCFieldDeclaration>(field);
    }
    
    popIndex();
    return constructor_definition();
}

shared_ptr<NCConstructorDeclaration> NCParser::constructor_definition(){
    //todo
    return nullptr;
}


//function_definition-> type_specifier argumentlist compound_statement
AstNodePtr NCParser::function_definition(){
    
    auto function = new NCASTFunctionDefinition();
    
    function->return_type = type_specifier();
    if (function->return_type.length() == 0) {
        return (nullptr);
    }
    if (isIdentifier(word)) {
        function->name = word;
        word = nextWord();
    }
    else {
        return (nullptr);
    }
    
    if (word!="(") {
        return (nullptr);
    }
    else {
        word = nextWord();
    }
    
    if (word != ")") {
        vector<NCParameter> plist;
        if (!parameterlist(plist)) {
            return (nullptr);
        }
        function->parameters = plist;
        
        if (word!=")") {
            return (nullptr);
        }
    }
    word = nextWord();
    
//    vector<AstNodePtr> statements;
    auto block_ = block();
    if (!block_)  {
        return (nullptr);
    }
    
    function->block = block_;
    
    return shared_ptr<NCASTFunctionDefinition>(function);
}

bool NCParser::parameterlist(vector<NCParameter> & parameters){
    NCParameter * para = nullptr;
    if(!parameter(&para)){
        return false;
    }
    parameters.push_back(*para);
    while (word==",") {
        word = nextWord();
        NCParameter * para = nullptr;
        if(!parameter(&para)){
            return false;
        }
        parameters.push_back(*para);
    }
    return true;
}

bool NCParser::parameter(NCParameter ** ppp){
    string type = type_specifier();
    if (type.length() == 0) {
        return false;
    }
    if (!isIdentifier(word)) {
        return false;
    }
    
    NCParameter * pp = new NCParameter();
    pp->type = type;
    pp->name = word;
    
    word = nextWord();
    
    *ppp = pp;
    
    return true;
}

shared_ptr<NCBlock> NCParser::block(){
    
    vector<AstNodePtr> stmts;
    if (word == "{") {
        word = nextWord();
        if(!statements(stmts)){
            return nullptr;
        }
        if (word != "}") {
            return nullptr;
        }
        word = nextWord();
        
        auto block_ = new NCBlock();
        block_->statement_list = stmts;
        return shared_ptr<NCBlock>(block_);
    }
    return nullptr;
}

//bool NCParser::block_statement(vector<AstNodePtr>& stmts){
//    if (word == "{") {
//        word = nextWord();
//        if(!statements(stmts)){
//            return false;
//        }
//        if (word != "}") {
//            return false;
//        }
//        word = nextWord();
//        return true;
//    }
//    return false;
//}

bool NCParser::statements(vector<AstNodePtr>& statements){
    while (1) {
        pushIndex();
        auto statement = blockStatement();
        if (!statement) {
            popIndex();
            break;
        }
        statements.push_back(statement);
    }
    return true;
}

shared_ptr<NCStatement> NCParser::blockStatement(){
    pushIndex();
    auto varDecStmt = variable_declaration_expression();
    if (!varDecStmt) {
        popIndex();
        return statement();
    }
    
    auto statment = new NCBlockStatement();
    statment->expression = varDecStmt;
    
    return shared_ptr<NCBlockStatement> (statment);
}

shared_ptr<NCExpression> NCParser::variable_declaration_expression(){
    auto varExprStmt = shared_ptr<VariableDeclarationExpression>(new VariableDeclarationExpression());
    
    auto type = type_specifier();
    if (type.length() == 0) {
        return nullptr;
    }
    
    varExprStmt->type = type;
    
    auto declarator = variable_declarator();
    if (!declarator) {
        return nullptr;
    }
    
    while (declarator) {
        varExprStmt->variables.push_back(declarator);
        
        if (word == ",") {
            declarator = variable_declarator();
            if (!declarator) {
                return nullptr;
            }
        }
        else {
            break;
        }
    }
    
    return varExprStmt;
}

shared_ptr<NCExpression> NCParser::variable_declarator(){
    
    auto variableDeclarator = new VariableDeclarator();
    
    auto varDecId = variable_declarator_id();
    if (varDecId.first.length() == 0) {
        return nullptr;
    }
    variableDeclarator->id = varDecId;
    
    if (word!="=") {
        return shared_ptr<VariableDeclarator>(variableDeclarator);
    }
    word = nextWord();
    auto expr = variable_initializer();
    if (!expr) {
        return nullptr;
    }
    variableDeclarator->expression = expr;
    return  shared_ptr<VariableDeclarator>(variableDeclarator);
}

pair<string, vector<NCArrayBracketPair>> NCParser::variable_declarator_id(){
    // array [] currently ignored
    vector<NCArrayBracketPair> brackets;
    if (!isIdentifier(word)) {
        return make_pair("", brackets);
    }
    auto w = word;
    word = nextWord();
    return make_pair(w, brackets);
}

shared_ptr<NCExpression> NCParser::variable_initializer(){
    return expression();
}

shared_ptr<NCExpression> NCParser::expression(){
    return conditional_expression();
}

bool NCParser::expression_list(vector<shared_ptr<NCExpression>>& exprList){
    auto ret = expression();
    if (!ret) {
        return false;
    }
    
    exprList.push_back(ret);
    while (1) {
        if (word != ",") {
            return true;
        }
        word = nextWord();
        ret = expression();
        if (!ret) {
            return false;
        }
        exprList.push_back(ret);
    }
    
    return true;
}

shared_ptr<NCExpression> NCParser::multiplicative_expression(){
    return parseBinExpr({"*","/","%"}, std::bind(&NCParser::unary_expression, this));
}

shared_ptr<NCExpression> NCParser::additive_expression(){
    return parseBinExpr({"+","-"}, std::bind(&NCParser::multiplicative_expression, this));
}

shared_ptr<NCExpression> NCParser::shift_expression(){
    //shift not supported for now
    return additive_expression();
}

shared_ptr<NCExpression> NCParser::relational_expression(){
    return parseBinExpr({">","<",">=","<="}, std::bind(&NCParser::shift_expression, this));
}

shared_ptr<NCExpression> NCParser::equality_expression(){
    return parseBinExpr({"==","!="}, std::bind(&NCParser::relational_expression, this));
}

shared_ptr<NCExpression> NCParser::and_expression(){
    return parseBinExpr({"&"}, std::bind(&NCParser::equality_expression, this));
}

shared_ptr<NCExpression> NCParser::exclusive_or_expression(){
    return parseBinExpr({"^"}, std::bind(&NCParser::and_expression, this));
}

shared_ptr<NCExpression> NCParser::inclusive_or_expression(){
    return parseBinExpr({"|"}, std::bind(&NCParser::exclusive_or_expression, this));
}

shared_ptr<NCExpression> NCParser::logical_and_expression(){
    return parseBinExpr({"&&"}, std::bind(&NCParser::inclusive_or_expression, this));
}

shared_ptr<NCExpression> NCParser::logical_or_expression(){
    return parseBinExpr({"||"}, std::bind(&NCParser::logical_and_expression, this));
}

shared_ptr<NCExpression> NCParser::conditional_expression(){
    //currently not support A?B:C
    auto expr = logical_or_expression();
    if (!expr) {
        return nullptr;
    }
    
    if (isAssignOperator(word)) {
        string op = word;
        word = nextWord();
        auto value = expression();
        
        if (!value) {
            return nullptr;
        }
        
        auto assignmentExpr = new NCAssignExpr(expr,op, value);
        return shared_ptr<NCExpression>(assignmentExpr);
    }
    else {
        return expr;
    }
}

shared_ptr<NCExpression> NCParser::parseBinExpr(vector<string> operators, BinParserFunc nextParseFunc){
    auto left = nextParseFunc();
    if (!left) {
        return nullptr;
    }
    
    if (!vecInclude(operators, word)) {
        return left;
    }
    string op = word;
    
//    auto left = shared_ptr<NCBinaryExpression>(new NCBinaryExpression());
//    left->left = _left;
//    left->op = word;
    
    word = nextWord();
    
    pushIndex();
    auto right = nextParseFunc();
    if (!right) {
        popIndex();
        return left;
    }
    while (right) {
        left = addRight(left, right, op);
        
        if (!vecInclude(operators, word)) {
            break;
        }
        
        op = word;
        word = nextWord();
        
        pushIndex();
        right = nextParseFunc();
        if (!right) {
            popIndex();
        }
    }
    return left;
}

shared_ptr<NCExpression> NCParser::unary_expression(){
    if (word == "+" ||word == "-" ||word == "!"  ) {
        string op = word;
        word = nextWord();
        
        auto unaryExp = new NCUnaryExpression();
        auto exp = unary_expression();
        if (!exp) {
            return nullptr;
        }
        unaryExp->op = op;
        unaryExp->expression = exp;
        
        return shared_ptr<NCExpression>(unaryExp);
    }
    else {
        return primary_expression();
    }
}

shared_ptr<NCExpression> NCParser::primary_expression(){
    auto prefix = primary_prefix();
    if (!prefix) {
        return nullptr;
    }
    
    pushIndex();
    auto ret = primary_suffix(prefix);
    if (!ret) {
        popIndex();
        return prefix;
    }
    
    while (1) {
        pushIndex();
        auto tmpRet = ret;
        ret = primary_suffix(ret);
        
        if (!ret) {
            popIndex();
            return tmpRet;
        }
    }
}

shared_ptr<NCExpression> NCParser::primary_prefix(){
    //literal
    pushIndex();
    auto ret = literal();
    if (ret) {
        return ret;
    }
    
    // '(' expression ')'
    popIndex();
    if (word == "(") {
        word = nextWord();
        auto exp = expression();
        if (word!=")") {
            popIndex();
            return nullptr;
        }
        word = nextWord();
        return exp;
    }
    
    // name [call(args)]
    if (!isIdentifier(word)) {
        return nullptr;
    }
    
    string name = word;
    word = nextWord();
    
    vector<shared_ptr<NCExpression>> args;
    pushIndex();
    if (!arguments_expression(args)) {
        popIndex();
        return shared_ptr<NCExpression>(new NCNameExpression(name));
    }
    return shared_ptr<NCExpression>(new NCMethodCallExpr(args, name));
}

bool NCParser::arguments_expression(vector<shared_ptr<NCExpression>> & args){
    if (word!="(") {
        return false;
    }
    word = nextWord();
    if (word == ")") {
        //empty arguments
        word = nextWord();
        return true;
    }
    
    if (!arguments(args)) {
        return false;
    }
    
    if (word != ")") {
        return false;
    }
    word = nextWord();
    return true;
}

bool NCParser::arguments(vector<shared_ptr<NCExpression>> & args){
    auto arg = expression();
    if (!arg) {
        return false;
    }
    while (arg) {
        args.push_back(arg);
        if (word != ",") {
            return true;
        }
        word = nextWord();
        arg = expression();
        if (!arg) {
            return false;
        }
    }
    return true;
}

shared_ptr<NCExpression> NCParser::primary_suffix(shared_ptr<NCExpression> scope){
    if (word == ".") {
        word =nextWord();
        if (isIdentifier(word)) {
            string name = word;
            word = nextWord();
            
            vector<shared_ptr<NCExpression>> args;
            if (arguments_expression(args)) {
                return shared_ptr<NCExpression>(new NCMethodCallExpr(args, scope, name));
            }
            else {
                return shared_ptr<NCExpression>(new NCFieldAccessExpr(scope,name));
            }
        }
    }
    else if(word == "["){
        word = nextWord();
        auto exp = expression();
        if (exp) {
            if (word == "]") {
                word =nextWord();
                return shared_ptr<NCArrayAccessExpr>(new NCArrayAccessExpr(scope,exp));
            }
        }
        
    }
    return nullptr;
}

shared_ptr<NCExpression> NCParser::literal(){
    string val = word;
    int intNum;
    float fNum;
    string str;
    if (isIntegerLiteral(word, &intNum)) {
        word = nextWord();
        return shared_ptr<NCIntegerLiteral>(new NCIntegerLiteral(intNum));
    }
    else if (isFloatLiteral(word, &fNum)) {
        word = nextWord();
        return shared_ptr<NCFloatLiteral>(new NCFloatLiteral(fNum));
    }
    else if (isStringLiteral(word,str)) {
        word = nextWord();
        return shared_ptr<NCStringLiteral>(new NCStringLiteral(str));
    }
    return nullptr;
}

bool NCParser::vecInclude(vector<string>& operators, string op){
    for (auto s :operators) {
        if (s == op) {
            return true;
        }
    }
    return false;
}

shared_ptr<NCBinaryExpression> NCParser::addRight(shared_ptr<NCExpression> left, shared_ptr<NCExpression> right, string op){
    auto binExpr = new NCBinaryExpression();
    binExpr->op = op;
    binExpr->left = left;
    binExpr->right = right;
    return shared_ptr<NCBinaryExpression>(binExpr);
}

shared_ptr<NCStatement> NCParser::statement(){
    
    pushIndex();
    shared_ptr<NCStatement> stmt = block();
    if (stmt) {
        return stmt;
    }
    
    popIndex();
    stmt = selection_statement();
    if (stmt) {
        return stmt;
    }
    
    popIndex();
    stmt = while_statement();
    if (stmt) {
        return stmt;
    }
    
    popIndex();
    stmt = for_statement();
    if (stmt) {
        return stmt;
    }
    
    popIndex();
    stmt = expression_statement();
    if (stmt) {
        return stmt;
    }
    
    popIndex();
    stmt = break_statement();
    if (stmt) {
        return stmt;
    }
    
    popIndex();
    stmt = return_statement();
    if (stmt) {
        return stmt;
    }
    
    return nullptr;
}

shared_ptr<NCStatement> NCParser::return_statement(){
    if (word == "return") {
        word = nextWord();
        
        pushIndex();
        auto exp = expression();
        if (!exp) {
            popIndex();
            return shared_ptr<NCStatement>(new ReturnStatement());
        }
        else {
            return shared_ptr<NCStatement>(new ReturnStatement(exp));
        }
    }
    return nullptr;
}

shared_ptr<NCStatement> NCParser::selection_statement(){
    if (word == "if") {
        word = nextWord();
        
        if (word!="(") {
            return nullptr;
        }
        
        word = nextWord();
        auto cond = expression();
        
        if (!cond) {
            return nullptr;
        }
        
        if (word!=")") {
            return nullptr;
        }
        
        word = nextWord();
        auto stmt = statement();
        if (!stmt) {
            return nullptr;
        }
        
        if (word != "else") {
            auto ifStmt = new IfStatement(cond,stmt);
            return shared_ptr<NCStatement>(ifStmt);
        }
        else {
            auto elseStmt = statement();
            if (!elseStmt) {
                return nullptr;
            }
            
            auto ifStmt = new IfStatement(cond,stmt, elseStmt);
            return shared_ptr<NCStatement>(ifStmt);
        }
    }
    return nullptr;
}

shared_ptr<NCStatement> NCParser::while_statement(){
    if (word == "while") {
        word = nextWord();
        
        if (word!="(") {
            return nullptr;
        }
        
        word = nextWord();
        auto cond = expression();
        
        if (!cond) {
            return nullptr;
        }
        
        if (word!=")") {
            return nullptr;
        }
        
        word = nextWord();
        auto stmt = statement();
        if (!stmt) {
            return nullptr;
        }
        
        auto whileStmt = new WhileStatement(cond,stmt);
        return shared_ptr<NCStatement>(whileStmt);
    }
    return nullptr;
}

shared_ptr<NCStatement> NCParser::for_statement(){
    if (word != "for") {
        return nullptr;
    }
    auto forStmt = new ForStatement();
    word = nextWord();
    
    if (word != "(") {
        return nullptr;
    }
    word = nextWord();
    
    if(!for_init(forStmt->init)){
        return nullptr;
    }
    
//    if (word != ";") {
//        return nullptr;
//    }
//    word = nextWord();
    
    auto expr = expression();
    if (!expr) {
        return nullptr;
    }
    forStmt->expr = expr;
    
//    if (word != ";") {
//        return nullptr;
//    }
//    word = nextWord();
    
    if(!for_update(forStmt->update)){
        return nullptr;
    }
    
    if (word != ")") {
        return nullptr;
    }
    word = nextWord();
    
    auto stmt = statement();
    if (!stmt) {
        return nullptr;
    }
    
    forStmt->body = stmt;
    return shared_ptr<NCStatement>(forStmt);
}

bool NCParser::for_init(vector<shared_ptr<NCExpression>>& init){
    pushIndex();
    auto expr = variable_declaration_expression();
    if (expr) {
        init.push_back(expr);
        return true;
    }
    popIndex();
    
    if (!expression_list(init)) {
        return false;
    }
    return true;
}

bool NCParser::for_update(vector<shared_ptr<NCExpression>>& update){
    return expression_list(update);
}

shared_ptr<NCStatement> NCParser::break_statement(){
    if (word == "break") {
        word = nextWord();
        return shared_ptr<NCStatement>(new BreakStatement());
    }
    return nullptr;
}

shared_ptr<NCStatement> NCParser::continue_statement(){
    if (word == "continue") {
        word = nextWord();
        return shared_ptr<NCStatement>(new ContinueStatement());
    }
    return nullptr;
}

shared_ptr<NCStatement> NCParser::expression_statement(){
    auto expr = primary_expression();
    if (!expr) {
        return nullptr;
    }
    
    if (isAssignOperator(word)) {
        word = nextWord();
        
        auto value = expression();
        if (!value) {
            return nullptr;
        }
        
        auto assignExpr = new NCAssignExpr(expr,word,value);
        auto expStmt = new NCExpressionStatement();
        expStmt->expression = shared_ptr<NCExpression>(assignExpr);
        return shared_ptr<NCStatement>(expStmt);
    }
    else {
        auto expStmt = new NCExpressionStatement();
        expStmt->expression = expr;
        return shared_ptr<NCStatement>(expStmt);
    }
}

bool NCParser::isAssignOperator(string&op){
    return op == "="|op == "+="|op == "-="|op == "*="|op == "="|op == "/=";
}

//type_specifier-> string|int|float|void
MCType NCParser::type_specifier(){
    if (word == "string"||word == "int"||word == "float"||word == "void") {
        auto ret = word;
        word = nextWord();
        return ret;
    }
    else if((word[0] >= 'a' && word[0] <= 'z')||(word[0] >= 'A' && word[0] <= 'Z') || word[0] == '_'){
        if(keywords.find(word) != keywords.end()){
            return "";
        }
        
        auto ret = word;
        word = nextWord();
        return ret;
    }
    return "";
}

bool NCParser::isIdentifier(string & word){
    return keywords.find(word) == keywords.end();
}

bool NCParser::isIntegerLiteral(string&word, int * num){
    stringstream ss(word);
    int d;
    ss>>d;
    *num = d;
    return !ss.fail();
}
bool NCParser::isFloatLiteral(string&word, float *num){
    stringstream ss(word);
    float d;
    ss>>d;
    *num = d;
    return !ss.fail();
}
bool NCParser::isStringLiteral(string&word,string&parsed){
    if( word.length() >= 2 && word[0] == '"' && word[word.length()-1] == '"'){
        parsed = word.substr(1,word.length()-2);
        return true;
    }
    return false;
}

