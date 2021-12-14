//
//  NVInterpreter.m
//  NaiveC
//
//  Created by liangzhiyuan on 2021/12/13.
//  Copyright © 2021 Ogreaxe. All rights reserved.
//

#import "NVInterpreter.h"
#import "NVAST.h"
#import "NVObject.h"
#import "NVModuleCache.h"
#import "NVStack.h"
#import "NVFrame.h"
#import "NVArray.h"

@interface NVCircuitControl : NSObject
@property (nonatomic) BOOL shouldBreak;
@property (nonatomic) BOOL shouldReturn;
@property (nonatomic) NVException *exception;
@end

@implementation NVCircuitControl
@end

@interface NVInterpreter ()

@end

@implementation NVInterpreter

- (id)initWithRoot:(NVASTRoot *)root {
    self = [super init];
    
    if (self) {
        for (NVASTFunctionDefinition *funcDef in root.functionList) {
            [[NVModuleCache globalCache] addNativeFunction:funcDef];
        }
        
        for (NVClassDeclaration *classDef in root.classList) {
            [[NVModuleCache globalCache] addClassDefinition:classDef];
        }
    }
    
    return self;
}

- (BOOL)isClassName:(NSString *)name {
    if ([name isEqualToString:@"array"]) {
        return YES;
    }
    
    return NO;
}

- (BOOL)invoke:(NSString *)functionName
     arguments:(NSArray<NVStackElement *> *)arguments
     lastStack:(NVStack *)lastStack {
    if ([self isClassName:functionName]) {
        return [self invoke_constructor:functionName
                       arguments:arguments
                       lastStack:lastStack];
    }

    NVASTFunctionDefinition *funcDef = [[NVModuleCache globalCache] nativeFunctionDefinitionForName:functionName];
    
    if (!funcDef) {
        return NO;
    }
    
    NVFrame *frame = [[NVFrame alloc] init];
    for (int i = 0; i<arguments.count; i++) {
        NVStackElement *var = arguments[i];
        [frame.localVariableMap setObject:var forKey:funcDef.parameters[i].name];
    }
    
    if (![self visit:funcDef.block frame:frame]) {
        return NO;
    }
    
    if (frame.stack.count > 0) {
        [lastStack addObject:frame.stack.top];
    }
    
    return true;

}

- (BOOL)invoke:(NSString *)functionName
         scope:(NVNativeObject *)scope
     arguments:(NSArray<NVStackElement *> *)arguments
     lastStack:(NVStack *)lastStack {
    NSAssert(NO, @"not implmemented");
    return NO;
}

- (BOOL)invoke_constructor:(NSString *)functionName
     arguments:(NSArray<NVStackElement *> *)arguments
     lastStack:(NVStack *)lastStack {
    NSAssert(NO, @"not implmemented");
    return NO;
}

- (BOOL)visit:(NVASTNode *)node frame:(NVFrame *)frame {
    return [self visit:node
                 frame:frame
        circuitControl:nil];
}

- (BOOL)visit:(NVASTNode *)currentNode
        frame:(NVFrame *)frame
circuitControl:(NVCircuitControl *)circuitControl {
    NSString *nodeClassName = NSStringFromClass(currentNode.class);
    
    nodeClassName = [nodeClassName substringFromIndex:2]; //remove NV prefix
    
    NSString *selectorString = [NSString stringWithFormat:@"visit%@:frame:circuitControl:", nodeClassName];
    
    SEL selector = NSSelectorFromString(selectorString);
    
    [self performSelector:selector withObject:frame withObject:circuitControl];
    
    if (circuitControl.exception) {
        return NO;
    }
    
    return YES;
}

#pragma mark visit node functions
- (void)visitBlock:(NVBlock *)node
        frame:(NVFrame *)frame
  circuitControl:(NVCircuitControl *)circuitControl {
    for (NVStatement *stmt in node.statement_list) {
        circuitControl.shouldReturn = NO;
        circuitControl.shouldBreak = NO;
        
        [self visit:stmt frame:frame circuitControl:circuitControl];
        
        if (circuitControl.shouldReturn) {
            break;
        }
        
        if (circuitControl.shouldBreak) {
            break;
        }
    }
}

- (void)visitBlockStatement:(NVBlockStatement *)node
        frame:(NVFrame *)frame
  circuitControl:(NVCircuitControl *)circuitControl {
    [self visit:node.expression frame:frame];
}

- (void)visitVariableDeclarationExpression:(NVVariableDeclarationExpression *)node
        frame:(NVFrame *)frame
  circuitControl:(NVCircuitControl *)circuitControl {
    NVStackStringElement *element = [[NVStackStringElement alloc] initWithString:node.type];
    [frame.stack addObject:element];
    
    for (NVExpression *var in node.variables) {
        [self visit:var frame:frame];
    }
}

