//
//  NVParser.m
//  NaiveC
//
//  Created by liangzhiyuan on 2021/11/18.
//  Copyright © 2021 Ogreaxe. All rights reserved.
//

#import "NVParser.h"

#define PUSH_INDEX int _saved_temp_index = _index;
#define POP_INDEX {_index = _saved_temp_index; _word = _tokens[_index].token;}

#define PUSH_INDEX2 int _saved_temp_index2 = _index;
#define POP_INDEX2 {_index = _saved_temp_index2; _word = _tokens[_index].token;}

typedef NVExpression *(^BinParserFunc)(void);

@interface NVParser ()

@property (nonatomic) NVASTRoot *pRoot;

@property (nonatomic) NSSet<NSString *> *keywords;

@property (nonatomic) BOOL lambdaFlag;  //indicate a lambda parse phrase start
@property (nonatomic) NSMutableArray<NSString *> *lambdaCapturedSymbols;

@end

@implementation NVParser

- (id)init {
    self = [super init];
    self.index = 0;
    return self;
}

- (NSSet<NSString *> *)keywords {
    static NSSet<NSString *> *g_keywords = nil;
    if (!g_keywords) {
        g_keywords = [NSSet setWithArray:@[
            //types
            @"int",@"float",@"string",@"void",
            //operator
            @"=",@"+=",@"-=",@"*=",@"/=",@"++",
            @"+",@"-",@"*",@"/",
            @"%",@".",@"|",@"&",@"||",@"&&",@"!",
            //paren
            @"{",@"}",@"(",@")",@"[",@"]",
            //comma
            @",",
            @"^",
            //statement
            @"if",@"else",
            @"while",@"for",
            @"break",@"continue",
            @"return",
        ]];
    }
    
    return g_keywords;
}

- (NVASTRoot *)root {
    return _pRoot;
}

- (id)initWithTokens:(NSArray<NVToken *> *)tokens {
    self = [super init];
    
    [self parse:tokens];
    
    return self;
}

/*
 helper functions
 */
bool isAssignOperator(NSString *op) {
    static NSArray<NSString *> *g_opList = nil;
    if (!g_opList) {
        g_opList = @[@"=", @"+=", @"-=", @"*=", @"=", @"/="];
    }
    
    return [g_opList containsObject:op];
}

bool isIntegerLiteral(NSString *word, int *num){
    return [[NSScanner scannerWithString:word] scanInt:num];
}

bool isFloatLiteral(NSString *word, float *num){
    if ([word rangeOfString:@"."].location == NSNotFound) {
        return NO;
    }
    
    return [[NSScanner scannerWithString:word] scanFloat:num];
}

bool isStringLiteral(NSString *word){
    if(word.length >= 2
       && [word characterAtIndex:0] == '"'
       && [word characterAtIndex:word.length - 1] == '"'){
//        if (parsed) {
//            *parsed = [word substringWithRange:NSMakeRange(1, word.length - 2)];
//        }
        
        return YES;
    }
    
    return NO;
}

- (BOOL)parse:(NSArray<NVToken *> *)tokens {
    self.tokens = tokens;
    
    if (self.tokens.count <= 0) {
        return NO;
    }
    
    NSLog(@"parsing tokens :");
    for (NVToken *token in self.tokens) {
        NSLog(@"%@ ", token.token);
    }

    self.index = 0;
    self.word = tokens[0].token;
    
    self.pRoot = [[NVASTRoot alloc] init];
    
    BOOL parseOK = NO;
    
    do {
        parseOK = NO;
        
        PUSH_INDEX
        
        NVASTFunctionDefinition *pFunc = [self function_definition];
        if (pFunc) {
            [_pRoot.functionList addObject:pFunc];
            parseOK = true;
            continue;
        }
        
        POP_INDEX
        
        
        NVClassDeclaration *pClass = [self class_definition];
        if (pClass) {
            [_pRoot.classList addObject:pClass];
            parseOK = YES;
            continue;
        }
        
    } while (parseOK);
    
    NSLog(@"parse %lu classes\n", _pRoot.classList.count);
    NSLog(@"parse %lu functions\n", _pRoot.functionList.count);
    
    if (_pRoot.functionList.count == 0) {
//        NCLog(NCLogTypeParser, "parse fail");
    }
    
    return YES;
}

