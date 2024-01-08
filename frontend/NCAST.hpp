//
//  MCAST.hpp
//  MiniC
//
//  Created by 梁志远 on 19/08/2017.
//  Copyright © 2017 Ogreaxe. All rights reserved.
//

#ifndef MCAST_hpp
#define MCAST_hpp

#include <stdio.h>
#include <stdio.h>
#include <vector>
#include <string>
#include <set>
#include <map>
#include <memory>
#include <unordered_map>

using namespace std;

typedef string MCType;

typedef long long NCInt;

typedef double NCFloat;

//struct NCValueHolder{
//    
//};
//
//struct NCIntegerHolder:public NCValueHolder{
//    int value;
//};
//struct NCFloatHolder:public NCValueHolder{
//    float value;
//};
//struct NCStringHolder:public NCValueHolder{
//    string value;
//};


class NCASTNode {
public:
    NCASTNode(){}
    virtual ~NCASTNode(){}
};

typedef shared_ptr<NCASTNode> AstNodePtr;

//template<class T>
//class NCVariable:public NCASTNode{
//    T value;
//};

class NCExpression:public NCASTNode{
public:
    NCExpression(){}
};

//class MCVariableDeclarationExpression:public NCExpression{
//public:
//    string name;
//    NCExpression expression;
//};

class NCUnaryExpression:public NCExpression{
public:
    string op;
    shared_ptr<NCExpression> expression;
};

class NCBinaryExpression:public NCExpression{
public:
    NCBinaryExpression(){}
    
    string op;
    shared_ptr<NCExpression> left;
    shared_ptr<NCExpression> right;
};


//class NCPrimaryExpression:public NCExpression{
//public:
//    string op;
//    shared_ptr<NCExpression> left;
//    shared_ptr<NCExpression> right;
//};

class NCPrimaryPrefix:public NCExpression{
public:
    
};

class NCPrimarySuffix:public NCExpression{
public:
};

class NCAssignExpr:public NCExpression{
public:
    NCAssignExpr(shared_ptr<NCExpression> expr,string op,shared_ptr<NCExpression> value):expr(expr),op(op),value(value){}
    shared_ptr<NCExpression> expr;
    string op; //currently only "=" is supported
    shared_ptr<NCExpression> value;
};

//class.method(...)
class NCMethodCallExpr:public NCPrimarySuffix{
public:
    string name;
    
    shared_ptr<NCExpression> scope;
    
    vector<shared_ptr<NCExpression>> args;
    
    vector<shared_ptr<NCExpression>> formatArgs;
    
//    bool isFormat;

    //method(args);
    NCMethodCallExpr(vector<shared_ptr<NCExpression>> & args,string &name):args(args), name(name), scope(nullptr){
    }
    
    //scope.method(args);
    NCMethodCallExpr(vector<shared_ptr<NCExpression>> & args, shared_ptr<NCExpression> scope, string &name):args(args), name(name), scope(scope){
    }
};

//support objective c style syntactic sugar starting with @
class NCObjcSyntacticSugarExpr:public NCPrimarySuffix{
private:
//    shared_ptr<NCExpression> exporession;
public:
    //method(args);
//    NCObjCSendMessageExpr(shared_ptr<NCExpression> &expression):expression(expression){}
};

class NCObjcStringExpr:public NCObjcSyntacticSugarExpr{
private:
    
public:
    string content;
    NCObjcStringExpr(string &content):content(content){}
};

class NCObjcNumberExpr:public NCObjcSyntacticSugarExpr{
private:
    
public:
    //method(args);
    shared_ptr<NCExpression> expression;
    NCObjcNumberExpr(shared_ptr<NCExpression> &expression):expression(expression){}
};

//support calling oc message [obj msg:para1:para2]
class NCObjCSendMessageExpr:public NCPrimarySuffix{
private:
    shared_ptr<NCMethodCallExpr> m_methodCallExpr;
public:
    vector<shared_ptr<NCExpression>> argument_expression_list;
    
    vector<string> parameter_list;
    shared_ptr<NCExpression> scope;
    
//    bool isFormat = false; // format function
    vector<shared_ptr<NCExpression>> format_argument_expression_list;
    
    //method(args);
    NCObjCSendMessageExpr(vector<shared_ptr<NCExpression>> & argument_expression_list,vector<string> parameter_list, shared_ptr<NCExpression> scope):argument_expression_list(argument_expression_list), parameter_list(parameter_list), scope(scope),m_methodCallExpr(nullptr){}
    
    
    /**
     covert to normal style method call

     @return <#return value description#>
     */
    shared_ptr<NCMethodCallExpr> getMehodCall();
};

class NCFieldAccessExpr:public NCPrimarySuffix{
public:
    shared_ptr<NCExpression> scope;
    string field;

