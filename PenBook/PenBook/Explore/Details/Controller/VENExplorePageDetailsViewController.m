//
//  VENExplorePageDetailsViewController.m
//  PenBook
//
//  Created by YVEN on 2019/1/16.
//  Copyright © 2019年 Hefei Haiba Network Technology Co., Ltd. All rights reserved.
//

#import "VENExplorePageDetailsViewController.h"
#import "VENExplorePageDetailsTableViewCell.h"
#import "VENExplorePageModel.h"
#import "VENExplorePageDetailsTableViewCellTwo.h"
#import "VENExplorePageDetailsTableViewCellThree.h"
#import "UIView+CLSetRect.h"
#import "CLInputToolbar.h"
#import "VENLoginViewController.h"
#import "VENExplorePageDetailsModel.h"

@interface VENExplorePageDetailsViewController () <UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) VENExplorePageModel *model;
@property (nonatomic, copy) NSArray *com_valArr;

@property (nonatomic, strong) CLInputToolbar *inputToolbar;
@property (nonatomic, strong) UIView *maskView;

@end

static NSString *cellIdentifier = @"cellIdentifier";
static NSString *cellIdentifier2 = @"cellIdentifier2";
static NSString *cellIdentifier3 = @"cellIdentifier3";
@implementation VENExplorePageDetailsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self setupRightButton];
    [self setupTableView];
    [self setTextViewToolbar];
    [self.tableView.mj_header beginRefreshing];
}

