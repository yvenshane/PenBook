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

@interface VENRegisterViewController () <UITableViewDelegate, UITableViewDataSource>

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
        
        
        
        return cell;
    } else {
        VENLoginTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier forIndexPath:indexPath];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        [cell.topButton setTitle:indexPath.row == 0 ? @"  手机" : @"  设置密码" forState:UIControlStateNormal];
        [cell.topButton setImage:[UIImage imageNamed:indexPath.row == 0 ? @"icon_phoneNumber" : @"icon_password"] forState:UIControlStateNormal];
        cell.bottomTextField.placeholder = indexPath.row == 0 ? @"请输入手机" : @"请设置您的登录密码";
        
        return cell;
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
    
    UIButton *registerButton = [[UIButton alloc] initWithFrame:CGRectMake(kMainScreenWidth / 2 - 202 / 2, 100, 202, 48)];
    registerButton.backgroundColor = UIColorFromRGB(0x5061FB);
    [registerButton setTitle:@"注册" forState:UIControlStateNormal];
    [registerButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    registerButton.titleLabel.font = [UIFont systemFontOfSize:16.0f];
    registerButton.layer.cornerRadius = 24.0f;
    registerButton.layer.masksToBounds = YES;
    [footerView addSubview:registerButton];
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
