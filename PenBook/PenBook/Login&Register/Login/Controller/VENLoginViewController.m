//
//  VENLoginViewController.m
//  PenBook
//
//  Created by YVEN on 2019/1/9.
//  Copyright © 2019年 Hefei Haiba Network Technology Co., Ltd. All rights reserved.
//

#import "VENLoginViewController.h"
#import "VENLoginTableViewCell.h"
#import "VENRegisterViewController.h"
#import "VENFindPasswordViewController.h"

@interface VENLoginViewController () <UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, strong) UITableView *tableView;

@end

static NSString *cellIdentifier = @"cellIdentifier";
@implementation VENLoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self setupNavigationBar];
    [self setupTableView];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 2;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    VENLoginTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier forIndexPath:indexPath];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    [cell.topButton setTitle:indexPath.row == 0 ? @"  手机" : @"  密码" forState:UIControlStateNormal];
    [cell.topButton setImage:[UIImage imageNamed:indexPath.row == 0 ? @"icon_phoneNumber" : @"icon_password"] forState:UIControlStateNormal];
    cell.bottomTextField.placeholder = indexPath.row == 0 ? @"请输入手机" : @"请输入密码";
    cell.bottomTextField.keyboardType = indexPath.row == 0 ? UIKeyboardTypeNumberPad : UIKeyboardTypeDefault;
    cell.bottomTextField.secureTextEntry = indexPath.row == 0 ? NO : YES;
    
    return cell;
}

- (void)setupTableView {
    UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, statusNavHeight, kMainScreenWidth, kMainScreenHeight - statusNavHeight) style:UITableViewStylePlain];
    tableView.delegate = self;
    tableView.dataSource = self;
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [tableView registerNib:[UINib nibWithNibName:@"VENLoginTableViewCell" bundle:nil] forCellReuseIdentifier:cellIdentifier];
    tableView.rowHeight = 100;
    [self.view addSubview:tableView];
    
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kMainScreenWidth, 128)];
    tableView.tableHeaderView = headerView;
    
    UILabel *topLabel = [[UILabel alloc] initWithFrame:CGRectMake(36, 21, kMainScreenWidth - 72, 42)];
    topLabel.text = @"登录";
    topLabel.font = [UIFont fontWithName:@"Helvetica-Bold" size:30.0f];
    [headerView addSubview:topLabel];
    
    UILabel *bottomLabel = [[UILabel alloc] initWithFrame:CGRectMake(36, 21 + 42 + 5, kMainScreenWidth - 72, 18)];
    bottomLabel.text = @"欢迎来到已录，我们一起来记录游戏生活";
    bottomLabel.font = [UIFont systemFontOfSize:13.0f];
    [headerView addSubview:bottomLabel];
    
    UIView *footerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kMainScreenWidth, 100 + 48)];
    tableView.tableFooterView = footerView;
    
    UIButton *findPasswordButton = [[UIButton alloc] initWithFrame:CGRectMake(36, 10, 60, 20)];
    [findPasswordButton setTitle:@"忘记密码" forState:UIControlStateNormal];
    [findPasswordButton setTitleColor:UIColorFromRGB(0x4073F8) forState:UIControlStateNormal];
    findPasswordButton.titleLabel.font = [UIFont systemFontOfSize:14.0f];
    [findPasswordButton addTarget:self action:@selector(findPasswordButtonClick) forControlEvents:UIControlEventTouchUpInside];
    [footerView addSubview:findPasswordButton];
    
    UIButton *loginButton = [[UIButton alloc] initWithFrame:CGRectMake(kMainScreenWidth / 2 - 202 / 2, 100, 202, 48)];
    loginButton.backgroundColor = UIColorFromRGB(0x5061FB);
    [loginButton setTitle:@"登录" forState:UIControlStateNormal];
    [loginButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [loginButton addTarget:self action:@selector(loginButtonClick) forControlEvents:UIControlEventTouchUpInside];
    loginButton.titleLabel.font = [UIFont systemFontOfSize:16.0f];
    loginButton.layer.cornerRadius = 24.0f;
    loginButton.layer.masksToBounds = YES;
    [footerView addSubview:loginButton];
    
    _tableView = tableView;
}

#pragma mark - 登录
- (void)loginButtonClick {
    VENLoginTableViewCell *cell = (VENLoginTableViewCell *)[self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
    if ([[VENClassEmptyManager sharedManager] isEmptyString:cell.bottomTextField.text] || cell.bottomTextField.text.length != 11) {
        [[VENMBProgressHUDManager sharedManager] showText:@"请输入手机"];
        return;
    }
    
    VENLoginTableViewCell *cell2 = (VENLoginTableViewCell *)[self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:1 inSection:0]];
    if ([[VENClassEmptyManager sharedManager] isEmptyString:cell2.bottomTextField.text]) {
        [[VENMBProgressHUDManager sharedManager] showText:@"请输入密码"];
        return;
    }
    
    NSDictionary *params = @{@"ip" : [[VENNetworkTool sharedManager] getIPAddress],
                             @"user" : cell.bottomTextField.text,
                             @"pass" : cell2.bottomTextField.text};
    [[VENNetworkTool sharedManager] requestWithMethod:HTTPMethodGet path:@"Recordlogin/login" params:params showLoading:YES successBlock:^(id response) {
        
        if ([response[@"ret"] integerValue] == 1) {
            
            NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
            
            NSDictionary *loginSuccess = @{@"userid" : response[@"userid"],
                                           @"username" : response[@"username"]};
            
            [userDefaults setObject:loginSuccess forKey:@"Login"];
            
            [[NSNotificationCenter defaultCenter] postNotificationName:@"LoginSuccessfully" object:nil];
            
            [self dismissViewControllerAnimated:YES completion:nil];
            
        } else {
            return;
        }
        
    } failureBlock:^(NSError *error) {
        
    }];
}

- (void)findPasswordButtonClick {
    VENFindPasswordViewController *vc = [[VENFindPasswordViewController alloc] init];
    [self presentViewController:vc animated:YES completion:nil];
}

- (void)setupNavigationBar {
    UIView *navigationBar = [[UIView alloc] initWithFrame:CGRectMake(0, Height_StatusBar, kMainScreenWidth, 44)];
    [self.view addSubview:navigationBar];
    
    UIButton *backButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 44, 44)];
    [backButton setImage:[UIImage imageNamed:@"icon_back"] forState:UIControlStateNormal];
    [backButton addTarget:self action:@selector(backButtonClick) forControlEvents:UIControlEventTouchUpInside];
    [navigationBar addSubview:backButton];
    
    UIButton *otherButton = [[UIButton alloc] initWithFrame:CGRectMake(kMainScreenWidth - 64, 0, 64, 44)];
    [otherButton setTitle:@"去注册" forState:UIControlStateNormal];
    [otherButton setTitleColor:UIColorFromRGB(0x424242) forState:UIControlStateNormal];
    otherButton.titleLabel.font = [UIFont systemFontOfSize:15.0f];
    [otherButton addTarget:self action:@selector(otherButtonClick) forControlEvents:UIControlEventTouchUpInside];
    [navigationBar addSubview:otherButton];
}

- (void)backButtonClick {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)otherButtonClick {
    VENRegisterViewController *vc = [[VENRegisterViewController alloc] init];
    [self presentViewController:vc animated:YES completion:nil];
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
