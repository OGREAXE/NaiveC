//
//  NCTextDataSource.h
//  NaiveC
//
//  Created by 梁志远 on 24/12/2017.
//  Copyright © 2017 Ogreaxe. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@class NCDataSource;

@protocol NCDataSourceDelegate<NSObject>

-(void)textDidLoad:(NCDataSource*)dataSource;
-(void)textDidChange:(NCDataSource*)dataSource;
- (BOOL)dataSource:(NCDataSource *)dataSource shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text;

@end

@interface NCDataSource : NSObject

-(id)initWithTextView:(UITextView*)textView;

@property (nonatomic,weak) id<NCDataSourceDelegate> delegate;

@property (nonatomic) NSString * text;

@end
