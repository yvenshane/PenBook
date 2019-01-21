//
//  VENExplorePageDetailsTableViewCell.m
//  PenBook
//
//  Created by YVEN on 2019/1/16.
//  Copyright © 2019年 Hefei Haiba Network Technology Co., Ltd. All rights reserved.
//

#import "VENExplorePageDetailsTableViewCell.h"

@implementation VENExplorePageDetailsTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    self.iconImageView.layer.cornerRadius = 22.0f;
    self.iconImageView.layer.masksToBounds = YES;
    
    self.fucosButton.layer.cornerRadius = 8;
    self.fucosButton.layer.masksToBounds = YES;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
