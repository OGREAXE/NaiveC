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

@property (nonatomic, readonly) NSString * sourceId;

@property (nonatomic) NSMutableArray<id<NCDataSourceDelegate>> *delegateArray;

@property (nonatomic) NSString * text;

@property (nonatomic) NSRange selectedRange;

@property (nonatomic) BOOL isEntryPoint;

-(void)addDelegate:(id<NCDataSourceDelegate>)aDelegate;

-(void)deleteDelegate:(id<NCDataSourceDelegate>)aDelegate;

-(void)replaceRange:(NSRange)range withText:(NSString*)text;

-(BOOL)save:(NSError**)error;

@end
 
@interface NCTextViewDataSource:NCDataSource

@property (nonatomic) NSString * linkedStorage;

-(id)initWithTextView:(UITextView*)textView;

@end
