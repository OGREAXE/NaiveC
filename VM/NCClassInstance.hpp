//
//  NCClassInstance.hpp
//  NaiveC
//
//  Created by 梁志远 on 24/09/2017.
//  Copyright © 2017 Ogreaxe. All rights reserved.
//

#ifndef NCClassInstance_hpp
#define NCClassInstance_hpp

#include <stdio.h>
#include "NCAST.hpp"
#include "NCStackElement.hpp"

class NCClassInstance {
public:
    
    uint32_t referenceCount;
    
    shared_ptr<NCClassDeclaration> classDefinition;
    
    shared_ptr<NCClassInstance> super;
    
    vector<shared_ptr<NCStackElement>> fields;
};

class NCStackPointerElement:NCStackElement{
private:
    shared_ptr<NCClassInstance> pObject;
public:
    NCStackPointerElement(shared_ptr<NCClassInstance> &pObject):pObject(pObject){type="pointer";}
    
    shared_ptr<NCClassInstance> getObjectPointer(){return pObject;}
    
    virtual shared_ptr<NCStackElement> doOperator(const string&op, shared_ptr<NCStackElement> rightOperand);
    virtual int toInt();
    virtual float toFloat();
    virtual string toString();
    virtual shared_ptr<NCStackElement> copy();
};

#endif /* NCClassInstance_hpp */
