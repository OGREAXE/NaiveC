//
//  NCTextManager.m
//  NaiveC
//
//  Created by 梁志远 on 24/12/2017.
//  Copyright © 2017 Ogreaxe. All rights reserved.
//

#import "NCTextManager.h"
#import "NCInterpreterController.h"
#import "NCParser.hpp"

@interface ParensisInfo:NSObject
@property (nonatomic) unichar charactor;
@property (nonatomic) NSUInteger position;
@end

@implementation ParensisInfo
@end

@interface NCTextManager()

@property (nonatomic) NCDataSource* dataSource;

@property (nonatomic) NSMutableArray* parensisBalanceArray;

@end

@implementation NCTextManager

-(id)initWithDataSource:(NCDataSource*)dataSource{
    self = [super init];
    if (self) {
        _dataSource = dataSource;
        [_dataSource addDelegate:self];
        
        _parensisBalanceArray = [NSMutableArray array];
    }
    return self;
}

#pragma mark dataSource
-(void)textDidLoad:(NCDataSource*)dataSource{
    [self countParensisPairArrayWithText:dataSource.text];
}

-(void)textDidChange:(NCDataSource*)dataSource{
    [self countParensisPairArrayWithText:dataSource.text];
}

- (BOOL)dataSource:(NCDataSource *)dataSource shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text{
    if ([text isEqualToString:@"\n"]) {
//        NSUInteger balance = 0;
//        if (range.location == dataSource.text.length) {
//            balance = ((NSNumber*)[self.parensisBalanceArray lastObject]).unsignedIntegerValue;
//        }
//        else {
//            balance = ((NSNumber*)[self.parensisBalanceArray objectAtIndex:range.location]).unsignedIntegerValue;
//        }
//
//        NSMutableString * formatedEnter = [NSMutableString stringWithString:@"\n"];
//        for (int i = 0; i<balance-1; i++) {
//            //4 space
//            [formatedEnter appendString:@"    "];
//        }
//        [formatedEnter appendString:@"}"];
//
//        dataSource.text = [dataSource.text stringByReplacingCharactersInRange:range withString:formatedEnter];
        int lBalance = 0, totalBalance = 0;
        for (int i=0; i<self.parensisBalanceArray.count; i++) {
            ParensisInfo * pInfo = self.parensisBalanceArray[i];
            if (pInfo.position < range.location) {
                if (pInfo.charactor == '{') {
                    lBalance ++;
                    totalBalance ++;
                }
                else {
                    lBalance --;
                    totalBalance --;
                }
            }
            else {
                if (pInfo.charactor == '{') {
                    totalBalance ++;
                }
                else {
                    totalBalance --;
                }
            }
        }
        
        if(lBalance <= 0){
            return YES;
        }
        else {
            NSMutableString * formatedEnter = [NSMutableString stringWithString:@"\n"];
            for (int i = 0; i<lBalance-1; i++) {
                //4 space
                [formatedEnter appendString:@"    "];
            }
            if (totalBalance>0) {
                [formatedEnter appendString:@"}"];
            }
            else {
                [formatedEnter appendString:@"    "];
            }
            
            dispatch_async(dispatch_get_main_queue(), ^{
                            dataSource.text = [dataSource.text stringByReplacingCharactersInRange:range withString:formatedEnter];

            });
//            dataSource.text = [dataSource.text stringByReplacingCharactersInRange:range withString:formatedEnter];
            
            return NO;
        }
    }
    else if ([text isEqualToString:@"{"]|| [text isEqualToString:@"}"]){
        
    }
    
    return YES;
}

#pragma mark private methods
-(void)countParensisPairArrayWithText:(NSString*)text{
//    int leftBalance = 0;
    [self.parensisBalanceArray removeAllObjects];
    for (int i = 0; i<text.length; i++) {
        unichar chr = [text characterAtIndex:i];
        if (chr == '{'|| chr == '}') {
            ParensisInfo *pInfo = [ParensisInfo new];
            pInfo.position = i;
            pInfo.charactor = chr;
            [self.parensisBalanceArray addObject:pInfo];
        }
        
//        [self.parensisBalanceArray addObject:@(leftBalance)];
    }
}

#pragma mark interpreter delegate
-(void)interpreterController:(NCInterpreterController*)controller didFinishParsingDataSource:(NCDataSource*)dataSource WithParser:(void*)parser{
    auto _parser = (NCParser*)parser;
    auto tokens =  _parser->getTokens();
    for (int i=0;i<tokens->size();i++) {
        auto aToken = (*tokens)[i];
        
    }
}

@end