- (void)loadDataWith:(NSDictionary *)params {
    [[VENNetworkTool sharedManager] requestWithMethod:HTTPMethodGet path:@"Recordtext/readarticle" params:params showLoading:NO successBlock:^(id response) {
        [self.tableView.mj_header endRefreshing];
        
        if ([response[@"ret"] integerValue] == 1) {
            
            VENExplorePageModel *model = [VENExplorePageModel yy_modelWithJSON:response];
            self.model = model;
            
            NSArray *com_valArr = [NSArray yy_modelArrayWithClass:[VENExplorePageDetailsModel class] json:response[@"com_val"]];
            self.com_valArr = com_valArr;
            
            [self.tableView reloadData];
        }
        
    } failureBlock:^(NSError *error) {
        [self.tableView.mj_header endRefreshing];
    }];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 2 + self.com_valArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.row == 0) {
        VENExplorePageDetailsTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier forIndexPath:indexPath];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        [cell.iconImageView sd_setImageWithURL:[NSURL URLWithString:self.model.headpic]];
        cell.userNameLabel.text = self.model.username;
        cell.contentLabel.text = [[VENClassEmptyManager sharedManager] isEmptyString:self.model.value] ? @"" : self.model.value;
        
        if ([self.model.give_state integerValue] == 1) {
            cell.zanButton.selected = YES;
        } else if ([self.model.give_state integerValue] == 0) {
            cell.zanButton.selected = NO;
        }
        
        if ([self.model.collect_state integerValue] == 1) {
            cell.focusButton.selected = YES;
        } else if ([self.model.collect_state integerValue] == 0) {
            cell.focusButton.selected = NO;
        }
        
        [cell.fucosButton addTarget:self action:@selector(guanzhuButtonClick) forControlEvents:UIControlEventTouchUpInside];
        
        [cell.zanButton setTitle:[NSString stringWithFormat:@"  %@", self.model.give] forState:UIControlStateNormal];
        [cell.focusButton setTitle:[NSString stringWithFormat:@"  %@", self.model.collect] forState:UIControlStateNormal];
        [cell.talkButton setTitle:[NSString stringWithFormat:@"  %@", self.model.comment] forState:UIControlStateNormal];
        [cell.shareButton setTitle:[NSString stringWithFormat:@"  %@", self.model.share] forState:UIControlStateNormal];
        
        cell.zanButton.tag = indexPath.row;
        cell.focusButton.tag = indexPath.row;
        cell.shareButton.tag = indexPath.row;
        
        [cell.zanButton addTarget:self action:@selector(zanButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        [cell.focusButton addTarget:self action:@selector(focusButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        [cell.talkButton addTarget:self action:@selector(talkButtonClick) forControlEvents:UIControlEventTouchUpInside];
        [cell.shareButton addTarget:self action:@selector(shareButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        [cell.jinzhiButton addTarget:self action:@selector(jinzhiButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        
        // gamePic
        for (UIView *subViews in cell.gameView.subviews) {
            [subViews removeFromSuperview];
        }
        
        for (NSInteger i = 0; i < self.model.head.count; i++) {
            UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(i * 12, 0, 21, 21)];
            [imageView sd_setImageWithURL:[NSURL URLWithString:self.model.head[i][@"portrait"]]];
            imageView.layer.cornerRadius = 21 / 2;
            imageView.layer.masksToBounds = YES;
            [cell.gameView addSubview:imageView];
        }
        
        
        // pic
        for (UIView *subViews in cell.picView.subviews) {
            [subViews removeFromSuperview];
        }
        
        if (self.model.image.count < 1) {
            cell.picViewlayoutConstraint.constant = 1;
        } else {
            cell.picViewlayoutConstraint.constant = (kMainScreenWidth - 54) / 3;
        }
        
        for (NSInteger i = 0; i < self.model.image.count; i++) {
            UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(i * (kMainScreenWidth - 54) / 3 + i * 16, 0, (kMainScreenWidth - 54) / 3, (kMainScreenWidth - 54) / 3)];
            [imageView sd_setImageWithURL:[NSURL URLWithString:self.model.image[i][@"image"]]];
            imageView.layer.cornerRadius = 6;
            imageView.layer.masksToBounds = YES;
            [cell.picView addSubview:imageView];
        }
        
        return cell;
    } else if (indexPath.row == 1) {
        VENExplorePageDetailsTableViewCellTwo *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier2 forIndexPath:indexPath];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        [cell.inputButton addTarget:self action:@selector(inputButtonClick) forControlEvents:UIControlEventTouchUpInside];
        
        return cell;
    } else {
        VENExplorePageDetailsTableViewCellThree *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier3 forIndexPath:indexPath];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        // 评论
        VENExplorePageDetailsModel *model = self.com_valArr[indexPath.row - 2];
        
        [cell.iconImageView sd_setImageWithURL:[NSURL URLWithString:model.image]];
        cell.nameLabel.text = model.username;
        cell.contentLabel.text = model.content;
        
        
        
        return cell;
    }
}

- (void)guanzhuButtonClick {
    
    if ([[VENLoginStatusManager sharedManager] isLogin]) {
        NSDictionary *params = @{@"objectid" : self.model.userid,
                                 @"selfid" : [[NSUserDefaults standardUserDefaults] objectForKey:@"Login"][@"userid"]};
        
        [[VENNetworkTool sharedManager] requestWithMethod:HTTPMethodGet path:@"Recordkernel/gamefollow" params:params showLoading:YES successBlock:^(id response) {
            
        } failureBlock:^(NSError *error) {
            
        }];
    } else {
        VENLoginViewController *vc = [[VENLoginViewController alloc] init];
        [self presentViewController:vc animated:YES completion:nil];
    }
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

- (void)talkButtonClick {
    NSLog(@"评论");
}

- (void)shareButtonClick:(UIButton *)button {
    NSLog(@"分享");
    
}

- (void)jinzhiButtonClick:(UIButton *)button {
    NSDictionary *params = @{};
    if ([[VENClassEmptyManager sharedManager] isEmptyString:[[NSUserDefaults standardUserDefaults] objectForKey:@"Login"][@"userid"]]) {
        params =  @{@"arid" : self.articleid,
                    @"idfa" : [[VENNetworkTool sharedManager] getIDFA]};
    } else {
        params =  @{@"arid" : self.articleid,
                    @"userid" : [[NSUserDefaults standardUserDefaults] objectForKey:@"Login"][@"userid"],
                    @"idfa" : [[VENNetworkTool sharedManager] getIDFA]};
    }
    
    [[VENNetworkTool sharedManager] requestWithMethod:HTTPMethodGet path:@"Recordkernel/userhide" params:params showLoading:YES successBlock:^(id response) {
        
        if ([response[@"ret"] integerValue] == 1) {
            button.selected = YES;
        }
        
    } failureBlock:^(NSError *error) {
        
    }];
}

- (void)loadDataWithUrl:(NSString *)url andIdex:(NSInteger)idex {
    
    if ([[VENLoginStatusManager sharedManager] isLogin]) {
        
        NSDictionary *params = @{@"articleid" : self.model.articleID,
                                 @"userid" : [[NSUserDefaults standardUserDefaults] objectForKey:@"Login"][@"userid"]};
        
        [[VENNetworkTool sharedManager] requestWithMethod:HTTPMethodGet path:url params:params showLoading:YES successBlock:^(id response) {
            
            if ([url isEqualToString:@"Recordkernel/gamegive"]) { // 点赞
                
                if ([response[@"ret"] integerValue] == 1) {
                    self.model.give_state = @"1";
                    self.model.give = [NSString stringWithFormat:@"%ld", [self.model.give integerValue] + 1];
                } else if ([response[@"ret"] integerValue] == 2) {
                    self.model.give_state = @"0";
                    self.model.give = [NSString stringWithFormat:@"%ld", [self.model.give integerValue] - 1];
                }
                
                [self.tableView reloadData];
                
            } else if ([url isEqualToString:@"Recordkernel/gamecollect"]) { // 收藏
                
                if ([response[@"ret"] integerValue] == 1) {
                    self.model.collect_state = @"1";
                    self.model.collect = [NSString stringWithFormat:@"%ld", [self.model.collect integerValue] + 1];
                }
                
                [self.tableView reloadData];
                
            } else if ([url isEqualToString:@"Recordkernel/deletecollect"]) { // 取消收藏
                
                if ([response[@"ret"] integerValue] == 1) {
                    self.model.collect_state = @"0";
                    self.model.collect = [NSString stringWithFormat:@"%ld", [self.model.collect integerValue] - 1];
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

#pragma mark - 输入框
- (void)setTextViewToolbar {
    
    self.maskView = [[UIView alloc] initWithFrame:self.view.bounds];
    self.maskView.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.39];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapActions:)];
    [self.maskView addGestureRecognizer:tap];
    [self.view addSubview:self.maskView];
    self.maskView.hidden = YES;
    self.inputToolbar = [[CLInputToolbar alloc] init];
    self.inputToolbar.textViewMaxLine = 3;
    self.inputToolbar.placeholder = @"写点什么吧...";
    
    __weak __typeof(self) weakSelf = self;
    [self.inputToolbar inputToolbarSendText:^(NSString *text) {
        __typeof(&*weakSelf) strongSelf = weakSelf;
        
        if (![[VENClassEmptyManager sharedManager] isEmptyString:text]) {
            
            NSDictionary *params = @{@"articleid" : self.model.articleID,
                                     @"ar_userid" : self.model.userid,
                                     @"userid" : [[NSUserDefaults standardUserDefaults] objectForKey:@"Login"][@"userid"],
                                     @"value" : text};

            [[VENNetworkTool sharedManager] requestWithMethod:HTTPMethodGet path:@"Recordkernel/gamecomment" params:params showLoading:YES successBlock:^(id response) {
                
                if ([response[@"ret"] integerValue] == 1) {
                    [self.tableView.mj_header beginRefreshing];
                }
                
            } failureBlock:^(NSError *error) {
                
            }];
        }
        
        // 清空输入框文字
        [strongSelf.inputToolbar bounceToolbar];
        strongSelf.maskView.hidden = YES;
    }];
    [self.maskView addSubview:self.inputToolbar];
}

- (void)tapActions:(UITapGestureRecognizer *)tap {
    [self.inputToolbar bounceToolbar];
    self.maskView.hidden = YES;
}

- (void)inputButtonClick {
    if ([[VENLoginStatusManager sharedManager] isLogin]) {
        self.maskView.hidden = NO;
        [self.inputToolbar popToolbar];
    } else {
        VENLoginViewController *vc = [[VENLoginViewController alloc] init];
        [self presentViewController:vc animated:YES completion:nil];
    }
}

- (void)setupTableView {
    UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, kMainScreenWidth, kMainScreenHeight - statusNavHeight) style:UITableViewStylePlain];
//    tableView.backgroundColor = UIColorMake(247, 247, 247);
    tableView.delegate = self;
    tableView.dataSource = self;
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    tableView.estimatedRowHeight = 300;
    [tableView registerNib:[UINib nibWithNibName:@"VENExplorePageDetailsTableViewCell" bundle:nil] forCellReuseIdentifier:cellIdentifier];
    [tableView registerNib:[UINib nibWithNibName:@"VENExplorePageDetailsTableViewCellTwo" bundle:nil] forCellReuseIdentifier:cellIdentifier2];
    [tableView registerNib:[UINib nibWithNibName:@"VENExplorePageDetailsTableViewCellThree" bundle:nil] forCellReuseIdentifier:cellIdentifier3];
    [self.view addSubview:tableView];
    
    UIView *foorerView = [[UIView alloc] initWithFrame:CGRectMake(27 , 0, kMainScreenWidth - 54, 54)];
    tableView.tableFooterView = foorerView;
    
    UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(0, 5, kMainScreenWidth - 54, 49)];
    [button setTitle:@"查看全部99条想法 v" forState:UIControlStateNormal];
    [button setTitleColor:UIColorFromRGB(0xC4A067) forState:UIControlStateNormal];
    button.titleLabel.font = [UIFont systemFontOfSize:11.0f];
    button.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    button.titleEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 0);
    [foorerView addSubview:button];
    
    tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        
        
        NSDictionary *params = @{};
        
        if ([[VENClassEmptyManager sharedManager] isEmptyString:[[NSUserDefaults standardUserDefaults] objectForKey:@"Login"][@"userid"]]) {
            params =  @{@"articleid" : self.articleid};
        } else {
            params =  @{@"articleid" : self.articleid,
                        @"userid" : [[NSUserDefaults standardUserDefaults] objectForKey:@"Login"][@"userid"]};
        }
        
        [self loadDataWith:params];
    }];
    
//    tableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
//        
//    }];
    
    _tableView = tableView;
}

