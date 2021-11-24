//
//  NVAST.h
//  NaiveC
//
//  Created by liangzhiyuan on 2021/11/19.
//  Copyright © 2021 Ogreaxe. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NVCommon.h"

typedef NSString * NVType;

typedef long long NVInt;

typedef double NVFloat;

NS_ASSUME_NONNULL_BEGIN

@interface NVASTNode : NSObject
@end

@interface NVExpression : NVASTNode
@end

//class MCVariableDeclarationExpression:  NVExpression{
// :
//@property (nonatomic) NSString * name;
//    NVExpression expression;
//

@interface NVUnaryExpression:  NVExpression
 
@property (nonatomic) NSString * op;
@property (nonatomic) NVExpression * expression;

@end

@interface NVBinaryExpression:  NVExpression
    
@property (nonatomic) NSString * op;
@property (nonatomic) NVExpression * left;
@property (nonatomic) NVExpression * right;

@end

//class NCPrimaryExpression:  NVExpression{
// :
//@property (nonatomic) NSString * op;
//@property (nonatomic) NVExpression> left;
//@property (nonatomic) NVExpression> right;
//

@interface NVPrimaryPrefix:  NVExpression

@end

@interface NVPrimarySuffix:  NVExpression

@end

@interface NVAssignExpr :  NVExpression
@property (nonatomic) NVExpression * expr;
@property (nonatomic) NSString * op; //currently only "=" is supported
@property (nonatomic) NVExpression * value;
 
@end

//class.method(...)
@interface NVMethodCallExpr:  NVPrimarySuffix
@property (nonatomic) NSArray<NVExpression *> * args;
@property (nonatomic) NSString * name;
@property (nonatomic) NVExpression * scope;

@end

//support calling oc message [obj msg:para1:para2]
@interface NVObjCSendMessageExpr:  NVPrimarySuffix
@property (nonatomic) NVMethodCallExpr * m_methodCallExpr;

@property (nonatomic) NSArray<NVExpression *> * argument_expression_list;
@property (nonatomic) NSArray<NSString *> *parameter_list;
@property (nonatomic) NVExpression * scope;

- (NVMethodCallExpr *)getMehodCall;
 
@end

@interface NVFieldAccessExpr:  NVPrimarySuffix
@property (nonatomic) NVExpression * scope;
@property (nonatomic) NSString * field;
@end

@interface NVArrayAccessExpr:  NVPrimarySuffix
@property (nonatomic) NVExpression * scope;
@property (nonatomic) NVExpression * expression;
 
@end

@interface NVArrayInitializer:  NVExpression
@property (nonatomic) NSArray<NVExpression *> * elements;
 
@end

@interface NVNameExpression:  NVExpression

@property (nonatomic) BOOL shouldAddKeyIfKeyNotFound;
@property (nonatomic) NSString * name;
 
@end

@interface NVLiteral:  NVExpression
@end

@interface NVIntegerLiteral:  NVLiteral
@property (nonatomic) int value;

//int getValue(){return value;}
@end

@interface NVFloatLiteral:  NVLiteral
    
@property (nonatomic) NVFloat value;

//    NCFloatLiteral(string & floatStr);
    
//NCFloat getValue(){return value;}

@end

@interface NVStringLiteral:  NVLiteral
@property (nonatomic) NSString * str;
@end

@interface NVStatement:  NVASTNode
@end

@interface NVBlockStatement:  NVStatement

@property (nonatomic) NVExpression * expression;
 
@end

typedef NVBlockStatement  NVExpressionStatement;

@interface NVArrayBracketPair : NSObject

@end

@interface VariableDeclarator:  NVExpression
//    pair<string, vector<NCArrayBracketPair *> * id;

@property (nonatomic)  NVPair<NSString *, NSArray<NVArrayBracketPair *>*> *Id;
    
- (NSString *)id_str; //{return id.first;}
    
@property (nonatomic) NVExpression * expression;
 
@end

@interface VariableDeclarationExpression:  NVExpression

@property (nonatomic) NSString * type;
@property (nonatomic) NSArray<NVExpression *> * variables;
 
@end

typedef VariableDeclarationExpression NCVariableDeclarationExpression;

@interface IfStatement:  NVStatement

//    IfStatement():condition(nullptr),thenStatement(nullptr),elseStatement(nullptr){
//
//    IfStatement(shared_ptr<NVExpression> condition,shared_ptr<NCStatement> thenStatement):condition(condition),thenStatement(thenStatement),elseStatement(nullptr){
//
//    IfStatement(shared_ptr<NVExpression> condition, shared_ptr<NCStatement> thenStatement,shared_ptr<NCStatement> elseStatement):condition(condition),thenStatement(thenStatement),elseStatement(elseStatement){
    
@property (nonatomic) NVExpression * condition;
@property (nonatomic) NVStatement * thenStatement;
@property (nonatomic) NVStatement * elseStatement;
 
@end

@interface ReturnStatement:  NVStatement

//    ReturnStatement():expression(nullptr){}
//    ReturnStatement(shared_ptr<NVExpression> expression):expression(expression){}
@property (nonatomic) NVExpression * expression;
 
@end

@interface WhileStatement:  NVStatement

//    WhileStatement(shared_ptr<NVExpression> condition,shared_ptr<NCStatement> statement):condition(condition),statement(statement){}
@property (nonatomic) NVExpression * condition;
@property (nonatomic) NVStatement * statement;
 
