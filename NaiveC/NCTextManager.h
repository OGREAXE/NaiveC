//
//  NCTextManager.h
//  NaiveC
//
//  Created by 梁志远 on 24/12/2017.
//  Copyright © 2017 Ogreaxe. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NCDataSource.h"
#import "NCInterpreterController.h"
#import "NCCodeTemplate.h"

@interface NCTextManager : NSObject<NCDataSourceDelegate,NCInterpreterControllerDelegate>

-(id)initWithDataSource:(NCDataSource*)dataSource;

-(void)insertCodeTemplate:(NCCodeTemplateType)type;

-(void)insertCodeTemplate:(NCCodeTemplateType)type placeholdersFillerArray:(NSArray*)fillers;

@end
