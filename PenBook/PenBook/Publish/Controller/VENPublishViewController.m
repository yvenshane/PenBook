//
//  VENPublishViewController.m
//  PenBook
//
//  Created by YVEN on 2019/1/6.
//  Copyright © 2019年 Hefei Haiba Network Technology Co., Ltd. All rights reserved.
//

#import "VENPublishViewController.h"
#import "VENTagView.h"

@interface VENPublishViewController () <UITextViewDelegate>
@property (nonatomic, strong) UILabel *placeHolderLabel;

@end

@implementation VENPublishViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self setupNavigationBar];
    [self setupTableView];
}

- (void)setupTableView {
    UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, statusNavHeight, kMainScreenWidth, kMainScreenHeight - statusNavHeight) style:UITableViewStylePlain];
    tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    [self.view addSubview:tableView];
    
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kMainScreenWidth, 16 + 83 + 16 + (kMainScreenWidth - 60) / 3 + 40 + 18 + 18 + 300 + 48 + 18 + 18)];
    headerView.backgroundColor = [UIColor whiteColor];
    tableView.tableHeaderView = headerView;
    
    // textView
    UITextView *contentTextView = [[UITextView alloc] initWithFrame:CGRectMake(30, 16, kMainScreenWidth - 60, 83)];
    contentTextView.backgroundColor = [UIColor whiteColor];
    contentTextView.font = [UIFont systemFontOfSize:14.0f];
    contentTextView.delegate = self;
    [contentTextView becomeFirstResponder];
    [headerView addSubview:contentTextView];
    
    UILabel *placeHolderLabel = [[UILabel alloc] initWithFrame:CGRectMake(5, 6, kMainScreenWidth, 20)];
    placeHolderLabel.text = @"说一下你这一刻的想法... ...";
    placeHolderLabel.font = [UIFont systemFontOfSize:14.0f];
    placeHolderLabel.textColor = [UIColor lightGrayColor];
    [contentTextView addSubview:placeHolderLabel];
    
    // 添加图片
    UIView *addImageView = [[UIView alloc] initWithFrame:CGRectMake(30, 16 + 83 + 16, kMainScreenWidth - 60, (kMainScreenWidth - 60) / 3)];
    addImageView.backgroundColor = [UIColor redColor];
    [headerView addSubview:addImageView];
    
    // 游戏标签
    UILabel *tagLabel = [[UILabel alloc] initWithFrame:CGRectMake(30, 16 + 83 + 16 + (kMainScreenWidth - 60) / 3 + 40, kMainScreenWidth - 60, 18)];
    tagLabel.text = @"游戏标签*";
    tagLabel.font = [UIFont systemFontOfSize:13.0f];
    [headerView addSubview:tagLabel];
    
    NSMutableArray *tagMuArr = [NSMutableArray array];
    [tagMuArr removeAllObjects];
    
//    for (NSInteger i = 0; i <self.dataArr.count; i++) {
//        [tagMuArr addObject:response[@"game"][i][@"game"]];
//    }
    
    VENTagView *tagView = [[VENTagView alloc] initWithFrame:CGRectMake(30, 16 + 83 + 16 + (kMainScreenWidth - 60) / 3 + 40 + 18 + 18, kMainScreenWidth - 60, 300) tagArray:@[@"王者者耀", @"王耀", @"王者者耀", @"王者", @"王荣耀", @"王者荣耀", @"者耀", @"王者荣耀", @"王者", @"耀", @"王者荣耀", @"王荣耀", @"王耀"].copy];
    tagView.textColorSelected = [UIColor whiteColor];
    tagView.textColorNormal = UIColorFromRGB(0xA3A3A3);
    tagView.backgroundColorSelected = UIColorFromRGB(0xFBC82E);
    tagView.backgroundColorNormal = [UIColor whiteColor];
    [headerView addSubview:tagView];
    
    // 发布
    UIButton *publishButton = [[UIButton alloc] initWithFrame:CGRectMake((kMainScreenWidth - 202) / 2, 16 + 83 + 16 + (kMainScreenWidth - 60) / 3 + 40 + 18 + 18 + 18 + 300, 202, 48)];
    publishButton.backgroundColor = UIColorFromRGB(0x5061FB);
    [publishButton setTitle:@"发布" forState: UIControlStateNormal];
    [publishButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    publishButton.layer.cornerRadius = 24.0f;
    publishButton.layer.masksToBounds = YES;
    [headerView addSubview:publishButton];
    
    _placeHolderLabel = placeHolderLabel;
}

- (void)setupNavigationBar {
    UIView *navigationBar = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kMainScreenWidth, statusNavHeight)];
//    navigationBar.backgroundColor = [UIColor redColor];
    [self.view addSubview:navigationBar];
    
    UIButton *backButton = [[UIButton alloc] initWithFrame:CGRectMake(0, Height_StatusBar, 44, 44)];
    [backButton setImage:[UIImage imageNamed:@"icon_back"] forState:UIControlStateNormal];
    [backButton addTarget:self action:@selector(backButonClick) forControlEvents:UIControlEventTouchUpInside];
    [navigationBar addSubview:backButton];
}

- (void)textViewDidChange:(UITextView *)textView {
    self.placeHolderLabel.hidden = textView.text.length == 0 ? NO : YES;
}

- (void)backButonClick {
    
    [self dismissViewControllerAnimated:YES completion:nil];
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
