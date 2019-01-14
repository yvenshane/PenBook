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
- (void)requestWithMethod:(HTTPMethod)method path:(NSString *)path params:(NSDictionary *)params showLoading:(BOOL)isShow successBlock:(SuccessBlock)success failureBlock:(FailureBlock)failure;
- (void)startMonitorNetworkWithBlock:(NetworkStatusBlock)block;
- (NSString *)getIPAddress;
- (NSString *)getIDFA;

@end
