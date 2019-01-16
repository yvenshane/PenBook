//
//  VENMinePageSettingViewController.m
//  PenBook
//
//  Created by YVEN on 2019/1/7.
//  Copyright © 2019年 Hefei Haiba Network Technology Co., Ltd. All rights reserved.
//

#import "VENMinePageSettingViewController.h"
#import "VENMinePageSettingTableViewCell.h"

@interface VENMinePageSettingViewController () <UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, copy) NSArray *titlesArr;

@end

static NSString *cellIdentifier = @"cellIdentifier";
@implementation VENMinePageSettingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.

    self.navigationItem.title = @"设置";
    
    [self setupTableView];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 4;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    VENMinePageSettingTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier forIndexPath:indexPath];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    cell.leftLabel.text = self.titlesArr[indexPath.row];
    cell.rightLabel.hidden = indexPath.row == 2 || indexPath.row == 3 ? NO : YES;
    cell.rightLabel.text = indexPath.row == 2 ? @"跟随版本" : indexPath.row == 3 ? @"版本0.1.1" : nil;
    cell.rightImageView.hidden = indexPath.row == 3 ? YES : NO;
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 0) {
        
    } else if (indexPath.row == 1) {
        
    } else if (indexPath.row == 2) {
        
    } else if (indexPath.row == 3) {
        
    }
}

- (void)setupTableView {
    UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, kMainScreenWidth, kMainScreenHeight - statusNavHeight) style:UITableViewStylePlain];
//    tableView.backgroundColor = UIColorMake(247, 247, 247);
    tableView.delegate = self;
    tableView.dataSource = self;
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    tableView.rowHeight = 56;
    [tableView registerNib:[UINib nibWithNibName:@"VENMinePageSettingTableViewCell" bundle:nil] forCellReuseIdentifier:cellIdentifier];
    [self.view addSubview:tableView];
    
    UIView *footerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 202, 144+48)];
    tableView.tableFooterView = footerView;
    
    UIButton *logoutButton = [[UIButton alloc] initWithFrame:CGRectMake((kMainScreenWidth - 202) / 2, 144, 202, 48)];
    logoutButton.backgroundColor = UIColorFromRGB(0x5061FB);
    [logoutButton setTitle:@"退出登录" forState:UIControlStateNormal];
    [logoutButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    logoutButton.titleLabel.font = [UIFont systemFontOfSize:16.0f];
    [logoutButton addTarget:self action:@selector(logoutButtonClick) forControlEvents:UIControlEventTouchUpInside];
    logoutButton.layer.cornerRadius = 24.0f;
    logoutButton.layer.masksToBounds = YES;
    [footerView addSubview:logoutButton];
}

- (void)logoutButtonClick {
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"Login"];
    [self.navigationController popViewControllerAnimated:YES];
    
    self.block(@"loginoutSuccess");
}

- (NSArray *)titlesArr {
    if (_titlesArr == nil) {
        _titlesArr = @[@"个人资料", @"绑定手机号", @"语音", @"当前版本"];
    }
    return _titlesArr;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
