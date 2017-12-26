//
//  NCTextManager.h
//  NaiveC
//
//  Created by 梁志远 on 24/12/2017.
//  Copyright © 2017 Ogreaxe. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NCDataSource.h"

@interface NCTextManager : NSObject<NCDataSourceDelegate>

-(id)initWithDataSource:(NCDataSource*)dataSource;

@end
