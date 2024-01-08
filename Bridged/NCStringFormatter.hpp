//
//  NCStringFormatter.hpp
//  NaiveC
//
//  Created by mi on 2024/1/8.
//  Copyright © 2024 Ogreaxe. All rights reserved.
//

#ifndef NCStringFormatter_hpp
#define NCStringFormatter_hpp

#include <stdio.h>
#include "NCObject.hpp"

shared_ptr<NCStackElement> stringWithFormat(shared_ptr<NCStackElement> &strformat, vector<shared_ptr<NCStackElement>> &arguments);

#endif /* NCStringFormatter_hpp */
