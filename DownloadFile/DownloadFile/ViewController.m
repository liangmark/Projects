//
//  ViewController.m
//  DownloadFile
//
//  Created by 明亮 on 15/6/12.
//  Copyright (c) 2015年 zhssit. All rights reserved.
//

#import "ViewController.h"
#import "DownloadOperation.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    NSURL *url = [NSURL URLWithString:@"http://127.0.0.1/01-Vim.mp4"];
    NSOperationQueue *queue = [NSOperationQueue mainQueue];
    DownloadOperation *operation = [DownloadOperation operationWithUrl:url];
    [queue addOperation:operation];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
