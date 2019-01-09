//
//  VENNetworkTool.h
//
//  Created by YVEN.
//  Copyright © 2018年 Hefei Haiba Network Technology Co., Ltd. All rights reserved.
//

#import "AFHTTPSessionManager.h"

typedef void (^SuccessBlock)(id response);
typedef void (^FailureBlock)(NSError *error);
typedef void (^NetworkStatusBlock)(NSString *status);

typedef enum {
    HTTPMethodGet,
    HTTPMethodPost
} HTTPMethod;

@interface VENNetworkTool : AFHTTPSessionManager
+ (instancetype)sharedManager;
- (BOOL)isConnectInternet;
- (void)startMonitorNetworkWithBlock:(NetworkStatusBlock)block;

@end
