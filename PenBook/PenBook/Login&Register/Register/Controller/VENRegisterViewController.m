//
//  VENRegisterViewController.m
//  PenBook
//
//  Created by YVEN on 2019/1/9.
//  Copyright © 2019年 Hefei Haiba Network Technology Co., Ltd. All rights reserved.
//

#import "VENRegisterViewController.h"
#import "VENLoginTableViewCell.h"
#import "VENRegisterTableViewCell.h"
#import "VENAboutUsViewController.h"

@interface VENRegisterViewController () <UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, assign) NSInteger seconds;
@property (nonatomic, strong) NSTimer *countDownTimer;

@end

static NSString *cellIdentifier = @"cellIdentifier";
static NSString *cellIdentifier2 = @"cellIdentifier2";
@implementation VENRegisterViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self setupNavigationBar];
    [self setupTableView];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 3;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 1) {
        VENRegisterTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier2 forIndexPath:indexPath];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        cell.bottomTextField.keyboardType = UIKeyboardTypeNumberPad;
        [cell.rightButton addTarget:self action:@selector(rightButtonClick) forControlEvents:UIControlEventTouchUpInside];
        
        return cell;
    } else {
        VENLoginTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier forIndexPath:indexPath];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        [cell.topButton setTitle:indexPath.row == 0 ? @"  手机" : @"  设置密码" forState:UIControlStateNormal];
        [cell.topButton setImage:[UIImage imageNamed:indexPath.row == 0 ? @"icon_phoneNumber" : @"icon_password"] forState:UIControlStateNormal];
        cell.bottomTextField.placeholder = indexPath.row == 0 ? @"请输入手机" : @"请设置您的登录密码";
        cell.bottomTextField.keyboardType = indexPath.row == 0 ? UIKeyboardTypeNumberPad : UIKeyboardTypeASCIICapable;
        cell.bottomTextField.secureTextEntry = indexPath.row == 0 ? NO : YES;
        
        return cell;
    }
}

#pragma mark - 获取验证码
- (void)rightButtonClick {
    VENLoginTableViewCell *cell = (VENLoginTableViewCell *)[self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
    
    if ([[VENClassEmptyManager sharedManager] isEmptyString:cell.bottomTextField.text] || cell.bottomTextField.text.length != 11) {
        [[VENMBProgressHUDManager sharedManager] showText:@"请输入手机"];
        return;
    }
    
    [[VENNetworkTool sharedManager] requestWithMethod:HTTPMethodGet path:@"Recordlogin/registersms" params:@{@"tel" : cell.bottomTextField.text} showLoading:YES successBlock:^(id response) {
        
        
        if ([response[@"ret"] integerValue] == 1) {
            self.seconds = 60;
            self.countDownTimer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(timeFireMethod) userInfo:nil repeats:YES];
        } else {
            return;
        }
        
        
    } failureBlock:^(NSError *error) {
        
    }];
    

}

- (void)timeFireMethod {
    _seconds--;
    
    VENRegisterTableViewCell *cell = (VENRegisterTableViewCell *)[self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:1 inSection:0]];
    
    cell.rightButton.userInteractionEnabled = NO;
    
    // titleLabel.text 解决频繁刷新 Button 闪烁的问题
    cell.rightButton.titleLabel.text = [NSString stringWithFormat:@"%lds", (long)_seconds];
    [cell.rightButton setTitle:[NSString stringWithFormat:@"%lds", (long)_seconds] forState:UIControlStateNormal];
    
    if(_seconds == 0) {
        [_countDownTimer invalidate];
        [cell.rightButton setTitle:@"获取验证码" forState:UIControlStateNormal];
        cell.rightButton.userInteractionEnabled = YES;
    }
}

