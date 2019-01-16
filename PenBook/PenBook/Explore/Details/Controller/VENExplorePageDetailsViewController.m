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

@interface VENExplorePageDetailsViewController () <UITableViewDelegate, UITableViewDataSource>
//@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, copy) NSArray *dataArr;

@end

static NSString *cellIdentifier = @"cellIdentifier";
static NSString *cellIdentifier2 = @"cellIdentifier2";
static NSString *cellIdentifier3 = @"cellIdentifier3";
@implementation VENExplorePageDetailsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    
    [self setupTableView];
    
    
//    if (![[VENClassEmptyManager sharedManager] isEmptyString:[[NSUserDefaults standardUserDefaults] objectForKey:@"Login"][@"userid"]]) {
//        parmas = @{@"gamenid" : self.gamenid,
//                   @"userid" : [[NSUserDefaults standardUserDefaults] objectForKey:@"Login"][@"userid"]};
//    } else {
//        parmas = @{@"gamenid" : self.gamenid};
//    }
//
//    [self loadDataWith:parmas];
}

- (void)loadDataWith:(NSDictionary *)params {
    [[VENNetworkTool sharedManager] requestWithMethod:HTTPMethodGet path:@"Recordkernel/gamearticle" params:params showLoading:NO successBlock:^(id response) {

        if ([response[@"ret"] integerValue] == 1) {
            NSArray *dataArr = [NSArray yy_modelArrayWithClass:[VENExplorePageModel class] json:response[@"arr"]];
            self.dataArr = dataArr;
            
            
        }
        
    } failureBlock:^(NSError *error) {
        
    }];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 4;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.row == 0) {
        VENExplorePageDetailsTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier forIndexPath:indexPath];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        return cell;
    } else if (indexPath.row == 1) {
        VENExplorePageDetailsTableViewCellTwo *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier2 forIndexPath:indexPath];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        return cell;
    } else {
        VENExplorePageDetailsTableViewCellThree *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier3 forIndexPath:indexPath];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        return cell;
    }
    
    
//    cell.gameNameLabel.hidden = YES;
//
//    VENExplorePageModel *model = self.dataArr[indexPath.row];
//    [cell.iconImageView sd_setImageWithURL:[NSURL URLWithString:model.headpic]];
//    cell.userNameLabel.text = model.username;
//    cell.contentLabel.text = model.value;
//
//    if ([model.give_state integerValue] == 1) {
//        cell.zanButton.selected = YES;
//    } else if ([model.give_state integerValue] == 0) {
//        cell.zanButton.selected = NO;
//    }
//
//    if ([model.collect_state integerValue] == 1) {
//        cell.focusButton.selected = YES;
//    } else if ([model.give_state integerValue] == 0) {
//        cell.focusButton.selected = NO;
//    }
//
//    [cell.zanButton setTitle:[NSString stringWithFormat:@"  %@", model.give] forState:UIControlStateNormal];
//    [cell.focusButton setTitle:[NSString stringWithFormat:@"  %@", model.collect] forState:UIControlStateNormal];
//    [cell.talkButton setTitle:[NSString stringWithFormat:@"  %@", model.comment] forState:UIControlStateNormal];
//    [cell.shareButton setTitle:[NSString stringWithFormat:@"  %@", model.share] forState:UIControlStateNormal];
//
//    // gamePic
//    for (UIView *subViews in cell.gameView.subviews) {
//        [subViews removeFromSuperview];
//    }
//
//    for (NSInteger i = 0; i < model.head.count; i++) {
//        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(i * 12, 0, 21, 21)];
//        [imageView sd_setImageWithURL:[NSURL URLWithString:model.head[i][@"portrait"]]];
//        imageView.layer.cornerRadius = 21 / 2;
//        imageView.layer.masksToBounds = YES;
//        [cell.gameView addSubview:imageView];
//    }
//
//
//    // pic
//    for (UIView *subViews in cell.picView.subviews) {
//        [subViews removeFromSuperview];
//    }
//
//    for (NSInteger i = 0; i < model.image.count; i++) {
//        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(i * (kMainScreenWidth - 44) / 3 + i * 16, 0, (kMainScreenWidth - 44) / 3, (kMainScreenWidth - 44) / 3)];
//        [imageView sd_setImageWithURL:[NSURL URLWithString:model.image[i][@"image"]]];
//        imageView.layer.cornerRadius = 6;
//        imageView.layer.masksToBounds = YES;
//        [cell.picView addSubview:imageView];
//    }
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
