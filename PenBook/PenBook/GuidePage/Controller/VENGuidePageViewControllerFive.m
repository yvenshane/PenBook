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
#import "VENGuidePageFiveModel.h"

@interface VENGuidePageViewControllerFive () <UITableViewDelegate, UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UIButton *finishButon;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, copy) NSArray *dataArr;

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
    
    [[VENNetworkTool sharedManager] requestWithMethod:HTTPMethodGet path:@"Recordkernel/gamerecommend" params:@{@"typeid" : self.types} showLoading:YES successBlock:^(id response) {
        
        if ([response[@"ret"] integerValue] == 1) {
            NSArray *dataArr = [NSArray yy_modelArrayWithClass:[VENGuidePageFiveModel class] json:response[@"game"]];
            
            self.dataArr = dataArr;
            
            [self.tableView reloadData];
        }
        
    } failureBlock:^(NSError *error) {
        
    }];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    VENMinePagemMyGameTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier forIndexPath:indexPath];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    VENGuidePageFiveModel *model = self.dataArr[indexPath.row];
    
    cell.topLabel.text = model.name;
    [cell.iconImageView sd_setImageWithURL:[NSURL URLWithString:model.image]];
    cell.bottomLabel.text = model.heat;
    cell.starCount = model.star;
    
    cell.rightButton.tag = indexPath.row;
    cell.rightButton.backgroundColor = UIColorFromRGB(0xFBC82E);
    [cell.rightButton setTitle:@"下载" forState:UIControlStateNormal];
    [cell.rightButton addTarget:self action:@selector(rightButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    cell.imageView2.hidden = YES;
    
    return cell;
}

- (void)rightButtonClick:(UIButton *)button {
    VENGuidePageFiveModel *model = self.dataArr[button.tag];
    
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