- (NVClassDeclaration *)class_definition {
    NVClassDeclaration *clsDecl = [[NVClassDeclaration alloc] init];
    
    if (![_word isEqualToString:@"class"]) {
        return nil;
    }
    _word = [self nextWord];
    
    if (![self isIdentifier:_word]) {
        return nil;
    }
    
    clsDecl.name = _word;
    _word = [self nextWord];
    
    if ([_word isEqualToString:@":"]) {
        _word = [self nextWord];
        
        if (![self isIdentifier:_word]) {
            return nil;
        }
        
        clsDecl.parent = _word;
        _word = [self nextWord];
    }
    
    if (![self class_body:clsDecl.members]) {
        return nil;
    }
    
    for (NVBodyDeclaration *member in clsDecl.members) {
        if ([member isKindOfClass:NVFieldDeclaration.class]) {
            [clsDecl.fields addObject:(NVFieldDeclaration *)member];
        }
        else if ([member isKindOfClass:NVMethodDeclaration.class]) {
            NVMethodDeclaration *methodDecl = (NVMethodDeclaration *)member;
            [clsDecl.methods setObject:methodDecl forKey:methodDecl.method.name];
        }
    }
    
    return clsDecl;
}

- (BOOL)class_body:(NSMutableArray<NVBodyDeclaration *> *)members {
    if (![_word isEqualToString:@"{"]) {
        return false;
    }
    
    _word = [self nextWord];
    
    while (![_word isEqualToString:@"}"]) {
        NVBodyDeclaration *member = [self class_body_declaration];
        if (!member) {
            return false;
        }
        
        [members addObject:member];
    }
    
    _word = [self nextWord];
    return true;
}

- (NVBodyDeclaration *)class_body_declaration {
    PUSH_INDEX
    
    NVASTFunctionDefinition *funcDef = [self function_definition];
    if (funcDef) {
        NVMethodDeclaration *methodDef = [[NVMethodDeclaration alloc] init];
        methodDef.method = funcDef;
        return methodDef;
    }
    
    POP_INDEX
    
    NSString *name;
    NVExpression *fieldExpr = [self field_expression:name];
    if (fieldExpr) {
        NVFieldDeclaration *field = [[NVFieldDeclaration alloc] init];
        field.declarator = fieldExpr;
        field.name = name;
        return field;
    }
    
    POP_INDEX
    
    return [self constructor_definition];
}

- (NVExpression *)field_expression:(NSString *)name {
//    if (!isIdentifier(word)) {
//        return nullptr;
//    }
    NSString *fname = _word;
    _word = [self nextWord];
    
    if (![_word isEqualToString:@"="]) {
        return nil;
    }
    
    _word = [self nextWord];
    NVExpression *initExpr = [self expression];
    if (!initExpr) {
        return nil;
    }
    
//    auto fieldExpr = new NCAssignExpr(shared_ptr<NCNameExpression>(new NCNameExpression(fname)),"=",initExpr);
    
    name = fname;
    
    return initExpr;
}

- (NVConstructorDeclaration *)constructor_definition {
    //todo
    return nil;
}

- (NVASTFunctionDefinition *)function_definition{
    
    NVASTFunctionDefinition *function = [[NVASTFunctionDefinition alloc] init];
    
    function.return_type = [self type_specifier];
    
    if (function.return_type.length == 0) {
        return NULL;
    }
    if ([self isIdentifier:_word]) {
        function.name = _word;
        _word = [self nextWord];
    }
    else {
        return NULL;
    }
    
    if (![_word isEqualToString:@"("]) {
        return NULL;
    }
    else {
        _word = [self nextWord];
    }
    
    if (![_word isEqualToString:@")"]) {
        NSMutableArray<NVParameter *> *plist = [NSMutableArray array];
        
        if (![self parameterlist:plist]) {
            return nil;
        }
        
        function.parameters = plist;
        
        if (![_word isEqualToString:@")"]) {
            return nil;
        }
    }
    
    _word = [self nextWord];
    
//    vector<AstNodePtr> statements;
    NVBlock *block_ = [self block];
    if (!block_)  {
        return nil;
    }
    
    function.block = block_;
    
    return function;
}

