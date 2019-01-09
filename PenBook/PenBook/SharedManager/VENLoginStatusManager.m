//
//  VENLoginStatusManager.m
//  PenBook
//
//  Created by YVEN on 2019/1/9.
//  Copyright © 2019年 Hefei Haiba Network Technology Co., Ltd. All rights reserved.
//

#import "VENLoginStatusManager.h"

static id instance;
static dispatch_once_t onceToken;
@implementation VENLoginStatusManager

+ (instancetype)sharedManager {
    dispatch_once(&onceToken, ^{
        instance = [[VENLoginStatusManager alloc] init];
    });
    return instance;
}

- (BOOL)isLogin {
    return [[NSUserDefaults standardUserDefaults] objectForKey:@"Login"] ? YES : NO;
}

@end
