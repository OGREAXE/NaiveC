//
//  NVCocoaEngine.h
//  NaiveC
//  implemented in Objective C/C++
//  Created by liangzhiyuan on 2021/12/16.
//  Copyright © 2021 Ogreaxe. All rights reserved.
//

#import "NVObject.h"
#import "NCCodeEngine.h"

NS_ASSUME_NONNULL_BEGIN

@interface NVCocoaEngine : NVObject<NCCodeEngine>

@property (nonatomic) NCInterpretorMode mode;

@property (nonatomic) NVStackElement *result;

@end

NS_ASSUME_NONNULL_END