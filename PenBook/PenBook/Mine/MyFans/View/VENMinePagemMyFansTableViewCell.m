//
//  VENMinePagemMyFansTableViewCell.m
//  PenBook
//
//  Created by YVEN on 2019/1/7.
//  Copyright © 2019年 Hefei Haiba Network Technology Co., Ltd. All rights reserved.
//

#import "VENMinePagemMyFansTableViewCell.h"

@implementation VENMinePagemMyFansTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    self.iconImageView.layer.cornerRadius = 22.0f;
    self.iconImageView.layer.masksToBounds = YES;
    
    self.rightButton.layer.cornerRadius = 8.0f;
    self.rightButton.layer.masksToBounds = YES;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
