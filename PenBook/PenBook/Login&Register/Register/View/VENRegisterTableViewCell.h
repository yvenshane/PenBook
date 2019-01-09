//
//  VENRegisterTableViewCell.h
//  PenBook
//
//  Created by YVEN on 2019/1/9.
//  Copyright © 2019年 Hefei Haiba Network Technology Co., Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface VENRegisterTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIButton *topLabel;
@property (weak, nonatomic) IBOutlet UITextField *bottomTextField;
@property (weak, nonatomic) IBOutlet UIButton *rightButton;

@end

NS_ASSUME_NONNULL_END
