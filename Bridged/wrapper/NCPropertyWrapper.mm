//
//  NCPropertyWrapper.m
//  Naive-C
//
//  Created by mi on 2024/3/22.
//  Copyright © 2024 Ogreaxe. All rights reserved.
//

#import "NCPropertyWrapper.h"

#include "NCObject.hpp"
#include "NCStackElement.hpp"

@interface NCPropertyWrapper ()
- (void)setStackElement:(shared_ptr<NCStackElement>)element forName:(const string &)name;
- (shared_ptr<NCStackElement>)stackElementForName:(const string &)name;
@end

@implementation NCPropertyWrapper {
//    shared_ptr<NCStackElement> _element;
    
    map<string, shared_ptr<NCStackElement>> _map;
}

- (void)setStackElement:(shared_ptr<NCStackElement>)element forName:(const string &)name {
    _map[name] = element;
}

- (shared_ptr<NCStackElement>)stackElementForName:(const string &)name {
    if (_map.find(name) != _map.end()) {
        return _map[name];
    }
    
    return nullptr;
}

//
//- (void)setStackElement:(shared_ptr<NCStackElement>)element {
//    _element = element;
//}
//
//- (shared_ptr<NCStackElement>)getStackElement {
//    return _element;
//}

@end
