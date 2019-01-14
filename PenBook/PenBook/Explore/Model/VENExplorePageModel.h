//
//  VENExplorePageModel.h
//  PenBook
//
//  Created by YVEN on 2019/1/13.
//  Copyright © 2019年 Hefei Haiba Network Technology Co., Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface VENExplorePageModel : NSObject
@property (nonatomic, copy) NSString *articleID;
@property (nonatomic, copy) NSString *userid;
@property (nonatomic, copy) NSString *username;
@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *value;
@property (nonatomic, copy) NSString *give;
@property (nonatomic, copy) NSString *comment;
@property (nonatomic, copy) NSString *collect;
@property (nonatomic, copy) NSString *share;
@property (nonatomic, copy) NSString *uptime;
@property (nonatomic, copy) NSString *give_state;
@property (nonatomic, copy) NSString *name;

//image => [
//          arid=>所属文章id 和上面文章id是同一个值
//          image=>文章图片地址
//          ]

@end

NS_ASSUME_NONNULL_END
