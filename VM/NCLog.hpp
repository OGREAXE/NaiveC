//
//  NCLog.hpp
//  NaiveC
//
//  Created by Liang,Zhiyuan(GIS) on 2018/2/23.
//  Copyright © 2018年 Ogreaxe. All rights reserved.
//

#ifndef NCLog_hpp
#define NCLog_hpp

#include <stdio.h>

typedef enum NCLogType{
    NCLogTypeParser,
    NCLogTypeInterpretor
} NCLogType;

#ifdef CPLUSPLUS
extern "c" {
#endif
void NCLog(NCLogType type, const char*format, ...);
#ifdef CPLUSPLUS
}
#endif

#endif /* NCLog_hpp */
