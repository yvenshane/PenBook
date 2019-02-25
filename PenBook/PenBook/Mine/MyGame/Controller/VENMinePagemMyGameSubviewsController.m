//
//  VENMinePagemMyGameSubviewsController.m
//  PenBook
//
//  Created by YVEN on 2019/1/7.
//  Copyright © 2019年 Hefei Haiba Network Technology Co., Ltd. All rights reserved.
//

#import "VENMinePagemMyGameSubviewsController.h"
#import "VENMinePagemMyGameTableViewCell.h"
#import "VENMinePagemMyGameSubviewsModel.h"

@interface VENMinePagemMyGameSubviewsController () <UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, copy) NSArray *gameplayArr;
@property (nonatomic, copy) NSArray *gamerecommendArr;
@property (nonatomic, assign) BOOL isFirst;

@end

static NSString *cellIdentifier = @"cellIdentifier";
@implementation VENMinePagemMyGameSubviewsController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self setupTableView];
    
    if ([self.pageTag isEqualToString:@"推荐"]) {
        [self.tableView.mj_header beginRefreshing];
    }
}

- (void)loadData {
    if ([self.pageTag isEqualToString:@"推荐"]) {
        
        NSDictionary *params = @{@"useridfa" : [[VENNetworkTool sharedManager] getIDFA]};
        
        [[VENNetworkTool sharedManager] requestWithMethod:HTTPMethodGet path:@"Recordkernel/gamerecommend" params:params showLoading:NO successBlock:^(id response) {
            [self.tableView.mj_header endRefreshing];
            
            if ([response[@"ret"] integerValue] == 1) {
                self.gamerecommendArr = [NSArray yy_modelArrayWithClass:[VENMinePagemMyGameSubviewsModel class] json:response[@"game"]];
                [self.tableView reloadData];
            }
        } failureBlock:^(NSError *error) {
            [self.tableView.mj_header endRefreshing];
        }];
    } else {
        
        [[VENNetworkTool sharedManager] requestWithMethod:HTTPMethodGet path:@"Recordkernel/gameplay" params:@{@"userid" : [[NSUserDefaults standardUserDefaults] objectForKey:@"Login"][@"userid"]} showLoading:NO successBlock:^(id response) {
            
            [self.tableView.mj_header endRefreshing];
            
            if ([response[@"ret"] integerValue] == 1) {
                self.gameplayArr = [NSArray yy_modelArrayWithClass:[VENMinePagemMyGameSubviewsModel class] json:response[@"head"]];
            }
            
            [self.tableView reloadData];
            
        } failureBlock:^(NSError *error) {
            [self.tableView.mj_header endRefreshing];
        }];
    }
}

