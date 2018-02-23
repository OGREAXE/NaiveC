//
//  NCLog.cpp
//  NaiveC
//
//  Created by Liang,Zhiyuan(GIS) on 2018/2/23.
//  Copyright © 2018年 Ogreaxe. All rights reserved.
//

#include "NCLog.hpp"
#include <stdio.h>
#include <stdarg.h>

#include <string>
#include <sstream>
#include <iostream>

#import <UIKit/UIKit.h>

using namespace std;

void NCLog(NCLogType type, const char*format, ...){
    va_list args;
    char buffer[1024];
    va_start (args, format);
    vsprintf (buffer,format, args);
    va_end (args);
    
    string strlogtype;
    if (type == NCLogTypeParser) {
        strlogtype = "parser";
    }
    else if (type == NCLogTypeInterpretor) {
        strlogtype = "interpretor";
    }
    
    std::ostringstream stringStream;
    stringStream<<strlogtype<<":"<<endl<<buffer<<endl;
    std::string copyOfStr = stringStream.str();
    
    NSString * logStr = [NSString stringWithUTF8String:copyOfStr.c_str()];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"NCLogNotification" object:logStr];
}
