//
//  NCClass.hpp
//  NaiveC
//
//  Created by Liang,Zhiyuan(GIS) on 2018/2/17.
//  Copyright © 2018年 Ogreaxe. All rights reserved.
//

#ifndef NCClass_hpp
#define NCClass_hpp

#include <stdio.h>
#include <memory>

#include "NCStackElement.hpp"
#include "NCClassInstance.hpp"

using namespace std;

class NCClass : public NCStackElement{
protected:
    string name;
public:
    NCClass(const string &name):name(name){}
    /**
     instantiate an object of this class

     @param arguments <#arguments description#>
     @return <#return value description#>
     */
    virtual shared_ptr<NCStackPointerElement> instantiate(vector<shared_ptr<NCStackElement>> &arguments){return nullptr;};
    
    /**
     invoke a class method (static method) on this class
     
     @param methodName <#methodName description#>
     @param arguments <#arguments description#>
     @param lastStack <#lastStack description#>
     @return <#return value description#>
     */
    virtual bool invokeMethod(string methodName, vector<shared_ptr<NCStackElement>> &arguments,vector<shared_ptr<NCStackElement>> & lastStack){return false;};
};

#endif /* NCClass_hpp */