- (NVType)type_specifier{
    if (_word.length <= 0) {
        return @"";
    }
    
    char firstChar = [_word characterAtIndex:0];
    
    if ([_word isEqualToString:@"string"]
        || [_word isEqualToString:@"int"]
        || [_word isEqualToString:@"float"]
        || [_word isEqualToString:@"void"]) {
        
        NSString *ret = _word;
        _word = [self nextWord];
        return ret;
    }
    else if ((firstChar >= 'a' && firstChar <= 'z')
            || (firstChar >= 'A' && firstChar <= 'Z')
            || firstChar == '_') {
        if ([self.keywords containsObject:self.word]){
            return @"";
        }
 
        NSString *ret = _word;
        _word = [self nextWord];
        return ret;
    }
    
    return @"";
}

- (NSString *)nextWord {
    _index ++;
    
    NSAssert(_index < self.tokens.count, @"parse fail:tokens exceeded");
    
    return self.tokens[_index].token;
}

- (BOOL)isIdentifier:(NSString *)word {
    return ![self.keywords containsObject:word];
}

- (NSString *)peek:(int)n {
    if (_index + n <= self.tokens.count - 1) {
        return self.tokens[_index + n].token;
    }
    return @"";
}

- (BOOL)parameterlist:(NSMutableArray<NVParameter *> *)parameters {
    NVParameter *para = [self parameter];
    
    if (!para){
        return NO;
    }
    
    [parameters addObject:para];
    
    while ([_word isEqualToString:@","]) {
        _word = [self nextWord];
        
        para = [self parameter];
        
        if(!para){
            return NO;
        }
        
        [parameters addObject:para];
    }
    
    return YES;
}

- (NVParameter *)parameter {
    NSString *peek1 = [self peek:1];
    
    if ([peek1 isEqualToString:@","]
        || [peek1 isEqualToString:@")"]) {
        if ([self isIdentifier:_word]) {
            //type is not specified
            NVParameter *p = [[NVParameter alloc] initWithName:_word];
            _word = [self nextWord];
            
            return p;
        }
        
        return nil;
    }
    
    NSString *type = [self type_specifier];
    
    if (type.length == 0) {
        return nil;
    }
    
    if (![self isIdentifier:_word]) {
        return nil;
    }
    
    NVParameter * pp = [[NVParameter alloc] init];
    
    pp.type = type;
    pp.name = _word;
    
    _word = [self nextWord];
    
    return pp;
}

- (NVBlock *)block {
    NSMutableArray<NVASTNode *> *stmts = [NSMutableArray array];
    
    if ([_word isEqualToString:@"{"]) {
        _word = [self nextWord];
        
        if(![self statements:stmts]){
            return nil;
        }
        
        if (![_word isEqualToString:@"}"]) {
            return nil;
        }
        
        _word = [self nextWord];
        
        NVBlock *retBlock = [[NVBlock alloc] init];
        retBlock.statement_list = stmts;
        
        return retBlock;
    }
    
    return nil;
}

- (BOOL)statements:(NSMutableArray<NVASTNode *> *)statements {
    while (1) {
//        pushIndex();
        PUSH_INDEX
        
        NVStatement *statement = [self blockStatement];
        if (!statement) {
//            popIndex();
            POP_INDEX
            
            break;
        }
        [statements addObject:statement];
    }
    
    return YES;
}

- (NVStatement *)blockStatement {
//    pushIndex();
    PUSH_INDEX
    
    NVExpression *varDecStmt = [self variable_declaration_expression];
    if (!varDecStmt) {
//        popIndex();
        POP_INDEX
        return [self statement];
    }
    
    NVBlockStatement *statment = [[NVBlockStatement alloc] init];
    statment.expression = varDecStmt;
    
    return statment;
}

- (NVExpression *)variable_declaration_expression {
    NVVariableDeclarationExpression *varExprStmt = [[NVVariableDeclarationExpression alloc] init];
    
    NSString *type = [self type_specifier];
    if (type.length == 0) {
        return nil;
    }
    
    varExprStmt.type = type;
    
    NVExpression *declarator = [self variable_declarator];
    if (!declarator) {
        return nil;
    }
    
    while (declarator) {
        [varExprStmt.variables addObject:declarator];
        
        if ([_word isEqualToString:@","]) {
            declarator = [self variable_declarator];
            if (!declarator) {
                return nil;
            }
        }
        else {
            break;
        }
    }
    
    return varExprStmt;
}

