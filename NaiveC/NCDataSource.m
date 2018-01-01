//
//  NCDataSource.m
//  NaiveC
//
//  Created by 梁志远 on 24/12/2017.
//  Copyright © 2017 Ogreaxe. All rights reserved.
//

#import "NCDataSource.h"
#import "NCConsole.h"

@implementation NCDataSource

-(void)addDelegate:(id<NCDataSourceDelegate>)aDelegate{
    [self.delegateArray addObject:aDelegate];
}

-(NSMutableArray<id<NCDataSourceDelegate>> *)delegateArray{
    if (!_delegateArray) {
        _delegateArray = [NSMutableArray array];
    }
    return _delegateArray;
}

@end

@interface NCTextViewDataSource()<UITextViewDelegate>

@property (nonatomic) UITextView * textView;

@end

@implementation NCTextViewDataSource

-(id)initWithTextView:(UITextView*)textView{
    self = [super init];
    if (self) {
        self.textView = textView;
        self.textView.delegate = self;
        
        self.delegateArray = [NSMutableArray array];
        
        [self addObserver:self forKeyPath:@"textView.text" options:NSKeyValueObservingOptionNew context:nil];
    }
    return self;
}

-(NSString*)sourceId{
    return @"NCTextViewDataSource";  //only one textView per App so return constant
}

-(void)dealloc{
    [self removeObserver:self forKeyPath:@"textView.text"];
}

-(void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context{
    if ([keyPath isEqualToString:@"textView.text"]) {
        [self.delegateArray enumerateObjectsUsingBlock:^(id<NCDataSourceDelegate>  delegate, NSUInteger idx, BOOL * _Nonnull stop) {
            if ([delegate respondsToSelector:@selector(textDidLoad:)]) {
                [delegate textDidLoad:self];
            }
        }];
    }
}

-(NSString*)text{
    return _textView.text;
}

-(void)setText:(NSString *)text{
    _textView.text = text;
}

-(NSRange)selectedRange{
    return _textView.selectedRange;
}

-(void)setSelectedRange:(NSRange)selectedRange{
    _textView.selectedRange = selectedRange;
}

-(void)replaceRange:(NSRange)range withText:(NSString*)text{
    UITextPosition *beginning = self.textView.beginningOfDocument;
    UITextPosition *start = [self.textView positionFromPosition:beginning offset:range.location];
    UITextPosition *end = [self.textView positionFromPosition:start offset:range.length];
    if (end == nil) {
        end = self.textView.endOfDocument;
    }
    UITextRange *textRange = [self.textView textRangeFromPosition:start toPosition:end];
    
    [self.textView replaceRange:textRange withText:text];
}

#pragma mark textView delegate
-(void)textViewDidChange:(UITextView *)textView{
    [self.delegateArray enumerateObjectsUsingBlock:^(id<NCDataSourceDelegate>  delegate, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([delegate respondsToSelector:@selector(textDidChange:)]) {
            [delegate textDidChange:self];
        }
    }];
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    __block BOOL shouldChange = YES;
    [self.delegateArray enumerateObjectsUsingBlock:^(id<NCDataSourceDelegate>  delegate, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([delegate respondsToSelector:@selector(dataSource:shouldChangeTextInRange:replacementText:)]) {
            shouldChange = [delegate dataSource:self shouldChangeTextInRange:range replacementText:text];
        }
    }];
    
    return shouldChange;
}

-(BOOL)save:(NSError**)error{
    [self.textView.text writeToFile:self.linkedStorage atomically:YES encoding:NSUTF8StringEncoding error:error];
    if (*error) {
        NCLog(@"save source error: %@",*error);
        return NO;
    }
    return YES;
}

-(void)setLinkedStorage:(NSString *)linkedStorage{
    _linkedStorage = linkedStorage;
    
    NSError * error = nil;
    //    NSString * filepath = [[NSBundle mainBundle] pathForResource:@"CodeTest" ofType:nil];
//    NSString * filepath = self.sourceFile.filepath;
    NSString * fileContent = [NSString stringWithContentsOfFile:linkedStorage encoding:NSUTF8StringEncoding error:&error];
    
    if (!error) {
        self.text = fileContent;
    }
}

@end
