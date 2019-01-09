//
//  VENLoginStatusManager.h
//  PenBook
//
//  Created by YVEN on 2019/1/9.
//  Copyright © 2019年 Hefei Haiba Network Technology Co., Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface VENLoginStatusManager : NSObject
+ (instancetype)sharedManager;
- (BOOL)isLogin;

@end

NS_ASSUME_NONNULL_END
