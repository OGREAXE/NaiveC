//
//  NCProjectManager.m
//  NaiveC
//
//  Created by 梁志远 on 31/12/2017.
//  Copyright © 2017 Ogreaxe. All rights reserved.
//

#import "NCProjectManager.h"

@implementation NCProjectManager

+(instancetype)sharedManager{
    static NCProjectManager * instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[NCProjectManager alloc] init];
    });
    return instance;
}

-(NCProject*)defaultProject{
    NCProject * project = [[NCProject alloc] initWithRoot:[NSString stringWithFormat:@"%@/Documents/projects/project0/",NSHomeDirectory()]];
    return project;
}

@end
