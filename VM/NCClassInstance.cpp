//
//  NCClassInstance.cpp
//  NaiveC
//
//  Created by 梁志远 on 24/09/2017.
//  Copyright © 2017 Ogreaxe. All rights reserved.
//

#include "NCClassInstance.hpp"

shared_ptr<NCStackElement> NCStackPointerElement::doOperator(const string&op, shared_ptr<NCStackElement> rightOperand){
    
    return rightOperand;
}

int NCStackPointerElement::toInt(){
    return 0;
}
float NCStackPointerElement::toFloat(){
    return 0;
}
string NCStackPointerElement::toString(){
    return 0;
}

shared_ptr<NCStackElement> NCStackPointerElement::copy(){
    return shared_ptr<NCStackElement>(nullptr);
}
