//
//  VENMBProgressHUDManager.h
//
//  Copyright © 2018年 Hefei Haiba Network Technology Co., Ltd. All rights reserved.
//

#import "MBProgressHUD.h"

NS_ASSUME_NONNULL_BEGIN

@interface VENMBProgressHUDManager : MBProgressHUD
+ (instancetype)sharedManager;
- (void)showText:(NSString *)text;

@end

NS_ASSUME_NONNULL_END
