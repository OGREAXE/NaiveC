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

-(BOOL)removeSourceFile:(NCSourceFile*)file project:(NCProject*)project error:(NSError**)error;

-(NCSourceFile*)createSourceFile:(NSString*)name project:(NCProject*)project error:(NSError**)error;

@end
