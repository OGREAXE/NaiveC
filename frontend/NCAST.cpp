//
//  MCAST.cpp
//  MiniC
//
//  Created by 梁志远 on 19/08/2017.
//  Copyright © 2017 Ogreaxe. All rights reserved.
//

#include "NCAST.hpp"
    
shared_ptr<NCMethodCallExpr> NCObjCSendMessageExpr::getMehodCall(){
    if (!m_methodCallExpr) {
        string name = parameter_list[0];
        for (int i=1; i<parameter_list.size(); i++) {
            name += "_"+ parameter_list[i];
        }
        auto methodCall = new NCMethodCallExpr(argument_expression_list,scope,name);
        
        methodCall->formatArgs = format_argument_expression_list;
        
        m_methodCallExpr = shared_ptr<NCMethodCallExpr>(methodCall);
    }
    return m_methodCallExpr;
}
