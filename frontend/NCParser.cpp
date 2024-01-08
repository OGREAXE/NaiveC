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
#include "NCException.hpp"

#include "NCLog.hpp"

#define PUSH_INDEX int _saved_temp_index = index;
#define POP_INDEX {index = _saved_temp_index; word = (*tokens)[index].token;}

#define PUSH_INDEX2 int _saved_temp_index2 = index;
#define POP_INDEX2 {index = _saved_temp_index2; word = (*tokens)[index].token;}

static unordered_set<string> keywords =
{
    //types
    "int","float","void",
    //operator
    "=","+=","-=","*=","/=","++",
    "+","-","*","/",
    "%",".","|","&","||","&&","!",
    //paren
    "{","}","(",")","[","]",
    //comma
    ",",
    "^",
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
    
    if (tokens->size() <= 0) {
        return false;
    }
    
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
//        pushIndex();
        PUSH_INDEX
        
        auto pFunc = function_definition();
        if (pFunc) {
            pRoot->functionList.push_back(static_pointer_cast<NCASTFunctionDefinition>(pFunc) );
            parseOK = true;
            continue;
        }
        
//        popIndex();
        POP_INDEX
        
        auto pClass = class_definition();
        if (pClass) {
            pRoot->classList.push_back(static_pointer_cast<NCClassDeclaration>(pClass));
            parseOK = true;
            continue;
        }

    }while (parseOK);
    
    printf("parse %lu classes\n", pRoot->classList.size());
    printf("parse %lu functions\n", pRoot->functionList.size());
    
    if (pRoot->functionList.size() == 0) {
//        NCLog(NCLogTypeParser, "parse fail");
    }
    
    return true;
}

string NCParser::nextWord(){
    index ++;
    if (index >= tokens->size()) {
        throw NCParseException(0,"parse fail:tokens exceeded");
    }
    return (*tokens)[index].token;
}

string NCParser::priviousWord(){
    return (*tokens)[--index].token;
}

string NCParser::peek(int n){
    if (index + n <= (*tokens).size()-1) {
        return (*tokens)[index + n].token;
    }
    return "";
}

void NCParser::pushIndex(){
//    tempIndex = index;
    indexStack.push_back(index);
}
void NCParser::popIndex(){
//    index = tempIndex;
    index = indexStack.back();
    indexStack.pop_back();
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
    
    for (auto member :functionDecl->members) {
        if (auto field = dynamic_pointer_cast<NCFieldDeclaration>(member)) {
            functionDecl->fields.push_back(field);
        }
        else if (auto med = dynamic_pointer_cast<NCMethodDeclaration>(member)) {
            functionDecl->methods.insert(make_pair(med->method->name, med));
        }
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
        members.push_back(member);
    }
    
    word = nextWord();
    return true;
}

shared_ptr<NCBodyDeclaration> NCParser::class_body_declaration(){

    PUSH_INDEX
    
    auto funcDef = function_definition();
    if (funcDef) {
        auto methodDef = new NCMethodDeclaration();
        methodDef->method = static_pointer_cast<NCASTFunctionDefinition>(funcDef);
        return shared_ptr<NCMethodDeclaration>(methodDef);
    }
    
    POP_INDEX
    
    string name;
    auto fieldExpr = field_expression(name);
    if (fieldExpr) {
        auto field = new NCFieldDeclaration();
        field->declarator = fieldExpr;
        field->name = name;
        return shared_ptr<NCFieldDeclaration>(field);
    }
    
    POP_INDEX
    
    return constructor_definition();
}

shared_ptr<NCExpression> NCParser::field_expression(string & name){
//    if (!isIdentifier(word)) {
//        return nullptr;
//    }
    string fname = word;
    word = nextWord();
    
    if (word!="=") {
        return nullptr;
    }
    
    word = nextWord();
    auto initExpr = expression();
    if (!initExpr) {
        return nullptr;
    }
    
//    auto fieldExpr = new NCAssignExpr(shared_ptr<NCNameExpression>(new NCNameExpression(fname)),"=",initExpr);
    
    name = fname;
    
    return shared_ptr<NCExpression> (initExpr);
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
    if (peek(1) == ","||peek(1) == ")") {
        if (isIdentifier(word)) {
            //type is not specified
            *ppp = new NCParameter(word);
            word = nextWord();
            return true;
        }
        return false;
    }
    
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
//        pushIndex();
        PUSH_INDEX
        
        auto statement = blockStatement();
        if (!statement) {
//            popIndex();
            POP_INDEX
            
            break;
        }
        statements.push_back(statement);
    }
    return true;
}

