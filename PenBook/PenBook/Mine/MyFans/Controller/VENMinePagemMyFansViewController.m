//
//  VENMinePagemMyFansViewController.m
//  PenBook
//
//  Created by YVEN on 2019/1/7.
//  Copyright © 2019年 Hefei Haiba Network Technology Co., Ltd. All rights reserved.
//

#import "VENMinePagemMyFansViewController.h"
#import "VENMinePagemMyFansTableViewCell.h"
#import "VENMinePagemMyFansModel.h"

@interface VENMinePagemMyFansViewController () <UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, copy) NSArray *dataArr;

@end

static NSString *cellIdentifier = @"cellIdentifier";
@implementation VENMinePagemMyFansViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.navigationItem.title = @"我的粉丝";
    
    [self setupTableView];
    
    [self.tableView.mj_header beginRefreshing];
}

- (void)loadData {
    [[VENNetworkTool sharedManager] requestWithMethod:HTTPMethodGet path:@"/Recordkernel/gamefans" params:@{@"userid" : [[NSUserDefaults standardUserDefaults] objectForKey:@"Login"][@"userid"]} showLoading:YES successBlock:^(id response) {
        [self.tableView.mj_header endRefreshing];
        
        if ([response[@"ret"] integerValue] == 1) {
            
            NSArray *dataArr = [NSArray yy_modelArrayWithClass:[VENMinePagemMyFansModel class] json:response[@"value"]];
            self.dataArr = dataArr;
            
            [self.tableView reloadData];
        }
    } failureBlock:^(NSError *error) {
        [self.tableView.mj_header endRefreshing];
    }];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    VENMinePagemMyFansTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier forIndexPath:indexPath];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    VENMinePagemMyFansModel *model = self.dataArr[indexPath.row];
    
    [cell.iconImageView sd_setImageWithURL:[NSURL URLWithString:model.url]];
    cell.topLabel.text = model.username;
    cell.bottomLabel.text = model.motto;
    [cell.rightButton setTitle:model.msg forState:UIControlStateNormal];
    
    if ([model.follow integerValue] == 1) {
        cell.rightButton.backgroundColor = UIColorFromRGB(0xF2F2F2);
        [cell.rightButton setTitleColor:UIColorFromRGB(0x565656) forState:UIControlStateNormal];
        [cell.rightButton setImage:[UIImage imageNamed:@"icon_focus2"] forState:UIControlStateNormal];
        cell.rightButtonWidthLayoutConstraint.constant = 80;
    } else {
        cell.rightButton.backgroundColor = UIColorFromRGB(0x5061FB);
        [cell.rightButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [cell.rightButton setImage:[UIImage imageNamed:@"nil"] forState:UIControlStateNormal];
        cell.rightButtonWidthLayoutConstraint.constant = 55;
    }
    
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
    
//    tableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
//        
//    }];
    
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
