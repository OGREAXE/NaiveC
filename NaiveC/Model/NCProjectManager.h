//
//  NCProjectManager.h
//  NaiveC
//
//  Created by 梁志远 on 31/12/2017.
//  Copyright © 2017 Ogreaxe. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NCProject.h"

@interface NCProjectManager : NSObject

+(instancetype)sharedManager;

-(NCProject*)defaultProject;

@end
