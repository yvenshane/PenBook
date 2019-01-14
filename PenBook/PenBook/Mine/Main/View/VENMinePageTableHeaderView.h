//
//  VENMinePageTableHeaderView.h
//  PenBook
//
//  Created by YVEN on 2019/1/6.
//  Copyright © 2019年 Hefei Haiba Network Technology Co., Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface VENMinePageTableHeaderView : UIView
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UIImageView *iconImageView;
@property (weak, nonatomic) IBOutlet UIButton *otherButton;
@property (weak, nonatomic) IBOutlet UILabel *xingzuoLabel;
@property (weak, nonatomic) IBOutlet UILabel *qianmingLabel;
@property (weak, nonatomic) IBOutlet UIButton *myFansButton;
@property (weak, nonatomic) IBOutlet UIButton *myFocusButton;
@property (weak, nonatomic) IBOutlet UIButton *myGameButton;
@property (weak, nonatomic) IBOutlet UIView *threeButtonBackgroundView;
@property (weak, nonatomic) IBOutlet UIView *shadowView;

@end
