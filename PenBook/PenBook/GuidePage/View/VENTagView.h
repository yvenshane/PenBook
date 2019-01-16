//
//  VENTagView.h
//  PenBook
//
//  Created by YVEN on 2019/1/14.
//  Copyright © 2019年 Hefei Haiba Network Technology Co., Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface VENTagView : UIView
- (instancetype)initWithFrame:(CGRect)frame tagArray:(NSMutableArray*)tagArray;
@property (nonatomic,retain) NSArray* tagArray;
@property (nonatomic,retain) UIColor* textColorSelected;
@property (nonatomic,retain) UIColor* textColorNormal;
@property (nonatomic,retain) UIColor* backgroundColorSelected;
@property (nonatomic,retain) UIColor* backgroundColorNormal;

@property (nonatomic, strong) NSMutableArray *buttonsMuArr;

@end

NS_ASSUME_NONNULL_END
