//
//  NCStringFormatter.cpp
//  NaiveC
//
//  Created by mi on 2024/1/8.
//  Copyright © 2024 Ogreaxe. All rights reserved.
//

#include "NCStringFormatter.hpp"
#import <Foundation/Foundation.h>
#include "NCCocoaBox.hpp"

#include <string>

using namespace std;

BOOL isPrefixInt(NSString *searchedString) {
    NSArray *intPrefixList = @[
        @"d",
        @"i",
        @"c",
        @"o",
        @"u",
        @"ld",
        @"lu",
        @"llu",
        @"x",
    ];
    
    for (NSString *prefix in intPrefixList) {
        if ([searchedString hasPrefix:prefix]) {
            return YES;
        }
    }
    
    return NO;
}

BOOL isPrefixDouble(NSString *searchedString) {
    
    NSError* error = nil;

    NSRegularExpression* regex = [NSRegularExpression regularExpressionWithPattern:@"([0-9]*[.])?[0-9]*[f|Lf|e].*"
                                                                           options:0
                                                                             error:&error];
    
    NSTextCheckingResult *match = [regex firstMatchInString:searchedString options:0
                                                      range:NSMakeRange(0, searchedString.length)];
    
    
    return match != NULL;
}

//NSString *stringWithFormat(NSString *format, NSArray *arguments) {
//    if (!format) return NULL;
//    
//    NSArray *arr = [format componentsSeparatedByString:@"%"];
//    
//    NSString *s = arr[0];
//    
//    for (int i = 1; i < arr.count; i ++) {
//        NSString *component = arr[i];
//        
//        NSObject *argument = arguments[i-1];
//        
//        if ([component hasPrefix:@"@"]) {
//            s = [s stringByAppendingFormat:[@"%" stringByAppendingString:component], argument];
//        } else if (isPrefixInt(component)) {
//            NSNumber *num = (NSNumber *)argument;
//            s = [s stringByAppendingFormat:[@"%" stringByAppendingString:component], num.longLongValue];
//        } else if (isPrefixDouble(component)) {
//            NSNumber *num = (NSNumber *)argument;
//            s = [s stringByAppendingFormat:[@"%" stringByAppendingString:component], num.doubleValue];
//        }
//    }
//    
//    return s;
//}

NSString *stringWithFormat(string &strformat, vector<shared_ptr<NCStackElement>> &arguments) {
    
    if (!arguments.size()) return [NSString stringWithUTF8String:strformat.c_str()];
    
    NSString *format = [NSString stringWithUTF8String:strformat.c_str()];
    
    if (!format) return NULL;
    
    NSArray *arr = [format componentsSeparatedByString:@"%"];
    
    NSString *s = arr[0];
    
    for (int i = 1; i < arr.count; i ++) {
        NSString *component = arr[i];
        
        if (i-1 >= arguments.size()){
            break;
        };
        
        auto argument = arguments[i-1];
        
        if ([component hasPrefix:@"@"]) {
            auto value = argument;
            
            NSObject *nsObj = NULL;
            
//            NCObject *obj = nullptr;
//            if (dynamic_pointer_cast<NCStackVariableElement>(value)) {
//                auto pVar = dynamic_pointer_cast<NCStackVariableElement>(value);
//                if (dynamic_pointer_cast<NCStackPointerElement>(pVar->valueElement)) {
//                    auto pRet = dynamic_pointer_cast<NCStackPointerElement> (pVar->valueElement);
//                    obj = (pRet->getPointedObject()).get();
//                }
//            }
//            else if (dynamic_pointer_cast<NCStackPointerElement>(value)) {
//                auto pRet = dynamic_pointer_cast<NCStackPointerElement> (value);
//                obj = (pRet->getPointedObject()).get();
//            }
            
            NCObject *obj = value->toObject().get();
            
            if (obj) {
                auto box = dynamic_cast<NCCocoaBox *>(obj);
                
                if (box) {
                    nsObj = SAFE_GET_BOX_CONTENT(box);
                }
            }
            
            s = [s stringByAppendingFormat:[@"%" stringByAppendingString:component], nsObj];
            
        } else if (isPrefixInt(component)) {
            
            s = [s stringByAppendingFormat:[@"%" stringByAppendingString:component], argument->toInt()];
        } else if (isPrefixDouble(component)) {
            s = [s stringByAppendingFormat:[@"%" stringByAppendingString:component], argument->toFloat()];
        }
    }
    
    return s;
}

shared_ptr<NCStackElement> stringWithFormat(shared_ptr<NCStackElement> &strformat, vector<shared_ptr<NCStackElement>> &arguments) {
    auto str = strformat->toString();
    
    NSString *nsstr = stringWithFormat(str, arguments);
    
    auto box = MAKE_COCOA_BOX(nsstr);
    
    return shared_ptr<NCStackElement>(new NCStackPointerElement(box));
}

shared_ptr<NCStackElement> stringWithFormat(vector<shared_ptr<NCStackElement>> &arguments) {
    auto format = arguments[0];
    
    auto restArgs = arguments;
    
    restArgs.erase(restArgs.begin());
    
    return stringWithFormat(format, restArgs);
}
