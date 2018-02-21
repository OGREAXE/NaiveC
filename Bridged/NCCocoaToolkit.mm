//
//  NCCocoaToolkit.cpp
//  NaiveC
//
//  Created by Liang,Zhiyuan(GIS) on 2018/2/20.
//  Copyright © 2018年 Ogreaxe. All rights reserved.
//

#include "NCCocoaToolkit.hpp"
#include <sstream>
#include <iostream>

string NCFrame::getDescription(){
    std::ostringstream stringStream;
    stringStream << "x:"<<x<<" y:"<<y<<" width:"<<width<<" height:"<<height<<endl;
    std::string copyOfStr = stringStream.str();
    return copyOfStr;
}

string NCSize::getDescription(){
    std::ostringstream stringStream;
    stringStream << "width:"<<width<<" height:"<<height<<endl;
    std::string copyOfStr = stringStream.str();
    return copyOfStr;
}

string NCPoint::getDescription(){
    std::ostringstream stringStream;
    stringStream << "x:"<<x<<" y:"<<y<<endl;
    std::string copyOfStr = stringStream.str();
    return copyOfStr;
}
