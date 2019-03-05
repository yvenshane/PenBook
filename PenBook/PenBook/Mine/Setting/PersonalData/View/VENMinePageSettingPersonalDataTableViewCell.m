//
//  VENMinePageSettingPersonalDataTableViewCell.m
//  PenBook
//
//  Created by YVEN on 2019/3/2.
//  Copyright © 2019 Hefei Haiba Network Technology Co., Ltd. All rights reserved.
//

#import "VENMinePageSettingPersonalDataTableViewCell.h"

@implementation VENMinePageSettingPersonalDataTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    self.iconButton.layer.cornerRadius = 56 / 2;
    self.iconButton.layer.masksToBounds = YES;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