- (void)setupRightButton {
    UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 44, 44)];
    [button setTitle:@"举报" forState:UIControlStateNormal];
    [button setTitleColor:UIColorMake(204, 14, 38) forState:UIControlStateNormal];
    button.titleLabel.font = [UIFont systemFontOfSize:15.0f];
    [button addTarget:self action:@selector(rightButtonClick) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *barButton = [[UIBarButtonItem alloc] initWithCustomView:button];
    self.navigationItem.rightBarButtonItem = barButton;
}

- (void)rightButtonClick {
    
    NSDictionary *params = @{};
    if ([[VENClassEmptyManager sharedManager] isEmptyString:[[NSUserDefaults standardUserDefaults] objectForKey:@"Login"][@"userid"]]) {
        params =  @{@"arid" : self.articleid,
                    @"idfa" : [[VENNetworkTool sharedManager] getIDFA]};
    } else {
        params =  @{@"arid" : self.articleid,
                    @"userid" : [[NSUserDefaults standardUserDefaults] objectForKey:@"Login"][@"userid"],
                    @"idfa" : [[VENNetworkTool sharedManager] getIDFA]};
    }
    
    [[VENNetworkTool sharedManager] requestWithMethod:HTTPMethodGet path:@"Recordkernel/arreport" params:params showLoading:YES successBlock:^(id response) {
        
        if ([response[@"ret"] integerValue] == 1) {
            
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
