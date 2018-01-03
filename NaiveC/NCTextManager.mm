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

struct BalanceInfo{
    int lBalance = 0;
    int totalBalance = 0;
    int insertPos = -1;
    BOOL insertAfterLeftParensis = NO;
    NSString * baseIndent;
};

@interface NCTextManager()

@property (nonatomic) NCDataSource* dataSource;

@property (nonatomic) NSMutableArray* parensisBalanceArray;

@property (nonatomic) BOOL shouldRecaculateParensis;

@end

@implementation NCTextManager

-(id)initWithDataSource:(NCDataSource*)dataSource{
    self = [super init];
    if (self) {
        _dataSource = dataSource;
        [_dataSource addDelegate:self];
        
        _shouldRecaculateParensis = NO;
        _parensisBalanceArray = [NSMutableArray array];
    }
    return self;
}

#pragma mark dataSource
-(void)textDidLoad:(NCDataSource*)dataSource{
    [self countParensisPairArrayWithText:dataSource.text];
}

-(void)textDidChange:(NCDataSource*)dataSource{
//    if (self.shouldRecaculateParensis) {
//        [self countParensisPairArrayWithText:dataSource.text];
//        self.shouldRecaculateParensis = NO;
//    }
    [self countParensisPairArrayWithText:dataSource.text];
}

- (BOOL)dataSource:(NCDataSource *)dataSource shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text{
    if ([text length] == 0){
        //backspace
        NSString * deletedText = [dataSource.text substringWithRange:range];
        if ([deletedText isEqualToString:@"{"]|| [deletedText isEqualToString:@"}"]){
            //recalculate parensis pair
            _shouldRecaculateParensis = YES;
        }
    }
    else if ([text isEqualToString:@"\n"]) {
        int lBalance = 0, totalBalance = 0;
        int insertPos = -1;
        BOOL insertAfterLeftParensis = NO;
//        for (int i=0; i<self.parensisBalanceArray.count; i++) {
//            ParensisInfo * pInfo = self.parensisBalanceArray[i];
//            if (pInfo.position < range.location) {
//                if (pInfo.charactor == '{') {
//                    lBalance ++;
//                    totalBalance ++;
//                }
//                else {
//                    lBalance --;
//                    totalBalance --;
//                }
//            }
//            else {
//                if (insertPos == -1) {
//                    insertPos = i;
//                    if (i>0 && ((ParensisInfo *)self.parensisBalanceArray[i-1]).charactor == '{') {
//                        insertAfterLeftParensis = YES;
//                    }
//                }
//
//                if (pInfo.charactor == '{') {
//                    totalBalance ++;
//                }
//                else {
//                    totalBalance --;
//                }
//            }
//        }
        BalanceInfo balanceInfo = [self calBalanceInfoWithRange:range];
        lBalance = balanceInfo.lBalance;
        totalBalance = balanceInfo.totalBalance;
        insertPos = balanceInfo.insertPos;
        insertAfterLeftParensis = balanceInfo.insertAfterLeftParensis;
        
        
        if(lBalance <= 0){
            return YES;
        }
        else {
            NSRange selectedRange = dataSource.selectedRange;
            NSMutableString * formatedEnter = [NSMutableString stringWithString:@"\n"];
//            for (int i = 0; i<lBalance-1; i++) {
//                //4 space
//                [formatedEnter appendString:@"    "];
//            }
            [formatedEnter appendString:balanceInfo.baseIndent];
            
            if (totalBalance>0) {
                //balance not met, need to add '}'
                if (insertAfterLeftParensis) {
                    selectedRange.location = selectedRange.location  + formatedEnter.length + 4;
                    formatedEnter = [NSMutableString stringWithFormat:@"%@    %@}",formatedEnter,formatedEnter];
                }
                else {
                    selectedRange.location += formatedEnter.length+1;
                    [formatedEnter appendString:@"}"];
                }
                
                //recalculate parensis pair
                _shouldRecaculateParensis = YES;
            }
            else {
                selectedRange.location = selectedRange.location  + formatedEnter.length + 4;
                [formatedEnter appendString:@"    "];
            }
            
            range.length += 1;
//            [dataSource replaceRange:range withText:formatedEnter];

            dispatch_async(dispatch_get_main_queue(), ^{
                [dataSource replaceRange:range withText:formatedEnter];
            });
            
            //change pos after a short time or cursor is not right
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.01 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                dataSource.selectedRange = selectedRange;
            });
            
            return NO;
        }
    }
    else if ([text isEqualToString:@"{"]|| [text isEqualToString:@"}"]){
        //recalculate parensis pair
        _shouldRecaculateParensis = YES;
    }
    
    return YES;
}

-(BalanceInfo)calBalanceInfoWithRange:(NSRange)range{
    int lBalance = 0, totalBalance = 0;
    int insertPos = -1;
    BOOL insertAfterLeftParensis = NO;
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
            if (insertPos == -1) {
                insertPos = i;
                if (i>0 && ((ParensisInfo *)self.parensisBalanceArray[i-1]).charactor == '{') {
                    insertAfterLeftParensis = YES;
                }
            }
            
            if (pInfo.charactor == '{') {
                totalBalance ++;
            }
            else {
                totalBalance --;
            }
        }
    }
    
    NSMutableString * baseIndent = [NSMutableString string];
    for (int i = 0; i<lBalance-1; i++) {
        //4 space
        [baseIndent appendString:@"    "];
    }
    
    struct BalanceInfo bInfo;
    bInfo.lBalance = lBalance;
    bInfo.totalBalance = totalBalance;
    bInfo.insertPos = insertPos;
    bInfo.insertAfterLeftParensis = insertAfterLeftParensis;
    bInfo.baseIndent = baseIndent;
    
    return bInfo;
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
//    auto _parser = (NCParser*)parser;
//    auto tokens =  _parser->getTokens();
//    for (int i=0;i<tokens->size();i++) {
//        auto aToken = (*tokens)[i];
//
//    }
}

-(void)insertCodeTemplate:(NCCodeTemplateType)type{
//    NSString * template = [NCCodeTemplate templa]
    auto bInfo = [self calBalanceInfoWithRange:self.dataSource.selectedRange];
    NSString * indent = [NSString stringWithFormat:@"%@%@",@"    ",bInfo.baseIndent];
    NSString * templateStr = [NCCodeTemplate templateWithType:type baseIndent:indent];
    [self.dataSource replaceRange:self.dataSource.selectedRange withText:templateStr];
}

-(void)insertCodeTemplate:(NCCodeTemplateType)type placeholdersFillerArray:(NSArray*)fillers{
    //    NSString * template = [NCCodeTemplate templa]
    auto bInfo = [self calBalanceInfoWithRange:self.dataSource.selectedRange];
    NSString * indent = [NSString stringWithFormat:@"%@%@",@"    ",bInfo.baseIndent];
    NSString * templateStr = [NCCodeTemplate templateWithType:type baseIndent:indent fillerStringArray:fillers];
    [self.dataSource replaceRange:self.dataSource.selectedRange withText:templateStr];
}

@end
