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

@end

static NSString *cellIdentifier = @"cellIdentifier";
@implementation VENExplorePageSubviewsController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self setupTableView];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    
    return self.dataArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    VENExplorePageTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier forIndexPath:indexPath];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    VENExplorePageModel *model = self.dataArr[indexPath.row];
    
    cell.gameNameLabel.text = model.title;
    cell.userNameLabel.text = model.username;
    cell.contentLabel.text = model.value;
    
    [cell.zanButton setTitle:[NSString stringWithFormat:@"  %@", model.give] forState:UIControlStateNormal];
    [cell.focusButton setTitle:[NSString stringWithFormat:@"  %@", model.collect] forState:UIControlStateNormal];
    [cell.talkButton setTitle:[NSString stringWithFormat:@"  %@", model.comment] forState:UIControlStateNormal];
    [cell.shareButton setTitle:[NSString stringWithFormat:@"  %@", model.share] forState:UIControlStateNormal];
    
    return cell;
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
