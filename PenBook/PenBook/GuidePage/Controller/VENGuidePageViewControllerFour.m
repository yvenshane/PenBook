//
//  VENGuidePageViewControllerFour.m
//  PenBook
//
//  Created by YVEN on 2019/1/8.
//  Copyright © 2019年 Hefei Haiba Network Technology Co., Ltd. All rights reserved.
//

#import "VENGuidePageViewControllerFour.h"
#import "VENGuidePageViewControllerFive.h"

@interface VENGuidePageViewControllerFour ()
@property (weak, nonatomic) IBOutlet UIButton *nextButton;

@end

@implementation VENGuidePageViewControllerFour

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (IBAction)nextButtonClick:(id)sender {
    VENGuidePageViewControllerFive *vc = [[VENGuidePageViewControllerFive alloc] init];
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
