//
//  NCTextManager.m
//  NaiveC
//
//  Created by 梁志远 on 24/12/2017.
//  Copyright © 2017 Ogreaxe. All rights reserved.
//

#import "NCTextManager.h"

@interface NCTextManager()

@property (nonatomic) NCTextDataSource* dataSource;

@property (nonatomic) NSMutableArray* parensisArray;

@end

@implementation NCTextManager

-(id)initWithDataSource:(NCTextDataSource*)dataSource{
    self = [super init];
    if (self) {
        _dataSource = dataSource;
        _dataSource.delegate = self;
    }
    return self;
}

#pragma mark dataSource
-(void)textDidLoad:(NCTextDataSource*)dataSource{
    
}

-(void)textDidChange:(NCTextDataSource*)dataSource{
    
}

- (BOOL)dataSource:(NCTextDataSource *)dataSource shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text{
    return YES;
}

#pragma mark private methods
-(void)countParensisPairArrayWithText:(NSString*)text{
    for (int i = 0; i<text.length; i++) {
        
    }
}

@end