- (NVExpression *)variable_declarator {
    NVVariableDeclarator *variableDeclarator = [[NVVariableDeclarator alloc] init];
    
    NVPair<NSString *, NSArray<NVArrayBracketPair *> *> *varDecId = [self variable_declarator_id];
    if (varDecId.first.length == 0) {
        return nil;
    }
    variableDeclarator.Id = varDecId;
    
    if (![_word isEqualToString:@"="]) {
        return variableDeclarator;
    }
    
    _word = [self nextWord];
    NVExpression *expr = [self variable_initializer];
    if (!expr) {
        return nil;
    }
    
    variableDeclarator.expression = expr;
    return  variableDeclarator;
}

- (NVPair<NSString *, NSArray<NVArrayBracketPair *> *> *)variable_declarator_id{
    // array [] currently ignored
    NSMutableArray<NVArrayBracketPair *> *brackets = [NSMutableArray array];
    
    if (![self isIdentifier:_word]) {
        return [NVPair makePair:@"" second:brackets];
    }
    
    NSString *w = _word;
    _word = [self nextWord];
    
    return [NVPair makePair:w second:brackets];
}

- (NVExpression *)variable_initializer {
    NVExpression *arrayInitializer = [self array_initializer];
    
    if (arrayInitializer) {
        return arrayInitializer;
    }
    
    return [self expression];
}

- (NVExpression *)array_initializer {
    if (![_word isEqualToString:@"{"]) {
        return nil;
    }
    
    _word = [self nextWord];
    
    NVArrayInitializer *arrayInitializer = [[NVArrayInitializer alloc] init];
    
    if (![self arguments:arrayInitializer.elements]) {
        return nil;
    }
    
    if (![_word isEqualToString:@"}"]) {
        return nil;
    }
    
    _word = [self nextWord];
    
    return arrayInitializer;
}

- (NVExpression *)expression {
    return [self conditional_expression];
}

- (BOOL)expression_list:(NSMutableArray<NVExpression *> *)exprList{
    NVExpression *ret = [self expression];
    if (!ret) {
        return NO;
    }
    
    [exprList addObject:ret];
    
    while (1) {
        if (![_word isEqualToString:@","]) {
            return YES;
        }
        
        _word = [self nextWord];
        
        ret = [self expression];
        if (!ret) {
            return NO;
        }
        
        [exprList addObject:ret];
    }
    
    return YES;
}

- (BOOL)arguments:(NSMutableArray<NVExpression *> *)args {
    NVExpression *arg = [self expression];
    if (!arg) {
        return NO;
    }
    
    while (arg) {
        [args addObject:arg];
        
        if (![_word isEqualToString:@","]) {
            return YES;
        }
        
        _word = [self nextWord];
        
        arg = [self expression];
        if (!arg) {
            return NO;
        }
    }
    
    return YES;
}

- (NVExpression *)multiplicative_expression {
//    return parseBinExpr({"|"}, std::bind(&NCParser::exclusive_or_expression, this));
    return [self parseBinExpr:@[@"*", @"/", @"%"] binParserFunc:^NVExpression *{
        return [self unary_expression];
    }];
}

- (NVExpression *)additive_expression {
//    return parseBinExpr({"|"}, std::bind(&NCParser::exclusive_or_expression, this));
    return [self parseBinExpr:@[@"+", @"-"] binParserFunc:^NVExpression *{
        return [self multiplicative_expression];
    }];
}

- (NVExpression *)shift_expression {
//    return parseBinExpr({"|"}, std::bind(&NCParser::exclusive_or_expression, this));
    return [self additive_expression];
}

- (NVExpression *)relational_expression {
//    return parseBinExpr({"|"}, std::bind(&NCParser::exclusive_or_expression, this));
    return [self parseBinExpr:@[@">", @"<", @">=", @"<="] binParserFunc:^NVExpression *{
        return [self shift_expression];
    }];
}

- (NVExpression *)equality_expression {
//    return parseBinExpr({"|"}, std::bind(&NCParser::exclusive_or_expression, this));
    return [self parseBinExpr:@[@"==", @"!="] binParserFunc:^NVExpression *{
        return [self relational_expression];
    }];
}

- (NVExpression *)and_expression {
//    return parseBinExpr({"|"}, std::bind(&NCParser::exclusive_or_expression, this));
    return [self parseBinExpr:@[@"&"] binParserFunc:^NVExpression *{
        return [self equality_expression];
    }];
}

