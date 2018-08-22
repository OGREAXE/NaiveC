//
//  NCException.cpp
//  NaiveC
//
//  Created by Liang,Zhiyuan(GIS) on 2018/3/4.
//  Copyright © 2018年 Ogreaxe. All rights reserved.
//

#include "NCException.hpp"
#include <stdio.h>
#include <stdarg.h>

#include <string>
#include <sstream>
#include <iostream>

using namespace std;

NCParseException::NCParseException(int errorCode, const char*format, ...):errorCode(errorCode){
    
    va_list args;
    char buffer[1024];
    va_start (args, format);
    vsprintf (buffer,format, args);
    va_end (args);
    
    std::ostringstream stringStream;
    stringStream<<buffer<<endl;
//    std::string copyOfStr = stringStream.str();
    errorMessage = stringStream.str();
}

NCRuntimeException::NCRuntimeException(int errorCode, const char*format, ...):errorCode(errorCode){
    
    va_list args;
    char buffer[1024];
    va_start (args, format);
    vsprintf (buffer,format, args);
    va_end (args);
    
    std::ostringstream stringStream;
    stringStream<<buffer<<endl;
//    std::string copyOfStr = stringStream.str();
    errorMessage = stringStream.str();
}
