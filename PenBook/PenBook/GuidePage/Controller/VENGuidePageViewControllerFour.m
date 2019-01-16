//
//  VENGuidePageViewControllerFour.m
//  PenBook
//
//  Created by YVEN on 2019/1/8.
//  Copyright © 2019年 Hefei Haiba Network Technology Co., Ltd. All rights reserved.
//

#import "VENGuidePageViewControllerFour.h"
#import "VENGuidePageViewControllerFive.h"

@interface VENGuidePageViewControllerFour ()
@property (weak, nonatomic) IBOutlet UIButton *nextButton;
@property (weak, nonatomic) IBOutlet UIView *backgroundView;
@property (nonatomic, strong) NSMutableArray *idMuArr;
@property (nonatomic, copy) NSArray *dataArr;

@end

@implementation VENGuidePageViewControllerFour

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    
    self.nextButton.layer.cornerRadius = 24.0f;
    self.nextButton.layer.masksToBounds = YES;
    
    [[VENNetworkTool sharedManager] requestWithMethod:HTTPMethodGet path:@"Recordkernel/gametype" params:nil showLoading:YES successBlock:^(id response) {
        
        if ([response[@"ret"] integerValue] == 1) {
            
            self.dataArr = response[@"head"];
            
            for (NSInteger i = 0; i < self.dataArr.count; i++) {
                int row = i / 3;
                int col = i % 3;
                
                UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(col * 80 + col * 20, row * 80 + row * 20, 80, 80)];
                button.tag = i + 1000;
                button.backgroundColor = [UIColor whiteColor];
                [button setTitle:self.dataArr[i][@"name"] forState:UIControlStateNormal];
                [button setTitleColor:UIColorFromRGB(0X5061FB) forState:UIControlStateNormal];
                [button setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];
                button.titleLabel.font = [UIFont systemFontOfSize:19.0f];
                
                button.layer.cornerRadius = 10.0f;
                button.layer.masksToBounds = YES;
                button.layer.borderColor = UIColorFromRGB(0x5061FB).CGColor;
                button.layer.borderWidth = 1.0f;
                [button addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
                [self.backgroundView addSubview:button];
            }
        }
        
    } failureBlock:^(NSError *error) {
        
    }];
    
    [self setupNavigationItemRightBarBackButtonItem];
}

- (void)buttonClick:(UIButton *)button {
    button.selected = !button.selected;
    
    button.backgroundColor = button.selected == YES ? UIColorFromRGB(0x5061FB) : [UIColor whiteColor];
    
    if (button.selected == YES) {
        [self.idMuArr addObject:self.dataArr[button.tag - 1000][@"id"]];
    } else {
        [self.idMuArr removeObject:self.dataArr[button.tag - 1000][@"id"]];
    }
}

- (IBAction)nextButtonClick:(id)sender {
    
    if ([[VENClassEmptyManager sharedManager] isEmptyArray:self.idMuArr]) {
        [[VENMBProgressHUDManager sharedManager] showText:@"请选择您最喜欢的游戏类型"];
        return;
    }
    
    NSDictionary *params = @{@"types" : [self.idMuArr componentsJoinedByString:@","],
                             @"idfa" : [[VENNetworkTool sharedManager] getIDFA]};
    
    [[VENNetworkTool sharedManager] requestWithMethod:HTTPMethodGet path:@"Recordkernel/gametypeadd" params:params showLoading:YES successBlock:^(id response) {
        
        if ([response[@"ret"] integerValue] == 1) {
            VENGuidePageViewControllerFive *vc = [[VENGuidePageViewControllerFive alloc] init];
            vc.types = [self.idMuArr componentsJoinedByString:@","];
            [self.navigationController pushViewController:vc animated:YES];
        }
        
    } failureBlock:^(NSError *error) {
        
    }];
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

- (NSMutableArray *)idMuArr {
    if (_idMuArr == nil) {
        _idMuArr = [NSMutableArray array];
    }
    return _idMuArr;
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