shared_ptr<NCStatement> NCParser::blockStatement(){
//    pushIndex();
    PUSH_INDEX
    
    auto varDecStmt = variable_declaration_expression();
    if (!varDecStmt) {
//        popIndex();
        POP_INDEX
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
    auto arrayInitializer = array_initializer();
    if (arrayInitializer) {
        return arrayInitializer;
    }
    return expression();
}

shared_ptr<NCArrayInitializer> NCParser::array_initializer(){
    if (word != "[") {
        return nullptr;
    }
    word = nextWord();
    
    auto arrayInitializer = new NCArrayInitializer();
    
    if (!arguments(arrayInitializer->elements)) {
        return nullptr;
    }
    
    if (word != "]") {
        return nullptr;
    }
    word = nextWord();
    return shared_ptr<NCArrayInitializer>(arrayInitializer);
}

shared_ptr<NCExpression> NCParser::ns_array_initializer() {
    auto arrInit = array_initializer();
    auto arr = new NCObjcArrayInitializer(arrInit);
    return shared_ptr<NCExpression>(arr);
}

shared_ptr<NCExpression> NCParser::ns_string_expression(){
    auto originalStr = word; //string with ""
    
    if (originalStr.length() >= 2) {
        originalStr = originalStr.substr(1, originalStr.length() - 2);
    }
    
    auto str = new NCObjcStringExpr(originalStr);
    word = nextWord();
    
    return shared_ptr<NCObjcStringExpr>(str);
}

shared_ptr<NCExpression> NCParser::ns_dictionary_initializer(){
    if (word != "{") {
        return nullptr;
    }
    word = nextWord();
    
    auto dictInitializer = new NCObjcDictionaryInitializer();
    
    if (!keyValueList(dictInitializer->keyValueList)) {
        return nullptr;
    }
    
    if (word != "}") {
        return nullptr;
    }
    
    word = nextWord();
    
    return shared_ptr<NCExpression>(dictInitializer);
}

shared_ptr<NCExpression> NCParser::expression(){
    //todo: add parse of @ in objective c here
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
    
//    pushIndex();
    PUSH_INDEX
    
    auto right = nextParseFunc();
    if (!right) {
//        popIndex();
        POP_INDEX
        return left;
    }
    while (right) {
        left = addRight(left, right, op);
        
        if (!vecInclude(operators, word)) {
            break;
        }
        
        op = word;
        word = nextWord();
        
//        pushIndex();
        PUSH_INDEX2
        
        right = nextParseFunc();
        if (!right) {
//            popIndex();
            POP_INDEX2
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
    
//    pushIndex();
    PUSH_INDEX
    
    auto ret = primary_suffix(prefix);
    if (!ret) {
//        popIndex();
        POP_INDEX
        return prefix;
    }
    
    while (1) {
//        pushIndex();
        PUSH_INDEX2
        auto tmpRet = ret;
        ret = primary_suffix(ret);
        
        if (!ret) {
//            popIndex();
            POP_INDEX2
            return tmpRet;
        }
    }
}

shared_ptr<NCLiteral> nameMapLiteral(const string &word) {
    if (word == "true" || word == "YES") {
        return shared_ptr<NCLiteral>(new NCIntegerLiteral(1));
    } else if (word == "false" || word == "NO") {
        return shared_ptr<NCLiteral>(new NCIntegerLiteral(0));
    }
    
    return nullptr;
}

shared_ptr<NCExpression> NCParser::primary_prefix(){
    //literal
//    pushIndex();
    PUSH_INDEX
    
    auto ret = literal();
    if (ret) {
        return ret;
    }
    
    // '(' expression ')'
//    popIndex();
    POP_INDEX
    
    if (word == "(") {
        word = nextWord();
        auto exp = expression();
        if (word!=")") {
//            popIndex();
            return nullptr;
        }
        word = nextWord();
        return exp;
    }
    
    if (word == "[") {
        auto objcSendMsgExpr = objc_send_message();
        
        if (objcSendMsgExpr) {
            return objcSendMsgExpr;
        }
        
        auto arrayInitor = array_initializer();
        if (arrayInitor) {
            return arrayInitor;
        }
        
        return nullptr;
    }
    
    if (word == "@") {
        //objective c syntactic sugar
        return objc_syntactic_sugar();
    }
    
    // name [call(args)]
    if (isIdentifier(word)) {
        string name = word;
        word = nextWord();
        
        auto mappedLiteral = nameMapLiteral(name);
        if (mappedLiteral) {
            return mappedLiteral;
        }
        
        vector<shared_ptr<NCExpression>> args;
        //    pushIndex();
        PUSH_INDEX2
        
        if (!arguments_expression(args)) {
            //        popIndex();
            POP_INDEX2
            if (lambdaFlag) {
                lambdaCapturedSymbols.push_back(name);
            }
            return shared_ptr<NCExpression>(new NCNameExpression(name));
        }
        return shared_ptr<NCExpression>(new NCMethodCallExpr(args, name));
    }
    
    if (word == "^") {
        //lambda
        auto lambdaExpr = new NCLambdaExpression();
        word = nextWord();
        
        if (word == "(") {
            word = nextWord();
            
            if (!parameterlist(lambdaExpr->parameters)) {
                return nullptr;
            }
            if (word!= ")") {
                return nullptr;
            }
            word = nextWord();
        }
        
        lambdaFlag = true;
        lambdaCapturedSymbols.clear();
        auto blockSmt = block();
        if (!blockSmt) {
            lambdaFlag = false;
            return nullptr;
        }
        lambdaFlag = false;
        
        lambdaExpr->capturedSymbols = lambdaCapturedSymbols;
        lambdaExpr->blockStmt = blockSmt;
        return shared_ptr<NCExpression>(lambdaExpr);
    }
    
    return nullptr;
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

 bool NCParser::keyvalue(pair<shared_ptr<NCExpression>, shared_ptr<NCExpression>> &kv) {
    auto key = expression();
    
    if (!key) {
        return false;
    }
     
    kv.first = key;
    
    if (word != ":") {
        return false;
    }
     
    word = nextWord();
    
    auto value = expression();
    
    if (!value) {
        return false;
    }
     
     kv.second = value;
    
     return true;
}

bool NCParser::keyValueList(vector<pair<shared_ptr<NCExpression>, shared_ptr<NCExpression>>> &args) {
    pair<shared_ptr<NCExpression>, shared_ptr<NCExpression>> kv;
    
    bool res = keyvalue(kv);
    
    if (!res) {
        return res;
    }
    
    while (res) {
        args.push_back(kv);
        
        if (word != ",") {
            return true;
        }
        
        word = nextWord();
        
        res = keyvalue(kv);
        
        if (!res) {
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
    if (isFloatLiteral(word, &fNum)) {
        word = nextWord();
        return shared_ptr<NCFloatLiteral>(new NCFloatLiteral(fNum));
    }
    else if (isIntegerLiteral(word, &intNum)) {
        word = nextWord();
        return shared_ptr<NCIntegerLiteral>(new NCIntegerLiteral(intNum));
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
    
//    pushIndex();
    PUSH_INDEX
    
    shared_ptr<NCStatement> stmt = block();
    if (stmt) {
        return stmt;
    }
    
//    popIndex();
    POP_INDEX
    stmt = selection_statement();
    if (stmt) {
        return stmt;
    }
    
//    popIndex();
    POP_INDEX
    stmt = while_statement();
    if (stmt) {
        return stmt;
    }
    
//    popIndex();
    POP_INDEX
    stmt = for_statement();
    if (stmt) {
        return stmt;
    }
    
//    popIndex();
    POP_INDEX
    stmt = expression_statement();
    if (stmt) {
        return stmt;
    }
    
//    popIndex();
    POP_INDEX
    stmt = break_statement();
    if (stmt) {
        return stmt;
    }
    
//    popIndex();
    POP_INDEX
    stmt = return_statement();
    if (stmt) {
        return stmt;
    }
    
    return nullptr;
}

shared_ptr<NCStatement> NCParser::return_statement(){
    if (word == "return") {
        word = nextWord();
        
//        pushIndex();
        PUSH_INDEX
        
        auto exp = expression();
        if (!exp) {
//            popIndex();
            POP_INDEX
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
            word = nextWord();
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
    
//    pushIndex();
    PUSH_INDEX
    
    if (isIdentifier(word)) {
        //try parse fast enumeration
        //for(e:array){ statements }
        string enumerator = word;
        word = nextWord();
        if(word != ":"){
            return nullptr;
        }
        word = nextWord();
        auto expr = expression();
        
        if (word != ")") {
            return nullptr;
        }
        word = nextWord();
        
        auto fastEnumeration = new NCFastEnumeration();
        fastEnumeration->enumerator = enumerator;
        fastEnumeration->expr = expr;
        
        forStmt->fastEnumeration = shared_ptr<NCFastEnumeration>(fastEnumeration);
        
        auto stmt = statement();
        if (!stmt) {
            return nullptr;
        }
        
        forStmt->body = stmt;
        return shared_ptr<NCStatement>(forStmt);
    }
    
    //not fast enumeration, fall back to normal parse
//    popIndex();
    POP_INDEX
    
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
//    pushIndex();
    PUSH_INDEX
    
    auto expr = variable_declaration_expression();
    if (expr) {
        init.push_back(expr);
        return true;
    }
//    popIndex();
    POP_INDEX
    
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

shared_ptr<NCExpression> NCParser::objc_syntactic_sugar(){
    word = nextWord();
    
    if (word[0] == '"') {
        //nsstring;
//        auto str = new NCObjcStringExpr(word);
//        word = nextWord();
//        
//        return shared_ptr<NCObjcStringExpr>(str);
        return ns_string_expression();
    } else if (word == "[") {
        //nsdictionary
//        auto arrInit = array_initializer();
//        auto arr = new NCObjcArrayExpr(arrInit);
//        return shared_ptr<NCExpression>(arr);
        return ns_array_initializer();
    } else if (word == "{") {
        //nsdictionary
        auto arrInit = ns_dictionary_initializer();
        return shared_ptr<NCExpression>(arrInit);
    } else if (word == "(" || (word[0] <= '9' && word[0] > '0')) {
        //nsdictionary
        auto exp = expression();
        return shared_ptr<NCExpression>(new NCObjcNumberExpr(exp));
    } else {
        return nullptr;
    }
}

shared_ptr<NCExpression> NCParser::objc_send_message(){
    if (word != "[") {
        return nullptr;
    }
    word = nextWord();
    
    auto scope = expression();
    if (!scope) {
        return nullptr;
    }
    
    vector<string> parameter_list;
    
    vector<shared_ptr<NCExpression>> argument_expression_list;
    
    vector<shared_ptr<NCExpression>> format_argument_expression_list;
    
    if (isIdentifier(word) && peek(1) == "]") {
        parameter_list.push_back(word);
        word = nextWord();
        word = nextWord();
        
        auto objcMsgSend = new NCObjCSendMessageExpr(argument_expression_list,parameter_list,scope);
        return shared_ptr<NCExpression>(objcMsgSend);
    }
    
    bool isFormat = false;
    
    while (1) {
        if (!isIdentifier(word)) {
            return nullptr;
        }
        parameter_list.push_back(word);
        word = nextWord();
        
        if (word != ":") {
            return nullptr;
        }
        word = nextWord();
        
        //try to parse string format like [NSString stringWithFormat:@"%d%@", 1, @" dog"];
        
        format_argument_expression_list.clear();
        
        arguments(format_argument_expression_list);
        
        if (format_argument_expression_list.size() == 0) {
            NCLog(NCLogTypeParser, "found no arguments");
            return nullptr;
        } else if (format_argument_expression_list.size() == 1) {
            argument_expression_list.push_back(format_argument_expression_list[0]);
            format_argument_expression_list.clear();
        } else if (format_argument_expression_list.size() > 1) {
            if (word != "]") {
                NCLog(NCLogTypeParser, "wrong format arguments");
                return nullptr;
            }
            
            argument_expression_list.push_back(format_argument_expression_list[0]);
            
            format_argument_expression_list.erase(format_argument_expression_list.begin());
            
            break;
        }
    
        
//        auto aArgExpr = expression();
//        
//        if (!aArgExpr) {
//            return nullptr;
//        }
//        
//        argument_expression_list.push_back(aArgExpr);
        
        if (word == "]") {
            break;
        }
    }
    
    word = nextWord();
    
    auto objcMsgSend = new NCObjCSendMessageExpr(argument_expression_list,parameter_list,scope);
    objcMsgSend->format_argument_expression_list = format_argument_expression_list;
    
    return shared_ptr<NCExpression>(objcMsgSend);
}

/*
 helper functions
 */
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
    
    bool hasDot = false;
    for (char c:word) {
        if (c == '.') {
            hasDot = true;
        }
    }
    
    return hasDot && !ss.fail();
}
bool NCParser::isStringLiteral(string&word,string&parsed){
    if( word.length() >= 2 && word[0] == '"' && word[word.length()-1] == '"'){
        parsed = word.substr(1,word.length()-2);
        return true;
    }
    return false;
}

