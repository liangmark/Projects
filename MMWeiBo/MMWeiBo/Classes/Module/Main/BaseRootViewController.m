//
//  BaseRootViewController.m
//  MMWeiBo
//
//  Created by 明亮 on 15/6/24.
//  Copyright © 2015年 zhssit. All rights reserved.
//

#import "BaseRootViewController.h"
#import "VisitorView.h"

@interface BaseRootViewController ()

@property (nonatomic, assign, getter=isUserLogon) BOOL userlogon;
@property (nonatomic, strong) VisitorView *visitor;

@end

@implementation BaseRootViewController

- (VisitorView *)visitor
{
    if (_visitor == nil) {
        _visitor = [[VisitorView alloc] init];
        _visitor.backgroundColor = [UIColor colorWithWhite:237.0 / 255.0 alpha:1.0];
    }
    return _visitor;
}

- (void)loadView {
    
    self.userlogon = true;
    
    self.userlogon ? [super loadView] : [self loadVisitorView];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"注册" style:UIBarButtonItemStylePlain target:self action:@selector(registerButtonClick)];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"登录" style:UIBarButtonItemStylePlain target:self action:@selector(logonButtonClick)];
}

- (void)loadVisitorView {
    self.view = self.visitor;
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
#warning Incomplete implementation, return the number of sections
    return 0;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
#warning Incomplete implementation, return the number of rows
    return 0;
}

- (void)registerButtonClick
{
    NSLog(@"register");
}

- (void)logonButtonClick
{
    NSLog(@"logon");
}

@end
