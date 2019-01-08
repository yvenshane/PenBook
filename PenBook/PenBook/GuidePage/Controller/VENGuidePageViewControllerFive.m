//
//  VENGuidePageViewControllerFive.m
//  PenBook
//
//  Created by YVEN on 2019/1/8.
//  Copyright © 2019年 Hefei Haiba Network Technology Co., Ltd. All rights reserved.
//

#import "VENGuidePageViewControllerFive.h"

@interface VENGuidePageViewControllerFive ()
@property (weak, nonatomic) IBOutlet UIButton *finishButon;

@end

@implementation VENGuidePageViewControllerFive

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (IBAction)finishButtonClick:(id)sender {
    
    [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"first"];
    
    [self.navigationController popToRootViewControllerAnimated:YES];
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
