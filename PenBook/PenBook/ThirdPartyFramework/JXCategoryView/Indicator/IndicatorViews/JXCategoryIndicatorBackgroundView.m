//
//  JXCategoryIndicatorBackgroundView.m
//  JXCategoryView
//
//  Created by jiaxin on 2018/8/17.
//  Copyright © 2018年 jiaxin. All rights reserved.
//

#import "JXCategoryIndicatorBackgroundView.h"
#import "JXCategoryFactory.h"

@implementation JXCategoryIndicatorBackgroundView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        _backgroundViewWidth = JXCategoryViewAutomaticDimension;
        _backgroundViewHeight = JXCategoryViewAutomaticDimension;
        _backgroundViewCornerRadius = JXCategoryViewAutomaticDimension;
        _backgroundViewColor = [UIColor lightGrayColor];
        _backgroundViewWidthIncrement = 10;
    }
    return self;
}

#pragma mark - JXCategoryComponentProtocol

- (void)jx_refreshState:(CGRect)selectedCellFrame {
    self.layer.cornerRadius = [self getBackgroundViewCornerRadius:selectedCellFrame];
    self.backgroundColor = self.backgroundViewColor;

    CGFloat width = [self getBackgroundViewWidth:selectedCellFrame];
    CGFloat height = [self getBackgroundViewHeight:selectedCellFrame];
    CGFloat x = selectedCellFrame.origin.x + (selectedCellFrame.size.width - width)/2;
    CGFloat y = (selectedCellFrame.size.height - height)/2;
    self.frame = CGRectMake(x, y, width, height);
    
    [self setupBackgroundViewShadow:width and:height];
}

- (void)jx_contentScrollViewDidScrollWithLeftCellFrame:(CGRect)leftCellFrame rightCellFrame:(CGRect)rightCellFrame selectedPosition:(JXCategoryCellClickedPosition)selectedPosition percent:(CGFloat)percent {

    CGFloat targetX = 0;
    CGFloat targetWidth = [self getBackgroundViewWidth:leftCellFrame];

    if (percent == 0) {
        targetX = leftCellFrame.origin.x + (leftCellFrame.size.width - targetWidth)/2.0;
    }else {
        CGFloat leftWidth = targetWidth;
        CGFloat rightWidth = [self getBackgroundViewWidth:rightCellFrame];

        CGFloat leftX = leftCellFrame.origin.x + (leftCellFrame.size.width - leftWidth)/2;
        CGFloat rightX = rightCellFrame.origin.x + (rightCellFrame.size.width - rightWidth)/2;

        targetX = [JXCategoryFactory interpolationFrom:leftX to:rightX percent:percent];

        if (self.backgroundViewWidth == JXCategoryViewAutomaticDimension) {
            targetWidth = [JXCategoryFactory interpolationFrom:leftWidth to:rightWidth percent:percent];
        }
    }

    //允许变动frame的情况：1、允许滚动；2、不允许滚动，但是已经通过手势滚动切换一页内容了；
    if (self.scrollEnabled == YES || (self.scrollEnabled == NO && percent == 0)) {
        CGFloat height = [self getBackgroundViewHeight:leftCellFrame];
        CGFloat y = (leftCellFrame.size.height - height)/2;
        self.frame = CGRectMake(targetX, y, targetWidth, height);
    }
}

- (void)jx_selectedCell:(CGRect)cellFrame clickedRelativePosition:(JXCategoryCellClickedPosition)clickedRelativePosition isClicked:(BOOL)isClicked {
    CGFloat width = [self getBackgroundViewWidth:cellFrame];
    CGFloat height = [self getBackgroundViewHeight:cellFrame];
    CGFloat x = cellFrame.origin.x + (cellFrame.size.width - width)/2;
    CGFloat y = (cellFrame.size.height - height)/2;
    CGRect toFrame = CGRectMake(x, y, width, height);
    
    [self setupBackgroundViewShadow:width and:height];
    
    if (self.scrollEnabled) {
        [UIView animateWithDuration:0.25 delay:0 options:UIViewAnimationOptionCurveLinear animations:^{
            self.frame = toFrame;
        } completion:^(BOOL finished) {
        }];
    }else {
        self.frame = toFrame;
    }
    
    
}

- (void)setupBackgroundViewShadow:(CGFloat)width and:(CGFloat)height {
    self.layer.shadowColor = COLOR_THEME.CGColor;
    self.layer.shadowOffset = CGSizeMake(-2, -2);
    self.layer.shadowOpacity = 0.15;
    self.layer.shadowRadius = 8;
    self.layer.shadowPath = [UIBezierPath bezierPathWithRect:CGRectMake(0, 0, width + 10, height + 10)].CGPath;
}

#pragma mark - Private

- (CGFloat)getBackgroundViewWidth:(CGRect)cellFrame
{
    if (self.backgroundViewWidth == JXCategoryViewAutomaticDimension) {
        return cellFrame.size.width  + self.backgroundViewWidthIncrement;
    }
    return self.backgroundViewWidth + self.backgroundViewWidthIncrement;
}

- (CGFloat)getBackgroundViewHeight:(CGRect)cellFrame
{
    if (self.backgroundViewHeight == JXCategoryViewAutomaticDimension) {
        return cellFrame.size.height;
    }
    return self.backgroundViewHeight;
}

- (CGFloat)getBackgroundViewCornerRadius:(CGRect)cellFrame {
    if (self.backgroundViewCornerRadius == JXCategoryViewAutomaticDimension) {
        return [self getBackgroundViewHeight:cellFrame]/2;
    }
    return self.backgroundViewCornerRadius;
}

@end
