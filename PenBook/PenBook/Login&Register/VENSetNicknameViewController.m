//
//  VENSetNicknameViewController.m
//  PenBook
//
//  Created by YVEN on 2019/3/4.
//  Copyright © 2019 Hefei Haiba Network Technology Co., Ltd. All rights reserved.
//

#import "VENSetNicknameViewController.h"

@interface VENSetNicknameViewController ()
@property (weak, nonatomic) IBOutlet UIButton *randomButton;
@property (weak, nonatomic) IBOutlet UIButton *finishButton;
@property (weak, nonatomic) IBOutlet UITextField *contentTextField;

@end

@implementation VENSetNicknameViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.randomButton.layer.cornerRadius = 8;
    self.randomButton.layer.masksToBounds = YES;
    
    self.finishButton.layer.cornerRadius = 24;
    self.finishButton.layer.masksToBounds = YES;
}

- (IBAction)leftButtonClick:(id)sender {
    [self.presentingViewController.presentingViewController dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)finishButtonClick:(id)sender {
    if ([[VENClassEmptyManager sharedManager] isEmptyString:self.contentTextField.text]) {
        [[VENMBProgressHUDManager sharedManager] showText:@"请设置您的昵称"];
        return;
    }
    
    NSDictionary *params = @{@"userid": self.userid,
                             @"nickname": self.contentTextField.text};
    
    [[VENNetworkTool sharedManager] requestWithMethod:HTTPMethodGet path:@"Recordlogin/nickwrite" params:params showLoading:YES successBlock:^(id response) {
        
        if ([response[@"ret"] integerValue] == 1) {
            [self.presentingViewController.presentingViewController dismissViewControllerAnimated:YES completion:nil];
        }
            
    } failureBlock:^(NSError *error) {
        
    }];
}

- (IBAction)randomButtonClick:(id)sender {
    [[VENNetworkTool sharedManager] requestWithMethod:HTTPMethodPost path:@"Recordlogin/registergenerate" params:nil showLoading:YES successBlock:^(id response) {
        
        if ([response[@"ret"] integerValue] == 1) {
            self.contentTextField.text = response[@"nickname"];
        }
        
    } failureBlock:^(NSError *error) {
        
    }];
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
