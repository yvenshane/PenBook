//
//  VENMineTableViewCell.m
//  PenBook
//
//  Created by YVEN on 2019/1/6.
//  Copyright © 2019年 Hefei Haiba Network Technology Co., Ltd. All rights reserved.
//

#import "VENMineTableViewCell.h"

@implementation VENMineTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    self.iconImageView.layer.cornerRadius = 34 / 2;
    self.iconImageView.layer.masksToBounds = YES;
    
    self.gameNameButton.layer.cornerRadius = 8;
    self.gameNameButton.layer.masksToBounds = YES;
    
    self.picViewLayoutConstraint.constant = (kMainScreenWidth - 60) / 3;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
