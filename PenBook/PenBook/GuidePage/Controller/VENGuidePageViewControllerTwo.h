//
//  VENGuidePageViewControllerTwo.h
//  PenBook
//
//  Created by YVEN on 2019/1/8.
//  Copyright © 2019年 Hefei Haiba Network Technology Co., Ltd. All rights reserved.
//

#import "VENBaseViewController.h"

NS_ASSUME_NONNULL_BEGIN

typedef void (^finishBlock)(NSString *);
@interface VENGuidePageViewControllerTwo : VENBaseViewController
@property (nonatomic, copy) finishBlock blk;

@end

NS_ASSUME_NONNULL_END
