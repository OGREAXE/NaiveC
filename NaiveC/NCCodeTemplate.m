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

@implementation NCCodeTemplate

+(NSString*)insertTemplate:(NCCodeTemplateType)template baseIndent:(NSString*)indent{
    switch (template) {
        case NCCodeTemplateIf:
            return [self.class insertTemplateString:TEMPLATE_IF_STR baseIndent:indent];
            break;
        case NCCodeTemplateIfElse:
            return [self.class insertTemplateString:TEMPLATE_IFELSE_STR baseIndent:indent];
            break;
        case NCCodeTemplateFor:
            return [self.class insertTemplateString:TEMPLATE_FOR_STR baseIndent:indent];
            break;
        case NCCodeTemplateWhile:
            return [self.class insertTemplateString:TEMPLATE_WHILE_STR baseIndent:indent];
            break;
        case NCCodeTemplateFunc:
            return [self.class insertTemplateString:TEMPLATE_FUNC_STR baseIndent:indent];
            break;
        default:
            break;
    }
    return nil;
}

+(NSString*)insertTemplateString:(NSString*)templateString baseIndent:(NSString*)indent{
    NSMutableString * finalString = [NSMutableString new];
    
    NSArray * components = [templateString componentsSeparatedByString:@"\n"];
    [components enumerateObjectsUsingBlock:^(id  obj, NSUInteger idx, BOOL * stop) {
        NSString * part = obj;
        [finalString appendString:indent];
        [finalString appendString:part];
        if (idx != components.count-1) {
            [finalString appendString:@"\n"];
        }
    }];
    
    return finalString;
}

@end
