//
//  ViewController.m
//  DownloadFile
//
//  Created by 明亮 on 15/6/12.
//  Copyright (c) 2015年 zhssit. All rights reserved.
//

#import "ViewController.h"
#import "DownloadManager.h"

#define BUTTON_TITLE_PAUSE @"暂停"
#define BUTTON_TITLE_CONTINUE @"继续"

@interface ViewController ()
@property (weak, nonatomic) IBOutlet UIProgressView *progressView;
@property (weak, nonatomic) IBOutlet UIButton *btnDownload;
@property (weak, nonatomic) IBOutlet UIButton *btnPause;
@property (strong, nonatomic) NSURL *url;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    self.btnPause.enabled = NO;
}

- (IBAction)btnDownloadClick:(id)sender {
    self.btnDownload.enabled = NO;
    self.btnPause.enabled = YES;
    [[DownloadManager sharedManager] downloadWithUrl:self.url progressBlock:^(float progress) {
        dispatch_async(dispatch_get_main_queue(), ^{
            self.progressView.progress = progress;
        });
    } finishedBlock:^(id obj) {
        NSLog(@"%@", obj);
        dispatch_async(dispatch_get_main_queue(), ^{
            self.btnDownload.enabled = YES;
            self.btnPause.enabled = NO;
        });
    }];
    
}

- (IBAction)btnPauseClick:(id)sender {
    if ([self.btnPause.titleLabel.text isEqualToString:BUTTON_TITLE_PAUSE]) {
        [self.btnPause setTitle:BUTTON_TITLE_CONTINUE forState:UIControlStateNormal];
        [[DownloadManager sharedManager] pause:self.url];
    }
    else {
        [self.btnPause setTitle:BUTTON_TITLE_PAUSE forState:UIControlStateNormal];
        [[DownloadManager sharedManager] downloadWithUrl:self.url progressBlock:^(float progress) {
            dispatch_async(dispatch_get_main_queue(), ^{
                self.progressView.progress = progress;
            });
        } finishedBlock:^(id obj) {
            NSLog(@"%@", obj);
            dispatch_async(dispatch_get_main_queue(), ^{
                self.btnDownload.enabled = YES;
                self.btnPause.enabled = NO;
            });
        }];
    }
    
}

- (NSURL *)url
{
    if (_url == nil) {
        _url = [NSURL URLWithString:@"http://dldir1.qq.com/qqfile/QQforMac/QQ_V4.0.2.dmg"];
    }
    return _url;
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    
//    NSOperationQueue *queue = [[NSOperationQueue alloc] init];
//    DownloadOperation *operation = [DownloadOperation operationWithUrl:url progressBlock:^(float progress) {
//        //
//    } finishedBlock:^(id obj) {
//        NSLog(@"");
//    }];
//    [queue addOperation:operation];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
