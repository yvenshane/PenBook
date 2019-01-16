//
//  VENMinePageTableHeaderView.m
//  PenBook
//
//  Created by YVEN on 2019/1/6.
//  Copyright © 2019年 Hefei Haiba Network Technology Co., Ltd. All rights reserved.
//

#import "VENMinePageTableHeaderView.h"

@implementation VENMinePageTableHeaderView

- (void)drawRect:(CGRect)rect {
    self.threeButtonBackgroundView.layer.cornerRadius = 12.0f;
    self.threeButtonBackgroundView.layer.shadowColor = COLOR_THEME.CGColor;
    self.threeButtonBackgroundView.layer.shadowOffset = CGSizeMake(1, 4);
    self.threeButtonBackgroundView.layer.shadowOpacity = 0.1;
    self.threeButtonBackgroundView.layer.shadowRadius = 12.0f;
    self.threeButtonBackgroundView.layer.shadowPath = [UIBezierPath bezierPathWithRect:CGRectMake(0, 0, kMainScreenWidth - 40, 74)].CGPath;
    
    self.myFansButton.layer.cornerRadius = 12.0f;
    self.myFansButton.layer.masksToBounds = YES;
    
    self.myGameButton.layer.cornerRadius = 12.0f;
    self.myGameButton.layer.masksToBounds = YES;
    
    self.otherButton.layer.cornerRadius = 10.0f;
    self.otherButton.layer.masksToBounds = YES;
    
    self.iconImageView.layer.cornerRadius = 74 / 2;
    self.iconImageView.layer.masksToBounds = YES;
}

@end
