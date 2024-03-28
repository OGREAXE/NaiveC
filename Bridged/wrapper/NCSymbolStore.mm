//
//  NCSymbolStore.cpp
//  NaiveC
//
//  Created by mi on 2024/3/8.
//  Copyright © 2024 Ogreaxe. All rights reserved.
//

#include "NCSymbolStore.hpp"
#import "NSCocoaSymbolStore.h"
#include "NCCocoaBox.hpp"
#import "NCCocoaMapper.h"

shared_ptr<NCStackElement> NCSymbolStore::objectForName(string &name) {
    NSString *nsName = [NSString stringWithUTF8String:name.c_str()];
    id obj = [NSCocoaSymbolStore symbolForName:nsName];
    
//    auto box = new NCCocoaBox();
//    LINK_COCOA_BOX(box, obj);
    
    auto box = MAKE_COCOA_BOX(obj);
    
    return shared_ptr<NCStackElement>(new NCStackPointerElement(box));
}

shared_ptr<NCStackIntElement> NCSymbolStore::intForName(string &name) {
    NSString *nsName = [NSString stringWithUTF8String:name.c_str()];
    id obj = [NSCocoaSymbolStore symbolForName:nsName];
    
    if (!obj || ![obj isKindOfClass:NSNumber.class])return nullptr;
    
    NSNumber *num = obj;
    
    return shared_ptr<NCStackIntElement>(new NCStackIntElement(num.intValue));
}
