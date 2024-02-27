//
//  NCObjCSourceParser.m
//  NaivePatch
//
//  Created by mi on 2024/1/19.
//

#import "NCObjCSourceParser.h"

@implementation NCObjCSourceParser

- (NSArray<NPPatchedClass *> *)extractPatchMethodFromContent:(NSString *)content {
    
    content = [self stringByRemovingCommentsInString:content];
    
    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:@"@implementation((.|\\s)*?)@end" options:NSRegularExpressionCaseInsensitive error:NULL];

    
    NSArray *myArray = [regex matchesInString:content options:0 range:NSMakeRange(0, [content length])] ;
    
    NSMutableArray *classes = [NSMutableArray array];

    for (NSTextCheckingResult *match in myArray) {
        NSRange matchRange = [match rangeAtIndex:1];
        
        NSString *impContent = [content substringWithRange:matchRange];
        
        NSString *className = [[impContent componentsSeparatedByString:@"\n"] objectAtIndex:0];
        className = [className stringByTrimmingCharactersInSet:
                                      [NSCharacterSet whitespaceAndNewlineCharacterSet]];
//        [matches addObject:impContent];
//         NSLog(@"%@", [matches lastObject]);
        
//        NSString *methodRegexPattern = @"- *\\(.*?\\)((.|\\s)*?)\\{((.|\\s)*?)\\}";
        NSString *patchMethodRegexPattern = @" *#pragma  *mark  *patch *\n *([-|+] *\\(.*?\\)(.|\\s)*?)\\{((.|\\s)*?)\\}";
        NSRegularExpression *methodRegex = [NSRegularExpression regularExpressionWithPattern:patchMethodRegexPattern options:NSRegularExpressionCaseInsensitive error:NULL];
        
        NSArray *methodArray = [methodRegex matchesInString:impContent options:0 range:NSMakeRange(0, [impContent length])] ;
        
        NPPatchedClass *pClass = [NPPatchedClass new];
        pClass.name = className;
        
        NSMutableArray *methods = [NSMutableArray array];
        NSMutableArray *classMethods = [NSMutableArray array];
        
        for (NSTextCheckingResult *methodMatch in methodArray) {
            NSRange methodDeclareMatchRange = [methodMatch rangeAtIndex:1];
            
            NSString *decl = [impContent substringWithRange:methodDeclareMatchRange];
            
            NSLog(@"method: %@", decl);
            
            NSString *body = [self methodBodyFromString:impContent fromIndex:methodDeclareMatchRange.location + methodDeclareMatchRange.length];
            
            NSLog(@"body: %@ \n end of %@\n", body, decl);
            
            NPPatchedMethod *pMethod = [NPPatchedMethod new];
            
            NSArray *pairs = [self parameterPairFromString:decl];
            pMethod.parameterPairs = pairs;
            
            pMethod.declaration = decl;
            pMethod.selector = [self selectorFromString:decl andParamPairs:pairs] ;
            pMethod.body = body;
            
            if (pMethod.isClassMethod) {
                [classMethods addObject:pMethod];
            } else {
                [methods addObject:pMethod];
            }
        }
        
        pClass.patchedMethods = methods;
        pClass.patchedClassMethods = classMethods;
        
        [classes addObject:pClass];
    }
    
    return classes;
}

- (NSString *)selectorFromString:(NSString *)str andParamPairs:(NSArray<NPParamterPair *> *)pairs {
    
    if (pairs.count > 0) {
        NSString *ret = @"";
        for (NPParamterPair *pair in pairs) {
            if (pair.formal.length)ret = [ret stringByAppendingFormat:@"%@:", pair.formal];
        }
        
        return ret;
    }

    return [self methodFirstNameFromString:str];
}

