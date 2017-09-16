//
//  NCBuiltinFunction.cpp
//  NaiveC
//
//  Created by 梁志远 on 28/08/2017.
//  Copyright © 2017 Ogreaxe. All rights reserved.
//

#include "NCBuiltinFunction.hpp"
#import <UIKit/UIKit.h>

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