@end

@interface NVFastEnumeration : NSObject

@property (nonatomic) NSString * enumerator;
@property (nonatomic) NVExpression * expr;
 
@end

@interface ForStatement:  NVStatement

@property (nonatomic) NVFastEnumeration * fastEnumeration;
    
@property (nonatomic) NSArray<NVExpression *> * theInit;
@property (nonatomic) NSArray<NVExpression *> * update;
@property (nonatomic) NVExpression * expr;
@property (nonatomic) NVStatement * body;

//    ForStatement(vector<shared_ptr<NVExpression *> * &init,
//             @property (nonatomic) NSArray<NVExpression *> * &update,
//             @property (nonatomic) NVExpression> expr,
//             @property (nonatomic) NCStatement> body):update(update),init(init),expr(expr),body(body){}
 
@end

@interface BreakStatement:  NVStatement
 
@end

@interface ContinueStatement:  NVStatement
 
@end

//class NVExpressionStatement:  NVStatement
//
//
//
//class MCVariableExpressionStatement:  NVExpressionStatement{
// :
//@property (nonatomic) NSString * name;
//    NVExpression expression;
//

//class NCASTWhile:  NVStatement{
//    NVASTNode condition;
//    NVASTNode body;
//
//
//class NCASTReturn:  NVStatement{
//    NVASTNode node;
//
//
//class NCASTBranch:  NVStatement{
//    NVASTNode condition;
//    NVASTNode if_body;
//    NVASTNode else_body;
//
//
//class NCASTCompare:  NVASTNode{
//    NVASTNode lnode;
//    NVASTNode rnode;
//
//
//class NCASTAssign:  NVASTNode{
//    NVASTNode lnode;
//    NVASTNode rnode;
//
//
//class NCASTBinOp:  NVASTNode{
//@property (nonatomic) NSString * op;
//    NVASTNode lnode;
//    NVASTNode rnode;
//
//
//class NCASTUnaOp:  NVASTNode{
//@property (nonatomic) NSString * op;
//    NVASTNode lnode;
//

/*
 type specification is not required
 may drop support of type specification in the future, just like most script languages did
 */
@interface NVParameter : NSObject

//    NCParameter(){}
//
//    NCParameter(string type,string name):type(type), name(name){}
//    NCParameter(string name):type(""), name(name){}
    
@property (nonatomic) NSString * type;
@property (nonatomic) NSString * name;
 
@end

@interface NVArgument : NSObject
    
@property (nonatomic) NVParameter *parameter;
    
@property (nonatomic) id value;
    
#warning there's no equivelent in OC as operator = in C++ so must pay attention to places it's used
//    void operator = (const void * value);
 
@end

@interface NVBlock:  NVStatement

@property (nonatomic) NSArray<NVASTNode *> *statement_list;
 
@end
//
//class NCClassMember:  NVASTNode{
// :
//@property (nonatomic) NSString * type;
//@property (nonatomic) NSString * name;
//@property (nonatomic) NVExpression> expression;
//
//
//class NCAstClassDefinition:  NVASTNode{
// :
//    unordered_map<string, shared_ptr<NCClassMember *> * memberMap;
//
//

@interface NVASTFunctionDefinition:  NVASTNode
    
@property (nonatomic) NVType return_type;
    
@property (nonatomic) NSString * name;
    
@property (nonatomic) NSArray<NVParameter *> *parameters;
    
//    NVASTNode statement_list;
@property (nonatomic) NVBlock * block;
    
@property (nonatomic) NVASTNode *return_stat;
 
@end

@interface NVLambdaExpression :  NVExpression

@property (nonatomic) NVBlock * blockStmt;
    
@property (nonatomic) NSArray<NVParameter *> *parameters;
    
@property (nonatomic) NSArray<NSString *> *capturedSymbols;
 
@end

/////////////////////////////////////////////////////////
//
//      class definition
//
/////////////////////////////////////////////////////////

@interface NVBodyDeclaration:  NVASTNode
    
 
@end

@interface NVFieldDeclaration:  NVBodyDeclaration

@property (nonatomic) NVExpression * declarator;
@property (nonatomic) NSString * name;
 
@end

@interface NVMethodDeclaration:  NVBodyDeclaration

@property (nonatomic) NVASTFunctionDefinition * method;
 
@end

@interface NVConstructorDeclaration:  NVBodyDeclaration
    
 
@end

@interface NVClassDeclaration:  NVASTNode

@property (nonatomic) NSString * name;
    
//@property (nonatomic) NCClassDeclaration> parent;
@property (nonatomic) NSString * parent;
    
@property (nonatomic) NSArray<NVBodyDeclaration *> * members;
    
@property (nonatomic) NSArray<NVFieldDeclaration *> * fields;
    
//    unordered_map<string, shared_ptr<NCMethodDeclaration *> * methods;
    
@property (nonatomic) NSDictionary<NSString *, NVMethodDeclaration *> *methods;

- (NVFieldDeclaration *)getField:(NSString *)name;
    
@end

@interface NVLambdaLiteral:  NVLiteral

@property (nonatomic) NVASTFunctionDefinition * invoke;
 
@end

@interface NVASTRoot:  NVASTNode

@property (nonatomic) NSArray<NVClassDeclaration *> * classList;
@property (nonatomic) NSArray<NVASTFunctionDefinition *> * functionList;
 
@end

NS_ASSUME_NONNULL_END
