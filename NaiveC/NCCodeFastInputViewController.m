//
//  NCCodeFastInputViewController.m
//  NaiveC
//
//  Created by Liang,Zhiyuan(GIS) on 2018/1/3.
//  Copyright © 2018年 Ogreaxe. All rights reserved.
//

#import "NCCodeFastInputViewController.h"

@interface NCCodeFastInputViewController ()

@property (nonatomic) IBOutlet NSLayoutConstraint * view1Height;
@property (nonatomic) IBOutlet NSLayoutConstraint * view2Height;
@property (nonatomic) IBOutlet NSLayoutConstraint * view3Height;

@property (nonatomic) IBOutlet UILabel * titleLabel;

@property (nonatomic) IBOutlet UILabel * label1;
@property (nonatomic) IBOutlet UITextField * textField1;

@property (nonatomic) IBOutlet UILabel * label2;
@property (nonatomic) IBOutlet UITextField * textField2;

@property (nonatomic) IBOutlet UILabel * label3;
@property (nonatomic) IBOutlet UITextField * textField3;

@end

@implementation NCCodeFastInputViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self loadType];
    
    [self.textField1 becomeFirstResponder];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

-(IBAction)didTapOk:(id)sender{
    if (self.delegate) {
        NSMutableArray * array = [NSMutableArray new];
        switch (self.type) {
            case NCFastInputTypeIf:
            case NCFastInputTypeIfElse:
                [array addObject:self.textField1.text];
                break;
            case NCFastInputTypeFor:
                [array addObject:self.textField1.text];
                [array addObject:self.textField2.text];
                [array addObject:self.textField3.text];
                break;
            case NCFastInputTypeWhile:
                [array addObject:self.textField1.text];
                break;
            case NCFastInputTypeFunc:
                [array addObject:self.textField1.text];
                [array addObject:self.textField2.text];
                [array addObject:self.textField3.text];
                break;
            default:
                break;
        }
        if ([self.delegate respondsToSelector:@selector(codeFastInputViewController:didInput:type:)]) {
            [self.delegate codeFastInputViewController:self didInput:array type:self.type];
        }
    }
             
    [self dismissViewControllerAnimated:YES completion:^{
        if ([self.delegate respondsToSelector:@selector(didClose:)]) {
            [self.delegate didClose:self];
        }
    }];
}

-(IBAction)didTapCancel:(id)sender{
    [self dismissViewControllerAnimated:YES completion:^{
        if ([self.delegate respondsToSelector:@selector(didClose:)]) {
            [self.delegate didClose:self];
        }
    }];
}

-(void)loadType{
    switch (self.type) {
        case NCFastInputTypeIf:
        case NCFastInputTypeIfElse:
            self.view2Height.constant = 0;
            self.view3Height.constant = 0;
            self.titleLabel.text = @"if";
            self.label1.text = @"condition";
            break;
        case NCFastInputTypeFor:
            self.titleLabel.text = @"for";
            self.label1.text = @"init";
            self.label2.text = @"condition";
            self.label3.text = @"update";
            break;
        case NCFastInputTypeWhile:
            self.view2Height.constant = 0;
            self.view3Height.constant = 0;
            self.titleLabel.text = @"while";
            self.label1.text = @"condition";
            break;
        case NCFastInputTypeFunc:
            self.titleLabel.text = @"function";
            self.label1.text = @"return";
            self.label2.text = @"name";
            self.label3.text = @"arguments";
            break;
        default:
            break;
    }
    [self.view setNeedsLayout];
}

@end
