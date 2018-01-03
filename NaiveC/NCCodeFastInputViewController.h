//
//  NCCodeFastInputViewController.h
//  NaiveC
//
//  Created by Liang,Zhiyuan(GIS) on 2018/1/3.
//  Copyright © 2018年 Ogreaxe. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NCCodeTemplate.h"

typedef NS_ENUM(NSUInteger,NCFastInputType) {
    NCFastInputTypeIf = NCCodeTemplateIf,
    NCFastInputTypeIfElse = NCCodeTemplateIfElse,
    NCFastInputTypeFor = NCCodeTemplateFor,
    NCFastInputTypeWhile = NCCodeTemplateWhile,
    NCFastInputTypeFunc = NCCodeTemplateFunc,
};

@class NCCodeFastInputViewController;

@protocol NCCodeFastInputViewControllerDelegate<NSObject>

-(void)codeFastInputViewController:(NCCodeFastInputViewController*)controller didInput:(NSArray*)textArray type:(NCFastInputType)type;

-(void)didClose:(NCCodeFastInputViewController*)controller;

@end

@interface NCCodeFastInputViewController : UIViewController

@property (nonatomic ) NCFastInputType type;

@property (nonatomic ) id<NCCodeFastInputViewControllerDelegate> delegate;

@end
