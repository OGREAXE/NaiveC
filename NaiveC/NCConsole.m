//
//  NCConsole.m
//  NaiveC
//
//  Created by Liang,Zhiyuan(GIS) on 2017/12/26.
//  Copyright © 2017年 Ogreaxe. All rights reserved.
//

#import "NCConsole.h"

void NCLog(NSString *format, ...){
    va_list argp;
    va_start(argp, format);
    NSLog(format, argp);
    va_end(argp);
}

@implementation NCConsole

@end
