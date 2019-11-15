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
#include <Foundation/Foundation.h>

//rect
string NCRect::getDescription(){
    std::ostringstream stringStream;
    stringStream << "x:"<<x<<" y:"<<y<<" width:"<<width<<" height:"<<height<<endl;
    std::string copyOfStr = stringStream.str();
    return copyOfStr;
}

shared_ptr<NCStackElement> NCRect::getAttribute(const string & attrName){
    if (attrName == "origin") {
        NCStackPointerElement * pval = new NCStackPointerElement(shared_ptr<NCObject>(new NCPoint(x,y)));
        return shared_ptr<NCStackPointerElement>(pval);
    }
    else if (attrName == "size") {
        NCStackPointerElement * pval = new NCStackPointerElement(shared_ptr<NCObject>(new NCSize(width,height)));
        return shared_ptr<NCStackPointerElement>(pval);
    }
    return nullptr;
}

//size
string NCSize::getDescription(){
    std::ostringstream stringStream;
    stringStream << "width:"<<width<<" height:"<<height<<endl;
    std::string copyOfStr = stringStream.str();
    return copyOfStr;
}

shared_ptr<NCStackElement> NCSize::getAttribute(const string & attrName){
    if (attrName == "width") {
        return shared_ptr<NCStackFloatElement>(new NCStackFloatElement(width));
    }
    else if (attrName == "height") {
        return shared_ptr<NCStackFloatElement>(new NCStackFloatElement(height));
    }
    return nullptr;
}

//point
string NCPoint::getDescription(){
    std::ostringstream stringStream;
    stringStream << "x:"<<x<<" y:"<<y<<endl;
    std::string copyOfStr = stringStream.str();
    return copyOfStr;
}

shared_ptr<NCStackElement> NCPoint::getAttribute(const string & attrName){
    if (attrName == "x") {
        return shared_ptr<NCStackFloatElement>(new NCStackFloatElement(x));
    }
    else if (attrName == "y") {
        return shared_ptr<NCStackFloatElement>(new NCStackFloatElement(y));
    }
    
    return nullptr;
}

//range
string NCRange::getDescription(){
    std::ostringstream stringStream;
    stringStream << "location:"<<location<<" length:"<<length<<endl;
    std::string copyOfStr = stringStream.str();
    return copyOfStr;
}

shared_ptr<NCStackElement> NCRange::getAttribute(const string & attrName){
    if (attrName == "location") {
        return shared_ptr<NCStackFloatElement>(new NCStackFloatElement(location));
    }
    else if (attrName == "length") {
        return shared_ptr<NCStackFloatElement>(new NCStackFloatElement(length));
    }
    
    return nullptr;
}

//edge insets
string NCEdgeInset::getDescription(){
    std::ostringstream stringStream;
    stringStream << "top:"<<top<<" left:"<<left<<" bottom:"<<bottom<<" right:"<<right<<endl;
    std::string copyOfStr = stringStream.str();
    return copyOfStr;
}

shared_ptr<NCStackElement> NCEdgeInset::getAttribute(const string & attrName){
    if (attrName == "top") {
        return shared_ptr<NCStackFloatElement>(new NCStackFloatElement(top));
    }
    else if (attrName == "left") {
        return shared_ptr<NCStackFloatElement>(new NCStackFloatElement(left));
    }
    else if (attrName == "bottom") {
        return shared_ptr<NCStackFloatElement>(new NCStackFloatElement(bottom));
    }
    else if (attrName == "right") {
        return shared_ptr<NCStackFloatElement>(new NCStackFloatElement(right));
    }
    return nullptr;
}

#pragma mark NCOcClass

string NCOcClass::getDescription(){
    Class cls = (__bridge Class)(pClass);
    return NSStringFromClass(cls).UTF8String;
}

shared_ptr<NCStackElement> NCOcClass::getAttribute(const string & attrName){
    return nullptr;
}
