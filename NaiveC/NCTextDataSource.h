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

@protocol NCTextDataResponderDelegate

-(void)dataSource:(NCTextDataSource*)dataSource textDidLoad:(NSString*)text;

-(void)dataSource:(NCTextDataSource*)dataSource didInputText:(NSString*)text;

-(void)dataSource:(NCTextDataSource*)dataSource didDeleteText:(NSString*)text range:(NSRange)range;

@end

@interface NCTextDataSource : NSObject

-(id)initWithTextView:(UITextView*)textView;

@property (nonatomic) id<NCTextDataResponderDelegate> delegate;

@end
