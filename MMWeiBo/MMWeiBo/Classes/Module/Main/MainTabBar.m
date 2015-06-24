//
//  MainTabBar.m
//  MMWeiBo
//
//  Created by 明亮 on 15/6/24.
//  Copyright © 2015年 zhssit. All rights reserved.
//

#import "MainTabBar.h"

@interface MainTabBar ()

@property (nonatomic, assign) int btnCount;
@property (nonatomic, weak) UIButton *btnCompoes;

@end

@implementation MainTabBar


- (void)layoutSubviews
{
    [super layoutSubviews];
    //NSLog(@"%d", self.btnCount);
    CGFloat w = self.bounds.size.width / (self.btnCount + 1);
    CGRect rect = CGRectMake(0, 0, w, self.bounds.size.height);
    int index = 0;
    for (id subview in self.subviews) {
        if ([subview isKindOfClass:[UIControl class]]) {
            [subview setFrame:CGRectOffset(rect, w * index, 0)];
            index = index == (self.btnCount / 2 - 1) ? index + 2 : index + 1;
        }
    }
    self.btnCompoes.frame = CGRectOffset(rect, w * (self.btnCount / 2), 0);
}

- (int)btnCount
{
    if (_btnCount == 0) {
        for (id subview in self.subviews) {
            if ([subview isKindOfClass:[UIControl class]]) {
                _btnCount++;
            }
        }
    }
    return _btnCount;
}

- (UIButton *)btnCompoes
{
    if (_btnCompoes == nil) {
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        [btn setImage:[UIImage imageNamed:@"tabbar_compose_icon_add"] forState:UIControlStateNormal];
        [btn setImage:[UIImage imageNamed:@"tabbar_compose_icon_add_highlighted"] forState:UIControlStateHighlighted];
        [btn setBackgroundImage:[UIImage imageNamed:@"tabbar_compose_button"] forState:UIControlStateNormal];
        [btn setBackgroundImage:[UIImage imageNamed:@"tabbar_compose_button_highlighted"] forState:UIControlStateHighlighted];
        [btn addTarget:self action:@selector(btnCompoesClick) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:btn];
        _btnCompoes = btn;
    }
    return _btnCompoes;
}

- (void)btnCompoesClick
{
    NSLog(@"compoes");
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
