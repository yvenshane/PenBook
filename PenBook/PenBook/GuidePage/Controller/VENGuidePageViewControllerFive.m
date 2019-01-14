//
//  VENGuidePageViewControllerFive.m
//  PenBook
//
//  Created by YVEN on 2019/1/8.
//  Copyright © 2019年 Hefei Haiba Network Technology Co., Ltd. All rights reserved.
//

#import "VENGuidePageViewControllerFive.h"
#import "VENGuidePageViewControllerOne.h"
#import "VENMinePagemMyGameTableViewCell.h"

@interface VENGuidePageViewControllerFive () <UITableViewDelegate, UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UIButton *finishButon;
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end

static NSString *cellIdentifier = @"cellIdentifier";
@implementation VENGuidePageViewControllerFive

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.finishButon.layer.cornerRadius = 24.0f;
    self.finishButon.layer.masksToBounds = YES;
    
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.tableView registerNib:[UINib nibWithNibName:@"VENMinePagemMyGameTableViewCell" bundle:nil] forCellReuseIdentifier:cellIdentifier];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 7;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    VENMinePagemMyGameTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier forIndexPath:indexPath];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    
    
    cell.starCount = [NSString stringWithFormat:@"%u", arc4random_uniform(5) + 1];
    
    
    
    cell.imageView2.hidden = YES;
    cell.rightButton.backgroundColor = UIColorFromRGB(0xFBC82E);
    [cell.rightButton setTitle:@"下载" forState:UIControlStateNormal];
    
    cell.iconImageView.backgroundColor = [UIColor colorWithRed:arc4random_uniform(255)/255.0 green:arc4random_uniform(255)/255.0 blue:arc4random_uniform(255)/255.0 alpha:1];
    
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 82;
}

- (IBAction)finishButtonClick:(id)sender {
    
    VENGuidePageViewControllerOne *vc = [[VENGuidePageViewControllerOne alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
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
