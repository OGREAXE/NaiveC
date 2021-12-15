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
#import "NVClassLoader.h"
#import "NVBuiltinFunction.h"

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
        if (isPrimitiveType(type)) {
            NVStackElement *value = [frame stack_popType:type];
            [frame insertVariable:name stackElement:value];
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
        if (isPrimitiveType(var.valueElement.type)) {
            [frame insertVariable:var.name
                     stackElement:[frame stack_popType:var.valueElement.type]];
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
    NVArray *pArray = [[NVArray alloc] init];
    
    for (NVExpression *element in node.elements) {
        [self visit:element frame:frame];
        NVStackElement *value = [frame stack_pop];
        [pArray addElement:value];
    }
    
    NVStackPointerElement *pointer = [[NVStackPointerElement alloc] initWithObject:pArray];
    [frame stack_push:pointer];
}

- (void)visitNameExpression:(NVNameExpression *)node
        frame:(NVFrame *)frame
  circuitControl:(NVCircuitControl *)circuitControl {
    if ([node.name isEqualToString:@"null"]
        || [node.name isEqualToString:@"NULL"]
        || [node.name isEqualToString:@"nil"]) {
        NVStackPointerElement *nullPtr = [[NVStackPointerElement alloc] init];
        [frame.stack addObject:nullPtr];
        return;
    }
    
    if ( [[NVClassLoader sharedLoader] isClassExist:node.name]) {
        //a 'meta' class
        NVClass *targetClass = [[NVClassLoader sharedLoader] loadClass:node.name];
        if (!targetClass) {
            NVException *e = [NVException exceptionWithName:@"NVNameExpression_exception" reason:@"NVClassLoader can't load class" userInfo:nil];
            circuitControl.exception = e;
            return;
        }
        
        [frame.stack addObject:targetClass];
        return;
    }
    
    NVStackElement *foundValue = [frame.localVariableMap objectForKey:node.name];
    
    if (foundValue) {
        if (node.shouldAddKeyIfKeyNotFound) {
            NVStackElement *placeholder = [[NVStackNullElement alloc] init];
            [frame insertVariable:node.name stackElement:placeholder];
            [frame.stack addObject:placeholder];
        }
        else {
            NVException *e = [NVException exceptionWithName:@"NVNameExpression_exception" reason:@"localVariableMap can't find value" userInfo:nil];
            circuitControl.exception = e;
            return;
        }
    }
    else {
        if ([foundValue isKindOfClass:NVStackVariableElement.class]) {
            //extract value, avoid variable in variable.
            NVStackVariableElement *varWrapped = (NVStackVariableElement *)foundValue;
            NVStackElement *payload = varWrapped.valueElement;
            
            [frame.stack addObject:[[NVStackVariableElement alloc] initWithName:node.name value:payload]];
            
        }
        else {
            [frame.stack addObject:[[NVStackVariableElement alloc] initWithName:node.name value:foundValue]];
        }
    }
}

- (void)visitLiteral:(NVLiteral *)node
        frame:(NVFrame *)frame
  circuitControl:(NVCircuitControl *)circuitControl {
    NVStackElement *stackElement = [NVStackElement stackElementWithLiteral:node];
    [frame.stack addObject:stackElement];
}

- (void)visitUnaryExpression:(NVUnaryExpression *)node
        frame:(NVFrame *)frame
  circuitControl:(NVCircuitControl *)circuitControl {
    [self visit:node.expression frame:frame];
    
    NVInt unaryResult = [frame stack_popInt];
    if ([node.op isEqualToString:@"+"]) {
        
    }
    else if ([node.op isEqualToString:@"-"]) {
        NVStackIntElement *intElement = [[NVStackIntElement alloc] initWithInt:-unaryResult];
        [frame.stack addObject:intElement];
    }
    else if ([node.op isEqualToString:@"!"]) {
        if (unaryResult != 0) {
//            frame.stack.push_back(shared_ptr<NCStackIntElement>(new NCStackIntElement(0)));
            NVStackIntElement *intElement = [[NVStackIntElement alloc] initWithInt:0];
            [frame.stack addObject:intElement];
        }
        else {
            NVStackIntElement *intElement = [[NVStackIntElement alloc] initWithInt:1];
            [frame.stack addObject:intElement];
        }
    }
}

- (void)visitLambdaExpression:(NVLambdaExpression *)lambdaExpr
        frame:(NVFrame *)frame
  circuitControl:(NVCircuitControl *)circuitControl {
    
    NSArray<NSString *> *capturedSymbols = lambdaExpr.capturedSymbols;
    
    NVLambdaObject *lambdaObj = [[NVLambdaObject alloc] initWithLambdaExpression:lambdaExpr];
    
    for (NSString *capturedSymbol in capturedSymbols) {
        NVStackElement *localVar = [frame.localVariableMap objectForKey:capturedSymbol];
        
        NVCapturedObject *captured = [[NVCapturedObject alloc] init];
        captured.signature = 0;
        captured.name = capturedSymbol;
        captured.object = localVar;
        
        [lambdaObj addCaptured:captured];
    }
    
    NVStackPointerElement *pLambdaObj = [[NVStackPointerElement alloc] initWithObject:lambdaObj];
    [frame stack_push:pLambdaObj];
}

- (void)visitReturnStatement:(NVReturnStatement *)node
        frame:(NVFrame *)frame
  circuitControl:(NVCircuitControl *)circuitControl {
    [self visit:node.expression frame:frame];
    circuitControl.shouldReturn = true;
}

#pragma mark helper functions
- (void)addFunction:(NVBuiltinFunction *)function {
    
}

- (NSArray<NVStackElement *> *)argumentsWithExpression:(NSArray<NVExpression*> *)intputArgumentExpressions
                      frame:(NVFrame *)frame {
    NSMutableArray<NVStackElement *> *output_arguments = [NSMutableArray array];
    
    for (int i = 0; i < intputArgumentExpressions.count; i++) {
        NVExpression *argExp = intputArgumentExpressions[i];
        [self visit:argExp frame:frame];
        
        NVStackElement *argValue = [frame stack_pop];
        [output_arguments addObject:argValue];
    }
    
    return output_arguments;
}

- (void)throw:(NVException *)exception {
    
}

- (BOOL)tree_callStaticMehothod:(NVMethodCallExpr *)method frame:(NVFrame *)frame {
    NVASTFunctionDefinition *functionDef = [[NVModuleCache globalCache] nativeFunctionDefinitionForName:method.name];
    
    if (functionDef) {
        NSArray<NVStackElement *> *arguments = [self tree_composeArgmemnts:functionDef.parameters
                                                                   methodCallExpr:method
                                                                            frame:frame];
        
        return [self invoke:functionDef.name arguments:arguments lastStack:frame.stack];
    }
    else {
        //no user-defined function found, try system library
        NVBuiltinFunction *funcDef = [[NVModuleCache globalCache] systemFunctionDefinitionForName:method.name];
        
        if (funcDef) {
            NSArray<NVParameter *> *parameters = funcDef.parameters;
            
            NSMutableArray<NVStackElement *> *arguments = [NSMutableArray array];
            
            for (int i = 0; i < method.args.count; i++) {
                if (i >= parameters.count) {
                    NVException *e = [NVException exceptionWithName:@"tree_callStaticMehothod_exception" reason:@"arguments exceed expected" userInfo:nil];
                    [self throw:e];
                    return NO;
                }
                
                NVParameter *parameter = parameters[i];
                
                [self visit:method.args[i] frame:frame];
                
                if (frame.stack.count == 0) {
                    NVException *e = [NVException exceptionWithName:@"tree_callStaticMehothod_exception" reason:@"get argument fail" userInfo:nil];
                    [self throw:e];
                    return NO;
                }
                
                if (parameter.isPrimitiveType) {
                    NVStackElement *stackElment = [frame stack_popType:parameter.type];
                    [arguments addObject:stackElment];
                }
                else if ([parameter.type isEqualToString:@"original"]) {
                    NVStackElement *value = [frame stack_pop];
                    [arguments addObject:value];
                }
                else {
                    //object pointer
                    NVStackElement *objectPointer = [frame stack_pop];
                    [arguments addObject:objectPointer];
                }
            }
            
            [funcDef invoke:arguments lastStack:frame.stack];
            
        }
        else {
            NVClass *cls = [[NVClassLoader sharedLoader] loadClass:method.name];
            
            if (!cls) {
                NSString *reason = [NSString stringWithFormat:@"class %@ not found", method.name];
                NVException *e = [NVException exceptionWithName:@"tree_callStaticMehothod_exception" reason:reason userInfo:nil];
                [self throw:e];
                return NO;
            }
            
            NSArray<NVStackElement *> *arguments = [self argumentsWithExpression:method.args frame:frame];
            
            NVStackPointerElement *aInstance = [cls instantiate:arguments];
            
            [frame.stack addObject:aInstance];
        }
    }
    return true;
}

- (BOOL)tree_callClassMehothod:(NVMethodCallExpr*)method frame:(NVFrame *)frame {
    [self visit:method.scope frame:frame];
    
    NSArray<NVExpression *> *parametersExpr = method.args;
    
    NSMutableArray<NVStackElement *> *arguments = [NSMutableArray array];
    
    for (int i = 0; i < parametersExpr.count; i++) {
        NVExpression *argExp = method.args[i];
        [self visit:argExp frame:frame];
        
        NVStackElement *val = [frame stack_popRealValue];
        [arguments addObject:val];
    }

    
    if ([frame stack_empty]) {
        return NO;
    }
    
    NVStackElement *rScope = [frame stack_pop];
    
    return [rScope invokeMethod:method.name arguments:arguments lastStack:frame.stack];
}

- (NSArray<NVStackElement *> *)tree_composeArgmemnts:(NSArray<NVParameter *> *)parameters
                                                methodCallExpr:(NVMethodCallExpr*)node
                                               frame:(NVFrame *)frame {
    NSMutableArray<NVStackElement *> *arguments = [NSMutableArray array];
    
    for (int i = 0; i < parameters.count; i++) {
        NVParameter *parameter = parameters[i];
        
        NVExpression *argExp = node.args[i];
        [self visit:argExp frame:frame];
        
        if (parameter.isPrimitiveType) {
            NVStackElement *arg = [frame stack_popType:parameter.type];
            [arguments addObject:arg];
        }
        else {
            //object pointer
            NVStackElement *objectPointer = [frame stack_pop];
            [arguments addObject:objectPointer];
            
        }
    }
    
    return arguments;
}

@end
