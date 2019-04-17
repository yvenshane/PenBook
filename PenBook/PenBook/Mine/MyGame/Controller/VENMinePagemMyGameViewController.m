//
//  VENMinePagemMyGameViewController.m
//  PenBook
//
//  Created by YVEN on 2019/1/7.
//  Copyright © 2019年 Hefei Haiba Network Technology Co., Ltd. All rights reserved.
//

#import "VENMinePagemMyGameViewController.h"
#import "JXCategoryView.h"
#import "VENMinePagemMyGameSubviewsController.h"

@interface VENMinePagemMyGameViewController () <JXCategoryViewDelegate, UITextFieldDelegate>
@property (nonatomic, strong) JXCategoryTitleView *categoryView;
@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) NSMutableArray <VENMinePagemMyGameSubviewsController *> *listVCArray;
@property (nonatomic, strong) NSMutableArray *selectedItemAtIndexMuArr;

@end

static CGFloat const categoryViewHeight = 70;
@implementation VENMinePagemMyGameViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.view.backgroundColor = [UIColor whiteColor];
    self.edgesForExtendedLayout = UIRectEdgeNone;

    [self setupSearchTextField];
    [self setupCategoryView];
    [self setupSubViews];
}

- (void)setupSearchTextField {
    UITextField *searchTextField = [[UITextField alloc] initWithFrame:CGRectMake(0, 0, kMainScreenWidth - 50 - 22, 28)];
    searchTextField.delegate = self;
    searchTextField.font = [UIFont systemFontOfSize:12.0f];
    searchTextField.backgroundColor = UIColorFromRGB(0xF1F1F1);
    searchTextField.placeholder = @"输入你想玩的游戏";
    
    searchTextField.layer.cornerRadius = 14.0f;
    searchTextField.layer.masksToBounds = YES;
    
    UIView *leftView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 23, 28)];
    searchTextField.leftView = leftView;
    searchTextField.leftViewMode = UITextFieldViewModeAlways;
    
    UIView *rightView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 28 + 5, 28)];
    searchTextField.rightView = rightView;
    searchTextField.rightViewMode = UITextFieldViewModeAlways;
    
    UIButton *searchButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 28, 28)];
    [searchButton setImage:[UIImage imageNamed:@"icon_game"] forState:UIControlStateNormal];
    [rightView addSubview:searchButton];
    
    self.navigationItem.titleView = searchTextField;
}

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField{
//    VENClassifySearchViewController *vc = [[VENClassifySearchViewController alloc] init];
//    [self presentViewController:vc animated:NO completion:nil];
    
    NSLog(@"搜索页面");
    
    return NO;
}

//这句代码必须加上
- (BOOL)shouldAutomaticallyForwardAppearanceMethods {
    return NO;
}

#pragma mark - JXCategoryViewDelegate

- (void)categoryView:(JXCategoryBaseView *)categoryView didSelectedItemAtIndex:(NSInteger)index {
    //侧滑手势处理
    self.navigationController.interactivePopGestureRecognizer.enabled = (index == 0);
    
    if (![self.selectedItemAtIndexMuArr containsObject:[NSString stringWithFormat:@"%ld", (long)index]]) {
        [self.listVCArray[index].tableView.mj_header beginRefreshing];
        [self.selectedItemAtIndexMuArr addObject:[NSString stringWithFormat:@"%ld", (long)index]];
    }
}

- (void)categoryView:(JXCategoryBaseView *)categoryView didClickSelectedItemAtIndex:(NSInteger)index {
    
}

- (void)categoryView:(JXCategoryBaseView *)categoryView didScrollSelectedItemAtIndex:(NSInteger)index {
    
}

- (void)categoryView:(JXCategoryBaseView *)categoryView scrollingFromLeftIndex:(NSInteger)leftIndex toRightIndex:(NSInteger)rightIndex ratio:(CGFloat)ratio {
    
}

- (void)setupCategoryView {
    
    self.categoryView = [[JXCategoryTitleView alloc] init];
    self.categoryView.frame = CGRectMake(0, 0, kMainScreenWidth, categoryViewHeight);
    self.categoryView.delegate = self;
    self.categoryView.titles = @[@"想玩", @"在玩"];
    self.categoryView.titleColor = UIColorFromRGB(0xABABAB);
    self.categoryView.titleFont = [UIFont systemFontOfSize:14.0f];
    self.categoryView.titleSelectedColor = COLOR_THEME;
    self.categoryView.titleSelectedFont = [UIFont fontWithName:@"Helvetica-Bold" size:14.0f];
    
    self.categoryView.titleColorGradientEnabled = YES;
    JXCategoryIndicatorBackgroundView *backgroundView = [[JXCategoryIndicatorBackgroundView alloc] init];
    backgroundView.backgroundViewHeight = 32.0f;
    backgroundView.backgroundViewWidth = kMainScreenWidth / 3 - 40;
    backgroundView.backgroundViewCornerRadius = 3.0f;
    backgroundView.backgroundViewColor = [UIColor whiteColor];
    self.categoryView.indicators = @[backgroundView];
    
    [self.view addSubview:self.categoryView];
}

- (void)setupSubViews {
    NSUInteger count = @[@"想玩", @"在玩"].count;
    CGFloat width = kMainScreenWidth;
    CGFloat height = kMainScreenHeight - statusNavHeight - categoryViewHeight;
    
    for (int i = 0; i < count; i ++) {
        VENMinePagemMyGameSubviewsController *listVC = [[VENMinePagemMyGameSubviewsController alloc] init];
        listVC.pageTag = @[@"想玩", @"在玩"][i];
        listVC.view.frame = CGRectMake(i*width, 0, width, height);
        [self.listVCArray addObject:listVC];
        
    }
    
    self.scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, categoryViewHeight,  width, height)];
    self.scrollView.pagingEnabled = YES;
    self.scrollView.contentSize = CGSizeMake(width*count, height);
    [self.view addSubview:self.scrollView];
    
    for (int i = 0; i < count; i ++) {
        VENMinePagemMyGameSubviewsController *listVC = self.listVCArray[i];
        [self.scrollView addSubview:listVC.view];
    }
    
    self.categoryView.contentScrollView = self.scrollView;
}

- (NSMutableArray *)listVCArray {
    if (_listVCArray == nil) {
        _listVCArray = [NSMutableArray array];
    }
    return _listVCArray;
}

- (NSMutableArray *)selectedItemAtIndexMuArr {
    if (_selectedItemAtIndexMuArr == nil) {
        _selectedItemAtIndexMuArr = [NSMutableArray arrayWithArray:@[@"0"]];
    }
    return _selectedItemAtIndexMuArr;
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
