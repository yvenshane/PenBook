//
//  VENExplorePageSubviewsController.m
//  PenBook
//
//  Created by YVEN on 2019/1/6.
//  Copyright © 2019年 Hefei Haiba Network Technology Co., Ltd. All rights reserved.
//

#import "VENExplorePageSubviewsController.h"
#import "VENExplorePageTableViewCell.h"
#import "VENExplorePageModel.h"

@interface VENExplorePageSubviewsController () <UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, copy) NSArray *dataArr;
@property (nonatomic, strong) UIImageView *gamePicImageView;
@property (nonatomic, strong) UIImageView *picImageView;

@end

static NSString *cellIdentifier = @"cellIdentifier";
@implementation VENExplorePageSubviewsController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self setupTableView];
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        [self.tableView.mj_header beginRefreshing];
    });
}

- (void)loadDataWith:(NSDictionary *)params {
    [[VENNetworkTool sharedManager] requestWithMethod:HTTPMethodGet path:@"Recordkernel/gamearticle" params:params showLoading:NO successBlock:^(id response) {
        
        [self.tableView.mj_header endRefreshing];;
        
        if ([response[@"ret"] integerValue] == 1) {
            NSArray *dataArr = [NSArray yy_modelArrayWithClass:[VENExplorePageModel class] json:response[@"arr"]];
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
    VENExplorePageTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier forIndexPath:indexPath];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    VENExplorePageModel *model = self.dataArr[indexPath.row];
    [cell.iconImageView sd_setImageWithURL:[NSURL URLWithString:model.headpic]];
    cell.gameNameLabel.text = model.title;
    cell.userNameLabel.text = model.username;
    cell.contentLabel.text = model.value;
    
    if ([model.give_state integerValue] == 1) {
        cell.zanButton.selected = YES;
    } else if ([model.give_state integerValue] == 0) {
        cell.zanButton.selected = NO;
    }
    
    if ([model.collect_state integerValue] == 1) {
        cell.focusButton.selected = YES;
    } else if ([model.collect_state integerValue] == 0) {
        cell.focusButton.selected = NO;
    }
    
    cell.fucosButton.tag = indexPath.row;
    [cell.fucosButton addTarget:self action:@selector(guanzhuButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    
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
    
    // gamePic
    for (UIView *subViews in cell.gameView.subviews) {
        [subViews removeFromSuperview];
    }
    
    for (NSInteger i = 0; i < model.head.count; i++) {
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(i * 12, 0, 21, 21)];
        [imageView sd_setImageWithURL:[NSURL URLWithString:model.head[i][@"portrait"]]];
        imageView.layer.cornerRadius = 21 / 2;
        imageView.layer.masksToBounds = YES;
        [cell.gameView addSubview:imageView];
    }
    
    
    // pic
    for (UIView *subViews in cell.picView.subviews) {
        [subViews removeFromSuperview];
    }
    
    if (model.image.count < 1) {
        cell.picViewlayoutConstraint.constant = 1;
    } else {
        cell.picViewlayoutConstraint.constant = (kMainScreenWidth - 44) / 3;
    }
    
    for (NSInteger i = 0; i < model.image.count; i++) {
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(i * (kMainScreenWidth - 44) / 3 + i * 16, 0, (kMainScreenWidth - 44) / 3, (kMainScreenWidth - 44) / 3)];
        [imageView sd_setImageWithURL:[NSURL URLWithString:model.image[i][@"image"]]];
        imageView.layer.cornerRadius = 6;
        imageView.layer.masksToBounds = YES;
        [cell.picView addSubview:imageView];
    }

    return cell;
}

- (void)guanzhuButtonClick:(UIButton *)button {
    
    VENExplorePageModel *model = self.dataArr[button.tag];
    
    NSDictionary *params = @{@"objectid" :model.userid,
                             @"selfid" : [[NSUserDefaults standardUserDefaults] objectForKey:@"Login"][@"userid"]};
    
    [[VENNetworkTool sharedManager] requestWithMethod:HTTPMethodGet path:@"Recordkernel/gamefollow" params:params showLoading:YES successBlock:^(id response) {
        
    } failureBlock:^(NSError *error) {
        
    }];
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
    NSLog(@"评论");
    
    VENExplorePageModel *model = self.dataArr[button.tag];
    self.block(model);
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
        [[NSNotificationCenter defaultCenter] postNotificationName:@"presentToLoginView" object:nil];
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    VENExplorePageModel *model = self.dataArr[indexPath.row];
    self.block(model);
}

- (void)setupTableView {
    UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, kMainScreenWidth, kMainScreenHeight - statusNavHeight - tabBarHeight - 70) style:UITableViewStylePlain];
    tableView.backgroundColor = UIColorMake(247, 247, 247);
    tableView.delegate = self;
    tableView.dataSource = self;
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    tableView.estimatedRowHeight = 300;
    [tableView registerNib:[UINib nibWithNibName:@"VENExplorePageTableViewCell" bundle:nil] forCellReuseIdentifier:cellIdentifier];
    [self.view addSubview:tableView];
    
    tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{

        NSDictionary *parmas = @{};

        if (![[VENClassEmptyManager sharedManager] isEmptyString:[[NSUserDefaults standardUserDefaults] objectForKey:@"Login"][@"userid"]]) {
            parmas = @{@"gamenid" : self.gamenid,
                       @"userid" : [[NSUserDefaults standardUserDefaults] objectForKey:@"Login"][@"userid"]};
        } else {
            parmas = @{@"gamenid" : self.gamenid};
        }
        
        [self loadDataWith:parmas];
    }];
    
//    tableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
//        
//    }];
    
//    static dispatch_once_t onceToken;
//    dispatch_once(&onceToken, ^{
//        [tableView.mj_header beginRefreshing];
//    });
    
    _tableView = tableView;
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
