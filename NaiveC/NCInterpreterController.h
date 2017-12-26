//
//  NCInterpreterController.h
//  NaiveC
//
//  Created by Liang,Zhiyuan(GIS) on 2017/12/25.
//  Copyright © 2017年 Ogreaxe. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NCDataSource.h"

@class NCInterpreterController;

@protocol NCInterpreterControllerDelegate<NSObject>

-(void)didFinishTokenization:(NCInterpreterController*)controller;

-(void)didFinishParsing:(NCInterpreterController*)controller;

@end

@interface NCInterpreterController : NSObject<NCDataSourceDelegate>

-(id)initWithDataSource:(NCDataSource*)dataSource;

@property (nonatomic) NSArray * tokenArray;

@property (nonatomic) id<NCInterpreterControllerDelegate> delegate;

-(BOOL)reinterprete;

-(BOOL)reparse;

@end
