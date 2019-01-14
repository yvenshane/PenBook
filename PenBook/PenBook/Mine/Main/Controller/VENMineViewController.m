//
//  VENMineViewController.m
//  PenBook
//
//  Created by YVEN on 2018/12/17.
//  Copyright © 2018年 Hefei Haiba Network Technology Co., Ltd. All rights reserved.
//

#import "VENMineViewController.h"
#import "VENMineTableViewCell.h"
#import "VENMinePageTableHeaderView.h"

#import "VENMinePageSettingViewController.h"

#import "VENMinePagemMyFansViewController.h"
#import "VENMinePagemMyFocusViewController.h"
#import "VENMinePagemMyGameViewController.h"

#import "VENMineModel.h"

@interface VENMineViewController ()<UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, strong) VENMineModel *model;

@end

static NSString *cellIdentifier = @"cellIdentifier";
@implementation VENMineViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self loadData];
    

}

- (void)loadData {
    [[VENNetworkTool sharedManager] requestWithMethod:HTTPMethodGet path:@"Recordtext/appuser" params:@{@"userid" : [[NSUserDefaults standardUserDefaults] objectForKey:@"Login"][@"userid"]} showLoading:YES successBlock:^(id response) {
        
        self.model = [VENMineModel yy_modelWithJSON:response];

        [self setupNavigationItemLeftBarButtonItem];
        [self setupNavigationItemRightBarButtonItem];
        
        [self setupTableView];
        
    } failureBlock:^(NSError *error) {
        
    }];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 10;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    VENMineTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier forIndexPath:indexPath];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    return cell;
}

- (void)setupTableView {
    UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, kMainScreenWidth, kMainScreenHeight - statusNavHeight - tabBarHeight) style:UITableViewStylePlain];
    tableView.backgroundColor = UIColorMake(247, 247, 247);
    tableView.delegate = self;
    tableView.dataSource = self;
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    tableView.estimatedRowHeight = 380;
    [tableView registerNib:[UINib nibWithNibName:@"VENMineTableViewCell" bundle:nil] forCellReuseIdentifier:cellIdentifier];
    [self.view addSubview:tableView];

    VENMinePageTableHeaderView *headerView = [[[NSBundle mainBundle] loadNibNamed:@"VENMinePageTableHeaderView" owner:nil options:nil] lastObject];
    headerView.nameLabel.text = _model.username;
    [headerView.otherButton setTitle:[NSString stringWithFormat:@"  %@", _model.age] forState:UIControlStateNormal];
    headerView.xingzuoLabel.text = _model.constell;
    headerView.qianmingLabel.text = _model.title;
    
    [headerView.myFansButton addTarget:self action:@selector(myFansButtonClick) forControlEvents:UIControlEventTouchUpInside];
    [headerView.myFocusButton addTarget:self action:@selector(myFocusButtonClick) forControlEvents:UIControlEventTouchUpInside];
    [headerView.myGameButton addTarget:self action:@selector(myGameButtonClick) forControlEvents:UIControlEventTouchUpInside];
    headerView.frame = CGRectMake(0, 0, kMainScreenWidth, 289);
    tableView.tableHeaderView = headerView;
}

- (void)myFansButtonClick {
    NSLog(@"粉丝");
    
    VENMinePagemMyFansViewController *vc = [[VENMinePagemMyFansViewController alloc] init];
    vc.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)myFocusButtonClick {
    NSLog(@"关注");
    
    VENMinePagemMyFocusViewController *vc = [[VENMinePagemMyFocusViewController alloc] init];
    vc.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)myGameButtonClick {
    NSLog(@"游戏");
    
    VENMinePagemMyGameViewController *vc = [[VENMinePagemMyGameViewController alloc] init];
    vc.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)setupNavigationItemRightBarButtonItem {
    UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 44, 44)];
    button.contentEdgeInsets = UIEdgeInsetsMake(0, 0, 0, -16);
    [button setImage:[UIImage imageNamed:@"icon_share2"] forState:UIControlStateNormal];
    [button addTarget:self action:@selector(rightButtonClick) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *barButton = [[UIBarButtonItem alloc] initWithCustomView:button];
    self.navigationItem.rightBarButtonItem = barButton;
}

- (void)rightButtonClick {
    NSLog(@"分享");
}

- (void)setupNavigationItemLeftBarButtonItem {
    UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 44, 44)];
    button.contentEdgeInsets = UIEdgeInsetsMake(0, -16, 0, 0);
    [button setImage:[UIImage imageNamed:@"icon_setting"] forState:UIControlStateNormal];
    [button addTarget:self action:@selector(leftButtonClick) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *barButton = [[UIBarButtonItem alloc] initWithCustomView:button];
    self.navigationItem.leftBarButtonItem = barButton;
}

- (void)leftButtonClick {
    NSLog(@"设置");
    
    VENMinePageSettingViewController *vc = [[VENMinePageSettingViewController alloc] init];
    vc.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:vc animated:YES];
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
