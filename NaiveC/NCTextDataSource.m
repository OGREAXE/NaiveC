//
//  NCTextDataSource.m
//  NaiveC
//
//  Created by 梁志远 on 24/12/2017.
//  Copyright © 2017 Ogreaxe. All rights reserved.
//

#import "NCTextDataSource.h"

@interface NCTextDataSource()<UITextViewDelegate>

@property (nonatomic) UITextView * textView;

@end

@implementation NCTextDataSource

-(id)initWithTextView:(UITextView*)textView{
    self = [super init];
    if (self) {
        self.textView = textView;
        self.textView.delegate = self;
    }
    return self;
}


-(void)countParensisPairArrayWithText:(NSString*)text{
    for (int i = 0; i<text.length; i++) {
        
    }
}


#pragma mark textView delegate
-(void)textViewDidChange:(UITextView *)textView{
    
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    if ([text isEqualToString:@"\n"]) {
        
    }
    
    return YES;
}

@end
