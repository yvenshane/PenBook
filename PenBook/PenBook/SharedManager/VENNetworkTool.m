//
//  VENNetworkTool.m
//
//  Copyright © 2018年 Hefei Haiba Network Technology Co., Ltd. All rights reserved.
//

#import "VENNetworkTool.h"

@implementation VENNetworkTool

static VENNetworkTool *instance;
static dispatch_once_t onceToken;

+ (instancetype)sharedManager {
    dispatch_once(&onceToken, ^{
        
        NSURL *baseURL = [NSURL URLWithString:@"http://ad.bestmago.com/"];
        NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
        configuration.timeoutIntervalForRequest = 15;
        instance = [[self alloc] initWithBaseURL:baseURL sessionConfiguration:configuration];
        instance.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/html",@"text/json", @"text/javascript", nil];
    });
    return instance;
}

@end
