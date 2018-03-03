//
//  NCException.hpp
//  NaiveC
//
//  Created by Liang,Zhiyuan(GIS) on 2018/3/4.
//  Copyright © 2018年 Ogreaxe. All rights reserved.
//

#ifndef NCException_hpp
#define NCException_hpp

#include <stdio.h>
#include <string>

using namespace std;

class NCRuntimeException {
private:
    int errorCode;
    string errorMessage;
public:
    NCRuntimeException(int errorCode, const string &errorMessage):errorCode(errorCode),errorMessage(errorMessage){}
    
    string getErrorMessage(){return errorMessage;}
};

#endif /* NCException_hpp */
