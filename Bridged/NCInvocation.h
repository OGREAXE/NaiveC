//
//  NSObject+NCInvocation.h
//  NaiveC
//
//  Created by Liang,Zhiyuan(GIS) on 2018/2/15.
//  Copyright © 2018年 Ogreaxe. All rights reserved.
//

#import <Foundation/Foundation.h>

#include <stdio.h>
#include "NCObject.hpp"

@interface NCInvocation : NSObject

+ (BOOL)invoke:(NSString*)methodName object:(NSObject*)aObject orClass:(Class)aClass arguments:(vector<shared_ptr<NCStackElement>> &)arguments stack:(vector<shared_ptr<NCStackElement>>& )lastStack;

+ (BOOL)invokeSuper:(NSString*)methodName
             object:(NSObject*)aObject
            orClass:(Class)aClass
          arguments:(vector<shared_ptr<NCStackElement>> &)arguments
              stack:(vector<shared_ptr<NCStackElement>>& )lastStack;

-(BOOL)invoke:(NSString*)methodName arguments:(vector<shared_ptr<NCStackElement>> &)arguments stack:(vector<shared_ptr<NCStackElement>>& )lastStack;

-(shared_ptr<NCStackElement>)attributeForName:(const string & )attrName;

+ (NSDictionary *)genObjectWithStackElement:(shared_ptr<NCStackElement>)element;

+(shared_ptr<NCStackElement>)instanceVariableForName:(NSString*)ivarName withObject:(NSObject*)aObject;

+ (void)setInstanceVariable:(shared_ptr<NCStackElement>)ivar forName:(NSString*)ivarName withObject:(NSObject*)aObject;

@end
