//
//  VENExplorePageTableViewCell.h
//  PenBook
//
//  Created by YVEN on 2019/1/6.
//  Copyright © 2019年 Hefei Haiba Network Technology Co., Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface VENExplorePageTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *gameNameLabel;
@property (weak, nonatomic) IBOutlet UIImageView *iconImageView;
@property (weak, nonatomic) IBOutlet UILabel *userNameLabel;
@property (weak, nonatomic) IBOutlet UIButton *fucosButton;
@property (weak, nonatomic) IBOutlet UILabel *contentLabel;
@property (weak, nonatomic) IBOutlet UIButton *zanButton;
@property (weak, nonatomic) IBOutlet UIButton *focusButton;
@property (weak, nonatomic) IBOutlet UIButton *talkButton;
@property (weak, nonatomic) IBOutlet UIButton *shareButton;

@property (weak, nonatomic) IBOutlet UIView *gameView;
@property (weak, nonatomic) IBOutlet UIView *picView;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *picViewlayoutConstraint;

@end

NS_ASSUME_NONNULL_END
