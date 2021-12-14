//
//  NVAST.m
//  NaiveC
//
//  Created by liangzhiyuan on 2021/11/19.
//  Copyright © 2021 Ogreaxe. All rights reserved.
//

#import "NVAST.h"

@implementation NVASTNode
@end

@implementation NVExpression : NVASTNode
@end

//class MCVariableDeclarationExpression {
// :
//@property (nonatomic) NSString * name;
//    NVExpression expression;
//

@implementation NVUnaryExpression
@end

@implementation NVBinaryExpression
@end

@implementation NVPrimaryPrefix
@end

@implementation NVPrimarySuffix
@end

@implementation NVAssignExpr
@end

//class.method(...)
@implementation NVMethodCallExpr:  NVPrimarySuffix
@end

//support calling oc message [obj msg:para1:para2]
@implementation NVObjCSendMessageExpr:  NVPrimarySuffix

- (NVMethodCallExpr *)getMehodCall {
    return nil;
}
 
@end

@implementation NVFieldAccessExpr
@end

@implementation NVArrayAccessExpr
@end

@implementation NVArrayInitializer
@end

@implementation NVNameExpression
@end

@implementation NVLiteral
@end

@implementation NVIntegerLiteral
@end

@implementation NVFloatLiteral
    
@end

@implementation NVStringLiteral
@end

@implementation NVStatement:  NVASTNode
@end

@implementation NVBlockStatement
@end

@implementation NVArrayBracketPair
@end

@implementation NVVariableDeclarator

- (NSString *)id_str {return _Id.first;}
 
@end

@implementation NVVariableDeclarationExpression
@end

@implementation NVIfStatement
@end

@implementation NVReturnStatement
@end

@implementation NVWhileStatement
@end

@implementation NVFastEnumeration
@end

@implementation NVForStatement
@end

@implementation NVBreakStatement
 
@end

@implementation NVContinueStatement
 
@end

//class NVExpressionStatement
//
//
//
//class MCVariableExpressionStatement Statement{
// :
//@property (nonatomic) NSString * name;
//    NVExpression expression;
//

//class NCASTWhile{
//    NVASTNode condition;
//    NVASTNode body;
//
//
//class NCASTReturn{
//    NVASTNode node;
//
//
//class NCASTBranch{
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
@implementation NVParameter
@end

@implementation NVArgument

- (id)copy {
    return nil;
}

@end

@implementation NVBlock
@end

@implementation NVASTFunctionDefinition
 
@end

@implementation NVLambdaExpression

@end

/////////////////////////////////////////////////////////
//
//      class definition
//
/////////////////////////////////////////////////////////

@implementation NVBodyDeclaration
    
 
@end

@implementation NVFieldDeclaration
@end

@implementation NVMethodDeclaration
@end

@implementation NVConstructorDeclaration
@end

@implementation NVClassDeclaration

- (NVFieldDeclaration *)getField:(NSString *)name {
    for (NVFieldDeclaration *field in self.fields) {
        if ([field.name isEqualToString:name]) {
            return field;
        }
    }
    return NULL;
}
    
@end

@implementation NVLambdaLiteral

@end

@implementation NVASTRoot
@end

