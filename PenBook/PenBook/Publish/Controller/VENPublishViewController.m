//
//  VENPublishViewController.m
//  PenBook
//
//  Created by YVEN on 2019/1/6.
//  Copyright © 2019年 Hefei Haiba Network Technology Co., Ltd. All rights reserved.
//

#import "VENPublishViewController.h"
#import "VENTagView.h"

#import "LGPhotoPickerViewController.h"
#import "LGPhotoPickerBrowserViewController.h"

@interface VENPublishViewController () <UITextViewDelegate, LGPhotoPickerViewControllerDelegate>
@property (nonatomic, strong) UITextView *contentTextView;
@property (nonatomic, strong) UILabel *placeHolderLabel;
@property (nonatomic, strong) NSMutableArray *gameIDs;

@property (nonatomic, strong) NSMutableArray *pickImageMuArr;
@property (nonatomic, strong) UIView *addImageView;

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
    addImageView.backgroundColor = [UIColor whiteColor];
    [headerView addSubview:addImageView];
    
    UIButton *addButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, (kMainScreenWidth - 60 - 8) / 3, (kMainScreenWidth - 60 - 8) / 3)];
    addButton.backgroundColor = UIColorFromRGB(0xF1F1F1);
    [addButton setImage:[UIImage imageNamed:@"icon_add"] forState:UIControlStateNormal];
    [addButton addTarget:self action:@selector(addButtonClick) forControlEvents:UIControlEventTouchUpInside];
    [addImageView addSubview:addButton];
    
    // 游戏标签
    UILabel *tagLabel = [[UILabel alloc] initWithFrame:CGRectMake(30, 16 + 83 + 16 + (kMainScreenWidth - 60) / 3 + 40, kMainScreenWidth - 60, 18)];
    tagLabel.text = @"游戏标签*";
    tagLabel.font = [UIFont systemFontOfSize:13.0f];
    [headerView addSubview:tagLabel];
    
    NSMutableArray *tagMuArr = [NSMutableArray array];
    [tagMuArr removeAllObjects];
    
    NSMutableArray *nameMuArr = [NSMutableArray array];
    for (NSDictionary *dict in [[NSUserDefaults standardUserDefaults] objectForKey:@"head"]) {
        [nameMuArr addObject:dict[@"game"]];
    }
    
    VENTagView *tagView = [[VENTagView alloc] initWithFrame:CGRectMake(15, 16 + 83 + 16 + (kMainScreenWidth - 60) / 3 + 40 + 18 + 18, kMainScreenWidth - 30, 300) tagArray:nameMuArr];
    tagView.buttonHeight = 29.0;
    tagView.textColorSelected = [UIColor whiteColor];
    tagView.textColorNormal = UIColorFromRGB(0xA3A3A3);
    tagView.backgroundColorSelected = UIColorFromRGB(0xFBC82E);
    tagView.backgroundColorNormal = [UIColor whiteColor];
    for (UIButton *button in tagView.buttonsMuArr) {
        [button addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    [headerView addSubview:tagView];
    
    // 发布
    UIButton *publishButton = [[UIButton alloc] initWithFrame:CGRectMake((kMainScreenWidth - 202) / 2, 16 + 83 + 16 + (kMainScreenWidth - 60) / 3 + 40 + 18 + 18 + 18 + 300, 202, 48)];
    publishButton.backgroundColor = UIColorFromRGB(0x5061FB);
    [publishButton setTitle:@"发布" forState: UIControlStateNormal];
    [publishButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    publishButton.layer.cornerRadius = 24.0f;
    publishButton.layer.masksToBounds = YES;
    [publishButton addTarget:self action:@selector(publishButtonClick) forControlEvents:UIControlEventTouchUpInside];
    [headerView addSubview:publishButton];
    
    _placeHolderLabel = placeHolderLabel;
    _contentTextView = contentTextView;
    _addImageView = addImageView;
}

- (void)addButtonClick {
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    
    UIAlertAction *appropriateAction = [UIAlertAction actionWithTitle:@"拍摄" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self presentCameraSingle];
    }];
    UIAlertAction *undeterminedAction = [UIAlertAction actionWithTitle:@"从手机相册选择" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
        [self presentPhotoPickerViewControllerWithStyle:LGShowImageTypeImagePicker];
    }];
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        
    }];
    
    [alert addAction:appropriateAction];
    [alert addAction:undeterminedAction];
    [alert addAction:cancelAction];
    
    [self presentViewController:alert animated:YES completion:nil];
}

- (void)buttonClick:(UIButton *)button {
    button.selected = !button.selected;
    
    if (button.selected == YES) {
        button.layer.borderColor = [UIColor whiteColor].CGColor;
        [self.gameIDs addObject:[[NSUserDefaults standardUserDefaults] objectForKey:@"head"][button.tag][@"id"]];
    } else if (button.selected == NO) {
        button.layer.borderColor = [UIColor lightGrayColor].CGColor;
        [self.gameIDs removeObject:[[NSUserDefaults standardUserDefaults] objectForKey:@"head"][button.tag][@"id"]];
    }
}

