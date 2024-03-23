//
//  NPEngine.m
//  NaivePatch
//
//  Created by mi on 2024/1/22.
//

#import "NPEngine.h"
#import "NPFunction.h"
#import <objc/runtime.h>
#import <objc/message.h>
#import "NCObjCSourceParser.h"
#import "NCCodeEngine_iOS.h"

#if TARGET_OS_IPHONE
#import <UIKit/UIApplication.h>
#endif

static NSMutableDictionary *_propKeys;
static NSMutableDictionary *_NCOverideMethods;
static NSMutableDictionary *_registeredStruct;
static NSMutableDictionary *_currInvokeSuperClsName;
static NSObject *_nilObj;
static NSLock              *_JSMethodSignatureLock;
static NSRecursiveLock     *_JSMethodForwardCallLock;
static NSMutableArray      *_pointersToRelease;

static NSMutableDictionary *_NPClassDefitions;

#ifdef DEBUG
static NSArray *_JSLastCallStack;
#endif

@implementation JPBoxing

#define JPBOXING_GEN(_name, _prop, _type) \
+ (instancetype)_name:(_type)obj  \
{   \
    JPBoxing *boxing = [[JPBoxing alloc] init]; \
    boxing._prop = obj;   \
    return boxing;  \
}

JPBOXING_GEN(boxObj, obj, id)
JPBOXING_GEN(boxPointer, pointer, void *)
JPBOXING_GEN(boxClass, cls, Class)
//JPBOXING_GEN(boxWeakObj, weakObj, id)
JPBOXING_GEN(boxAssignObj, assignObj, id)

+ (instancetype)boxWeakObj:(id)obj
{
    JPBoxing *boxing = [[JPBoxing alloc] init];
    boxing.weakObj = obj;
    return boxing;
}

- (id)unbox
{
    if (self.obj) return self.obj;
    if (self.weakObj) return self.weakObj;
    if (self.assignObj) return self.assignObj;
    if (self.cls) return self.cls;
    return self;
}
- (void *)unboxPointer
{
    return self.pointer;
}
- (Class)unboxClass
{
    return self.cls;
}
@end

static NSString *extractStructName(NSString *typeEncodeString)
{
    NSArray *array = [typeEncodeString componentsSeparatedByString:@"="];
    NSString *typeString = array[0];
    int firstValidIndex = 0;
    for (int i = 0; i< typeString.length; i++) {
        char c = [typeString characterAtIndex:i];
        if (c == '{' || c=='_') {
            firstValidIndex++;
        }else {
            break;
        }
    }
    return [typeString substringFromIndex:firstValidIndex];
}

@implementation NPEngine

+ (void)startEngine {
    _registeredStruct = [[NSMutableDictionary alloc] init];
    _currInvokeSuperClsName = [[NSMutableDictionary alloc] init];
}

+ (void)patchWithCode:(NSString *)code {
    NCObjCSourceParser *parser = [NCObjCSourceParser new];
    
    NSArray *patches = [parser extractPatchMethodFromContent:code];
    
    if (patches.count == 0) {
        NSLog(@"[Naive] Patch fail, nothing is patched, please check source code");
    }
    
    [self.class defineClasses:patches];
}

+ (void)defineClasses:(NSArray<NPPatchedClass *> *)classes {
    for (NPPatchedClass *cls in classes) {
        if (!_NPClassDefitions)_NPClassDefitions = [NSMutableDictionary dictionary];
        
        if (!cls.name)continue;
        
        if (!_NPClassDefitions[cls.name]) {
            _NPClassDefitions[cls.name] = cls;
        } else {
            [self.class mergeExitingClassDefinition:cls];
        }
        
        [self.class defineClass:cls.name
                instanceMethods:cls.patchedMethods
                   classMethods:cls.patchedClassMethods];
    }
}

NSArray * mergeArray(NSArray *oldArray, NSArray *newArray, NSString *keyName) {
    
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    
    for (id obj in oldArray) {
        NSString *key = [obj valueForKey:keyName];
        
        dict[key] = obj;
    }
    
    for (id obj in newArray) {
        NSString *key = [obj valueForKey:keyName];
        
        dict[key] = obj;
    }
    
    
    return dict.allValues;
}

+ (void)mergeExitingClassDefinition:(NPPatchedClass *)cls {
    NPPatchedClass *oldcls = _NPClassDefitions[cls.name];
    
    if (!oldcls)return;
    
//    oldcls.patchedMethods = [oldcls.patchedMethods arrayByAddingObjectsFromArray:cls.patchedMethods];
//    oldcls.patchedClassMethods = [oldcls.patchedClassMethods arrayByAddingObjectsFromArray:cls.patchedClassMethods];
//    oldcls.patchedProperties = [oldcls.patchedProperties arrayByAddingObjectsFromArray:cls.patchedProperties];
    
    oldcls.patchedMethods = mergeArray(oldcls.patchedMethods, cls.patchedMethods, @"selector");
    oldcls.patchedClassMethods = mergeArray(oldcls.patchedClassMethods, cls.patchedClassMethods, @"selector");
    oldcls.patchedProperties = mergeArray(oldcls.patchedProperties, cls.patchedProperties, @"name");
}

