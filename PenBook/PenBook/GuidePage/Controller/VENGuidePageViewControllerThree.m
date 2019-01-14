//
//  VENGuidePageViewControllerThree.m
//  PenBook
//
//  Created by YVEN on 2019/1/8.
//  Copyright © 2019年 Hefei Haiba Network Technology Co., Ltd. All rights reserved.
//

#import "VENGuidePageViewControllerThree.h"
#import "VENGuidePageViewControllerFour.h"
#import "VENTagView.h"

@interface VENGuidePageViewControllerThree ()
@property (weak, nonatomic) IBOutlet UIButton *nextButton;
@property (weak, nonatomic) IBOutlet UITextField *searchTextField;
@property (weak, nonatomic) IBOutlet UIButton *searchButton;

@property (nonatomic, strong) VENTagView *tagView;

@end

@implementation VENGuidePageViewControllerThree

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.nextButton.layer.cornerRadius = 24.0f;
    self.nextButton.layer.masksToBounds = YES;
    
    [self setupNavigationItemRightBarBackButtonItem];
}

#pragma mark - 搜索
- (IBAction)searchButtonClick:(id)sender {
    if ([[VENClassEmptyManager sharedManager] isEmptyString:self.searchTextField.text]) {
        [[VENMBProgressHUDManager sharedManager] showText:@"请输入您曾经玩过的游戏"];
        return;
    }
    
    NSString *userid = @"";
    if (![[VENClassEmptyManager sharedManager] isEmptyString:[[NSUserDefaults standardUserDefaults] objectForKey:@"Login"][@"userid"]]) {
        userid = [[NSUserDefaults standardUserDefaults] objectForKey:@"Login"][@"userid"];
    }
    
    NSDictionary *params = @{@"userid" : userid,
                             @"gamename" : self.searchTextField.text};
    
    [[VENNetworkTool sharedManager] requestWithMethod:HTTPMethodGet path:@"Recordkernel/gameplayed" params:params showLoading:YES successBlock:^(id response) {
        
        if ([response[@"ret"] integerValue] == 1) {
            
            [self.tagView removeFromSuperview];
            self.tagView = nil;
            
            if (self.tagView == nil) {
//                self.tagView = [[VENTagView alloc] initWithFrame:CGRectMake(0, 200, kMainScreenWidth, 500) tagArray:];
                [self.view addSubview:self.tagView];
                
                
            }
            
            
            
        }
        
        

        
    } failureBlock:^(NSError *error) {
        
    }];
}

- (IBAction)nextButtonClick:(id)sender {
    
//    if ([[VENClassEmptyManager sharedManager] isEmptyString:self.searchTextField.text]) {
//        [[VENMBProgressHUDManager sharedManager] showText:@"请输入您曾经玩过的游戏"];
//        return;
//    }
    
    
    
    VENGuidePageViewControllerFour *vc = [[VENGuidePageViewControllerFour alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)setupNavigationItemRightBarBackButtonItem {
    UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 44, 44)];
    [button setTitle:@"跳过" forState:UIControlStateNormal];
    button.titleLabel.font = [UIFont systemFontOfSize:14.0f];
    [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [button addTarget:self action:@selector(rightButtonClick) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *barButton = [[UIBarButtonItem alloc] initWithCustomView:button];
    self.navigationItem.rightBarButtonItem = barButton;
}

- (void)rightButtonClick {
    [self.navigationController popViewControllerAnimated:YES];
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