- (NVExpression *)exclusive_or_expression {
//    return parseBinExpr({"|"}, std::bind(&NCParser::exclusive_or_expression, this));
    return [self parseBinExpr:@[@"^"] binParserFunc:^NVExpression *{
        return [self and_expression];
    }];
}

- (NVExpression *)inclusive_or_expression {
//    return parseBinExpr({"|"}, std::bind(&NCParser::exclusive_or_expression, this));
    return [self parseBinExpr:@[@"&&"] binParserFunc:^NVExpression *{
        return [self exclusive_or_expression];
    }];
}

- (NVExpression *)logical_and_expression {
//    return parseBinExpr({"&&"}, std::bind(&NCParser::inclusive_or_expression, this));
    return [self parseBinExpr:@[@"&&"] binParserFunc:^NVExpression *{
        return [self inclusive_or_expression];
    }];
}

- (NVExpression *)logical_or_expression {
    return [self parseBinExpr:@[@"||"] binParserFunc:^NVExpression *{
        return [self logical_and_expression];
    }];
}

- (NVExpression *)conditional_expression {
    //currently not support A?B:C
    NVExpression *expr = [self logical_or_expression];
    if (!expr) {
        return nil;
    }
    
    if (isAssignOperator(_word)) {
        NSString *op = _word;
        _word = [self nextWord];
        NVExpression *value = [self expression];
        
        if (!value) {
            return nil;
        }
        
        return [[NVAssignExpr alloc] initWithExpr:expr op:op value:value];
    }
    else {
        return expr;
    }
}

