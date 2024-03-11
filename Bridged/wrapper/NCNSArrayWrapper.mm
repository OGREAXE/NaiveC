//
//  NCNSArrayWrapper.cpp
//  NaiveC
//
//  Created by mi on 2024/1/4.
//  Copyright © 2024 Ogreaxe. All rights reserved.
//

#include "NCNSArrayWrapper.hpp"
#include "NCLog.hpp"
#import <Foundation/Foundation.h>
#import "NCCocoaMapper.h"

NCNSArrayWrapper::NCNSArrayWrapper() {
    NSMutableArray *arr = [NSMutableArray array];
    
//    m_cocoaObject = NC_COCOA_BRIDGE(arr);
    LINK_COCOA_BOX(this, arr);
}

string NCNSArrayWrapper::getDescription() {
    NSMutableArray *arr = GET_NS_OBJECT;
    
    return arr.description.UTF8String;
}

NSObject *getNsObjectFromStackElement(shared_ptr<NCStackElement> &e) {
    auto p = dynamic_pointer_cast<NCStackPointerElement>(e);
    
    if (!p) return NULL;
    
//    auto box = dynamic_cast<NCCocoaBox *>(p->getPointedObject().get());
    
    auto box = dynamic_pointer_cast<NCCocoaBox>(p->getPointedObject());
    
    if (!box) return NULL;
    
    return GET_NS_OBJECT_P(box);
}

/*
 bracket access support
 */
void NCNSArrayWrapper::br_set(shared_ptr<NCStackElement> & key,shared_ptr<NCStackElement> &value) {
    auto k = dynamic_cast<NCStackIntElement *>(key.get());
    
    if (!k) {
        NCLog(NCLogTypeInterpretor, "array key illegal");
        return;
    }
    
    NSObject *nv = getNsObjectFromStackElement(value);
    
    if (!nv) {
        NCLog(NCLogTypeInterpretor, "array key illegal");
        return;
    }
    
    NSMutableArray *arr = GET_NS_OBJECT;
        
    arr[k->value] = nv;
}

shared_ptr<NCStackElement> NCNSArrayWrapper::br_getValue(shared_ptr<NCStackElement> & key) {
    auto k = dynamic_cast<NCStackIntElement *>(key.get());
    
    if (!k) {
        NCLog(NCLogTypeInterpretor, "array key illegal");
        return nullptr;
    }
    
    NSMutableArray *arr = GET_NS_OBJECT;
    
    NSObject *obj = arr[k->value];
    
    NCCocoaBox *box = new NCCocoaBox();
    LINK_COCOA_BOX(box, obj);
    
    return shared_ptr<NCStackPointerElement>(new NCStackPointerElement(box));
}

void NCNSArrayWrapper::addElement(shared_ptr<NCStackElement>&e) {
    NSObject *nv = getNsObjectFromStackElement(e);
    
    NSMutableArray *arr = GET_NS_OBJECT;
    
    if (nv){
        [arr addObject:nv];
    }
}

/**
 fast enumeration support

 @param anObj <#anObj description#>
 */
void NCNSArrayWrapper::enumerate(std::function<bool (shared_ptr<NCStackElement> anObj)> handler) {
    
}