+ (NPPatchedProperty *)patchedPropertyForName:(NSString *)methodName withClass:(Class)cls {
    NSString *clsName = NSStringFromClass(cls);
    
    NPPatchedClass *patchedCls = _NPClassDefitions[clsName];
    
    for (NPPatchedProperty *property in patchedCls.patchedProperties) {
        if ([property.name isEqualToString:methodName]) {
            return property;
        }
    }
    
    return NULL;
}

+ (NSDictionary *)defineClass:(NSString *)classDeclaration
              instanceMethods:(NSArray<NPPatchedMethod *> *)instanceMethods
                 classMethods:(NSArray<NPPatchedMethod *> *)classMethods {
    return defineClass(classDeclaration, instanceMethods, classMethods);
}

+ (void)defineStruct:(NSDictionary *)defineDict
{
    [_registeredStruct setObject:defineDict forKey:defineDict[@"name"]];
}

+ (NSMutableDictionary *)registeredStruct
{
    return _registeredStruct;
}

static void (^_exceptionBlock)(NSString *log) = ^void(NSString *log) {
    NSCAssert(NO, log);
};

static NSDictionary *defineClass(NSString *classDeclaration, NSArray<NPPatchedMethod *> *instanceMethods, NSArray<NPPatchedMethod *> *classMethods)
{
    NSScanner *scanner = [NSScanner scannerWithString:classDeclaration];
    
    NSString *className;
    NSString *superClassName;
    NSString *protocolNames;
    [scanner scanUpToString:@":" intoString:&className];
    if (!scanner.isAtEnd) {
        scanner.scanLocation = scanner.scanLocation + 1;
        [scanner scanUpToString:@"<" intoString:&superClassName];
        if (!scanner.isAtEnd) {
            scanner.scanLocation = scanner.scanLocation + 1;
            [scanner scanUpToString:@">" intoString:&protocolNames];
        }
    }
    
    if (!superClassName) superClassName = @"NSObject";
    className = trim(className);
    superClassName = trim(superClassName);
    
    NSArray *protocols = [protocolNames length] ? [protocolNames componentsSeparatedByString:@","] : nil;
    
    Class cls = NSClassFromString(className);
    if (!cls) {
        Class superCls = NSClassFromString(superClassName);
        if (!superCls) {
            _exceptionBlock([NSString stringWithFormat:@"can't find the super class %@", superClassName]);
            return @{@"cls": className};
        }
        cls = objc_allocateClassPair(superCls, className.UTF8String, 0);
        objc_registerClassPair(cls);
    }
    
    if (protocols.count > 0) {
        for (NSString* protocolName in protocols) {
            Protocol *protocol = objc_getProtocol([trim(protocolName) cStringUsingEncoding:NSUTF8StringEncoding]);
            class_addProtocol (cls, protocol);
        }
    }
    
    for (int i = 0; i < 2; i ++) {
        BOOL isInstance = i == 0;
        NSArray<NPPatchedMethod *> *methods = isInstance ? instanceMethods: classMethods;
        
        Class currCls = isInstance ? cls: objc_getMetaClass(className.UTF8String);
        
        for (NPPatchedMethod *method in methods) {
                        
            if (![[NCCodeEngine_iOS defaultEngine] canParseMethod:method error:nil]) {
                NSLog(@"[Naive] fail to parse method %@", method.selector);
                continue;
            }
            
            //todo init ncMethod
            NPFunction *ncMethod = [[NPFunction alloc] init];
//            ncMethod.code = method.body;
            ncMethod.method = method;
            
            if (class_respondsToSelector(currCls, NSSelectorFromString(method.selector))) {
                overrideMethod(currCls, method.selector, ncMethod, !isInstance, NULL);
            } else {
                NSLog(@"[Naive] define method not exist:(%@)-->(%@)",currCls, method.selector);
                NSLog(@"[Naive] add new method ..");
                      
                NSMutableString *typeDescStr = [@"@@:" mutableCopy];
                for (int i = 1; i < method.parameterPairs.count; i ++) {
                    [typeDescStr appendString:@"@"];
                }
                overrideMethod(currCls, method.selector, ncMethod, !isInstance, [typeDescStr cStringUsingEncoding:NSUTF8StringEncoding]);
                
//                BOOL overrided = NO;
//                for (NSString *protocolName in protocols) {
//                    char *types = methodTypesInProtocol(protocolName, selectorName, isInstance, YES);
//                    if (!types) types = methodTypesInProtocol(protocolName, selectorName, isInstance, NO);
//                    if (types) {
//                        overrideMethod(currCls, selectorName, jsMethod, !isInstance, types);
//                        free(types);
//                        overrided = YES;
//                        break;
//                    }
//                }
//                if (!overrided) {
//                    if (![[jsMethodName substringToIndex:1] isEqualToString:@"_"]) {
//                        NSMutableString *typeDescStr = [@"@@:" mutableCopy];
//                        for (int i = 0; i < numberOfArg; i ++) {
//                            [typeDescStr appendString:@"@"];
//                        }
//                        overrideMethod(currCls, selectorName, jsMethod, !isInstance, [typeDescStr cStringUsingEncoding:NSUTF8StringEncoding]);
//                    }
//                }
            }
        }
    }
    
    class_addMethod(cls, @selector(getProp:), (IMP)getPropIMP, "@@:@");
    class_addMethod(cls, @selector(setProp:forKey:), (IMP)setPropIMP, "v@:@@");

    return @{@"cls": className, @"superCls": superClassName};
}

