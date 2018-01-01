//
//  NCAddNewFileViewController.m
//  NaiveC
//
//  Created by 梁志远 on 01/01/2018.
//  Copyright © 2018 Ogreaxe. All rights reserved.
//

#import "NCAddNewFileViewController.h"
#import "Common.h"
#import "NCEditorViewController.h"
#import "NCProjectManager.h"

@interface NCAddNewFileViewController ()

@property (nonatomic) IBOutlet UITextField * textField;

@property (nonatomic) IBOutlet UIButton * okButton;

@end

@implementation NCAddNewFileViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(IBAction)didTapOk:(id)sender{
//    NSString * filename = self.textField.text;
//    NSString * projectPath = self.currentProject.rootDirectory;
//    NSString * filepath = [projectPath stringByAppendingPathComponent:filename];
//
    NSError * error = nil;
//    [@"" writeToFile:filepath atomically:YES encoding:NSUTF8StringEncoding error:&error];
    
    NCSourceFile * file = [[NCProjectManager sharedManager] createSourceFile:self.textField.text project:self.currentProject error:&error];
    
    if (error) {
        NSLog(@"write file fail: %@",error);
    }
    else {
        NCEditorViewController * controller = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:NSStringFromClass([NCEditorViewController class])];
        
        controller.sourceFile = file;
        
        [self.navigationController pushViewController:controller animated:YES];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            NSArray *currentControllers = self.navigationController.viewControllers;
            
            NSMutableArray *newControllers = [NSMutableArray
                                              arrayWithArray:currentControllers];
            [newControllers removeObject:self];
            
            self.navigationController.viewControllers = newControllers;
        });
    }
}

@end
