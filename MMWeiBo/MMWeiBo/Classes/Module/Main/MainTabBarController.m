//
//  MainTabBarController.m
//  MMWeiBo
//
//  Created by 明亮 on 15/6/24.
//  Copyright © 2015年 zhssit. All rights reserved.
//

#import "MainTabBarController.h"
#import "MainTabBar.h"

@interface MainTabBarController ()

@end

@implementation MainTabBarController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self addChildViewControllers];
    
    [self setValue:[[MainTabBar alloc] init] forKey:@"tabBar"];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - 添加自控制器

- (void)addChildViewControllers
{
    [self addChildViewControllerWithName:@"HomeViewController" title:@"首页" imageName:@"tabbar_home"];
    [self addChildViewControllerWithName:@"MessageViewController" title:@"消息" imageName:@"tabbar_message_center"];
    [self addChildViewControllerWithName:@"DiscoverViewController" title:@"发现" imageName:@"tabbar_discover"];
    [self addChildViewControllerWithName:@"ProfileViewController" title:@"我" imageName:@"tabbar_profile"];
}

- (void)addChildViewControllerWithName:(NSString *)vcName title:(NSString *)title imageName:(NSString *)imageName
{
    //[NSBundle mainBundle].infoDictionary["CFBundleExecutable"]
    
    UIViewController *vc = [[NSClassFromString(vcName) alloc] init];
    vc.title = title;
    vc.tabBarItem.image = [UIImage imageNamed:imageName];
    vc.tabBarItem.selectedImage = [UIImage imageNamed:[NSString stringWithFormat:@"%@_highlighted", imageName]];
    
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:vc];
    
    [self addChildViewController:nav];
}

@end
