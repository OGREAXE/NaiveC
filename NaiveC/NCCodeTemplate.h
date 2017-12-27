//
//  NCCodeTemplate.h
//  NaiveC
//
//  Created by Liang,Zhiyuan(GIS) on 2017/12/27.
//  Copyright © 2017年 Ogreaxe. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSUInteger, NCCodeTemplateType) {
    NCCodeTemplateIf = 0,
    NCCodeTemplateIfElse,
    NCCodeTemplateFor,
    NCCodeTemplateWhile,
    NCCodeTemplateFunc,
};

@interface NCCodeTemplate : NSObject

+(NSString*)insertTemplate:(NCCodeTemplateType)template baseIndent:(NSString*)indent;
@end
