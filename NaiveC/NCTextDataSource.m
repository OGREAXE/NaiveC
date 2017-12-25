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
        
        [self addObserver:self forKeyPath:@"textView.text" options:NSKeyValueObservingOptionNew context:nil];
    }
    return self;
}

-(void)dealloc{
    [self removeObserver:self forKeyPath:@"textView.text"];
}

-(void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context{
    if ([keyPath isEqualToString:@"textView.text"]) {
        if ([self.delegate respondsToSelector:@selector(textDidLoad:)]) {
            [self.delegate textDidLoad:self];
        }
    }
}

-(NSString*)text{
    return _textView.text;
}

-(void)setText:(NSString *)text{
    _textView.text = text;
}

#pragma mark textView delegate
-(void)textViewDidChange:(UITextView *)textView{
    if ([self.delegate respondsToSelector:@selector(textDidChange:)]) {
        [self.delegate textDidChange:self];
    }
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    if ([self.delegate respondsToSelector:@selector(dataSource:shouldChangeTextInRange:replacementText:)]) {
        return [self.delegate dataSource:self shouldChangeTextInRange:range replacementText:text];
    }
    
    return YES;
}

@end
