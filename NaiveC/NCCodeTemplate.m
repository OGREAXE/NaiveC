//
//  NCCodeTemplate.m
//  NaiveC
//
//  Created by Liang,Zhiyuan(GIS) on 2017/12/27.
//  Copyright © 2017年 Ogreaxe. All rights reserved.
//

#import "NCCodeTemplate.h"

#define TEMPLATE_IF_STR @"if( ){\n    \n}"
#define TEMPLATE_IFELSE_STR @"if( ){\n    \n}\nelse{\n    \n}"
#define TEMPLATE_FOR_STR @"for( ; ; ){\n    \n}"
#define TEMPLATE_WHILE_STR @"while( ){\n    \n}"
#define TEMPLATE_FUNC_STR @"R func( ){\n    \n}"

#define TEMPLATE_IF_STR_PH @"if(%@){\n    \n}"
#define TEMPLATE_IFELSE_STR_PH @"if(%@){\n    \n}\nelse{\n    \n}"
#define TEMPLATE_FOR_STR_PH @"for(%@;%@;%@){\n    \n}"
#define TEMPLATE_WHILE_STR_PH @"while(%@){\n    \n}"
#define TEMPLATE_FUNC_STR_PH @"%@ %@(%@){\n    \n}"

@implementation NCCodeTemplate

+(NSString*)templateWithType:(NCCodeTemplateType)template baseIndent:(NSString*)indent{
    switch (template) {
        case NCCodeTemplateIf:
            return [self.class templateString:TEMPLATE_IF_STR baseIndent:indent];
            break;
        case NCCodeTemplateIfElse:
            return [self.class templateString:TEMPLATE_IFELSE_STR baseIndent:indent];
            break;
        case NCCodeTemplateFor:
            return [self.class templateString:TEMPLATE_FOR_STR baseIndent:indent];
            break;
        case NCCodeTemplateWhile:
            return [self.class templateString:TEMPLATE_WHILE_STR baseIndent:indent];
            break;
        case NCCodeTemplateFunc:
            return [self.class templateString:TEMPLATE_FUNC_STR baseIndent:indent];
            break;
        default:
            break;
    }
    return nil;
}

+(NSString*)templateWithType:(NCCodeTemplateType)template baseIndent:(NSString*)indent fillerStringArray:(NSArray*)fillers{
    switch (template) {
        case NCCodeTemplateIf:
            return [self.class templateString:TEMPLATE_IF_STR_PH baseIndent:indent fillerStringArray:fillers];
            break;
        case NCCodeTemplateIfElse:
            return [self.class templateString:TEMPLATE_IFELSE_STR_PH baseIndent:indent fillerStringArray:fillers];
            break;
        case NCCodeTemplateFor:
            return [self.class templateString:TEMPLATE_FOR_STR_PH baseIndent:indent fillerStringArray:fillers];
            break;
        case NCCodeTemplateWhile:
            return [self.class templateString:TEMPLATE_WHILE_STR_PH baseIndent:indent fillerStringArray:fillers];
            break;
        case NCCodeTemplateFunc:
            return [self.class templateString:TEMPLATE_FUNC_STR_PH baseIndent:indent fillerStringArray:fillers];
            break;
        default:
            break;
    }
    return nil;
}

+(NSString*)templateString:(NSString*)templateString baseIndent:(NSString*)indent{
    NSMutableString * finalString = [NSMutableString new];
    
    NSArray * components = [templateString componentsSeparatedByString:@"\n"];
    [components enumerateObjectsUsingBlock:^(id  obj, NSUInteger idx, BOOL * stop) {
        NSString * part = obj;
        if (idx!=0) {
            [finalString appendString:indent];
        }
        
        [finalString appendString:part];
        
        if (idx != components.count-1) {
            [finalString appendString:@"\n"];
        }
    }];
    
    return finalString;
}

+(NSString*)templateString:(NSString*)templateString baseIndent:(NSString*)indent fillerStringArray:(NSArray*)fillers{
    NSMutableString * finalString = [NSMutableString new];
    
    __block int fillerIndex = 0;
    NSArray * components = [templateString componentsSeparatedByString:@"\n"];
    [components enumerateObjectsUsingBlock:^(id  obj, NSUInteger idx, BOOL * stop) {
        NSString * part = obj;
        
        int placeholderCount = 0;
        for (int i=0; i<part.length; i++) {
            unichar c = [part characterAtIndex:i];
            if (c == '%') {
                placeholderCount ++;
            }
        }
        
        NSString * filledPart = nil;
        if (placeholderCount == 0) {
            filledPart = part;
        }
        else if (placeholderCount == 1) {
            filledPart = [NSString stringWithFormat:part,fillers[fillerIndex]];
            fillerIndex ++;
        }
        else if (placeholderCount == 2) {
            filledPart = [NSString stringWithFormat:part,fillers[fillerIndex],fillers[fillerIndex + 1]];
            fillerIndex += 2;
        }
        else if (placeholderCount == 3) {
            filledPart = [NSString stringWithFormat:part,fillers[fillerIndex],fillers[fillerIndex + 1],fillers[fillerIndex + 2]];
            fillerIndex += 3;
        }
        
        if (idx!=0) {
            [finalString appendString:indent];
        }
        
        [finalString appendString:filledPart];
        
        if (idx != components.count-1) {
            [finalString appendString:@"\n"];
        }
    }];
    
    return finalString;
}

@end
