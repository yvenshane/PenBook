//
//  VENGuidePageViewControllerOne.m
//  PenBook
//
//  Created by YVEN on 2019/1/7.
//  Copyright © 2019年 Hefei Haiba Network Technology Co., Ltd. All rights reserved.
//

#import "VENGuidePageViewControllerOne.h"
#import "VENGuidePageViewControllerTwo.h"

@interface VENGuidePageViewControllerOne ()
@property (weak, nonatomic) IBOutlet UIImageView *backgroundImageView;
@property (weak, nonatomic) IBOutlet UIButton *nextButton;

@end

@implementation VENGuidePageViewControllerOne

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self.navigationController setNavigationBarHidden:YES animated:animated];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    [self.navigationController setNavigationBarHidden:NO animated:animated];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    
    self.nextButton.layer.cornerRadius = 24.0f;
    self.nextButton.layer.masksToBounds = YES;
}

- (IBAction)nextButtonClick:(id)sender {    
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
