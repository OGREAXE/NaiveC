//
//  NVObject.m
//  NaiveC
//
//  Created by liangzhiyuan on 2021/12/13.
//  Copyright © 2021 Ogreaxe. All rights reserved.
//

#import "NVObject.h"
#import "NVInterpreter.h"
#import "NVFrame.h"
#import "NVAST.h"

@implementation NVObject
- (NSString *)getDescription {
    return [self description];
}
@end

@implementation NVNativeObject

- (BOOL)invokeMethod:(NSString *)methodName arguments:(NSArray<NVStackElement *> *)arguments lastStack:(NVStack *)lastStack {
    NVASTFunctionDefinition *funcDef = [self.classDefinition.methods objectForKey:methodName].method;
    
    NVFrame *frame = [[NVFrame alloc] init];
    
    for (int i = 0; i < arguments.count; i++) {
        NVStackElement *var = arguments[i];
        [frame.localVariableMap setObject:var forKey:funcDef.parameters[i].name];
    }
    
    if (![[NVInterpreter defaultInterperter] visit:funcDef.block
                                             frame:frame]) {
        return NO;
    }
    
    if (frame.stack.count > 0) {
        [lastStack addObject:frame.stack.top];
    }
    
    return YES;
}

- (NVStackElement *)getAttribute:(NSString *)attributeName {
    return self.fieldMap[attributeName];
}

- (void)setAttribute:(NSString *)attributeName value:(NVStackElement *)value {
    self.fieldMap[attributeName] = value;
}

@end

@implementation NVCapturedObject
@end

@implementation NVLambdaObject

- (id)initWithLambdaExpression:(NVLambdaExpression *)lambdaExpr {
    self = [super init];
    
    self.lambdaExpression = lambdaExpr;
    
    return self;
}

- (void)addCaptured:(NVCapturedObject *)capuredObj {
    [self.capturedObjects addObject:capuredObj];
}

- (NSMutableArray<NVCapturedObject *> *)capturedObjects {
    if (_capturedObjects) {
        _capturedObjects = [NSMutableArray array];
    }
    
    return _capturedObjects;
}

- (NVObject *)copy {
    NVLambdaObject *copy = [[NVLambdaObject alloc] initWithLambdaExpression:self.lambdaExpression];
    
    for (NVCapturedObject *c in self.capturedObjects) {
        NVCapturedObject *captured = [[NVCapturedObject alloc] init];
        captured.signature = 0;
        captured.name = c.name;
        captured.object = c.object;
        
        [copy addCaptured:captured];
    }
    
    return copy;
}

@end

@implementation NVStackPointerElement

- (id)initWithObject:(NVObject *)obj {
    self = [super init];
    
    _object = obj;
    
    return self;
}

- (NVStackElement *)doOperator:(NSString *)op rightOperand:(NVStackElement *)rightOperand {
    if ([op isEqualToString:@"=="]) {
        if ([rightOperand.type isEqualToString:@"int"]) {
            NVInt ret = ( [self toInt] == [rightOperand toInt]);
            return [[NVStackIntElement alloc] initWithInt:ret];
        }
    }
    
    return rightOperand;
}

- (NVStackElement *)getAttribute:(NSString *)attrName {
    return [self.object getAttribute:attrName];
}

- (void)setAttribute:(NSString *)attributeName value:(NVStackElement *)value {
    [self.object setAttribute:attributeName value:value];
}

- (NVInt)toInt {
    return [self.object toInt];
}

- (NVFloat)toFloat {
    return 0;
}

- (NSString *)toString {
    return [self.object getDescription];
}

- (NVStackElement *)copy {
    return [[NVStackPointerElement alloc] initWithObject:self.object];
}

- (BOOL)invokeMethod:(NSString *)methodName arguments:(NSArray<NVStackElement *> *)arguments lastStack:(NVStack *)lastStack {
    return [self.object invokeMethod:methodName arguments:arguments lastStack:lastStack];
}

@end

@implementation NSObject (NVObject)

- (void)throw_exception:(NVException *)e {
    
}

@end

BOOL isPrimitiveType(NSString *type) {
    if ([type isEqualToString:@"int"]
        || [type isEqualToString:@"float"]
        || [type isEqualToString:@"string"]) {
        return YES;
    }
    
    return NO;
}