- (void)visitVariableDeclarator:(NVVariableDeclarator *)node
        frame:(NVFrame *)frame
  circuitControl:(NVCircuitControl *)circuitControl {
    NSString *type = [frame stack_popString];
    
    if (node.expression) {
        [self visit:node.expression frame:frame];
        
        NSString * name = node.id_str;
        if ([type isEqualToString:@"int"]) {
            int value = [frame stack_popInt];
            [frame insertVariable:name intValue:value];
        }
        else if ([type isEqualToString:@"float"]) {
            float value = [frame stack_popFloat];
            [frame insertVariable:name floatValue:value];
        }
        else if ([type isEqualToString:@"string"]) {
            NSString *value = [frame stack_popString];
            [frame insertVariable:name stringValue:value];
        }
        else {
            NVStackPointerElement *pointerElement = [frame stack_popObjectPointer];
            [frame insertVariable:name stackPointerElement:pointerElement];
        }
    }
}

- (void)visitMethodCallExpr:(NVMethodCallExpr *)node
        frame:(NVFrame *)frame
  circuitControl:(NVCircuitControl *)circuitControl {
    if (node.scope) {
        [self tree_callClassMehothod:node frame:frame];
    } else {
        [self tree_callStaticMehothod:node frame:frame];
    }
}

- (void)visitObjCSendMessageExpr:(NVObjCSendMessageExpr *)node
        frame:(NVFrame *)frame
  circuitControl:(NVCircuitControl *)circuitControl {
    [self tree_callClassMehothod:node.getMehodCall frame:frame];
}

- (void)visitFieldAccessExpr:(NVFieldAccessExpr *)node
        frame:(NVFrame *)frame
  circuitControl:(NVCircuitControl *)circuitControl {
    [self visit:node.scope frame:frame];
    
    if ([frame stack_empty]) {
        NVException *e = [NVException exceptionWithName:@"NVFieldAccessExpr_exception" reason:@"stack_empty" userInfo:nil];
        circuitControl.exception = e;
        return;
    }
    
    NVStackElement *scope = [frame stack_pop];
    NVFieldAccessor *accessor = [[NVFieldAccessor alloc] initWithScope:scope
                                                         attributeName:node.field];
    
    [frame stack_push:accessor];
}

- (void)visitBinaryExpression:(NVBinaryExpression *)node
        frame:(NVFrame *)frame
  circuitControl:(NVCircuitControl *)circuitControl {
    [self visit:node.left frame:frame];
    
    NVStackElement *leftOperand = [frame stack_pop];
    if (!leftOperand) {
        NVException *e = [NVException exceptionWithName:@"NVBinaryExpression_exception" reason:@"leftOperand is nil" userInfo:nil];
        circuitControl.exception = e;
        return;
    }
    
    [self visit:node.right frame:frame];
    NVStackElement *rightOperand = [frame stack_pop];;
    if (!rightOperand) {
        NVException *e = [NVException exceptionWithName:@"NVBinaryExpression_exception" reason:@"rightOperand is nil" userInfo:nil];
        circuitControl.exception = e;
        return;
    }

    NVStackElement *result = [leftOperand doOperator:node.op rightOperand:rightOperand];
    [frame.stack addObject:result];
}

- (void)visitIfStatement:(NVIfStatement *)node
        frame:(NVFrame *)frame
  circuitControl:(NVCircuitControl *)circuitControl {
    NVExpression *condition = node.condition;
    [self visit:condition frame:frame];
    
    if (frame.stack.count > 0) {
        NVStackElement *stackTop = frame.stack.top;
        [frame.stack pop];
        
        if ([stackTop toInt]) {
            NVStatement *thenBlock = node.thenStatement;
            [self visit:thenBlock frame:frame circuitControl:circuitControl];
        }
        else {
            NVStatement *elseBlock = node.elseStatement;
            [self visit:elseBlock frame:frame circuitControl:circuitControl];
        }
    }
    else {
        NVStatement *elseBlock = node.elseStatement;
        [self visit:elseBlock frame:frame circuitControl:circuitControl];
    }
}