    NCFieldAccessExpr(shared_ptr<NCExpression> scope, string &field):field(field), scope(scope){};
};

class NCArrayAccessExpr:public NCPrimarySuffix{
public:
    NCArrayAccessExpr(shared_ptr<NCExpression> scope,shared_ptr<NCExpression> expression):scope(scope),expression(expression){};
    
    shared_ptr<NCExpression> scope;
    shared_ptr<NCExpression> expression;
};

class NCArrayInitializer:public NCExpression{
public:
    vector<shared_ptr<NCExpression>> elements;
};

//class NCNSDictionaryInitializer:public NCExpression{
//public:
//    vector<pair<shared_ptr<NCExpression>, shared_ptr<NCExpression>>> keyValueList;
//};

class NCNameExpression:public NCExpression{
private:
    bool shouldAddKeyIfKeyNotFound;
public:
    NCNameExpression(string&name):name(name),shouldAddKeyIfKeyNotFound(false){};
    string name;
    
    void setShouldAddKeyIfKeyNotFound(bool shouldAdd){shouldAddKeyIfKeyNotFound = shouldAdd;}
    bool getShouldAddKeyIfKeyNotFound(){return shouldAddKeyIfKeyNotFound;}
};

class NCLiteral:public NCExpression{
public:
    virtual ~NCLiteral(){}
};

class NCIntegerLiteral:public NCLiteral{
    int value;
public:
    int getValue(){return value;};
//    NCIntegerLiteral(string & intStr);
    NCIntegerLiteral(int val):value(val){};
};

class NCFloatLiteral:public NCLiteral{
    
    NCFloat value;
public:
//    NCFloatLiteral(string & floatStr);
    
    NCFloat getValue(){return value;};
    NCFloatLiteral(float val):value(val){};
};

class NCStringLiteral:public NCLiteral{
    string str;
public:
    string getValue(){return str;};
    NCStringLiteral(string & str):str(str){};
};

class NCStatement:public NCASTNode{
    
};

class NCBlockStatement:public NCStatement{
public:
    shared_ptr<NCExpression> expression;
};

typedef NCBlockStatement  NCExpressionStatement;

class NCArrayBracketPair{
    
};

class VariableDeclarator:public NCExpression{
public:
    pair<string, vector<NCArrayBracketPair>> id;
    
    string id_str(){return id.first;}
    
    shared_ptr<NCExpression> expression;
};

class VariableDeclarationExpression:public NCExpression{
public:
    string type;
    vector<shared_ptr<NCExpression>> variables;
};

typedef VariableDeclarationExpression NCVariableDeclarationExpression;

class IfStatement:public NCStatement{
public:
    IfStatement():condition(nullptr),thenStatement(nullptr),elseStatement(nullptr){};
    
    IfStatement(shared_ptr<NCExpression> condition,shared_ptr<NCStatement> thenStatement):condition(condition),thenStatement(thenStatement),elseStatement(nullptr){};
    
    IfStatement(shared_ptr<NCExpression> condition, shared_ptr<NCStatement> thenStatement,shared_ptr<NCStatement> elseStatement):condition(condition),thenStatement(thenStatement),elseStatement(elseStatement){};
    
    shared_ptr<NCExpression> condition;
    shared_ptr<NCStatement> thenStatement;
    shared_ptr<NCStatement> elseStatement;
};

class ReturnStatement:public NCStatement{
public:
    ReturnStatement():expression(nullptr){}
    ReturnStatement(shared_ptr<NCExpression> expression):expression(expression){}
    shared_ptr<NCExpression> expression;
};

class WhileStatement:public NCStatement{
public:
    WhileStatement(shared_ptr<NCExpression> condition,shared_ptr<NCStatement> statement):condition(condition),statement(statement){}
    shared_ptr<NCExpression> condition;
    shared_ptr<NCStatement> statement;
};

class NCFastEnumeration{
public:
    string enumerator;
    shared_ptr<NCExpression> expr;
};

class ForStatement:public NCStatement{
public:
    shared_ptr<NCFastEnumeration> fastEnumeration;
    
    vector<shared_ptr<NCExpression>> init;
    vector<shared_ptr<NCExpression>> update;
    shared_ptr<NCExpression> expr;
    shared_ptr<NCStatement> body;

    ForStatement(){};
    ForStatement(vector<shared_ptr<NCExpression>> &init,
                 vector<shared_ptr<NCExpression>> &update,
                 shared_ptr<NCExpression> expr,
                 shared_ptr<NCStatement> body):update(update),init(init),expr(expr),body(body){}
};

class BreakStatement:public NCStatement{
};

class ContinueStatement:public NCStatement{
};

