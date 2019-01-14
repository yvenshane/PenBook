//
//  VENGuidePageViewControllerTwo.m
//  PenBook
//
//  Created by YVEN on 2019/1/8.
//  Copyright © 2019年 Hefei Haiba Network Technology Co., Ltd. All rights reserved.
//

#import "VENGuidePageViewControllerTwo.h"
#import "VENGuidePageViewControllerThree.h"

@interface VENGuidePageViewControllerTwo ()
@property (weak, nonatomic) IBOutlet UITextField *topTextField;
@property (weak, nonatomic) IBOutlet UITextField *bottomTextField;
@property (weak, nonatomic) IBOutlet UIButton *nextButton;

@end

@implementation VENGuidePageViewControllerTwo

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.nextButton.layer.cornerRadius = 24.0f;
    self.nextButton.layer.masksToBounds = YES;
    
    [self setupNavigationItemRightBarBackButtonItem];
}

- (IBAction)nextButtonClick:(id)sender {
    
    if ([[VENClassEmptyManager sharedManager] isEmptyString:self.topTextField.text]) {
        [[VENMBProgressHUDManager sharedManager] showText:@"请输入您正在玩的游戏"];
        return;
    }
    
    if ([[VENClassEmptyManager sharedManager] isEmptyString:self.bottomTextField.text]) {
        [[VENMBProgressHUDManager sharedManager] showText:@"请输入您游戏所在的区服"];
        return;
    }
    
    NSDictionary *params = @{@"game" : self.topTextField.text,
                             @"servicearea" : self.bottomTextField.text};
    
    [[VENNetworkTool sharedManager] requestWithMethod:HTTPMethodGet path:@"Recordlogin/usertype" params:params showLoading:YES successBlock:^(id response) {
        
        if ([response[@"ret"] integerValue] == 1) {
            VENGuidePageViewControllerThree *vc = [[VENGuidePageViewControllerThree alloc] init];
            [self.navigationController pushViewController:vc animated:YES];
        }
        
    } failureBlock:^(NSError *error) {
        
    }];
}

- (void)setupNavigationItemLeftBarBackButtonItem {
    UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 44, 44)];
    button.contentEdgeInsets = UIEdgeInsetsMake(0, -16, 0, 0);
    [button addTarget:self action:@selector(leftBackButtonClick) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *barButton = [[UIBarButtonItem alloc] initWithCustomView:button];
    self.navigationItem.leftBarButtonItem = barButton;
}

- (void)leftBackButtonClick {
    
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
