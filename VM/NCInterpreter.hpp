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
#include "NCObject.hpp"
#include "NCBuiltinFunctionStore.hpp"
#include "NCModuleCache.hpp"
#include "NCSymbolStore.hpp"

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
    void insertVariable(string&name, NCInt value);
    void insertVariable(string&name, NCFloat value);
    void insertVariable(string&name, NCInt value, const string &opcode);
    void insertVariable(string&name, NCFloat value, const string &opcode);
    void insertVariable(string&name, string& value);
    void insertVariable(string&name, shared_ptr<NCStackElement> pObject);
    void insertVariable(string&name, NCStackPointerElement & pObject);

    unordered_map<string, shared_ptr<NCStackElement>> localVariableMap;
    vector<shared_ptr<NCStackElement>> stack;
    
    shared_ptr<NCNativeObject> scope;
    
    shared_ptr<NCStackElement> stack_pop();
    
    /**
     if stack top is a variable, pop its content, otherwise pop stack top

     @param element <#element description#>
     @return <#return value description#>
     */
    shared_ptr<NCStackElement> stack_popRealValue();
    
    void stack_push(shared_ptr<NCStackElement> element);
    
    bool stack_empty(){return stack.size()==0;}
    
    bool objectScopeFlag; //indicate frame contains "self" object
};

class NCInterpreter:public NCInvocationDelegate{
private:
//    unordered_map<string, shared_ptr<NCASTNode>> functionMap;
//
//    NCBuiltinFunctionStore m_builtinFunctionStore;
//
//    unordered_map<string, shared_ptr<NCClassDeclaration>> classDefinitionMap;
    
    NCSymbolStore *m_symStore = new NCSymbolStore();
    
    bool isStackTopInt(NCFrame & frame);
    bool isStackTopFloat(NCFrame & frame);
    bool isStackTopString(NCFrame & frame);
    
    NCInt stackPopInt(NCFrame & frame);
    NCFloat stackPopFloat(NCFrame & frame);
    string stackPopString(NCFrame & frame);
    
    bool isClassName(const string & name);
    
    bool initArguments(vector<shared_ptr<NCExpression>> &intput_argumentExpressions, vector<shared_ptr<NCStackElement>> & output_arguments,NCFrame&frame);
    
    bool tree_doStaticMehothodCall(NCFrame & frame,NCMethodCallExpr*);
    bool tree_doClassMehothodCall(NCFrame & frame,NCMethodCallExpr*);
    bool tree_composeArgmemnts(NCFrame & frame,NCMethodCallExpr*node,vector<NCParameter>& parametersExpr, vector<shared_ptr<NCStackElement>>&args);
    
public:
    NCInterpreter(shared_ptr<NCASTRoot> root);
    NCInterpreter(){}
    
    bool initWithRoot(shared_ptr<NCASTRoot> root);
    
    bool invoke(string function, vector<string> &argumentNames, vector<shared_ptr<NCStackElement>> &arguments,vector<shared_ptr<NCStackElement>> & lastStack);
    bool invoke(string function, vector<shared_ptr<NCStackElement>> &arguments,vector<shared_ptr<NCStackElement>> & lastStack);
    
    bool invoke_constructor(string function, vector<shared_ptr<NCStackElement>> &arguments,vector<shared_ptr<NCStackElement>> & lastStack);
    
    void invoke_main(){
        vector<shared_ptr<NCStackElement>> arguments;
        vector<shared_ptr<NCStackElement>> stack;
        invoke("main", arguments, stack);
    }
    
    bool invoke(shared_ptr<NCNativeObject> & scope, const string& methodName, vector<shared_ptr<NCStackElement>> &arguments,vector<shared_ptr<NCStackElement>> & lastStack);
    
    bool visit(shared_ptr<NCASTNode> node, NCFrame & frame);
    bool visit(shared_ptr<NCASTNode> node, NCFrame & frame, bool * shouldReturn);  //recursive method
    bool visit(shared_ptr<NCASTNode> node, NCFrame & frame, bool * shouldReturn, bool * shouldBreak);
    
    void addFunction(shared_ptr<NCBuiltinFunction> & func){
//        m_builtinFunctionStore.addFunction(func);
        NCModuleCache::GetGlobalCache()->addSystemFunction(func);
    }
    
    shared_ptr<NCStackPointerElement> stackPopObjectPointer(NCFrame & frame);
};

#endif /* NCInterpreter_hpp */