- (void)publishButtonClick {
    
    if ([[VENClassEmptyManager sharedManager] isEmptyString:self.contentTextView.text]) {
        [[VENMBProgressHUDManager sharedManager] showText:@"说一下你这一刻的想法"];
        return;
    }
    
    if ([[VENClassEmptyManager sharedManager] isEmptyArray:self.pickImageMuArr]) {
        [[VENMBProgressHUDManager sharedManager] showText:@"请选择图片"];
        return;
    }
    
    if ([[VENClassEmptyManager sharedManager] isEmptyArray:self.gameIDs]) {
        [[VENMBProgressHUDManager sharedManager] showText:@"请选择游戏标签"];
        return;
    }
    
    NSDictionary *params = @{@"userid" : [[NSUserDefaults standardUserDefaults] objectForKey:@"Login"][@"userid"],
                             @"gameid" : [self.gameIDs componentsJoinedByString:@","],
                             @"cent" : self.contentTextView.text};
    
    [[VENNetworkTool sharedManager] uploadImageWithPath:@"Recordtext/gametext" photos:self.pickImageMuArr name:@"images" params:params success:^(id response) {
        
        if ([response[@"ret"] integerValue] == 1) {
            [self dismissViewControllerAnimated:YES completion:nil];
        }
        
    } failure:^(NSError *error) {
        
    }];

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

- (NSMutableArray *)gameIDs {
    if (_gameIDs == nil) {
        _gameIDs = [NSMutableArray array];
    }
    return _gameIDs;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - LGPhotoPickerViewControllerDelegate

- (void)pickerViewControllerDoneAsstes:(NSArray <LGPhotoAssets *> *)assets isOriginal:(BOOL)original{
    /*
     //assets的元素是LGPhotoAssets对象，获取image方法如下:
     NSMutableArray *thumbImageArray = [NSMutableArray array];
     NSMutableArray *originImage = [NSMutableArray array];
     NSMutableArray *fullResolutionImage = [NSMutableArray array];
     
     for (LGPhotoAssets *photo in assets) {
     //缩略图
     [thumbImageArray addObject:photo.thumbImage];
     //原图
     [originImage addObject:photo.originImage];
     //全屏图
     [fullResolutionImage addObject:fullResolutionImage];
     }
     */
    
    [self.pickImageMuArr removeAllObjects];
    
    for (LGPhotoAssets *photo in assets) {
        [self.pickImageMuArr addObject:photo.originImage];
    }
    
    [self setupAddImageView];
}

/**
 *  初始化相册选择器
 */
- (void)presentPhotoPickerViewControllerWithStyle:(LGShowImageType)style {
    LGPhotoPickerViewController *pickerVc = [[LGPhotoPickerViewController alloc] initWithShowType:style];
    pickerVc.status = PickerViewShowStatusCameraRoll;
    pickerVc.maxCount = 3;   // 最多能选9张图片
    pickerVc.delegate = self;
    //    pickerVc.nightMode = YES;//夜间模式
    //    self.showType = style;
    [pickerVc showPickerVc:self];
}

/**
 *  初始化自定义相机（单拍）
 */
- (void)presentCameraSingle {
    ZLCameraViewController *cameraVC = [[ZLCameraViewController alloc] init];
    // 拍照最多个数
    cameraVC.maxCount = 1;
    // 单拍
    cameraVC.cameraType = ZLCameraSingle;
    cameraVC.callback = ^(NSArray *cameras){
        //在这里得到拍照结果
        //数组元素是ZLCamera对象
        /*
         @exemple
         ZLCamera *canamerPhoto = cameras[0];
         UIImage *image = canamerPhoto.photoImage;
         */
        
        [self.pickImageMuArr removeAllObjects];
        
        ZLCamera *canamerPhoto = cameras[0];
        [self.pickImageMuArr addObject:canamerPhoto.photoImage];
    };
    [cameraVC showPickerVc:self];
}

- (void)setupAddImageView {
    
    NSLog(@"pickImageMuArr - %@", self.pickImageMuArr);
    
    for (UIView *subviews in self.addImageView.subviews) {
        [subviews removeFromSuperview];
    }
    
    for (NSInteger i = 0; i < self.pickImageMuArr.count; i++) {
        UIButton *addButton = [[UIButton alloc] initWithFrame:CGRectMake(i * (kMainScreenWidth - 60 - 8) / 3 + i * 4, 0, (kMainScreenWidth - 60 - 8) / 3, (kMainScreenWidth - 60 - 8) / 3)];
        [addButton setImage:self.pickImageMuArr[i] forState:UIControlStateNormal];
        [self.addImageView addSubview:addButton];
    }
    
    UIButton *addButton = [[UIButton alloc] init];
    addButton.backgroundColor = UIColorFromRGB(0xF1F1F1);
    [addButton setImage:[UIImage imageNamed:@"icon_add"] forState:UIControlStateNormal];
    [addButton addTarget:self action:@selector(addButtonClick) forControlEvents:UIControlEventTouchUpInside];
    [self.addImageView addSubview:addButton];
    
    if (self.pickImageMuArr.count == 1) {
        addButton.frame = CGRectMake((kMainScreenWidth - 60 - 8) / 3 + 4, 0, (kMainScreenWidth - 60 - 8) / 3, (kMainScreenWidth - 60 - 8) / 3);
    } else if (self.pickImageMuArr.count == 2) {
        addButton.frame = CGRectMake(2 * (kMainScreenWidth - 60 - 8) / 3 + 8, 0, (kMainScreenWidth - 60 - 8) / 3, (kMainScreenWidth - 60 - 8) / 3);
    } else {
        [addButton removeFromSuperview];
    }
}

- (NSMutableArray *)pickImageMuArr {
    if (_pickImageMuArr == nil) {
        _pickImageMuArr = [NSMutableArray array];
    }
    return _pickImageMuArr;
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
