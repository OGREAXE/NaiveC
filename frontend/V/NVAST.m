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

- (id)initWithExpr:(NVExpression *)expr
                op:(NSString *)op
             value:(NVExpression *)value {
    self = [super init];
    
    self.expr = expr;
    self.op = op;
    self.value = value;
    
    return self;
}

@end

//class.method(...)
@implementation NVMethodCallExpr:  NVPrimarySuffix

- (id)initWithArgs:(NSArray<NVExpression *> *)args
              name:(NSString *)name
             scope:(nullable NVExpression *)scope {
    self = [super init];
    
    self.args = args;
    self.name = name;
    self.scope = scope;
    
    return self;
}

@end

//support calling oc message [obj msg:para1:para2]
@interface NVObjCSendMessageExpr()
@property (nonatomic) NVMethodCallExpr * methodCallExpr;
@end

@implementation NVObjCSendMessageExpr:  NVPrimarySuffix

- (id)initWithArgumentExprList:(NSArray<NVExpression *> *)argument_expression_list
                 parameterList:(NSArray<NSString *> *)parameter_list
                         scope:(NVExpression *)scope {
    self = [super init];
    
    self.argument_expression_list = argument_expression_list;
    self.parameter_list = parameter_list;
    self.scope = scope;
    
    return self;
}

- (NVMethodCallExpr *)getMehodCall {
    if (!_methodCallExpr) {
        NSMutableString *name = [NSMutableString stringWithString:self.parameter_list[0]];
        for (int i = 1; i < self.parameter_list.count; i++) {
            [name appendFormat:@"_%@", _parameter_list[i]];
        }
        
//        auto methodCall = new NCMethodCallExpr(argument_expression_list,scope,name);
//        m_methodCallExpr = shared_ptr<NCMethodCallExpr>(methodCall);
        
        _methodCallExpr = [[NVMethodCallExpr alloc] initWithArgs:_argument_expression_list
                                                            name:name
                                                           scope:_scope];
    }
    
    return _methodCallExpr;
}
 
@end

@implementation NVFieldAccessExpr

- (id)initWithScope:(NVExpression *)scope field:(NSString *)field {
    self = [super init];
    
    self.field = field;
    self.scope = scope;
    
    return self;
}

@end

@implementation NVArrayAccessExpr

- (id)initWithScope:(NVExpression *)scope expression:(NVExpression *)expression {
    self = [super init];
    
    self.expression = expression;
    self.scope = scope;
    
    return self;
}

@end

@implementation NVArrayInitializer

- (NSMutableArray *)elements {
    if (!_elements) {
        _elements = [NSMutableArray array];
    }
    
    return _elements;
}

@end

@implementation NVNameExpression

- (id)initWithName:(NSString *)name {
    self = [super init];
    
    self.name = name;
    
    return self;
}

@end

@implementation NVLiteral
@end

@implementation NVIntegerLiteral

- (id)initWithInt:(int)intValue {
    self = [super init];
    
    self.value = intValue;
    
    return self;
}

@end

@implementation NVFloatLiteral

- (id)initWithFloat:(float)floatValue {
    self = [super init];
    
    self.value = floatValue;
    
    return self;
}

@end

@implementation NVStringLiteral

- (id)initWithString:(NSString *)str {
    self = [super init];
    
    self.str = str;
    
    return self;
}

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

- (id)initWithExpression:(NVExpression *)expression {
    self = [super init];
    
    self.expression = expression;
    
    return self;
}

@end

@implementation NVWhileStatement

- (id)initWithCondition:(NVExpression *)condition statement:(NVStatement *)statement {
    self = [super init];
    
    self.condition = condition;
    self.statement = statement;
    
    return self;
}

@end

@implementation NVFastEnumeration
@end

@implementation NVForStatement

- (NSMutableArray *)forInit {
    if (!_forInit) {
        _forInit = [NSMutableArray array];
    }
    
    return _forInit;
}

- (NSMutableArray *)update {
    if (!_update) {
        _update = [NSMutableArray array];
    }
    
    return _update;
}

@end

@implementation NVBreakStatement
 
@end

@implementation NVContinueStatement
 
@end

/*
 type specification is not required
 may drop support of type specification in the future, just like most script languages did
 */
@implementation NVParameter

- (id)initWithType:(NSString *)type name:(NSString *)name; {
    self = [super init];
    
    self.type = type;
    self.name = name;
    
    return self;
}

- (id)initWithName:(NSString *)name {
    self = [super init];
    
    self.name = name;
    
    return self;
}

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

- (NSMutableArray *)functionList {
    if (!_functionList) {
        _functionList = [NSMutableArray array];
    }
    
    return _functionList;
}

@end

