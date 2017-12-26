//
//  NCTextManager.m
//  NaiveC
//
//  Created by 梁志远 on 24/12/2017.
//  Copyright © 2017 Ogreaxe. All rights reserved.
//

#import "NCTextManager.h"

@interface NCTextManager()

@property (nonatomic) NCDataSource* dataSource;

@property (nonatomic) NSMutableArray* parensisArray;

@end

@implementation NCTextManager

-(id)initWithDataSource:(NCDataSource*)dataSource{
    self = [super init];
    if (self) {
        _dataSource = dataSource;
        _dataSource.delegate = self;
    }
    return self;
}

#pragma mark dataSource
-(void)textDidLoad:(NCDataSource*)dataSource{
    
}

-(void)textDidChange:(NCDataSource*)dataSource{
    
}

- (BOOL)dataSource:(NCDataSource *)dataSource shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text{
    
    return YES;
}

#pragma mark private methods
-(void)countParensisPairArrayWithText:(NSString*)text{
    for (int i = 0; i<text.length; i++) {
        
    }
}

@end
