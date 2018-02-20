//
//  NCCodeEngine.h
//  NaiveC
//
//  Created by Liang,Zhiyuan(GIS) on 2018/2/16.
//  Copyright © 2018年 Ogreaxe. All rights reserved.
//

#import <Foundation/Foundation.h>


/**
 naive c code engine
 */
@interface NCCodeEngine_iOS : NSObject
-(BOOL)run:(NSString*)sourceCode error:(NSError**)error;
@end
