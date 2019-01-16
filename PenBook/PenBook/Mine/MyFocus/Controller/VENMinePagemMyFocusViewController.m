//
//  VENMinePagemMyFocusViewController.m
//  PenBook
//
//  Created by YVEN on 2019/1/7.
//  Copyright © 2019年 Hefei Haiba Network Technology Co., Ltd. All rights reserved.
//

#import "VENMinePagemMyFocusViewController.h"
#import "VENMinePagemMyFansTableViewCell.h"

@interface VENMinePagemMyFocusViewController () <UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, strong) UITableView *tableView;

@end

static NSString *cellIdentifier = @"cellIdentifier";
@implementation VENMinePagemMyFocusViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.navigationItem.title = @"我的关注";
    
    [self setupTableView];
    
    [self.tableView.mj_header beginRefreshing];
}

- (void)loadData {
    [[VENNetworkTool sharedManager] requestWithMethod:HTTPMethodGet path:@"/Recordkernel/gamemyfollow" params:@{@"userid" : [[NSUserDefaults standardUserDefaults] objectForKey:@"Login"][@"userid"]} showLoading:YES successBlock:^(id response) {
        
        [self.tableView reloadData];
        
    } failureBlock:^(NSError *error) {
        
    }];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 10;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    VENMinePagemMyFansTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier forIndexPath:indexPath];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    cell.iconImageView.backgroundColor = [UIColor colorWithRed:arc4random_uniform(255)/255.0 green:arc4random_uniform(255)/255.0 blue:arc4random_uniform(255)/255.0 alpha:1];
    
    [cell.rightButton setTitle:@"  已关注" forState:UIControlStateNormal];
    [cell.rightButton setImage:[UIImage imageNamed:@"icon_focus3"] forState:UIControlStateNormal];
    cell.rightButtonWidthLayoutConstraint.constant = 72.0f;
    
    return cell;
}

- (void)setupTableView {
    UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, kMainScreenWidth, kMainScreenHeight - statusNavHeight) style:UITableViewStylePlain];
    tableView.backgroundColor = UIColorMake(247, 247, 247);
    tableView.delegate = self;
    tableView.dataSource = self;
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    tableView.rowHeight = 86;
    [tableView registerNib:[UINib nibWithNibName:@"VENMinePagemMyFansTableViewCell" bundle:nil] forCellReuseIdentifier:cellIdentifier];
    [self.view addSubview:tableView];
    
    tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        
        [self loadData];
    }];
    
    tableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        
    }];
    
    _tableView = tableView;
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