- (NSString *)stringByRemovingCommentsInString:(NSString *)string {
    NSError *error = nil;
    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:@"(?:/\\*(?:[^*]|(?:\\*+[^*/]))*\\*+/)|(?://.*)" options:NSRegularExpressionCaseInsensitive error:&error];
    NSString *modifiedString = [regex stringByReplacingMatchesInString:string options:0 range:NSMakeRange(0, [string length]) withTemplate:@""];
    
    return modifiedString;
}

- (NSString *)methodBodyFromString:(NSString *)string fromIndex:(NSInteger)fromIndex {
    int par = 0;
    
    BOOL isInIgnoreState = NO;
    int startIndex = 0, endIndex = 0;
//    int lasti = 0;
    for (int i = fromIndex; i < string.length; i ++) {
        unichar c = [string characterAtIndex:i];
        if (c == '"') {
            if (i>0 && [string characterAtIndex:i-1] == '\\') {
                
            } else {
                isInIgnoreState = !isInIgnoreState;
            }
        }
        
        if (!isInIgnoreState) {
            if (c == '{') {
                if (par == 0) startIndex = i;
                par ++;
            }
            else if (c == '}') {
                if (par == 1) {
                    endIndex = i;
                    break;
                }
                par --;
            }
        }
    }
    
    if (endIndex > 0) {
        return [string substringWithRange:NSMakeRange(startIndex, endIndex - startIndex + 1)];
    }
    
    return nil;
}

- (NSString *)methodFirstNameFromString:(NSString *)str {
    NSString *patchMethodRegexPattern = @"[-|+] *\\([^:]+\\)([^:]+)";
    NSRegularExpression *methodRegex = [NSRegularExpression regularExpressionWithPattern:patchMethodRegexPattern options:NSRegularExpressionCaseInsensitive error:NULL];
    
    NSArray *methodArray = [methodRegex matchesInString:str options:0 range:NSMakeRange(0, [str length])] ;
    
    if (methodArray.count) {
        NSRange methodDeclareMatchRange = [methodArray[0] rangeAtIndex:1];
        
        NSString *name = [str substringWithRange:methodDeclareMatchRange];
        
        return name;
    }
    
    return nil;
}

- (NSArray<NPParamterPair *> *)parameterPairFromString:(NSString *)str {
    str = [str stringByAppendingString:@" "];
    NSString *patchMethodRegexPattern = @"\\) *([^ ]*) *: *\\(([^:]+)\\)([^ ]+) +";
    NSRegularExpression *methodRegex = [NSRegularExpression regularExpressionWithPattern:patchMethodRegexPattern options:NSRegularExpressionCaseInsensitive error:NULL];
    
    NSArray *methodArray = [methodRegex matchesInString:str options:0 range:NSMakeRange(0, [str length])] ;
    
    NSMutableArray *pairs = [NSMutableArray array];
    
    //self
    NPParamterPair *selfPair = [NPParamterPair new];
    selfPair.type = @"id";
    selfPair.name = @"self";
    
    [pairs addObject:selfPair];
    
    for (NSTextCheckingResult *methodMatch in methodArray) {
        NSRange methodDeclareMatchRange = [methodMatch rangeAtIndex:0];
        
//        NSString *pair = [str substringWithRange:methodDeclareMatchRange];
        
        if (methodMatch.numberOfRanges == 4) {
            NSRange formalRange = [methodMatch rangeAtIndex:1];
            NSRange typeRange = [methodMatch rangeAtIndex:2];
            NSRange nameRange = [methodMatch rangeAtIndex:3];
            
            NPParamterPair *pair = [NPParamterPair new];
            pair.formal = [str substringWithRange:formalRange];
            pair.type = [str substringWithRange:typeRange];
            pair.name = [str substringWithRange:nameRange];
            
            [pairs addObject:pair];
            
//            NSLog(@"(%@)%@", [str substringWithRange:typeRange], [str substringWithRange:nameRange]);
        } else {
            NSLog(@"fail to run parameterPairFromString for %@", str);
            break;
        }
    }
    
    return pairs;
}

@end
