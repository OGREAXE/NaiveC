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

extern NSObject *getNsObjectFromStackElement(shared_ptr<NCStackElement> &e);

NCNSDictionaryWrapper::NCNSDictionaryWrapper() {
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    
    m_cocoaObject = NC_COCOA_BRIDGE(dict);
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
    
    NCCocoaBox *box = new NCCocoaBox(NC_COCOA_BRIDGE(obj));
    
    return shared_ptr<NCStackPointerElement>(new NCStackPointerElement(box));
}
