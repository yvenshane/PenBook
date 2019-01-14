//
//  VENMinePagemMyGameTableViewCell.m
//  PenBook
//
//  Created by YVEN on 2019/1/7.
//  Copyright © 2019年 Hefei Haiba Network Technology Co., Ltd. All rights reserved.
//

#import "VENMinePagemMyGameTableViewCell.h"

@implementation VENMinePagemMyGameTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code

    self.rightButton.layer.cornerRadius = 8.0f;
    self.rightButton.layer.masksToBounds = YES;
}

- (void)setStarCount:(NSString *)starCount {
    for (NSInteger i = 0; i < [starCount integerValue]; i++) {
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(i * 10, 0, 10, 10)];
        imageView.image = [UIImage imageNamed:@"icon_like"];
        [self.starView addSubview:imageView];
    }
    
    return;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