- (void)visitWhileStatement:(NVWhileStatement *)node
        frame:(NVFrame *)frame
  circuitControl:(NVCircuitControl *)circuitControl {
    NVExpression *condition = node.condition;
    
    while (1) {
        [self visit:condition frame:frame];
        
        NVStackElement *stackTop = [frame.stack pop];
        
        if ([stackTop toInt]) {
            NVStatement *block = node.statement;
            
            NVCircuitControl *localControl = [[NVCircuitControl alloc] init];
            [self visit:block frame:frame circuitControl:localControl];
            
            circuitControl.shouldReturn = localControl.shouldReturn;
            circuitControl.exception = localControl.exception;
            
            if (localControl.shouldReturn) {
                break;
            }
            
            if (localControl.shouldBreak) {
                break;
            }
            
            if (localControl.exception) {
                break;
            }
        }
        else {
            break;
        }
    }
}

- (void)visitForStatement:(NVForStatement *)node
        frame:(NVFrame *)frame
  circuitControl:(NVCircuitControl *)circuitControl {
    if (node.fastEnumeration) {
        NVExpression *expr = node.fastEnumeration.expr;
        [self visit:expr frame:frame];
        
        NSString *enumerator = node.fastEnumeration.enumerator;
        
        NVStackPointerElement *exprVal = [frame stack_popObjectPointer];
        if (!exprVal) {
            NVException *e = [NVException exceptionWithName:@"NVForStatement_exception" reason:@"exprVal is nil" userInfo:nil];
            circuitControl.exception = e;
            return;
        }
        
        NVObject *pointedObject = exprVal.object;
        if ([pointedObject conformsToProtocol:@protocol(NVFastEnumerable)]) {
            id<NVFastEnumerable> enumerable = (id<NVFastEnumerable>)pointedObject;
            [enumerable enumerate:^BOOL(NVStackElement * _Nonnull stackElement) {
//                frame.insertVariable(enumerator, element);
                [frame insertVariable:enumerator stackElement:stackElement];
                
                NVStatement *block = node.body;
                
                NVCircuitControl *localControl = [[NVCircuitControl alloc] init];
                [self visit:block frame:frame circuitControl:localControl];
                
                circuitControl.exception = localControl.exception;
                
                return localControl.shouldReturn;
            }];
        }
        else {
            NVException *e = [NVException exceptionWithName:@"NVForStatement_exception" reason:@"not fastEnumerable" userInfo:nil];
            circuitControl.exception = e;
            return;
        }
    }
    else {
        for (NVExpression *aInit in node.forInit) {
            [self visit:aInit frame:frame];
        }
        
        while (1) {
            [self visit:node.expr frame:frame];
            
            NVStackElement *stackTop = [frame.stack pop];
            
            if ([stackTop toInt]) {
                NVStatement *block = node.body;
                
                NVCircuitControl *localControl = [[NVCircuitControl alloc] init];
                [self visit:block frame:frame circuitControl:localControl];
                
                circuitControl.shouldReturn = localControl.shouldReturn;
                circuitControl.exception = localControl.exception;
                
                if (localControl.shouldReturn) {
                    break;
                }
                
                if (localControl.shouldBreak) {
                    break;
                }
                
                if (localControl.exception) {
                    break;
                }
                
                for (NVExpression *aUpdate in node.update) {
                    [self visit:aUpdate frame:frame];
                }
            }
            else {
                break;
            }
        }
    }
}

- (void)visitBreakStatement:(NVBreakStatement *)node
        frame:(NVFrame *)frame
  circuitControl:(NVCircuitControl *)circuitControl {
    circuitControl.shouldBreak = YES;
}

