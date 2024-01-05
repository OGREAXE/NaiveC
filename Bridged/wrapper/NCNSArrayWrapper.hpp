//
//  NCNSArrayWrapper.hpp
//  NaiveC
//
//  Created by mi on 2024/1/4.
//  Copyright © 2024 Ogreaxe. All rights reserved.
//

#ifndef NCNSArrayWrapper_hpp
#define NCNSArrayWrapper_hpp

#include <stdio.h>
#include "NCCocoaBox.hpp"

class NCNSArrayWrapper :public NCCocoaBox {
private:
    
public:
    NCNSArrayWrapper();
    
    virtual string getDescription();
    
    void addElement(shared_ptr<NCStackElement>&e);
    /*
     bracket access support
     */
    virtual void br_set(shared_ptr<NCStackElement> & key,shared_ptr<NCStackElement> &value);
    virtual shared_ptr<NCStackElement> br_getValue(shared_ptr<NCStackElement> & key);
    
    
    /**
     fast enumeration support

     @param anObj <#anObj description#>
     */
    virtual void enumerate(std::function<bool (shared_ptr<NCStackElement> anObj)> handler);
};

#endif /* NCNSArrayWrapper_hpp */
