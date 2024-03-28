//
//  NCNSDictionaryWrapper.cpp
//  NaiveC
//
//  Created by mi on 2024/1/4.
//  Copyright © 2024 Ogreaxe. All rights reserved.
//

#include "NCNSDictionaryWrapper.hpp"
#include "NCLog.hpp"
#import <Foundation/Foundation.h>
#import "NCCocoaMapper.h"

extern NSObject *getNsObjectFromStackElement(shared_ptr<NCStackElement> &e);

NCNSDictionaryWrapper::NCNSDictionaryWrapper() {
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    LINK_COCOA_BOX(this, dict);
}

/*
 bracket access support
 */
void NCNSDictionaryWrapper::br_set(shared_ptr<NCStackElement> & key,shared_ptr<NCStackElement> &value) {
    NSObject *nk = getNsObjectFromStackElement(key);
    
    if (!nk) {
        NCLog(NCLogTypeInterpretor, "dict key illegal");
        return;
    }
    
    NSObject *nv = getNsObjectFromStackElement(value);
    
    if (!nv) {
        NCLog(NCLogTypeInterpretor, "dictionary value illegal");
        return;
    }
    
    NSMutableDictionary *dict = GET_NS_OBJECT;
        
    if ([nk conformsToProtocol:@protocol(NSCopying)]) {
        id<NSCopying> copyingKey = (id<NSCopying>)nk;
        dict[copyingKey] = nv;
    } else {
        NCLog(NCLogTypeInterpretor, "dictionary key not conforms to NSCopying");
    }
    
}

shared_ptr<NCStackElement> NCNSDictionaryWrapper::br_getValue(shared_ptr<NCStackElement> & key) {
    NSObject *nk = getNsObjectFromStackElement(key);
    
    if (!nk) {
        NCLog(NCLogTypeInterpretor, "dictionary key illegal");
        return nullptr;
    }
    
    NSMutableDictionary *arr = GET_NS_OBJECT;
    
    NSObject *obj = arr[nk];
    
//    NCCocoaBox *box = new NCCocoaBox(NC_COCOA_BRIDGE(obj));
//    auto box = new NCCocoaBox();
//    LINK_COCOA_BOX(box, obj);
    
    auto box = MAKE_COCOA_BOX(obj);
    
    return shared_ptr<NCStackPointerElement>(new NCStackPointerElement(box));
}
