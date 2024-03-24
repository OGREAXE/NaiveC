//
//  NCSymbolStore.hpp
//  NaiveC
//
//  Created by mi on 2024/3/8.
//  Copyright © 2024 Ogreaxe. All rights reserved.
//

#ifndef NCSymbolStore_hpp
#define NCSymbolStore_hpp

#include <stdio.h>
#include "NCStackElement.hpp"

class NCSymbolStore {
public:
    shared_ptr<NCStackElement> objectForName(string &name);
    
    shared_ptr<NCStackIntElement> intForName(string &name);
};

#endif /* NCSymbolStore_hpp */
