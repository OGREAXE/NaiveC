//
//  ViewController.m
//  NaiveC
//
//  Created by 梁志远 on 16/09/2017.
//  Copyright © 2017 Ogreaxe. All rights reserved.
//

#import "ViewController.h"
#include "NCTokenizer.hpp"
#include "NCParser.hpp"
#include "NCInterpreter.hpp"
#include "NCTextManager.h"

@interface ViewController ()

@property (weak, nonatomic) IBOutlet  UITextView * textView;

@property (weak, nonatomic) IBOutlet  UITextView * outputView;

@property (nonatomic) NCTextManager * textManager;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Do any additional setup after loading the view, typically from a nib.
    
    //    string str = "int i=0 \n if(i==0)i=2+1";
    
    _textManager = [[NCTextManager alloc] initWithDataSource:[[NCTextDataSource alloc] initWithTextView:self.textView]];
    
    NSError * error = nil;
    NSString * filepath = [[NSBundle mainBundle] pathForResource:@"CodeTest" ofType:nil];
    NSString * fileContent = [NSString stringWithContentsOfFile:filepath encoding:NSUTF8StringEncoding error:&error];
    
    if (!error) {
        string str = fileContent.UTF8String;
        
        self.textView.text = [NSString stringWithUTF8String:str.c_str()];
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didReceivePrintNotification:) name:@"NCPrintStringNotification" object:nil];
    }
}

-(void)testNC{
    
    string str = self.textView.text.UTF8String;
    NCTokenizer tokenizer(str);
    const vector<NCToken> & tokens = tokenizer.getTokens();
    for (int i=0; i<tokens.size(); i++) {
        const auto & aToken = tokens[i];
        NSLog(@"%s",aToken.token.c_str());
    }
    
    vector<NCToken> _tokens = tokens;
    auto parser =  shared_ptr<NCParser>(new NCParser(_tokens));
    
    auto interpreter = shared_ptr<NCInterpreter>(new NCInterpreter(parser->getRoot()));
    interpreter->invoke_main();
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(IBAction)didTapCompile:(id)sender{
    self.outputView.text = @"";
    [self testNC];
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self.view endEditing:YES];
}

-(void)didReceivePrintNotification:(NSNotification*)notification{
    NSString * str = notification.object;
    
    self.outputView.text = [[[self.outputView.text stringByAppendingString:str]stringByReplacingOccurrencesOfString:@"\\n" withString:@"\n"] stringByAppendingString:@"\n"];
}


@end