static void _initJPOverideMethods(Class cls) {
    if (!_NCOverideMethods) {
        _NCOverideMethods = [[NSMutableDictionary alloc] init];
    }
    if (!_NCOverideMethods[cls]) {
        _NCOverideMethods[(id<NSCopying>)cls] = [[NSMutableDictionary alloc] init];
    }
}

static void overrideMethod(Class cls, NSString *selectorName, NPFunction *function, BOOL isClassMethod, const char *typeDescription)
{
    SEL selector = NSSelectorFromString(selectorName);
    
    if (!typeDescription) {
        Method method = class_getInstanceMethod(cls, selector);
        typeDescription = (char *)method_getTypeEncoding(method);
    }
    
    IMP originalImp = class_respondsToSelector(cls, selector) ? class_getMethodImplementation(cls, selector) : NULL;
    
    IMP msgForwardIMP = _objc_msgForward;
    #if !defined(__arm64__)
        if (typeDescription[0] == '{') {
            //In some cases that returns struct, we should use the '_stret' API:
            //http://sealiesoftware.com/blog/archive/2008/10/30/objc_explain_objc_msgSend_stret.html
            //NSMethodSignature knows the detail but has no API to return, we can only get the info from debugDescription.
            NSMethodSignature *methodSignature = [NSMethodSignature signatureWithObjCTypes:typeDescription];
            if ([methodSignature.debugDescription rangeOfString:@"is special struct return? YES"].location != NSNotFound) {
                msgForwardIMP = (IMP)_objc_msgForward_stret;
            }
        }
    #endif

    if (class_getMethodImplementation(cls, @selector(forwardInvocation:)) != (IMP)JPForwardInvocation) {
        IMP originalForwardImp = class_replaceMethod(cls, @selector(forwardInvocation:), (IMP)JPForwardInvocation, "v@:@");
        if (originalForwardImp) {
            class_addMethod(cls, @selector(ORIGforwardInvocation:), originalForwardImp, "v@:@");
        }
    }

    if (class_respondsToSelector(cls, selector)) {
        NSString *originalSelectorName = [NSString stringWithFormat:@"ORIG%@", selectorName];
        SEL originalSelector = NSSelectorFromString(originalSelectorName);
        if(!class_respondsToSelector(cls, originalSelector)) {
            class_addMethod(cls, originalSelector, originalImp, typeDescription);
        }
    }
    
    NSString *NPSelectorName = [NSString stringWithFormat:@"_NP%@", selectorName];
    
    _initJPOverideMethods(cls);
    _NCOverideMethods[cls][NPSelectorName] = function;
    
    // Replace the original selector at last, preventing threading issus when
    // the selector get called during the execution of `overrideMethod`
    class_replaceMethod(cls, selector, msgForwardIMP, typeDescription);
    
    NSLog(@"[Naive] finish patching %@", selectorName);
}

static NPFunction *getJSFunctionInObjectHierachy(id slf, NSString *selectorName)
{
    Class cls = object_getClass(slf);
    if (_currInvokeSuperClsName[selectorName]) {
        cls = NSClassFromString(_currInvokeSuperClsName[selectorName]);
        selectorName = [selectorName stringByReplacingOccurrencesOfString:@"_JPSUPER_" withString:@"_NP"];
    }
    NPFunction *func = _NCOverideMethods[cls][selectorName];
    while (!func) {
        cls = class_getSuperclass(cls);
        if (!cls) {
            return nil;
        }
        func = _NCOverideMethods[cls][selectorName];
    }
    return func;
}


