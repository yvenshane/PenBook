//
//  VENExplorePageSubviewsController.h
//  PenBook
//
//  Created by YVEN on 2019/1/6.
//  Copyright © 2019年 Hefei Haiba Network Technology Co., Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef void (^pushNewViewControllerBlock)(NSString *);

@interface VENExplorePageSubviewsController : UIViewController
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, copy) NSString *gamenid;

@property (nonatomic, copy) pushNewViewControllerBlock block;

@end




