//
//  VENExplorePageTableViewCell.m
//  PenBook
//
//  Created by YVEN on 2019/1/6.
//  Copyright © 2019年 Hefei Haiba Network Technology Co., Ltd. All rights reserved.
//

#import "VENExplorePageTableViewCell.h"

@implementation VENExplorePageTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    self.iconImageView.layer.cornerRadius = 22.0f;
    self.iconImageView.layer.masksToBounds = YES;
    
    self.fucosButton.layer.cornerRadius = 8.0f;
    self.fucosButton.layer.masksToBounds = YES;
    
    
    UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:self.gameNameLabel.bounds byRoundingCorners:UIRectCornerBottomLeft|UIRectCornerBottomRight cornerRadii:CGSizeMake(16, 16)];
    
    CAShapeLayer *maskLayer = [CAShapeLayer layer];
    maskLayer.frame = self.gameNameLabel.bounds;
    maskLayer.path = maskPath.CGPath;
    
    self.gameNameLabel.layer.mask = maskLayer;
    
    
    
    self.picViewlayoutConstraint.constant = (kMainScreenWidth - 44) / 3;
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
