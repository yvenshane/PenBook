//
//  VENMinePageSettingViewController.h
//  PenBook
//
//  Created by YVEN on 2019/1/7.
//  Copyright © 2019年 Hefei Haiba Network Technology Co., Ltd. All rights reserved.
//

#import "VENBaseViewController.h"
typedef void (^loginoutSuccess)(NSString *);

@interface VENMinePageSettingViewController : VENBaseViewController
@property (nonatomic, copy) loginoutSuccess block;

@end
