//
//  NCInterpreter.hpp
//  NaiveC
//
//  Created by 梁志远 on 27/08/2017.
//  Copyright © 2017 Ogreaxe. All rights reserved.
//

#ifndef NCInterpreter_hpp
#define NCInterpreter_hpp

#include <stdio.h>
#include <unordered_map>
#include "NCAST.hpp"
#include "NCBuiltinFunction.hpp"
#include "NCStackElement.hpp"

using namespace std;

//struct NCVariable{
//    string name;
//    string type;
//};
//
//struct NCVariableInt:NCVariable{
//    NCVariableInt(string &name, int value):value(value){name = name;type="int";}
//    int value;
//};
//
//struct NCVariableFloat:NCVariable{
//    NCVariableFloat(string &name, float value):value(value){name = name;type="float";}
//    float value;
//};
//
//struct NCVariableString:NCVariable{
//    NCVariableString(string &name, string value):value(value){name = name;type="string";}
//    string value;
//};

class NCFrame{
public:
    void insertVariable(string&name, int value);
    void insertVariable(string&name, float value);
    void insertVariable(string&name, string& value);

    unordered_map<string, shared_ptr<NCStackElement>> localVariableMap;
    vector<shared_ptr<NCStackElement>> stack;
};

class NCInterpreter{
private:
    unordered_map<string, shared_ptr<NCASTNode>> functionMap;
    unordered_map<string, shared_ptr<NCBuiltinFunction>> builtinFunctionMap;

    void intBuiltiFunctionMap();
    
    bool isStackTopInt(NCFrame & frame);
    bool isStackTopFloat(NCFrame & frame);
    bool isStackTopString(NCFrame & frame);
    
    int stackPopInt(NCFrame & frame);
    float stackPopFloat(NCFrame & frame);
    string stackPopString(NCFrame & frame);
    
public:
    NCInterpreter(shared_ptr<NCASTRoot> root);
    
    void invoke_main(){
        vector<shared_ptr<NCStackElement>> arguments;
        vector<shared_ptr<NCStackElement>> stack;
        invoke("main", arguments, stack);
    }
    
    bool invoke(string function, vector<shared_ptr<NCStackElement>> &arguments,vector<shared_ptr<NCStackElement>> & lastStack);
    
    bool walkTree(shared_ptr<NCASTNode> node, NCFrame & frame);
    bool walkTree(shared_ptr<NCASTNode> node, NCFrame & frame, bool * shouldReturn);  //recursive method
};

#endif /* NCInterpreter_hpp */