static void JPForwardInvocation(__unsafe_unretained id assignSlf, SEL selector, NSInvocation *invocation)
{
    
#ifdef DEBUG
    _JSLastCallStack = [NSThread callStackSymbols];
#endif
    BOOL deallocFlag = NO;
    id slf = assignSlf;
    BOOL isBlock = [[assignSlf class] isSubclassOfClass : NSClassFromString(@"NSBlock")];
    
    NSMethodSignature *methodSignature = [invocation methodSignature];
    NSInteger numberOfArguments = [methodSignature numberOfArguments];
    NSString *selectorName = isBlock ? @"" : NSStringFromSelector(invocation.selector);
    NSString *JPSelectorName = [NSString stringWithFormat:@"_NP%@", selectorName];
    NPFunction *jsFunc = isBlock ? objc_getAssociatedObject(assignSlf, "_JSValue") : getJSFunctionInObjectHierachy(slf, JPSelectorName);
    if (!jsFunc) {
        JPExecuteORIGForwardInvocation(slf, selector, invocation);
        return;
    }
    
    NSMutableArray *argList = [[NSMutableArray alloc] init];
    if (!isBlock) {
        if ([slf class] == slf) {
//            [argList addObject:[JSValue valueWithObject:@{@"__clsName": NSStringFromClass([slf class])} inContext:_context]];
            [argList addObject:[JPBoxing boxClass:slf]];
        } else if ([selectorName isEqualToString:@"dealloc"]) {
            [argList addObject:[JPBoxing boxAssignObj:slf]];
            deallocFlag = YES;
        } else {
            [argList addObject:slf];
        }
    }
    
    for (NSUInteger i = isBlock ? 1 : 2; i < numberOfArguments; i++) {
        const char *argumentType = [methodSignature getArgumentTypeAtIndex:i];
        
        BOOL isRawPointer = NO; // int *, BOOL *
        if (argumentType[0] == '^') {
            //char type2 = argumentType[1];
            
            isRawPointer = YES;
        }
        
        switch((argumentType[0] == 'r' || argumentType[0] == '^' )? argumentType[1] : argumentType[0]) {
        
            #define JP_FWD_ARG_CASE(_typeChar, _type) \
            case _typeChar: {   \
                _type arg;  \
                if (!isRawPointer) {\
                    [invocation getArgument:&arg atIndex:i];    \
                    NPValue *npv = [NPValue numberWithNumber:@(arg) type:_typeChar]; \
                    [argList addObject:npv]; \
                }\
                else {\
                    void* arg; \
                    [invocation getArgument:&arg atIndex:i];\
                    long long adress = (long long)arg;\
NPValue *npv = [NPValue numberWithNumber:@(adress) type:_typeChar isPointer:YES]; \
                    npv.isRawPointer = isRawPointer;\
                    [argList addObject:npv]; \
                }\
                break;  \
            }
            JP_FWD_ARG_CASE('c', char)
            JP_FWD_ARG_CASE('C', unsigned char)
            JP_FWD_ARG_CASE('s', short)
            JP_FWD_ARG_CASE('S', unsigned short)
            JP_FWD_ARG_CASE('i', int)
            JP_FWD_ARG_CASE('I', unsigned int)
            JP_FWD_ARG_CASE('l', long)
            JP_FWD_ARG_CASE('L', unsigned long)
            JP_FWD_ARG_CASE('q', long long)
            JP_FWD_ARG_CASE('Q', unsigned long long)
            JP_FWD_ARG_CASE('f', float)
            JP_FWD_ARG_CASE('d', double)
            JP_FWD_ARG_CASE('B', BOOL)
            case '@': {
                __unsafe_unretained id arg;
                [invocation getArgument:&arg atIndex:i];
                if ([arg isKindOfClass:NSClassFromString(@"NSBlock")]) {
                    [argList addObject:(arg ? [arg copy]: _nilObj)];
                } else {
                    [argList addObject:(arg ? arg: _nilObj)];
                }
                break;
            }
            case '{': {
                NSString *typeString = extractStructName([NSString stringWithUTF8String:argumentType]);
                #define JP_FWD_ARG_STRUCT(_type, _transFunc) \
                if ([typeString rangeOfString:@#_type].location != NSNotFound) {    \
                    _type arg; \
                    [invocation getArgument:&arg atIndex:i];    \
                    [argList addObject:[NPValue _transFunc:arg]];  \
                    break; \
                }
                JP_FWD_ARG_STRUCT(CGRect, valueWithRect)
                JP_FWD_ARG_STRUCT(CGPoint, valueWithPoint)
                JP_FWD_ARG_STRUCT(CGSize, valueWithSize)
                JP_FWD_ARG_STRUCT(NSRange, valueWithRange)
                
//                @synchronized (_context) {
//                    NSDictionary *structDefine = _registeredStruct[typeString];
//                    if (structDefine) {
//                        size_t size = sizeOfStructTypes(structDefine[@"types"]);
//                        if (size) {
//                            void *ret = malloc(size);
//                            [invocation getArgument:ret atIndex:i];
//                            NSDictionary *dict = getDictOfStruct(ret, structDefine);
//                            [argList addObject:[JSValue valueWithObject:dict inContext:_context]];
//                            free(ret);
//                            break;
//                        }
//                    }
//                }
                
                break;
            }
            case ':': {
                SEL selector;
                [invocation getArgument:&selector atIndex:i];
                NSString *selectorName = NSStringFromSelector(selector);
                [argList addObject:(selectorName ? selectorName: _nilObj)];
                break;
            }
            case '^':
            case '*': {
                void *arg;
                [invocation getArgument:&arg atIndex:i];
                [argList addObject:[JPBoxing boxPointer:arg]];
                break;
            }
            case '#': {
                Class arg;
                [invocation getArgument:&arg atIndex:i];
                [argList addObject:[JPBoxing boxClass:arg]];
                break;
            }
            default: {
                NSLog(@"error type %s", argumentType);
                break;
            }
        }
    }
    
    if (_currInvokeSuperClsName[selectorName]) {
        Class cls = NSClassFromString(_currInvokeSuperClsName[selectorName]);
        NSString *tmpSelectorName = [[selectorName stringByReplacingOccurrencesOfString:@"_JPSUPER_" withString:@"_JP"] stringByReplacingOccurrencesOfString:@"SUPER_" withString:@"_JP"];
        if (!_NCOverideMethods[cls][tmpSelectorName]) {
#ifdef SHOW_TO_DO
            NSString *ORIGSelectorName = [selectorName stringByReplacingOccurrencesOfString:@"SUPER_" withString:@"ORIG"];
            [argList removeObjectAtIndex:0];
            id retObj = callSelector(_currInvokeSuperClsName[selectorName], ORIGSelectorName, [JSValue valueWithObject:argList inContext:_context], [JSValue valueWithObject:@{@"__obj": slf, @"__realClsName": @""} inContext:_context], NO);
            id __autoreleasing ret = formatJSToOC([JSValue valueWithObject:retObj inContext:_context]);
            [invocation setReturnValue:&ret];
            return;
#endif
        }
    }
    
//    NSArray *params = _formatOCToJSList(argList);
    NSArray *params = argList;
    char returnType[255];
    strcpy(returnType, [methodSignature methodReturnType]);
    
    // Restore the return type
//    if (strcmp(returnType, @encode(JPDouble)) == 0) {
//        strcpy(returnType, @encode(double));
//    }
//    if (strcmp(returnType, @encode(JPFloat)) == 0) {
//        strcpy(returnType, @encode(float));
//    }
    
//#ifdef DEBUG
//    if (isBlock) {
//        strcpy(returnType, "q");
//    }
//#endif
    
    NPValue *jsval;
    [_JSMethodForwardCallLock lock];
    jsval = [jsFunc callWithArguments:params];
    [_JSMethodForwardCallLock unlock];
    
    if (isBlock) {
        if (jsval.objectType) {
            strcpy(returnType, jsval.objectType.UTF8String);
        }
    }

    switch (returnType[0] == 'r' ? returnType[1] : returnType[0]) {
        #define JP_FWD_RET_CALL_JS \
//            NPValue *jsval; \
//            [_JSMethodForwardCallLock lock];   \
//            jsval = [jsFunc callWithArguments:params]; \
//            [_JSMethodForwardCallLock unlock]; \
            

        #define JP_FWD_RET_CASE_RET(_typeChar, _type, _retCode)   \
            case _typeChar : { \
                JP_FWD_RET_CALL_JS \
                _retCode \
                [invocation setReturnValue:&ret];\
                break;  \
            }

        #define JP_FWD_RET_CASE(_typeChar, _type, _typeSelector)   \
            JP_FWD_RET_CASE_RET(_typeChar, _type, _type ret = [[jsval toObject] _typeSelector];)   \

        #define JP_FWD_RET_CODE_ID \
            id __autoreleasing ret = formatJSToOC(jsval); \
            if (ret == _nilObj ||   \
                ([ret isKindOfClass:[NSNumber class]] && strcmp([ret objCType], "c") == 0 && ![ret boolValue])) ret = nil;  \

        #define JP_FWD_RET_CODE_POINTER    \
            void *ret; \
            id obj = formatJSToOC(jsval); \
            if ([obj isKindOfClass:[JPBoxing class]]) { \
                ret = [((JPBoxing *)obj) unboxPointer]; \
            }

        #define JP_FWD_RET_CODE_CLASS    \
            Class ret;   \
            ret = formatJSToOC(jsval);


        #define JP_FWD_RET_CODE_SEL    \
            SEL ret;   \
            id obj = formatJSToOC(jsval); \
            if ([obj isKindOfClass:[NSString class]]) { \
                ret = NSSelectorFromString(obj); \
            }

        JP_FWD_RET_CASE_RET('@', id, JP_FWD_RET_CODE_ID)
        JP_FWD_RET_CASE_RET('^', void*, JP_FWD_RET_CODE_POINTER)
        JP_FWD_RET_CASE_RET('*', void*, JP_FWD_RET_CODE_POINTER)
        JP_FWD_RET_CASE_RET('#', Class, JP_FWD_RET_CODE_CLASS)
        JP_FWD_RET_CASE_RET(':', SEL, JP_FWD_RET_CODE_SEL)

        JP_FWD_RET_CASE('c', char, charValue)
        JP_FWD_RET_CASE('C', unsigned char, unsignedCharValue)
        JP_FWD_RET_CASE('s', short, shortValue)
        JP_FWD_RET_CASE('S', unsigned short, unsignedShortValue)
        JP_FWD_RET_CASE('i', int, intValue)
        JP_FWD_RET_CASE('I', unsigned int, unsignedIntValue)
        JP_FWD_RET_CASE('l', long, longValue)
        JP_FWD_RET_CASE('L', unsigned long, unsignedLongValue)
        JP_FWD_RET_CASE('q', long long, longLongValue)
        JP_FWD_RET_CASE('Q', unsigned long long, unsignedLongLongValue)
        JP_FWD_RET_CASE('f', float, floatValue)
        JP_FWD_RET_CASE('d', double, doubleValue)
        JP_FWD_RET_CASE('B', BOOL, boolValue)

        case 'v': {
            JP_FWD_RET_CALL_JS
            break;
        }
        
        case '{': {
            NSString *typeString = extractStructName([NSString stringWithUTF8String:returnType]);
            #define JP_FWD_RET_STRUCT(_type, _funcSuffix) \
            if ([typeString rangeOfString:@#_type].location != NSNotFound) {    \
                JP_FWD_RET_CALL_JS \
                _type ret = [jsval _funcSuffix]; \
                [invocation setReturnValue:&ret];\
                break;  \
            }
            JP_FWD_RET_STRUCT(CGRect, toRect)
            JP_FWD_RET_STRUCT(CGPoint, toPoint)
            JP_FWD_RET_STRUCT(CGSize, toSize)
            JP_FWD_RET_STRUCT(NSRange, toRange)
            
//            @synchronized (_context) {
//                NSDictionary *structDefine = _registeredStruct[typeString];
//                if (structDefine) {
//                    size_t size = sizeOfStructTypes(structDefine[@"types"]);
//                    JP_FWD_RET_CALL_JS
//                    void *ret = malloc(size);
//                    NSDictionary *dict = formatJSToOC(jsval);
//                    getStructDataWithDict(ret, dict, structDefine);
//                    [invocation setReturnValue:ret];
//                    free(ret);
//                }
//            }
            break;
        }
        default: {
            break;
        }
    }
    
    if (_pointersToRelease) {
        for (NSValue *val in _pointersToRelease) {
            void *pointer = NULL;
            [val getValue:&pointer];
            CFRelease(pointer);
        }
        _pointersToRelease = nil;
    }
    
    if (deallocFlag) {
        slf = nil;
        Class instClass = object_getClass(assignSlf);
        Method deallocMethod = class_getInstanceMethod(instClass, NSSelectorFromString(@"ORIGdealloc"));
        void (*originalDealloc)(__unsafe_unretained id, SEL) = (__typeof__(originalDealloc))method_getImplementation(deallocMethod);
        originalDealloc(assignSlf, NSSelectorFromString(@"dealloc"));
    }
}

static void JPExecuteORIGForwardInvocation(id slf, SEL selector, NSInvocation *invocation)
{
    SEL origForwardSelector = @selector(ORIGforwardInvocation:);
    
    if ([slf respondsToSelector:origForwardSelector]) {
        NSMethodSignature *methodSignature = [slf methodSignatureForSelector:origForwardSelector];
        if (!methodSignature) {
            _exceptionBlock([NSString stringWithFormat:@"unrecognized selector -ORIGforwardInvocation: for instance %@", slf]);
            return;
        }
        NSInvocation *forwardInv= [NSInvocation invocationWithMethodSignature:methodSignature];
        [forwardInv setTarget:slf];
        [forwardInv setSelector:origForwardSelector];
        [forwardInv setArgument:&invocation atIndex:2];
        [forwardInv invoke];
    } else {
        Class superCls = [[slf class] superclass];
        Method superForwardMethod = class_getInstanceMethod(superCls, @selector(forwardInvocation:));
        void (*superForwardIMP)(id, SEL, NSInvocation *);
        superForwardIMP = (void (*)(id, SEL, NSInvocation *))method_getImplementation(superForwardMethod);
        superForwardIMP(slf, @selector(forwardInvocation:), invocation);
    }
}

#pragma mark - Utils

static NSString *trim(NSString *string)
{
    return [string stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
}

#pragma mark - Implements

static const void *propKey(NSString *propName) {
    if (!_propKeys) _propKeys = [[NSMutableDictionary alloc] init];
    id key = _propKeys[propName];
    if (!key) {
        key = [propName copy];
        [_propKeys setObject:key forKey:propName];
    }
    return (__bridge const void *)(key);
}
static id getPropIMP(id slf, SEL selector, NSString *propName) {
    return objc_getAssociatedObject(slf, propKey(propName));
}
static void setPropIMP(id slf, SEL selector, id val, NSString *propName) {
    objc_setAssociatedObject(slf, propKey(propName), val, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

static id formatJSToOC(NPValue *jsval)
{
    id obj = [jsval toObject];
    if (!obj || [obj isKindOfClass:[NSNull class]]) return _nilObj;
    
    if ([obj isKindOfClass:[JPBoxing class]]) return [obj unbox];
//    if ([obj isKindOfClass:[NSArray class]]) {
//        NSMutableArray *newArr = [[NSMutableArray alloc] init];
//        for (int i = 0; i < [(NSArray*)obj count]; i ++) {
//            [newArr addObject:formatJSToOC(jsval[i])];
//        }
//        return newArr;
//    }
//    if ([obj isKindOfClass:[NSDictionary class]]) {
//        if (obj[@"__obj"]) {
//            id ocObj = [obj objectForKey:@"__obj"];
//            if ([ocObj isKindOfClass:[JPBoxing class]]) return [ocObj unbox];
//            return ocObj;
//        } else if (obj[@"__clsName"]) {
//            return NSClassFromString(obj[@"__clsName"]);
//        }
//        if (obj[@"__isBlock"]) {
//            Class JPBlockClass = NSClassFromString(@"JPBlock");
//            if (JPBlockClass && ![jsval[@"blockObj"] isUndefined]) {
//                return [JPBlockClass performSelector:@selector(blockWithBlockObj:) withObject:[jsval[@"blockObj"] toObject]];
//            } else {
//                return genCallbackBlock(jsval);
//            }
//        }
//        NSMutableDictionary *newDict = [[NSMutableDictionary alloc] init];
//        for (NSString *key in [obj allKeys]) {
//            [newDict setObject:formatJSToOC(jsval[key]) forKey:key];
//        }
//        return newDict;
//    }
    return obj;
}

static id genCallbackBlock(NSArray *argTypes)
{
    //block with empty body might lead to memory-access error when setting a custom invoke pointer
    //possible explaination is Apple may generate a NSGlobalBlock in this case which seems to be readonly
    //trying to capture something in the body makes Apple generate normal block instead of global one
    __block int dummy = 0;
    void (^block)(void) = ^(void){dummy = 2;};
    uint8_t *p = (uint8_t *)((__bridge void *)block);
    p += sizeof(void *) + sizeof(int32_t) *2;
    void(**invoke)(void) = (void (**)(void))p;
    
    p += sizeof(void *) + sizeof(uintptr_t) * 2;
    const char **signature = (const char **)p;
    
    static NSMutableDictionary *typeSignatureDict;
    if (!typeSignatureDict) {
        typeSignatureDict  = [NSMutableDictionary new];
        #define JP_DEFINE_TYPE_SIGNATURE(_type) \
        [typeSignatureDict setObject:@[[NSString stringWithUTF8String:@encode(_type)], @(sizeof(_type))] forKey:@#_type];\

        JP_DEFINE_TYPE_SIGNATURE(id);
        JP_DEFINE_TYPE_SIGNATURE(BOOL);
        JP_DEFINE_TYPE_SIGNATURE(BOOL*);
        //JP_DEFINE_TYPE_SIGNATURE(BOOL *);
        JP_DEFINE_TYPE_SIGNATURE(int);
        JP_DEFINE_TYPE_SIGNATURE(int*);
        JP_DEFINE_TYPE_SIGNATURE(void);
        JP_DEFINE_TYPE_SIGNATURE(char);
        JP_DEFINE_TYPE_SIGNATURE(char*);
        JP_DEFINE_TYPE_SIGNATURE(short);
        JP_DEFINE_TYPE_SIGNATURE(unsigned short);
        JP_DEFINE_TYPE_SIGNATURE(unsigned int);
        JP_DEFINE_TYPE_SIGNATURE(long);
        JP_DEFINE_TYPE_SIGNATURE(unsigned long);
        JP_DEFINE_TYPE_SIGNATURE(long long);
        JP_DEFINE_TYPE_SIGNATURE(unsigned long long);
        JP_DEFINE_TYPE_SIGNATURE(float);
        JP_DEFINE_TYPE_SIGNATURE(double);
        JP_DEFINE_TYPE_SIGNATURE(bool);
        JP_DEFINE_TYPE_SIGNATURE(size_t);
        JP_DEFINE_TYPE_SIGNATURE(CGFloat);
        JP_DEFINE_TYPE_SIGNATURE(CGSize);
        JP_DEFINE_TYPE_SIGNATURE(CGRect);
        JP_DEFINE_TYPE_SIGNATURE(CGPoint);
        JP_DEFINE_TYPE_SIGNATURE(CGVector);
        JP_DEFINE_TYPE_SIGNATURE(NSRange);
        JP_DEFINE_TYPE_SIGNATURE(NSInteger);
        JP_DEFINE_TYPE_SIGNATURE(NSUInteger);
        JP_DEFINE_TYPE_SIGNATURE(Class);
        JP_DEFINE_TYPE_SIGNATURE(SEL);
        JP_DEFINE_TYPE_SIGNATURE(void*);
        JP_DEFINE_TYPE_SIGNATURE(void *);
    }
    
//    NSString *types = [jsVal[@"args"] toString];
//    NSString *types = jsVal.types;
//    
//    NSArray *lt = [types componentsSeparatedByString:@","];
    
    NSArray *lt = argTypes;
    
    NSString *funcSignature = @"@?0";
    
    NSInteger size = sizeof(void *);
    for (NSInteger i = 1; i < lt.count;) {
        NSString *t = trim(lt[i]);
        NSString *tpe = typeSignatureDict[typeSignatureDict[t] ? t : @"id"][0];
        if (i == 0) {
            funcSignature  =[[NSString stringWithFormat:@"%@%@",tpe, [@(size) stringValue]] stringByAppendingString:funcSignature];
            break;
        }
        
        funcSignature = [funcSignature stringByAppendingString:[NSString stringWithFormat:@"%@%@", tpe, [@(size) stringValue]]];
        size += [typeSignatureDict[typeSignatureDict[t] ? t : @"id"][1] integerValue];
        
        i = (i != lt.count - 1) ? i + 1 : 0;
    }
    
    IMP msgForwardIMP = _objc_msgForward;
#if !defined(__arm64__)
    if ([funcSignature UTF8String][0] == '{') {
        //In some cases that returns struct, we should use the '_stret' API:
        //http://sealiesoftware.com/blog/archive/2008/10/30/objc_explain_objc_msgSend_stret.html
        //NSMethodSignature knows the detail but has no API to return, we can only get the info from debugDescription.
        NSMethodSignature *methodSignature = [NSMethodSignature signatureWithObjCTypes:[funcSignature UTF8String]];
        if ([methodSignature.debugDescription rangeOfString:@"is special struct return? YES"].location != NSNotFound) {
            msgForwardIMP = (IMP)_objc_msgForward_stret;
        }
    }
#endif
    *invoke = (void *)msgForwardIMP;
    
    const char *fs = [funcSignature UTF8String];
    char *s = malloc(strlen(fs));
    strcpy(s, fs);
    *signature = s;
    
    objc_setAssociatedObject(block, "_block_signature", funcSignature, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        Class cls = NSClassFromString(@"NSBlock");
#define JP_HOOK_METHOD(selector, func) {Method method = class_getInstanceMethod([NSObject class], selector); \
BOOL success = class_addMethod(cls, selector, (IMP)func, method_getTypeEncoding(method)); \
if (!success) { class_replaceMethod(cls, selector, (IMP)func, method_getTypeEncoding(method));}}
        
        JP_HOOK_METHOD(@selector(methodSignatureForSelector:), block_methodSignatureForSelector);
        JP_HOOK_METHOD(@selector(forwardInvocation:), JPForwardInvocation);
    });
    
    return block;
}

NSMethodSignature *block_methodSignatureForSelector(id self, SEL _cmd, SEL aSelector) {
    uint8_t *p = (uint8_t *)((__bridge void *)self);
    p += sizeof(void *) * 2 + sizeof(int32_t) *2 + sizeof(uintptr_t) * 2;
    const char **signature = (const char **)p;
    return [NSMethodSignature signatureWithObjCTypes:*signature];
}

+ (id)genCallbackBlock:(NSArray *)argTypes {
    return genCallbackBlock(argTypes);
}

@end
