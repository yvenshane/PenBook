//
//  VENRegisterTableViewCell.m
//  PenBook
//
//  Created by YVEN on 2019/1/9.
//  Copyright © 2019年 Hefei Haiba Network Technology Co., Ltd. All rights reserved.
//

#import "VENRegisterTableViewCell.h"

@implementation VENRegisterTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    self.rightButton.layer.cornerRadius = 19.0f;
    self.rightButton.layer.masksToBounds = YES;
    self.rightButton.layer.borderColor = UIColorFromRGB(0xEBEBEB).CGColor;
    self.rightButton.layer.borderWidth = 1;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
