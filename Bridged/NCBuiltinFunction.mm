//
//  NCBuiltinFunction.cpp
//  NaiveC
//
//  Created by 梁志远 on 28/08/2017.
//  Copyright © 2017 Ogreaxe. All rights reserved.
//

#include "NCBuiltinFunction.hpp"
#import <UIKit/UIKit.h>

#include <cstdlib>
#include "NCCocoaBox.hpp"

NCBuiltinPrint::NCBuiltinPrint(){
    name = "print";
    parameters.push_back(shared_ptr<NCParameter>(new NCParameter("string","str")));
}

bool NCBuiltinPrint::invoke(vector<shared_ptr<NCStackElement>> &arguments){
    auto str = arguments[0]->toString();
    NSString * nestedString = [NSString stringWithUTF8String:str.c_str()];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"NCPrintStringNotification" object:nestedString];
    
    return true;
}

bool NCBuiltinPrint::invoke(vector<shared_ptr<NCStackElement>> &arguments,vector<shared_ptr<NCStackElement>> & lastStack){
    return invoke(arguments);
}

NCBuiltinGetObject::NCBuiltinGetObject(){
    name = "getObject";
    parameters.push_back(shared_ptr<NCParameter>(new NCParameter("string","str")));
}

bool NCBuiltinGetObject::invoke(vector<shared_ptr<NCStackElement>> &arguments){
    
    return true;
}

bool NCBuiltinGetObject::invoke(vector<shared_ptr<NCStackElement>> &arguments,vector<shared_ptr<NCStackElement>> & lastStack){
    auto str = arguments[0]->toString();
//    NSString * nestedString = [NSString stringWithUTF8String:str.c_str()];
    char * end;
    unsigned long long ullAddr = strtoull(str.c_str(),&end, 16);
    
    if (errno == ERANGE) {
        NSLog(@"error range");
        return false;
    }
    
    NCCocoaBox * cbox = new NCCocoaBox((void*)ullAddr);
    
    lastStack.push_back(shared_ptr<NCStackPointerElement>(new NCStackPointerElement(shared_ptr<NCObject>(cbox))));
    
    return true;
}