- (NVExpression *)parseBinExpr:(NSArray<NSString *> *)operators binParserFunc:(BinParserFunc )nextParseFunc{
    NVExpression *left = nextParseFunc();
    if (!left) {
        return nil;
    }

    if (![operators containsObject:_word]) {
        return left;
    }
    
    NSString *op = _word;
    
//    auto left = shared_ptr<NCBinaryExpression>(new NCBinaryExpression());
//    left->left = _left;
//    left->op = word;
    
    _word = [self nextWord];
    
//    pushIndex();
    PUSH_INDEX
    
    NVExpression *right = nextParseFunc();
    if (!right) {
//        popIndex();
        POP_INDEX
        return left;
    }
    
    while (right) {
        left = [self left:left addRight:right operator:op];
        
        if (![operators containsObject:_word]) {
            break;
        }
        
        op = _word;
        _word = [self nextWord];
        
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

- (NVExpression *)unary_expression {
    if ([_word isEqualToString:@"+"]
        || [_word isEqualToString:@"-"]
        || [_word isEqualToString:@"!"]) {
        NSString *op = _word;
        _word = [self nextWord];
        
        NVUnaryExpression *unaryExp = [[NVUnaryExpression alloc] init];
        NVExpression *exp = [self unary_expression];
        if (!exp) {
            return nil;
        }
        unaryExp.op = op;
        unaryExp.expression = exp;
        
        return unaryExp;
    }
    else {
        return [self primary_expression];
    }
}

- (NVExpression *)primary_expression {
    NVExpression *prefix = [self primary_prefix];
    if (!prefix) {
        return nil;
    }
    
//    pushIndex();
    PUSH_INDEX
    
    NVExpression *ret = [self primary_suffix:prefix];
    if (!ret) {
//        popIndex();
        POP_INDEX
        return prefix;
    }
    
    while (1) {
//        pushIndex();
        PUSH_INDEX2
        
        NVExpression *tmpRet = ret;
        ret = [self primary_suffix:ret];
        
        if (!ret) {
//            popIndex();
            POP_INDEX2
            return tmpRet;
        }
    }
}

- (NVExpression *)primary_prefix {
    //literal
//    pushIndex();
    PUSH_INDEX
    
    NVExpression *ret = [self literal];
    if (ret) {
        return ret;
    }
    
    // '(' expression ')'
//    popIndex();
    POP_INDEX
    
    if ([_word isEqualToString:@"("]) {
        _word = [self nextWord];
        
        NVExpression *exp = [self expression];
        if (![_word isEqualToString:@")"]) {
//            popIndex();
            return nil;
        }
        
        _word = [self nextWord];
        
        return exp;
    }
    
    if ([_word isEqualToString:@"["]) {
        NVExpression *objcSendMsgExpr = [self objc_send_message];
        return objcSendMsgExpr;
    }
    
    // name [call(args)]
    if ([self isIdentifier:_word]) {
        NSString *name = _word;
        _word = [self nextWord];
        
        NSMutableArray<NVExpression *> *args = [NSMutableArray array];
        //    pushIndex();
        PUSH_INDEX2
        
        if (![self arguments_expression:args]) {
            //        popIndex();
            POP_INDEX2
            
            if (_lambdaFlag) {
                [self.lambdaCapturedSymbols addObject:name];
            }
            
            return [[NVNameExpression alloc] initWithName:name];
        }
        
        return [[NVMethodCallExpr alloc] initWithArgs:args name:name scope:nil];
    }
    
    if ([_word isEqualToString:@"{"]) {
        NVExpression *arrayInitor = [self array_initializer];
        if (arrayInitor) {
            return arrayInitor;
        }
    }
    
    if ([_word isEqualToString:@"^"]) {
        //lambda
        NVLambdaExpression *lambdaExpr = [[NVLambdaExpression alloc] init];
        
        _word = [self nextWord];
        
        if ([_word isEqualToString:@"("]) {
            _word = [self nextWord];
            
            if (![self parameterlist:lambdaExpr.parameters]) {
                return nil;
            }
            
            if (![_word isEqualToString:@")"]) {
                return nil;
            }
            
            _word = [self nextWord];
        }
        
        _lambdaFlag = YES;
        [_lambdaCapturedSymbols removeAllObjects];
        
        NVBlock *blockSmt = [self block];
        if (!blockSmt) {
            _lambdaFlag = NO;
            return nil;
        }
        
        _lambdaFlag = NO;
        
        lambdaExpr.capturedSymbols = _lambdaCapturedSymbols;
        lambdaExpr.blockStmt = blockSmt;
        return lambdaExpr;
    }
    
    return nil;
}

- (BOOL)arguments_expression:(NSMutableArray<NVExpression *> *)args {
    if (![_word isEqualToString:@"("]) {
        return NO;
    }
    
    _word = [self nextWord];
    
    if ([_word isEqualToString:@")"]) {
        //empty arguments
        _word = [self nextWord];
        return YES;
    }
    
    if (![self arguments:args]) {
        return NO;
    }
    
    if (![_word isEqualToString:@")"]) {
        return NO;
    }
    
    _word = [self nextWord];
    
    return YES;
}

- (NVExpression *)primary_suffix:(NVExpression *)scope {
    if ([_word isEqualToString:@"."]) {
        _word = [self nextWord];
        
        if ([self isIdentifier:_word]) {
            NSString *name = _word;
            _word = [self nextWord];
            
            NSMutableArray<NVExpression *> *args = [NSMutableArray array];
            if ([self arguments_expression:args]) {
                return [[NVMethodCallExpr alloc] initWithArgs:args name:name scope:scope];
            }
            else {
                return [[NVFieldAccessExpr alloc] initWithScope:scope field:name];
            }
        }
    }
    else if([_word isEqualToString:@"["]){
        _word = [self nextWord];
        
        NVExpression *exp = [self expression];
        if (exp) {
            if ([_word isEqualToString:@"]"]) {
                _word = [self nextWord];
                
                return [[NVArrayAccessExpr alloc] initWithScope:scope expression:exp];
            }
        }
        
    }
    
    return nil;
}

- (NVExpression *)literal {
    int intNum;
    float fNum;
    
    if (isFloatLiteral(_word, &fNum)) {
        _word = [self nextWord];
        return [[NVFloatLiteral alloc] initWithFloat:fNum];
    }
    else if (isIntegerLiteral(_word, &intNum)) {
        _word = [self nextWord];
        return [[NVIntegerLiteral alloc] initWithInt:intNum];
    }
    else if (isStringLiteral(_word)) {
        NSString *str = [_word substringWithRange:NSMakeRange(1, _word.length - 2)];
        _word = [self nextWord];
        return [[NVStringLiteral alloc] initWithString:str];
    }
    
    return nil;
}

- (NVBinaryExpression *)left:(NVExpression *)left addRight:(NVExpression *)right operator:(NSString *)op {
    NVBinaryExpression *binExpr = [[NVBinaryExpression alloc] init];
    binExpr.op = op;
    binExpr.left = left;
    binExpr.right = right;
    return binExpr;
}

- (NVStatement *)statement{
    
//    pushIndex();
    PUSH_INDEX
    
    NVStatement *stmt = [self block];
    if (stmt) {
        return stmt;
    }
    
//    popIndex();
    POP_INDEX
    stmt = [self selection_statement];
    if (stmt) {
        return stmt;
    }
    
//    popIndex();
    POP_INDEX
    stmt = [self while_statement];
    if (stmt) {
        return stmt;
    }
    
//    popIndex();
    POP_INDEX
    stmt = [self for_statement];
    if (stmt) {
        return stmt;
    }
    
//    popIndex();
    POP_INDEX
    stmt = [self expression_statement];
    if (stmt) {
        return stmt;
    }
    
//    popIndex();
    POP_INDEX
    stmt = [self break_statement];
    if (stmt) {
        return stmt;
    }
    
//    popIndex();
    POP_INDEX
    stmt = [self return_statement];
    if (stmt) {
        return stmt;
    }
    
    return nil;
}

- (NVStatement *)selection_statement {
    if ([_word isEqualToString:@"if"]) {
        _word = [self nextWord];
        
        if (![_word isEqualToString:@"("]) {
            return nil;
        }
        
        _word = [self nextWord];
        NVExpression *cond = [self expression];
        
        if (!cond) {
            return nil;
        }
        
        if (![_word isEqualToString:@")"]) {
            return nil;
        }
        
        _word = [self nextWord];
        
        NVStatement *stmt = [self statement];
        if (!stmt) {
            return nil;
        }
        
        if (![_word isEqualToString:@"else"]) {
            NVIfStatement *ifStmt = [[NVIfStatement alloc] init];
            ifStmt.condition = cond;
            ifStmt.thenStatement = stmt;
            
            return ifStmt;
        }
        else {
            _word = [self nextWord];
            
            NVStatement *elseStmt = [self statement];
            if (!elseStmt) {
                return nil;
            }
            
            NVIfStatement *ifStmt = [[NVIfStatement alloc] init];
            ifStmt.condition = cond;
            ifStmt.thenStatement = stmt;
            ifStmt.elseStatement = elseStmt;
            
            return ifStmt;
        }
    }
    
    return nil;
}

- (NVStatement *)while_statement {
    if ([_word isEqualToString:@"while"]) {
        _word = [self nextWord];
        
        if (![_word isEqualToString:@"("]) {
            return nil;
        }
        
        _word = [self nextWord];
        
        NVExpression *cond = [self expression];
        
        if (!cond) {
            return nil;
        }
        
        if (![_word isEqualToString:@")"]) {
            return nil;
        }
        
        _word = [self nextWord];
        
        NVStatement *stmt = [self statement];
        if (!stmt) {
            return nil;
        }
        
        NVWhileStatement *whileStmt = [[NVWhileStatement alloc] initWithCondition:cond
                                                                        statement:stmt];
        return whileStmt;
    }
    
    return nil;
}

- (NVStatement *)for_statement {
    if (![_word isEqualToString:@"for"]) {
        return nil;
    }
    
    NVForStatement *forStmt = [[NVForStatement alloc] init];
    
    _word = [self nextWord];
    
    if (![_word isEqualToString:@"("]) {
        return nil;
    }
    
    _word = [self nextWord];
    
//    pushIndex();
    PUSH_INDEX
    
    if ([self isIdentifier:_word]) {
        //try parse fast enumeration
        //for(e:array){ statements }
        NSString *enumerator = _word;
        
        _word = [self nextWord];
        
        if(![_word isEqualToString:@":"]){
            return nil;
        }
        
        _word = [self nextWord];
        
        NVExpression *expr = [self expression];
        
        if (![_word isEqualToString:@")"]) {
            return nil;
        }
        
        _word = [self nextWord];
        
        NVFastEnumeration *fastEnumeration = [[NVFastEnumeration alloc] init];
        fastEnumeration.enumerator = enumerator;
        fastEnumeration.expr = expr;
        
        forStmt.fastEnumeration = fastEnumeration;
        
        NVStatement *stmt = [self statement];
        if (!stmt) {
            return nil;
        }
        
        forStmt.body = stmt;
        return forStmt;
    }
    
    //not fast enumeration, fall back to normal parse
//    popIndex();
    POP_INDEX
    
    if(![self for_init:forStmt.forInit]){
        return nil;
    }
    
//    if (![_word isEqualToString:@";") {
//        return nil;
//    }
//    _word = [self nextWord];
    
    NVExpression *expr = [self expression];
    if (!expr) {
        return nil;
    }
    
    forStmt.expr = expr;
    
//    if (![_word isEqualToString:@";") {
//        return nil;
//    }
//    _word = [self nextWord];
    
    if(![self for_update:forStmt.update]){
        return nil;
    }
    
    if (![_word isEqualToString:@")"]) {
        return nil;
    }
    
    _word = [self nextWord];
    
    NVStatement *stmt = [self statement];
    if (!stmt) {
        return nil;
    }
    
    forStmt.body = stmt;
    return forStmt;
}

- (BOOL)for_init:(NSMutableArray<NVExpression *> *)init{
//    pushIndex();
    PUSH_INDEX
    
    NVExpression *expr = [self variable_declaration_expression];
    if (expr) {
        [init addObject:expr];
        return YES;
    }

    POP_INDEX
    
    if (![self expression_list:init]) {
        return NO;
    }
    
    return YES;
}

- (BOOL)for_update:(NSMutableArray<NVExpression *> *)update {
    return [self expression_list:update];
}

- (NVStatement *)break_statement {
    if ([_word isEqualToString:@"break"]) {
        _word = [self nextWord];
        return [[NVBreakStatement alloc] init];
    }
    
    return nil;
}

- (NVStatement *)continue_statement {
    if ([_word isEqualToString:@"continue"]) {
        _word = [self nextWord];
        return [[NVContinueStatement alloc] init];
    }
    
    return nil;
}

- (NVStatement *)expression_statement{
    NVExpression *expr = [self primary_expression];
    if (!expr) {
        return nil;
    }
    
    if (isAssignOperator(_word)) {
        _word = [self nextWord];
        
        NVExpression *value = [self expression];
        if (!value) {
            return nil;
        }
        
        NVAssignExpr *assignExpr = [[NVAssignExpr alloc] initWithExpr:expr
                                                                   op:_word
                                                                value:value];
        NVExpressionStatement *expStmt = [[NVExpressionStatement alloc] init];
        expStmt.expression = assignExpr;
        return expStmt;
    }
    else {
        NVExpressionStatement *expStmt = [[NVExpressionStatement alloc] init];
        expStmt.expression = expr;
        return expStmt;
    }
}

- (NVExpression *)objc_send_message {
    if (![_word isEqualToString:@"["]) {
        return nil;
    }
    
    _word = [self nextWord];
    
    NVExpression *scope = [self expression];
    if (!scope) {
        return nil;
    }
    
    NSMutableArray<NSString *> *parameter_list = [NSMutableArray array];
    NSMutableArray<NVExpression *> *argument_expression_list = [NSMutableArray array];
    
    if ([self isIdentifier:_word]
        && [[self peek:1] isEqualToString:@"]"]) {
            
        [parameter_list addObject:_word];
        
        _word = [self nextWord];
        _word = [self nextWord];
        
        return [[NVObjCSendMessageExpr alloc] initWithArgumentExprList:argument_expression_list
                                                         parameterList:parameter_list
                                                                 scope:scope];
    }
    
    while (1) {
        if (![self isIdentifier:_word]) {
            return nil;
        }
        
        [parameter_list addObject:_word];
        
        _word = [self nextWord];
        
        if (![_word isEqualToString:@":"]) {
            return nil;
        }
        
        _word = [self nextWord];
        
        NVExpression *aArgExpr = [self expression];
        
        if (!aArgExpr) {
            return nil;
        }
        
        [argument_expression_list addObject:aArgExpr];
        
        if ([_word isEqualToString:@"]"]) {
            break;
        }
    }
    
    _word = [self nextWord];
    
    return [[NVObjCSendMessageExpr alloc] initWithArgumentExprList:argument_expression_list
                                                     parameterList:parameter_list
                                                             scope:scope];
}

- (NVStatement *)return_statement{
    if ([_word isEqualToString:@"return"]) {
        _word = [self nextWord];
        
//        pushIndex();
        PUSH_INDEX
        
        NVExpression *exp = [self expression];
        if (!exp) {
//            popIndex();
            POP_INDEX
            return [[NVReturnStatement alloc] init];
        }
        else {
            return [[NVReturnStatement alloc] initWithExpression:exp];
        }
    }
    
    return nil;
}

@end