- (void)setupTableView {
    UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, statusNavHeight, kMainScreenWidth, kMainScreenHeight - statusNavHeight) style:UITableViewStylePlain];
    tableView.delegate = self;
    tableView.dataSource = self;
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [tableView registerNib:[UINib nibWithNibName:@"VENLoginTableViewCell" bundle:nil] forCellReuseIdentifier:cellIdentifier];
    [tableView registerNib:[UINib nibWithNibName:@"VENRegisterTableViewCell" bundle:nil] forCellReuseIdentifier:cellIdentifier2];
    tableView.rowHeight = 100;
    [self.view addSubview:tableView];
    
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kMainScreenWidth, 128)];
    tableView.tableHeaderView = headerView;
    
    UILabel *topLabel = [[UILabel alloc] initWithFrame:CGRectMake(36, 21, kMainScreenWidth - 72, 42)];
    topLabel.text = @"注册";
    topLabel.font = [UIFont fontWithName:@"Helvetica-Bold" size:30.0f];
    [headerView addSubview:topLabel];
    
    UILabel *bottomLabel = [[UILabel alloc] initWithFrame:CGRectMake(36, 21 + 42 + 5, kMainScreenWidth - 72, 18)];
    bottomLabel.text = @"欢迎来到已录，我们一起来记录游戏生活";
    bottomLabel.font = [UIFont systemFontOfSize:13.0f];
    [headerView addSubview:bottomLabel];
    
    UIView *footerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kMainScreenWidth, 100 + 48)];
    tableView.tableFooterView = footerView;
    
    // 用户使用协议
    UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(0, 20, kMainScreenWidth, 18)];
    [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    button.titleLabel.font = [UIFont systemFontOfSize:15];
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:@"点击立即注册代表您同意《隐私政策》"];
    [attributedString addAttribute:NSForegroundColorAttributeName value:UIColorFromRGB(0x4073F8) range:NSMakeRange(attributedString.length - 6, 6)];
    [button setAttributedTitle:attributedString forState:UIControlStateNormal];
    [button addTarget:self action:@selector(buttonClick) forControlEvents:UIControlEventTouchUpInside];
    [footerView addSubview:button];
    
    UIButton *registerButton = [[UIButton alloc] initWithFrame:CGRectMake(kMainScreenWidth / 2 - 202 / 2, 100, 202, 48)];
    registerButton.backgroundColor = UIColorFromRGB(0x5061FB);
    [registerButton setTitle:@"注册" forState:UIControlStateNormal];
    [registerButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    registerButton.titleLabel.font = [UIFont systemFontOfSize:16.0f];
    registerButton.layer.cornerRadius = 24.0f;
    registerButton.layer.masksToBounds = YES;
    [registerButton addTarget:self action:@selector(registerButtonClick) forControlEvents:UIControlEventTouchUpInside];
    [footerView addSubview:registerButton];
    
    _tableView = tableView;
}

- (void)buttonClick {
    VENAboutUsViewController *vc = [[VENAboutUsViewController alloc] init];
    vc.HTMLString = @"http://www.bishugame.com/policy.html";
    [self presentViewController:vc animated:YES completion:nil];
}

#pragma mark - 注册
- (void)registerButtonClick {
    VENLoginTableViewCell *cell = (VENLoginTableViewCell *)[self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
    if ([[VENClassEmptyManager sharedManager] isEmptyString:cell.bottomTextField.text] || cell.bottomTextField.text.length != 11) {
        [[VENMBProgressHUDManager sharedManager] showText:@"请输入手机"];
        return;
    }
    
    VENRegisterTableViewCell *cell1 = (VENRegisterTableViewCell *)[self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:1 inSection:0]];
    if ([[VENClassEmptyManager sharedManager] isEmptyString:cell1.bottomTextField.text]) {
        [[VENMBProgressHUDManager sharedManager] showText:@"请输入验证码"];
        return;
    }
    
    VENLoginTableViewCell *cell2 = (VENLoginTableViewCell *)[self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:2 inSection:0]];
    if ([[VENClassEmptyManager sharedManager] isEmptyString:cell2.bottomTextField.text]) {
        [[VENMBProgressHUDManager sharedManager] showText:@"请设置您的登录密码"];
        return;
    }
    
    NSDictionary *params = @{@"ip" : [[VENNetworkTool sharedManager] getIPAddress],
                             @"tel" : cell.bottomTextField.text,
                             @"code" : cell1.bottomTextField.text,
                             @"pass" : cell2.bottomTextField.text,
                             @"idfa" : [[VENNetworkTool sharedManager] getIDFA]};
    
    [[VENNetworkTool sharedManager] requestWithMethod:HTTPMethodGet path:@"Recordlogin/register" params:params showLoading:YES successBlock:^(id response) {
        
        if ([response[@"ret"] integerValue] == 1) {
            [self dismissViewControllerAnimated:YES completion:nil];
            
        } else {
            return;
        }
        
    } failureBlock:^(NSError *error) {
        
    }];
}

- (void)setupNavigationBar {
    UIView *navigationBar = [[UIView alloc] initWithFrame:CGRectMake(0, Height_StatusBar, kMainScreenWidth, 44)];
    [self.view addSubview:navigationBar];
    
    UIButton *backButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 44, 44)];
    [backButton setImage:[UIImage imageNamed:@"icon_back"] forState:UIControlStateNormal];
    [backButton addTarget:self action:@selector(backButtonClick) forControlEvents:UIControlEventTouchUpInside];
    [navigationBar addSubview:backButton];

    UIButton *otherButton = [[UIButton alloc] initWithFrame:CGRectMake(kMainScreenWidth - 64, 0, 64, 44)];
    [otherButton setTitle:@"去登录" forState:UIControlStateNormal];
    [otherButton setTitleColor:UIColorFromRGB(0x424242) forState:UIControlStateNormal];
    otherButton.titleLabel.font = [UIFont systemFontOfSize:15.0f];
    [otherButton addTarget:self action:@selector(otherButtonClick) forControlEvents:UIControlEventTouchUpInside];
    [navigationBar addSubview:otherButton];
}

- (void)backButtonClick {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)otherButtonClick {
    [self dismissViewControllerAnimated:YES completion:nil];
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
