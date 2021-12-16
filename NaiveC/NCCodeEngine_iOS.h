//
//  NCCodeEngine.h
//  NaiveC
//  implemented in C++
//
//  Created by Liang,Zhiyuan(GIS) on 2018/2/16.
//  Copyright © 2018年 Ogreaxe. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NCCodeEngine.h"

/**
 naive c code engine
 */
@interface NCCodeEngine_iOS : NSObject<NCCodeEngine>

@property (nonatomic) NCInterpretorMode mode;

//used in project
-(void)setRoot:(NSString*)rootDir;
-(void)setDirty:(NSString*)filename;
-(BOOL)run;
-(BOOL)runWithError:(NSError**)error;

//play ground only
//run a piece of code
-(BOOL)run:(NSString*)sourceCode error:(NSError**)error;
-(BOOL)run:(NSString*)sourceCode mode:(NCInterpretorMode)mode error:(NSError**)error;
@end
