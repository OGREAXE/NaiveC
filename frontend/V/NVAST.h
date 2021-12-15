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

typedef int NVInt;

typedef float NVFloat;

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
 
- (id)initWithExpr:(NVExpression *)expr
                op:(NSString *)op
             value:(NVExpression *)value;

@end

//class.method(...)
@interface NVMethodCallExpr:  NVPrimarySuffix
@property (nonatomic) NSArray<NVExpression *> * args;
@property (nonatomic) NSString * name;
@property (nonatomic) NVExpression * scope;

- (id)initWithArgs:(NSArray<NVExpression *> *)args
              name:(NSString *)name
             scope:(nullable NVExpression *)scope;

@end

//support calling oc message [obj msg:para1:para2]
@interface NVObjCSendMessageExpr:  NVPrimarySuffix

@property (nonatomic) NSArray<NVExpression *> * argument_expression_list;
@property (nonatomic) NSArray<NSString *> *parameter_list;
@property (nonatomic) NVExpression * scope;

- (id)initWithArgumentExprList:(NSArray<NVExpression *> *)argument_expression_list
                 parameterList:(NSArray<NSString *> *)parameter_list
                         scope:(NVExpression *)scope;

- (NVMethodCallExpr *)getMehodCall;
 
@end

@interface NVFieldAccessExpr:  NVPrimarySuffix
@property (nonatomic) NVExpression * scope;
@property (nonatomic) NSString * field;

- (id)initWithScope:(NVExpression *)scope field:(NSString *)field;

@end

@interface NVArrayAccessExpr:  NVPrimarySuffix

@property (nonatomic) NVExpression * scope;
@property (nonatomic) NVExpression * expression;
 
- (id)initWithScope:(NVExpression *)scope expression:(NVExpression *)expression;

@end

@interface NVArrayInitializer:  NVExpression
@property (nonatomic) NSMutableArray<NVExpression *> *elements;
 
@end

@interface NVNameExpression:  NVExpression

@property (nonatomic) BOOL shouldAddKeyIfKeyNotFound;
@property (nonatomic) NSString * name;

- (id)initWithName:(NSString *)name;
 
@end

@interface NVLiteral:  NVExpression
@end

@interface NVIntegerLiteral:  NVLiteral

@property (nonatomic) int value;

- (id)initWithInt:(int)intValue;

@end

@interface NVFloatLiteral:  NVLiteral
    
@property (nonatomic) NVFloat value;

- (id)initWithFloat:(float)floatValue;

@end

@interface NVStringLiteral:  NVLiteral

@property (nonatomic) NSString *str;

- (id)initWithString:(NSString *)str;

@end

@interface NVStatement:  NVASTNode
@end

@interface NVBlockStatement:  NVStatement

@property (nonatomic) NVExpression * expression;
 
@end

typedef NVBlockStatement  NVExpressionStatement;

@interface NVArrayBracketPair : NSObject

@end

@interface NVVariableDeclarator:  NVExpression
//    pair<string, vector<NCArrayBracketPair *> * id;

@property (nonatomic)  NVPair<NSString *, NSArray<NVArrayBracketPair *>*> *Id;
    
- (NSString *)id_str; //{return id.first;}
    
@property (nonatomic) NVExpression * expression;
 
@end

@interface NVVariableDeclarationExpression:  NVExpression

@property (nonatomic) NSString * type;
@property (nonatomic) NSMutableArray<NVExpression *> * variables;
 
@end

@interface NVIfStatement:  NVStatement

//    IfStatement():condition(nullptr),thenStatement(nullptr),elseStatement(nullptr){
//
//    IfStatement(shared_ptr<NVExpression> condition,shared_ptr<NCStatement> thenStatement):condition(condition),thenStatement(thenStatement),elseStatement(nullptr){
//
//    IfStatement(shared_ptr<NVExpression> condition, shared_ptr<NCStatement> thenStatement,shared_ptr<NCStatement> elseStatement):condition(condition),thenStatement(thenStatement),elseStatement(elseStatement){
    
@property (nonatomic) NVExpression * condition;
@property (nonatomic) NVStatement * thenStatement;
@property (nonatomic) NVStatement * elseStatement;
 
@end

@interface NVReturnStatement:  NVStatement

//    ReturnStatement():expression(nullptr){}
//    ReturnStatement(shared_ptr<NVExpression> expression):expression(expression){}
@property (nonatomic) NVExpression * expression;
 
- (id)initWithExpression:(NVExpression *)expr;

@end

@interface NVWhileStatement:  NVStatement

//    WhileStatement(shared_ptr<NVExpression> condition,shared_ptr<NCStatement> statement):condition(condition),statement(statement){}
@property (nonatomic) NVExpression * condition;
@property (nonatomic) NVStatement * statement;

- (id)initWithCondition:(NVExpression *)condition statement:(NVStatement *)stmt;
 
@end

@interface NVFastEnumeration : NSObject

@property (nonatomic) NSString * enumerator;
@property (nonatomic) NVExpression * expr;
 
@end

@interface NVForStatement:  NVStatement

@property (nonatomic) NVFastEnumeration * fastEnumeration;
    
@property (nonatomic) NSMutableArray<NVExpression *> * forInit;
@property (nonatomic) NSMutableArray<NVExpression *> * update;
@property (nonatomic) NVExpression * expr;
@property (nonatomic) NVStatement * body;

//    ForStatement(vector<shared_ptr<NVExpression *> * &init,
//             @property (nonatomic) NSArray<NVExpression *> * &update,
//             @property (nonatomic) NVExpression> expr,
//             @property (nonatomic) NCStatement> body):update(update),init(init),expr(expr),body(body){}
 
@end

@interface NVBreakStatement:  NVStatement
 
@end

@interface NVContinueStatement:  NVStatement
 
@end

/*
 type specification is not required
 may drop support of type specification in the future, just like most script languages did
 */
@interface NVParameter : NSObject

@property (nonatomic) NSString * type;
@property (nonatomic) NSString * name;

- (id)initWithType:(NSString *)type name:(NSString *)name;
- (id)initWithName:(NSString *)name;
    
@property (nonatomic, readonly) BOOL isPrimitiveType; //param pass by value such as int, float,
 
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
    
@property (nonatomic) NSMutableArray<NVParameter *> *parameters;
    
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
    
@property (nonatomic) NSMutableArray<NVBodyDeclaration *> *members;
    
@property (nonatomic) NSMutableArray<NVFieldDeclaration *> *fields;
    
//    unordered_map<string, shared_ptr<NCMethodDeclaration *> * methods;
    
@property (nonatomic) NSMutableDictionary<NSString *, NVMethodDeclaration *> *methods;

- (NVFieldDeclaration *)getField:(NSString *)name;
    
@end

@interface NVLambdaLiteral:  NVLiteral

@property (nonatomic) NVASTFunctionDefinition * invoke;
 
@end

@interface NVASTRoot:  NVASTNode

@property (nonatomic) NSMutableArray<NVClassDeclaration *> * classList;
@property (nonatomic) NSMutableArray<NVASTFunctionDefinition *> * functionList;
 
@end

NS_ASSUME_NONNULL_END
