//
//  NCTextDataSource.h
//  NaiveC
//
//  Created by 梁志远 on 24/12/2017.
//  Copyright © 2017 Ogreaxe. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@class NCTextDataSource;

@protocol NCTextDataResponderDelegate<NSObject>

-(void)textDidLoad:(NCTextDataSource*)dataSource;
-(void)textDidChange:(NCTextDataSource*)dataSource;
- (BOOL)dataSource:(NCTextDataSource *)dataSource shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text;

@end

@interface NCTextDataSource : NSObject

-(id)initWithTextView:(UITextView*)textView;

@property (nonatomic,weak) id<NCTextDataResponderDelegate> delegate;

@property (nonatomic) NSString * text;

@end