//class NCExpressionStatement:public NCStatement{
//    
//};
//
//class MCVariableExpressionStatement:public NCExpressionStatement{
//public:
//    string name;
//    NCExpression expression;
//};

//class NCASTWhile:public NCStatement{
//    AstNodePtr condition;
//    AstNodePtr body;
//};
//
//class NCASTReturn:public NCStatement{
//    AstNodePtr node;
//};
//
//class NCASTBranch:public NCStatement{
//    AstNodePtr condition;
//    AstNodePtr if_body;
//    AstNodePtr else_body;
//};
//
//class NCASTCompare:public NCASTNode{
//    AstNodePtr lnode;
//    AstNodePtr rnode;
//};
//
//class NCASTAssign:public NCASTNode{
//    AstNodePtr lnode;
//    AstNodePtr rnode;
//};
//
//class NCASTBinOp:public NCASTNode{
//    string op;
//    AstNodePtr lnode;
//    AstNodePtr rnode;
//};
//
//class NCASTUnaOp:public NCASTNode{
//    string op;
//    AstNodePtr lnode;
//};

/*
 type specification is not required
 may drop support of type specification in the future, just like most script languages did
 */
class NCParameter{
public:
    NCParameter(){}
    
    NCParameter(string type,string name):type(type), name(name){}
    NCParameter(string name):type(""), name(name){}
    
    string type;
    string name;
};

class NCArgument{
    NCArgument();
    
    NCParameter parameter;
    
    void * value;
    
    void operator = (const void * value);
};

class NCBlock:public NCStatement{
public:
    vector<AstNodePtr> statement_list;
};
//
//class NCClassMember:public NCASTNode{
//public:
//    string type;
//    string name;
//    shared_ptr<NCExpression> expression;
//};
//
//class NCAstClassDefinition:public NCASTNode{
//public:
//    unordered_map<string, shared_ptr<NCClassMember>> memberMap;
//    
//};

class NCASTFunctionDefinition:public NCASTNode{
public:
    
    MCType return_type;
    
    string name;
    
    vector<NCParameter> parameters;
    
//    AstNodePtr statement_list;
    shared_ptr<NCBlock> block;
    
    AstNodePtr return_stat;
};

class NCLambdaExpression :public NCExpression{
public:
    shared_ptr<NCBlock> blockStmt;
    
    vector<NCParameter> parameters;
    
    vector<string> capturedSymbols;
};

/////////////////////////////////////////////////////////
//
//      class definition
//
/////////////////////////////////////////////////////////

class NCBodyDeclaration:public NCASTNode {
    
};

class NCFieldDeclaration:public NCBodyDeclaration {
public:
    shared_ptr<NCExpression> declarator;
    string name;
};

class NCMethodDeclaration:public NCBodyDeclaration {
public:
    shared_ptr<NCASTFunctionDefinition> method;
};

class NCConstructorDeclaration:public NCBodyDeclaration {
    
};

class NCClassDeclaration:public NCASTNode {
public:
    string name;
    
//    shared_ptr<NCClassDeclaration> parent;
    string parent;
    
    vector<shared_ptr<NCBodyDeclaration>> members;
    
    vector<shared_ptr<NCFieldDeclaration>> fields;
    
    unordered_map<string, shared_ptr<NCMethodDeclaration>> methods;
    
    shared_ptr<NCFieldDeclaration> getField(const string & name){
        for (auto field : fields) {
            if (field->name == name) {
                return field;
            }
        }
        return nullptr;
    }
};

class NCLambdaLiteral:public NCLiteral{
public:
    shared_ptr<NCASTFunctionDefinition> invoke;
};

class NCASTRoot:public NCASTNode {
public:
    vector<shared_ptr<NCClassDeclaration>> classList;
    vector<shared_ptr<NCASTFunctionDefinition>> functionList;
};


class NCObjcArrayInitializer:public NCObjcSyntacticSugarExpr{
private:
    
public:
    //method(args);
    shared_ptr<NCArrayInitializer> arrayInitializer;
    NCObjcArrayInitializer(shared_ptr<NCArrayInitializer> &arrayInitializer):arrayInitializer(arrayInitializer){}
};
//
//class NCObjcDictionaryExpr:public NCObjcSyntacticSugarExpr{
//private:
//    shared_ptr<NCNSDictionaryInitializer> dictionaryInitializer;
//public:
//    //method(args);
//    NCObjcDictionaryExpr(shared_ptr<NCNSDictionaryInitializer> &dictionaryInitializer):dictionaryInitializer(dictionaryInitializer){}
//};

class NCObjcDictionaryInitializer:public NCExpression{
public:
    vector<pair<shared_ptr<NCExpression>, shared_ptr<NCExpression>>> keyValueList;
};

#endif /* MCAST_hpp */
