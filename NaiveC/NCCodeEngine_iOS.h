//
//  NCCodeEngine.h
//  NaiveC
//
//  Created by Liang,Zhiyuan(GIS) on 2018/2/16.
//  Copyright © 2018年 Ogreaxe. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NPPatchedClass.h"

typedef NS_ENUM(NSUInteger, NCInterpretorMode) {
    NCInterpretorModeModular = 0,
    NCInterpretorModeCommandLine,
};

/**
 naive c code engine
 */
@interface NCCodeEngine_iOS : NSObject

@property (nonatomic) NCInterpretorMode mode;

+ (NCCodeEngine_iOS *)defaultEngine;

//used in project
-(void)setRoot:(NSString*)rootDir;
-(void)setDirty:(NSString*)filename;
-(BOOL)run;
-(BOOL)runWithError:(NSError**)error;

//play ground only
//run a piece of code
-(BOOL)run:(NSString*)sourceCode error:(NSError**)error;
-(BOOL)run:(NSString*)sourceCode mode:(NCInterpretorMode)mode error:(NSError**)error;

//arguments type should be NPValue
-(id)runWithMethod:(NPPatchedMethod*)method arguments:(NSArray *)arguments error:(NSError**)error;
@end
