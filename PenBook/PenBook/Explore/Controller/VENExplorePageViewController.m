//
//  VENExplorePageViewController.m
//  PenBook
//
//  Created by YVEN on 2018/12/17.
//  Copyright © 2018年 Hefei Haiba Network Technology Co., Ltd. All rights reserved.
//

#import "VENExplorePageViewController.h"
#import "JXCategoryView.h"
#import "VENExplorePageSubviewsController.h"
#import "VENGuidePageViewControllerTwo.h"
#import "VENExplorePageModel.h"

#import "VENGuidePageViewControllerFive.h"

@interface VENExplorePageViewController () <JXCategoryViewDelegate>
@property (nonatomic, strong) JXCategoryTitleView *categoryView;
@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) NSMutableArray <VENExplorePageSubviewsController *> *listVCArray;
@property (nonatomic, strong) NSMutableArray *navTitlesMuArr;
@property (nonatomic, copy) NSArray *dataArr;

@end

@implementation VENExplorePageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.view.backgroundColor = [UIColor whiteColor];
    self.edgesForExtendedLayout = UIRectEdgeNone;
    
    if (![[NSUserDefaults standardUserDefaults] objectForKey:@"first"]) {
        VENGuidePageViewControllerFive *vc = [[VENGuidePageViewControllerFive alloc] init];
        vc.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:vc animated:NO];
    } else {
        
        
        if (![[VENClassEmptyManager sharedManager] isEmptyString:[[NSUserDefaults standardUserDefaults] objectForKey:@"Login"][@"userid"]]) {
            
            [self loadDataWith:@{@"userid" : [[NSUserDefaults standardUserDefaults] objectForKey:@"Login"][@"userid"]}];
        }
        
        [self setupNavigationItemLeftBarButtonItem];
        [self setupNavigationItemRightBarButtonItem];
    }
}

- (void)loadDataWith:(NSDictionary *)params {
    
    [[VENNetworkTool sharedManager] requestWithMethod:HTTPMethodGet path:@"Recordkernel/gamenavig" params:nil showLoading:NO successBlock:^(id response) {
        
        for (NSDictionary *dict in response) {
            [self.navTitlesMuArr addObject:dict[@"game"]];
        }
        
    } failureBlock:^(NSError *error) {
        
    }];
    
    [[VENNetworkTool sharedManager] requestWithMethod:HTTPMethodGet path:@"Recordkernel/gamearticle" params:params showLoading:NO successBlock:^(id response) {
        
        NSArray *dataArr = [NSArray yy_modelArrayWithClass:[VENExplorePageModel class] json:response[@"arr"]];
        self.dataArr = dataArr;
        
        [self setupCategoryView];
        
    } failureBlock:^(NSError *error) {
        
    }];
}

//这句代码必须加上
- (BOOL)shouldAutomaticallyForwardAppearanceMethods {
    return NO;
}

#pragma mark - JXCategoryViewDelegate

- (void)categoryView:(JXCategoryBaseView *)categoryView didSelectedItemAtIndex:(NSInteger)index {
    //侧滑手势处理
    self.navigationController.interactivePopGestureRecognizer.enabled = (index == 0);
}

- (void)categoryView:(JXCategoryBaseView *)categoryView didClickSelectedItemAtIndex:(NSInteger)index {
    
}

- (void)categoryView:(JXCategoryBaseView *)categoryView didScrollSelectedItemAtIndex:(NSInteger)index {
    
}

- (void)categoryView:(JXCategoryBaseView *)categoryView scrollingFromLeftIndex:(NSInteger)leftIndex toRightIndex:(NSInteger)rightIndex ratio:(CGFloat)ratio {
    
}

- (void)setupCategoryView {
    NSArray *titles = self.navTitlesMuArr;
    NSUInteger count = titles.count;
    CGFloat categoryViewHeight = 70;
    CGFloat width = kMainScreenWidth;
    CGFloat height = kMainScreenHeight - statusNavHeight - categoryViewHeight;
    
    self.listVCArray = [NSMutableArray array];
    for (int i = 0; i < count; i ++) {
        VENExplorePageSubviewsController *listVC = [[VENExplorePageSubviewsController alloc] init];
        listVC.dataArr = self.dataArr;
        listVC.view.frame = CGRectMake(i*width, 0, width, height);
        [self.listVCArray addObject:listVC];
    }
    
    self.categoryView = [[JXCategoryTitleView alloc] init];
    self.categoryView.frame = CGRectMake(0, 0, kMainScreenWidth, categoryViewHeight);
    self.categoryView.delegate = self;
    self.categoryView.titles = titles;
    self.categoryView.titleColor = UIColorFromRGB(0xABABAB);
    self.categoryView.titleFont = [UIFont systemFontOfSize:14.0f];
    self.categoryView.titleSelectedColor = COLOR_THEME;
    self.categoryView.titleSelectedFont = [UIFont fontWithName:@"Helvetica-Bold" size:14.0f];
    
    self.categoryView.titleColorGradientEnabled = YES;
    JXCategoryIndicatorBackgroundView *backgroundView = [[JXCategoryIndicatorBackgroundView alloc] init];
    backgroundView.backgroundViewHeight = 32.0f;
    backgroundView.backgroundViewCornerRadius = 3.0f;
    backgroundView.backgroundViewColor = [UIColor whiteColor];
    self.categoryView.indicators = @[backgroundView];
    
    [self.view addSubview:self.categoryView];
    
    self.scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, categoryViewHeight,  width, height)];
    self.scrollView.pagingEnabled = YES;
    self.scrollView.contentSize = CGSizeMake(width*count, height);
    [self.view addSubview:self.scrollView];
    
    for (int i = 0; i < count; i ++) {
        VENExplorePageSubviewsController *listVC = self.listVCArray[i];
        [self.scrollView addSubview:listVC.view];
    }
    
    self.categoryView.contentScrollView = self.scrollView;
}

- (void)setupNavigationItemRightBarButtonItem {
    UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 44, 44)];
    button.contentEdgeInsets = UIEdgeInsetsMake(18, 0, 0, -16);
    [button setImage:[UIImage imageNamed:@"icon_game"] forState:UIControlStateNormal];
    [button addTarget:self action:@selector(rightButtonClick) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *barButton = [[UIBarButtonItem alloc] initWithCustomView:button];
    self.navigationItem.rightBarButtonItem = barButton;
}

- (void)rightButtonClick {
    NSLog(@"右边");
}

- (void)setupNavigationItemLeftBarButtonItem {
    UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 50, 44)];
    button.contentEdgeInsets = UIEdgeInsetsMake(18, -1, 0, 0);
    [button setTitle:@"已录" forState:UIControlStateNormal];
    [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    button.titleLabel.font = [UIFont fontWithName:@"Helvetica-Bold" size:23.0f];
    UIBarButtonItem *barButton = [[UIBarButtonItem alloc] initWithCustomView:button];
    self.navigationItem.leftBarButtonItem = barButton;
}

- (NSMutableArray *)navTitlesMuArr {
    if (_navTitlesMuArr == nil) {
        _navTitlesMuArr = [NSMutableArray array];
    }
    return _navTitlesMuArr;
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
