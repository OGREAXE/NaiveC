//
//  MCParser.hpp
//  MiniC
//
//  Created by 梁志远 on 15/08/2017.
//  Copyright © 2017 Ogreaxe. All rights reserved.
//

#ifndef MCParser_hpp
#define MCParser_hpp

#include <stdio.h>
#include <vector>
#include <string>
#include <set>
#include "NCAST.hpp"
#include "NCTokenizer.hpp"

using namespace std;

typedef AstNodePtr MCParserReturnType ;

class NCParser{
public:
    NCParser(){};
    NCParser(shared_ptr<const vector<NCToken>>& tokens);
    
    shared_ptr<NCASTRoot> getRoot(){return pRoot;}
    
    bool parse(shared_ptr<const vector<NCToken>>& tokens);
    
    shared_ptr<const vector<NCToken>> getTokens(){return tokens;}
private:
    
    shared_ptr<NCASTRoot> pRoot;
    
    shared_ptr<const vector<NCToken>> tokens;
    
//    multiset<string> keywords;
    
    string nextWord();
    
    string priviousWord();
    
    string peek(int n);
    
    void printNearTokens();
    
    int index;
    string word;
    
    bool lambdaFlag;  //indicate a lambda parse phrase start
    set<string> lambdaCapturedSymbols;
    
    bool isIdentifier(string & word);
    
    shared_ptr<NCBinaryExpression> addRight(shared_ptr<NCExpression> binExpr, shared_ptr<NCExpression> right, string op);
    
    typedef std::function<shared_ptr<NCExpression> ()> BinParserFunc;
    shared_ptr<NCExpression> parseBinExpr(vector<string> operators, BinParserFunc);
    
    bool vecInclude(vector<string>& operators, string op);
    
//    int tempIndex;
    vector<int> indexStack;
    
    void pushIndex();
    void popIndex();
    
    bool isIntegerLiteral(string&word, NCInt*);
    bool isFloatLiteral(string&word, NCFloat*);
    bool isStringLiteral(string&word, string& parsed);
    
    bool isAssignOperator(string&word);
private:
    //top-down parsing functions
    
    MCParserReturnType class_definition();
    
    bool class_body(vector<shared_ptr<NCBodyDeclaration>> & members);
    
    shared_ptr<NCBodyDeclaration> class_body_declaration();
    
    shared_ptr<NCExpression> field_expression(string & name);
    
    shared_ptr<NCConstructorDeclaration> constructor_definition();
    
    //function_definition-> type_specifier argumentlist compound_statement
    MCParserReturnType function_definition();
    
    //type_specifier-> string|int|float|void
    MCType type_specifier();
    
    bool  parameterlist(vector<NCParameter> & );
    
    bool parameter(NCParameter**);
    
    //declarator->direct_declarator
    MCParserReturnType declarator();
    
    //direct_declarator-> IDENTIFIER| '(' declarator ')'| direct_declarator '[' constant_expression ']'| direct_declarator '[' ']'| direct_declarator '(' parameter_type_list ')'| direct_declarator '(' identifier_list ')'| direct_declarator '(' ')'
    MCParserReturnType direct_declarator();
    
    //parameter_type_list-> parameter_list
    MCParserReturnType parameter_type_list();
    
    //parameter_list-> parameter_declaration | parameter_list ',' parameter_declaration
    MCParserReturnType parameter_list();
    
    //parameter_declaration-> declaration_specifiers  IDENTIFIER
    MCParserReturnType parameter_declaration();
    
    //declaration_specifiers-> type_specifier
    MCParserReturnType declaration_specifiers();
    
    //declaration_list->declaration| declaration_list declaration
    MCParserReturnType declaration_list();
    
    //declaration-> declaration_specifiers init_declarator_list ';'
    MCParserReturnType declaration();
    
    //init_declarator_list-> init_declarator| init_declarator_list ',' init_declarator
    MCParserReturnType init_declarator_list();
    
    //init_declarator-> declarator| declarator '=' initializer
    MCParserReturnType init_declarator();
    
    //statement_list-> statement| statement_list statement
    MCParserReturnType statement_list();
    
    //statement->compound_statement| expression_statement| selection_statement| iteration_statement| jump_statement
    shared_ptr<NCStatement> statement();
    
    shared_ptr<NCExpression> variable_initializer();
    
    shared_ptr<NCBlock> block();
    
    bool statements(vector<AstNodePtr>& statements);
    
    shared_ptr<NCStatement> blockStatement();
    
    shared_ptr<NCExpression> variable_declaration_expression();
    
    shared_ptr<NCExpression> variable_declarator();
    
    pair<string, vector<NCArrayBracketPair>> variable_declarator_id();
    
//    shared_ptr<NCExpressionStatement> expression_statement();
    
    //compound_statement-> '{' '}'| '{' statement_list '}'| '{' declaration_list '}'| '{' declaration_list statement_list '}'
    MCParserReturnType compound_statement();
    
    //expression_statement-> ';'| expression ';'
//    MCParserReturnType expression_statement();
    
    //selection_statement->IF '(' expression ')' statement| IF '(' expression ')' statement ELSE statement
    shared_ptr<NCStatement> selection_statement();
    
