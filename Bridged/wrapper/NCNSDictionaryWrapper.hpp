//
//  NCNSDictionaryWrapper.hpp
//  NaiveC
//
//  Created by mi on 2024/1/4.
//  Copyright © 2024 Ogreaxe. All rights reserved.
//

#ifndef NCNSDictionaryWrapper_hpp
#define NCNSDictionaryWrapper_hpp

#include <stdio.h>
#include "NCObject.hpp"
#include "NCCocoaBox.hpp"

class NCNSDictionaryWrapper :public NCCocoaBox {
private:
    
public:
    NCNSDictionaryWrapper();
    
    /*
     bracket access support
     */
    virtual void br_set(shared_ptr<NCStackElement> & key,shared_ptr<NCStackElement> &value);
    virtual shared_ptr<NCStackElement> br_getValue(shared_ptr<NCStackElement> & key);
    
    
    /**
     fast enumeration support

     @param anObj <#anObj description#>
     */
//    virtual void enumerate(std::function<bool (shared_ptr<NCStackElement> anObj)> handler);
};

#endif /* NCNSDictionaryWrapper_hpp */
