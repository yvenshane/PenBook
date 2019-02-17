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
#import "VENExplorePageModel.h"
#import "VENLoginViewController.h"

#import "VENExplorePageDetailsViewController.h"

@interface VENMineViewController ()<UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) VENMineModel *model;
@property (nonatomic, copy) NSArray *dataArr;

@end

static NSString *cellIdentifier = @"cellIdentifier";
@implementation VENMineViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self setupNavigationItemLeftBarButtonItem];
    [self setupNavigationItemRightBarButtonItem];
    [self setupTableView];
    
    [self.tableView.mj_header beginRefreshing];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(notificationCenter:) name:@"LoginSuccessfully" object:nil];
}

- (void)notificationCenter:(NSNotification *)noti {
    [self.tableView.mj_header beginRefreshing];
}

- (void)loadData {
    
    NSString *userid = @"";
    
    if (![[VENClassEmptyManager sharedManager] isEmptyString:[[NSUserDefaults standardUserDefaults] objectForKey:@"Login"][@"userid"]]) {
        userid = [[NSUserDefaults standardUserDefaults] objectForKey:@"Login"][@"userid"];
    }
    
    NSDictionary *params = @{@"userid" : userid};
    
    [[VENNetworkTool sharedManager] requestWithMethod:HTTPMethodGet path:@"Recordtext/appuser" params:params showLoading:NO successBlock:^(id response) {
        
        self.model = [VENMineModel yy_modelWithJSON:response];
        
        [[VENNetworkTool sharedManager] requestWithMethod:HTTPMethodGet path:@"/Recordkernel/footprint" params:params showLoading:NO successBlock:^(id response) {
            
            [self.tableView.mj_header endRefreshing];
            
            NSArray *dataArr = [NSArray yy_modelArrayWithClass:[VENExplorePageModel class] json:response[@"arr"]];
            self.dataArr = dataArr;
            
            self.tableView.tableHeaderView = nil;
            [self setupHeaderView];
            [self.tableView reloadData];
            
        } failureBlock:^(NSError *error) {
            [self.tableView.mj_header endRefreshing];
        }];
    } failureBlock:^(NSError *error) {
        
    }];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    VENMineTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier forIndexPath:indexPath];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    VENExplorePageModel *model = self.dataArr[indexPath.row];
    
    [cell.iconImageView sd_setImageWithURL:[NSURL URLWithString:model.headpic]];
    cell.nameLabel.text = model.username;
    cell.contentLabel.text = model.value;
    cell.dateLabel.text = model.uptime;
    
    [cell.gameNameButton setTitle:model.gamename forState:UIControlStateNormal];
    
    if ([model.give_state integerValue] == 1) {
        cell.zanButton.selected = YES;
    } else if ([model.give_state integerValue] == 0) {
        cell.zanButton.selected = NO;
    }
    
    if ([model.collect_state integerValue] == 1) {
        cell.focusButton.selected = YES;
    } else if ([model.give_state integerValue] == 0) {
        cell.focusButton.selected = NO;
    }
    
    [cell.zanButton setTitle:[NSString stringWithFormat:@"  %@", model.give] forState:UIControlStateNormal];
    [cell.focusButton setTitle:[NSString stringWithFormat:@"  %@", model.collect] forState:UIControlStateNormal];
    [cell.talkButton setTitle:[NSString stringWithFormat:@"  %@", model.comment] forState:UIControlStateNormal];
    [cell.shareButton setTitle:[NSString stringWithFormat:@"  %@", model.share] forState:UIControlStateNormal];
    
    cell.zanButton.tag = indexPath.row;
    cell.focusButton.tag = indexPath.row;
    cell.talkButton.tag = indexPath.row;
    cell.shareButton.tag = indexPath.row;
    
    [cell.zanButton addTarget:self action:@selector(zanButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [cell.focusButton addTarget:self action:@selector(focusButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [cell.talkButton addTarget:self action:@selector(talkButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [cell.shareButton addTarget:self action:@selector(shareButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    
    // pic
    for (UIView *subViews in cell.picView.subviews) {
        [subViews removeFromSuperview];
    }
    
    if (model.image.count < 1) {
        cell.picViewLayoutConstraint.constant = 1;
    } else {
        cell.picViewLayoutConstraint.constant = (kMainScreenWidth - 60) / 3;
    }
    
    for (NSInteger i = 0; i < model.image.count; i++) {
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(i * (kMainScreenWidth - 60) / 3 + i * 16, 0, (kMainScreenWidth - 60) / 3, (kMainScreenWidth - 60) / 3)];
        [imageView sd_setImageWithURL:[NSURL URLWithString:model.image[i][@"image"]]];
        imageView.layer.cornerRadius = 6;
        imageView.layer.masksToBounds = YES;
        [cell.picView addSubview:imageView];
    }

    return cell;
}

- (void)zanButtonClick:(UIButton *)button {
    NSLog(@"赞");
    
    [self loadDataWithUrl:@"Recordkernel/gamegive" andIdex:button.tag];
}

- (void)focusButtonClick:(UIButton *)button {
    NSLog(@"收藏");
    
    if (button.selected == YES) {
        [self loadDataWithUrl:@"Recordkernel/deletecollect" andIdex:button.tag];
    } else {
        [self loadDataWithUrl:@"Recordkernel/gamecollect" andIdex:button.tag];
    }
}

- (void)talkButtonClick:(UIButton *)button {
    
    
    VENExplorePageModel *model = self.dataArr[button.tag];
    
    VENExplorePageDetailsViewController *vc = [[VENExplorePageDetailsViewController alloc] init];
    vc.navigationItem.title = model.gamename;
    vc.articleid = model.articleID;
    vc.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)shareButtonClick:(UIButton *)button {
    NSLog(@"分享");
    
}

- (void)loadDataWithUrl:(NSString *)url andIdex:(NSInteger)idex {
    
    if ([[VENLoginStatusManager sharedManager] isLogin]) {
        
        VENExplorePageModel *model = self.dataArr[idex];
        
        NSDictionary *params = @{@"articleid" : model.articleID,
                                 @"userid" : [[NSUserDefaults standardUserDefaults] objectForKey:@"Login"][@"userid"]};
        
        [[VENNetworkTool sharedManager] requestWithMethod:HTTPMethodGet path:url params:params showLoading:YES successBlock:^(id response) {
            
            if ([url isEqualToString:@"Recordkernel/gamegive"]) { // 点赞
                
                if ([response[@"ret"] integerValue] == 1) {
                    model.give_state = @"1";
                    model.give = [NSString stringWithFormat:@"%ld", [model.give integerValue] + 1];
                } else if ([response[@"ret"] integerValue] == 2) {
                    model.give_state = @"0";
                    model.give = [NSString stringWithFormat:@"%ld", [model.give integerValue] - 1];
                }
                
                [self.tableView reloadData];
                
            } else if ([url isEqualToString:@"Recordkernel/gamecollect"]) { // 收藏
                
                if ([response[@"ret"] integerValue] == 1) {
                    model.collect_state = @"1";
                    model.collect = [NSString stringWithFormat:@"%ld", [model.collect integerValue] + 1];
                }
                
                [self.tableView reloadData];
                
            } else if ([url isEqualToString:@"Recordkernel/deletecollect"]) { // 取消收藏
                
                if ([response[@"ret"] integerValue] == 1) {
                    model.collect_state = @"0";
                    model.collect = [NSString stringWithFormat:@"%ld", [model.collect integerValue] - 1];
                }
                
                [self.tableView reloadData];
                
            } else if ([url isEqualToString:@"Recordkernel/gameshare"]) { // 分享
                
            }
            
        } failureBlock:^(NSError *error) {
            
        }];
        
    } else {
        VENLoginViewController *vc = [[VENLoginViewController alloc] init];
        [self presentViewController:vc animated:YES completion:nil];
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    VENExplorePageModel *model = self.dataArr[indexPath.row];
    
    VENExplorePageDetailsViewController *vc = [[VENExplorePageDetailsViewController alloc] init];
    vc.navigationItem.title = model.gamename;
    vc.articleid = model.articleID;
    vc.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:vc animated:YES];
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
    
    tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        
        [self loadData];
    }];
    
//    tableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
//        
//    }];
    
    _tableView = tableView;
}

- (void)setupHeaderView {
    VENMinePageTableHeaderView *headerView = [[[NSBundle mainBundle] loadNibNamed:@"VENMinePageTableHeaderView" owner:nil options:nil] lastObject];
    headerView.nameLabel.text = _model.username;
    headerView.otherButton.backgroundColor = [_model.gender isEqualToString:@"女"] ? UIColorFromRGB(0xFD5871) : UIColorFromRGB(0x789Df9);
    [headerView.otherButton setImage:[UIImage imageNamed:[_model.gender isEqualToString:@"女"] ? @"icon_boy" : @"icon_girl"] forState:UIControlStateNormal];
    [headerView.otherButton setTitle:[NSString stringWithFormat:@"  %@", _model.age] forState:UIControlStateNormal];
    headerView.xingzuoLabel.text = _model.constell;
    headerView.qianmingLabel.text = _model.title;
    [headerView.iconImageView sd_setImageWithURL:[NSURL URLWithString:_model.headpic]];
    
    for (NSInteger i = 0; i < _model.headgame.count; i++) {
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(i * 12, 0, 21, 21)];
        [imageView sd_setImageWithURL:[NSURL URLWithString:_model.headgame[i]]];
        imageView.layer.cornerRadius = 21 / 2;
        imageView.layer.masksToBounds = YES;
        [headerView.gameView addSubview:imageView];
        
        headerView.gameViewLayoutConstraint.constant = 12 * i + 21 - 12;
    }
    
    [headerView.myFansButton addTarget:self action:@selector(myFansButtonClick) forControlEvents:UIControlEventTouchUpInside];
    [headerView.myFocusButton addTarget:self action:@selector(myFocusButtonClick) forControlEvents:UIControlEventTouchUpInside];
    [headerView.myGameButton addTarget:self action:@selector(myGameButtonClick) forControlEvents:UIControlEventTouchUpInside];
    headerView.frame = CGRectMake(0, 0, kMainScreenWidth, 289);
    
    self.tableView.tableHeaderView = headerView;
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
    vc.block = ^(NSString *str) {
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            self.tabBarController.selectedIndex = 0;
        });
    };
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
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
