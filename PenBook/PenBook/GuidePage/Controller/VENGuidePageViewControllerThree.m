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
@property (weak, nonatomic) IBOutlet UIView *backgroundView;
@property (nonatomic, copy) NSArray *dataArr;
@property (nonatomic, strong) NSMutableArray *gameIDs;

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
    
    NSDictionary *params = @{@"gamename" : self.searchTextField.text};
    
    [[VENNetworkTool sharedManager] requestWithMethod:HTTPMethodGet path:@"Recordkernel/gameplayed" params:params showLoading:YES successBlock:^(id response) {
        
        if ([response[@"ret"] integerValue] == 1) {
            
            [self.tagView removeFromSuperview];
            self.tagView = nil;
            
            if (self.tagView == nil) {
                
                self.dataArr = response[@"game"];
                NSMutableArray *tagMuArr = [NSMutableArray array];
                [tagMuArr removeAllObjects];
                for (NSInteger i = 0; i <self.dataArr.count; i++) {
                    [tagMuArr addObject:response[@"game"][i][@"game"]];
                }
                
                self.tagView = [[VENTagView alloc] initWithFrame:self.backgroundView.bounds tagArray:tagMuArr];
                self.tagView.textColorSelected = [UIColor whiteColor];
                self.tagView.textColorNormal = UIColorFromRGB(0xC0C0C0);
                self.tagView.backgroundColorSelected = UIColorFromRGB(0x5061FB);
                self.tagView.backgroundColorNormal = [UIColor whiteColor];
                
                for (UIButton *button in self.tagView.buttonsMuArr) {
                    [button addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
                }

                [self.backgroundView addSubview:self.tagView];
            }
        }
    } failureBlock:^(NSError *error) {
        
    }];
}

- (void)buttonClick:(UIButton *)button {
    button.selected = !button.selected;
    
    if (button.selected == YES) {
        [self.gameIDs addObject:self.dataArr[button.tag][@"id"]];
    } else if (button.selected == NO) {
        [self.gameIDs removeObject:self.dataArr[button.tag][@"id"]];
    }
}

- (IBAction)nextButtonClick:(id)sender {
//    
    if ([[VENClassEmptyManager sharedManager] isEmptyArray:self.gameIDs]) {
        [[VENMBProgressHUDManager sharedManager] showText:@"请选择您曾经玩过的游戏"];
        return;
    }
    
    NSDictionary *params = @{@"gameid" : [self.gameIDs componentsJoinedByString:@","],
                             @"idfa" : [[VENNetworkTool sharedManager] getIDFA]};
    
    [[VENNetworkTool sharedManager] requestWithMethod:HTTPMethodGet path:@"recordkernel/gameplayedadd" params:params showLoading:YES successBlock:^(id response) {
        
        if ([response[@"ret"] integerValue] == 1) {
            VENGuidePageViewControllerFour *vc = [[VENGuidePageViewControllerFour alloc] init];
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

- (NSMutableArray *)gameIDs {
    if (_gameIDs == nil) {
        _gameIDs = [NSMutableArray array];
    }
    return _gameIDs;
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