- (void)loadViewWithParams:(NSDictionary *)params {
    [[VENNetworkTool sharedManager] requestWithMethod:HTTPMethodGet path:@"Recordtext/searchgame" params:params showLoading:YES successBlock:^(id response) {
        
    } failureBlock:^(NSError *error) {
        
    }];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.pageTag isEqualToString:@"推荐"] ? self.gamerecommendArr.count : self.gameplayArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    VENMinePagemMyGameTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier forIndexPath:indexPath];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;

    if ([self.pageTag isEqualToString:@"推荐"]) {
        VENMinePagemMyGameSubviewsModel *model = self.gamerecommendArr[indexPath.row];
        
        [cell.iconImageView sd_setImageWithURL:[NSURL URLWithString:model.image]];
        cell.topLabel.text = model.name;
        cell.bottomLabel.text = model.heat;
        cell.starCount = model.star;
        [cell.imageView2 sd_setImageWithURL:[NSURL URLWithString:model.poster]];
        [cell.rightButton setTitle:@"下载" forState:UIControlStateNormal];
        cell.rightButton.backgroundColor = UIColorFromRGB(0xFBC82E);
        cell.rightButton.tag = indexPath.row;
        [cell.rightButton addTarget:self action:@selector(rightButtonClick2:) forControlEvents:UIControlEventTouchUpInside];
        
    } else {
        VENMinePagemMyGameSubviewsModel *model = self.gameplayArr[indexPath.row];
        
        [cell.iconImageView sd_setImageWithURL:[NSURL URLWithString:model.image]];
        cell.topLabel.text = model.game;
        cell.bottomLabel.text = model.heat;
        cell.starCount = model.star;
        cell.imageView2.hidden = YES;
        
        if ([self.pageTag isEqualToString:@"想玩"]) {
            [cell.rightButton setTitle:@"下载" forState:UIControlStateNormal];
            cell.rightButton.backgroundColor = UIColorFromRGB(0xFBC82E);
            cell.rightButton.tag = indexPath.row;
            [cell.rightButton addTarget:self action:@selector(rightButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        } else {
            [cell.rightButton setTitle:@"在玩" forState:UIControlStateNormal];
            cell.rightButton.backgroundColor = UIColorFromRGB(0xD2D2D2);
        }
    }
    
    return cell;
}

- (void)rightButtonClick:(UIButton *)button {
    VENMinePagemMyGameSubviewsModel *model = self.gameplayArr[button.tag];
    
    NSDictionary *params = @{@"idfa" : [[VENNetworkTool sharedManager] getIDFA],
                             @"ip" : [[VENNetworkTool sharedManager] getIPAddress],
                             @"callback" : [NSString stringWithFormat:@"%@?idfa={%@}&ip={%@}", model.callback, [[VENNetworkTool sharedManager] getIDFA], [[VENNetworkTool sharedManager] getIPAddress]]};
    
    [[VENNetworkTool sharedManager] requestWithMethod:HTTPMethodGet path:[model.click substringFromIndex:23] params:params showLoading:YES successBlock:^(id response) {
        
        if ([response[@"ret"] integerValue] == 0) {
            [[UIApplication sharedApplication]openURL:[NSURL URLWithString:[NSString stringWithFormat:@"itms-apps://itunes.apple.com/app/id%@", model.ituuesid]]];
        }
        
    } failureBlock:^(NSError *error) {
        
    }];
}

- (void)rightButtonClick2:(UIButton *)button {
    VENMinePagemMyGameSubviewsModel *model = self.gamerecommendArr[button.tag];
    
    NSDictionary *params = @{@"idfa" : [[VENNetworkTool sharedManager] getIDFA],
                             @"ip" : [[VENNetworkTool sharedManager] getIPAddress],
                             @"callback" : [NSString stringWithFormat:@"%@?idfa={%@}&ip={%@}", model.callback, [[VENNetworkTool sharedManager] getIDFA], [[VENNetworkTool sharedManager] getIPAddress]]};
    
    [[VENNetworkTool sharedManager] requestWithMethod:HTTPMethodGet path:[model.click substringFromIndex:23] params:params showLoading:YES successBlock:^(id response) {
        
        if ([response[@"ret"] integerValue] == 0) {
            [[UIApplication sharedApplication]openURL:[NSURL URLWithString:[NSString stringWithFormat:@"itms-apps://itunes.apple.com/app/id%@", model.ituuesid]]];
        }
        
    } failureBlock:^(NSError *error) {
        
    }];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return [self.pageTag isEqualToString:@"推荐"] ? 192 : 92;
}

- (void)setupTableView {
    UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, kMainScreenWidth, kMainScreenHeight - statusNavHeight - 64) style:UITableViewStylePlain];
    tableView.backgroundColor = UIColorMake(247, 247, 247);
    tableView.delegate = self;
    tableView.dataSource = self;
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [tableView registerNib:[UINib nibWithNibName:@"VENMinePagemMyGameTableViewCell" bundle:nil] forCellReuseIdentifier:cellIdentifier];
    [self.view addSubview:tableView];
    
    tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [self loadData];
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
