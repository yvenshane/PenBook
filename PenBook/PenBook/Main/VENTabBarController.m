//
//  VENTabBarController.m
//  
//  Created by YVEN.
//  Copyright © 2018年 Hefei Haiba Network Technology Co., Ltd. All rights reserved.
//

#import "VENTabBarController.h"
#import "VENNavigationController.h"

@interface VENTabBarController () <UITabBarControllerDelegate>

@end

@implementation VENTabBarController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    UIViewController *vc1 = [self loadChildViewControllerWithClassName:@"VENExplorePageViewController" andTitle:@"探索" andImageName:@"icon_nav03"];
    UIViewController *vc2 = [[UIViewController alloc] init];
    UIViewController *vc3 = [self loadChildViewControllerWithClassName:@"VENMineViewController" andTitle:@"我的" andImageName:@"icon_nav01"];
    
    self.viewControllers = @[vc1, vc2, vc3];
    
    self.tabBar.tintColor = COLOR_THEME;
    //    self.tabBar.barTintColor = [UIColor whiteColor];
    self.tabBar.translucent = NO;

    // 去除 tabBar 黑线
    CGRect rect = CGRectMake(0, 0, kMainScreenWidth, 1);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, [[UIColor clearColor] CGColor]);
    CGContextFillRect(context, rect);
    UIImage *img = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    [self.tabBar setBackgroundImage:img];
    [self.tabBar setShadowImage:img];
    
    // 加号 按钮
    CGRect rect2 = self.tabBar.bounds;
    CGFloat width = rect2.size.width / 3;
    
    UIButton *button = [[UIButton alloc] initWithFrame:CGRectInset(rect2, width, -16)];
    [button setImage:[UIImage imageNamed:@"icon_nav02"] forState:UIControlStateNormal];
    button.imageEdgeInsets = UIEdgeInsetsMake(-16, 0, 0, 0);
    [self.tabBar addSubview:button];
}

- (UIViewController *)loadChildViewControllerWithClassName:(NSString *)className andTitle:(NSString *)title andImageName:(NSString *)imageName {
    
    // 把类名的字符串转成类的类型
    Class class = NSClassFromString(className);
    
    // 通过转换出来的类的类型来创建控制器
    UIViewController *vc = [class new];
    
    // 设置TabBar的文字
    vc.tabBarItem.title = title;
    
    NSString *normalImageName = [imageName stringByAppendingString:@""];
    // 设置默认状态的图片
    vc.tabBarItem.image = [[UIImage imageNamed:normalImageName] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    
    // 拼接选中状态的图片
    NSString *selectedImageName = [imageName stringByAppendingString:@"_active"];
    // 设置选中图片
    vc.tabBarItem.selectedImage = [[UIImage imageNamed:selectedImageName] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    
    // 创建导航控制器
    VENNavigationController *nav = [[VENNavigationController alloc] initWithRootViewController:vc];
    
    return nav;
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