    shared_ptr<NCStatement> while_statement();
    
    shared_ptr<NCStatement> for_statement();
    
    bool for_init(vector<shared_ptr<NCExpression>>& init);
    
    bool for_update(vector<shared_ptr<NCExpression>>& update);
    
    shared_ptr<NCStatement> break_statement();
    
    shared_ptr<NCStatement> continue_statement();
    
    shared_ptr<NCStatement> return_statement();
    
    shared_ptr<NCStatement> expression_statement();
    
    //iteration_statement-> WHILE '(' expression ')' statement| DO statement WHILE '(' expression ')' ';'| FOR '(' expression_statement expression_statement ')' statement| FOR '(' expression_statement expression_statement expression ')' statement
    shared_ptr<NCStatement> iteration_statement();
    
    //jump_statement-> CONTINUE ';'| BREAK ';'| RETURN ';'| RETURN expression ';'
    MCParserReturnType jump_statement();
    
    //expression-> assignment_expression| expression ',' assignment_expression
    shared_ptr<NCExpression> expression();
    
    shared_ptr<NCArrayInitializer> array_initializer();
    
    shared_ptr<NCExpression> ns_array_initializer();
    
    shared_ptr<NCExpression> ns_string_expression();
    
    shared_ptr<NCExpression> ns_dictionary_initializer();
    
    shared_ptr<NCExpression> ns_selector_initializer();
    
    bool expression_list(vector<shared_ptr<NCExpression>>& exprList);
    
    //multiplicative_expression-> cast_expression| multiplicative_expression '*' cast_expression| multiplicative_expression '/' cast_expression| multiplicative_expression '%' cast_expression
    shared_ptr<NCExpression> multiplicative_expression();
    
    //additive_expression-> multiplicative_expression| additive_expression '+' multiplicative_expression| additive_expression '-' multiplicative_expression
    shared_ptr<NCExpression> additive_expression();
    
    //shift_expression-> additive_expression| shift_expression LEFT_OP additive_expression| shift_expression RIGHT_OP additive_expression
    shared_ptr<NCExpression> shift_expression();
    
    //relational_expression-> shift_expression| relational_expression '<' shift_expression| relational_expression '>' shift_expression| relational_expression LE_OP shift_expression| relational_expression GE_OP shift_expression
    shared_ptr<NCExpression> relational_expression();
    
    //equality_expression-> relational_expression| equality_expression EQ_OP relational_expression| equality_expression NE_OP relational_expression
    shared_ptr<NCExpression> equality_expression();
    
    //and_expression-> equality_expression| and_expression '&' equality_expression
    shared_ptr<NCExpression> and_expression();
    
    //exclusive_or_expression-> and_expression| exclusive_or_expression '^' and_expression
    shared_ptr<NCExpression> exclusive_or_expression();
    
    //inclusive_or_expression-> exclusive_or_expression| inclusive_or_expression '|' exclusive_or_expression
    shared_ptr<NCExpression> inclusive_or_expression();
    
    //logical_and_expression-> inclusive_or_expression| logical_and_expression AND_OP inclusive_or_expression
    shared_ptr<NCExpression> logical_and_expression();
    
    //logical_or_expression-> logical_and_expression| logical_or_expression OR_OP logical_and_expression
    shared_ptr<NCExpression> logical_or_expression();
    
    //conditional_expression->logical_or_expression
    shared_ptr<NCExpression> conditional_expression();
    
    //assignment_expression-> conditional_expression|unary_expression assignment_operator assignment_expression
    MCParserReturnType assignment_expression();
    
    //unary_expression-> postfix_expression| unary_operator unary_expression
    shared_ptr<NCExpression> unary_expression();
    
    //unary_operator-> '+'| '-'| '~'| '!'
    MCParserReturnType unary_operator();
    
    //assignment_operator-> '='
    MCParserReturnType assignment_operator();
    
    //postfix_expression-> primary_expression| postfix_expression '[' expression ']'| postfix_expression '(' ')'| postfix_expression '(' argument_expression_list ')'| postfix_expression '.' IDENTIFIER
    MCParserReturnType postfix_expression();
    
    //primary_expression-> IDENTIFIER
    shared_ptr<NCExpression> primary_expression();
    
    shared_ptr<NCExpression> primary_prefix();
    
    shared_ptr<NCExpression> primary_suffix(shared_ptr<NCExpression> scope);
    
    shared_ptr<NCExpression> literal();
    
    bool arguments_expression(vector<shared_ptr<NCExpression>> & args);
    
    bool arguments(vector<shared_ptr<NCExpression>> & args);
    
    bool keyValueList(vector<pair<shared_ptr<NCExpression>, shared_ptr<NCExpression>>> & args);
    
    bool keyvalue(pair<shared_ptr<NCExpression>, shared_ptr<NCExpression>> &kv);
    
    //argument_expression_list-> assignment_expression| argument_expression_list ',' assignment_expression
    MCParserReturnType argument_expression_list();
    
    shared_ptr<NCExpression> objc_syntactic_sugar();
    
    shared_ptr<NCExpression> objc_send_message();
};

#endif /* MCParser_hpp */
