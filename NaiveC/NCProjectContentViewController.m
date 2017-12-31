//
//  NCProjectContentViewController.m
//  NaiveC
//
//  Created by 梁志远 on 31/12/2017.
//  Copyright © 2017 Ogreaxe. All rights reserved.
//

#import "NCProjectContentViewController.h"
#import "NCProjectManager.h"
#import "NCEditorViewController.h"

@interface NCProjectContentViewController ()<UITableViewDataSource, UITableViewDelegate>

@property  (nonatomic) IBOutlet UITableView * tableView;

@property  (nonatomic) NCProject * project;

@end

@implementation NCProjectContentViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.project = [[NCProjectManager sharedManager] defaultProject];
    
    [self.tableView reloadData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.project.sourceFiles.count;
}

// Row display. Implementers should *always* try to reuse cells by setting each cell's reuseIdentifier and querying for available reusable cells with dequeueReusableCellWithIdentifier:
// Cell gets various attributes set automatically based on table (separators) and data source (accessory views, editing controls)

#define CONTENTVIEWCELL_REUSEIDENTIFIER @"contentViewCell"

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell * cell = [self.tableView dequeueReusableCellWithIdentifier:CONTENTVIEWCELL_REUSEIDENTIFIER];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CONTENTVIEWCELL_REUSEIDENTIFIER];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    NCSourceFile * file = self.project.sourceFiles[indexPath.row];
    
    cell.textLabel.text = file.filename;
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NCEditorViewController * controller = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:NSStringFromClass([NCEditorViewController class])];
    
    controller.sourceFile = self.project.sourceFiles[indexPath.row];
    
    [self.navigationController pushViewController:controller animated:YES];
}

@end
