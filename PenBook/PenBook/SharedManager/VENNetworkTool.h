//
//  VENNetworkTool.h
//
//  Copyright © 2018年 Hefei Haiba Network Technology Co., Ltd. All rights reserved.
//

#import "AFHTTPSessionManager.h"

@interface VENNetworkTool : AFHTTPSessionManager
+ (instancetype)sharedManager;

@end
