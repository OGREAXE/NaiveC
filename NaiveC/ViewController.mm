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

@interface ViewController ()

@property (weak, nonatomic) IBOutlet  UITextView * textView;

@property (weak, nonatomic) IBOutlet  UITextView * outputView;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    //    string str = "int i=0 \n if(i==0)i=2+1";
    
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
    const vector<string> & tokens = tokenizer.getTokens();
    for (int i=0; i<tokens.size(); i++) {
        const string & token = tokens[i];
        NSLog(@"%s",token.c_str());
    }
    
    vector<string> _tokens = tokens;
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

-(void)didReceivePrintNotification:(NSNotification*)notification{
    NSString * str = notification.object;
    
    self.outputView.text = [[self.outputView.text stringByAppendingString:str]stringByReplacingOccurrencesOfString:@"\\n" withString:@"\n"];
}


@end