- (void)visitAssignExpr:(NVAssignExpr *)node
        frame:(NVFrame *)frame
  circuitControl:(NVCircuitControl *)circuitControl {
    NVExpression *primary = node.expr;
    
    if ([primary isKindOfClass:NVNameExpression.class]) {
        NVNameExpression *_pri = (NVNameExpression *)primary;
        _pri.shouldAddKeyIfKeyNotFound = YES;
    }
    
    if (![self visit:primary frame:frame circuitControl:circuitControl]) {
        return;
    }
    
    NVStackElement *stackTop = [frame stack_pop];
    
    if ([stackTop isKindOfClass:NVStackVariableElement.class]) {
        NVStackVariableElement *var = (NVStackVariableElement *)stackTop;
        [self visit:node.value frame:frame];
        
        //primitive types, like int ,float and string pass by value
        if ([var.valueElement.type isEqualToString:@"int"]) {
            [frame insertVariable:var.name intValue:[frame stack_popInt]];
        }
        else if ([var.valueElement.type isEqualToString:@"float"]) {
            [frame insertVariable:var.name intValue:[frame stack_popFloat]];
        }
        else if ([var.valueElement.type isEqualToString:@"string"]) {
            [frame insertVariable:var.name stringValue:[frame stack_popString]];
        }
        else {
            //pass by pointer
            NVStackPointerElement *pointerElement = [frame stack_popObjectPointer];
            [frame insertVariable:var.name stackPointerElement:pointerElement];
        }
    }
    else if ([stackTop isKindOfClass:NVAccessor.class]) {
        NVAccessor *accessor = (NVAccessor *)stackTop;
        [self visit:node.value frame:frame];
        NVStackElement *value = [frame stack_popRealValue];
        if ([value isKindOfClass:NVAccessor.class]) {
            NVAccessor *accessorValue = (NVAccessor *)value;
            [accessor set:accessorValue.value];
        }
        else {
            [accessor set:value];
        }
    }
    else if ([stackTop isKindOfClass:NVNameExpression.class]) {
        NVNameExpression *nameExpr = (NVNameExpression *)stackTop;
        
        [self visit:node.value frame:frame];
        NVStackElement *value = [frame stack_pop];
        if (!value) {
            NVException *e = [NVException exceptionWithName:@"NVAssignExpr_exception" reason:@"stack_pop nil" userInfo:nil];
            circuitControl.exception = e;
            return;
        }
        
        if ([value isKindOfClass:NVAccessor.class]) {
            NVAccessor *accessor = (NVAccessor *)value;
            [frame insertVariable:nameExpr.name stackElement:accessor.value];
        } else {
            if ([value isKindOfClass:NVObject.class]) {
                NVObject *object = (NVObject *)value;
                NVStackPointerElement *pointer = [[NVStackPointerElement alloc] initWithObject:object];

                [frame insertVariable:nameExpr.name stackPointerElement:pointer];
            }
            else {
                [frame insertVariable:nameExpr.name stackElement:value];
            }
        }
    }
    
}

- (void)visitArrayAccessExpr:(NVArrayAccessExpr *)node
        frame:(NVFrame *)frame
  circuitControl:(NVCircuitControl *)circuitControl {
    [self visit:node.scope frame:frame];
    [self visit:node.expression frame:frame];
    
    int index = [frame stack_popInt];
    NVStackPointerElement *pointer = [frame stack_popObjectPointer];
    if (!pointer) {
        NVException *e = [NVException exceptionWithName:@"NVArrayAccessExpr_exception" reason:@"accessing null array" userInfo:nil];
        circuitControl.exception = e;
        return;
    }
    
    NVObject *obj = pointer.object;
    if ([obj conformsToProtocol:@protocol(NVBracketAccessible)]) {
        id<NVBracketAccessible> accessible = (id<NVBracketAccessible>)obj;
        NVArrayAccessor *accessor = [[NVArrayAccessor alloc] initWithAccessible:accessible key:[[NVStackIntElement alloc] initWithInt:index]];
        [frame.stack addObject:accessor];
    }
}

- (void)visitArrayInitializer:(NVArrayInitializer *)node
        frame:(NVFrame *)frame
  circuitControl:(NVCircuitControl *)circuitControl {
    
}

- (void)visitNameExpression:(NVNameExpression *)node
        frame:(NVFrame *)frame
  circuitControl:(NVCircuitControl *)circuitControl {
    
}

- (void)visitLiteral:(NVLiteral *)node
        frame:(NVFrame *)frame
  circuitControl:(NVCircuitControl *)circuitControl {
    
}

- (void)visitUnaryExpression:(NVUnaryExpression *)node
        frame:(NVFrame *)frame
  circuitControl:(NVCircuitControl *)circuitControl {
    
}

- (void)visitLambdaExpression:(NVLambdaExpression *)node
        frame:(NVFrame *)frame
  circuitControl:(NVCircuitControl *)circuitControl {
    
}

- (void)visitReturnStatement:(NVReturnStatement *)node
        frame:(NVFrame *)frame
  circuitControl:(NVCircuitControl *)circuitControl {
    
}

#pragma mark helper functions
- (void)addFunction:(NVBuiltinFunction *)function {
    
}

- (BOOL)initializeArguments:(NSArray<NVExpression *> *)intput_argumentExpressions
            outputArguments:(NSArray<NVStackElement *> *)output_arguments
                      frame:(NVFrame *)frame {
    
}

- (BOOL)tree_callStaticMehothod:(NVMethodCallExpr*)method frame:(NVFrame *)frame {
    
}

- (BOOL)tree_callClassMehothod:(NVMethodCallExpr*)method frame:(NVFrame *)frame {
    
}

- (NSArray<NVStackElement *> *)tree_composeArgmemnts:(NSArray<NVParameter *> *)parametersExpr
                                                node:(NVMethodCallExpr*)node
                                               frame:(NVFrame *)frame {
    
}

@end
