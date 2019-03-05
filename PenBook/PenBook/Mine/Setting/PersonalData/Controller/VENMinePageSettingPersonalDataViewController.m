//
//  VENMinePageSettingPersonalDataViewController.m
//  PenBook
//
//  Created by YVEN on 2019/3/2.
//  Copyright © 2019 Hefei Haiba Network Technology Co., Ltd. All rights reserved.
//

#import "VENMinePageSettingPersonalDataViewController.h"
#import "VENMinePageSettingPersonalDataTableViewCell.h"
#import "VENMinePageSettingPersonalDataModel.h"

#import "LGPhotoPickerViewController.h"
#import "LGPhotoPickerBrowserViewController.h"

@interface VENMinePageSettingPersonalDataViewController () <UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate, LGPhotoPickerViewControllerDelegate>
@property (nonatomic, copy) NSArray *titleNameArr;
@property (nonatomic, strong) VENMinePageSettingPersonalDataModel *model;
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, copy) NSString *dateStr;

@end

static NSString *cellIdentifier = @"cellIdentifier";
@implementation VENMinePageSettingPersonalDataViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.navigationItem.title = @"个人资料";
    
    self.titleNameArr = @[@"头像", @"昵称", @"性别", @"出生年月日", @"个性签名"];
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    formatter.dateFormat = @"yyyy年MM月dd日";
    _dateStr = [formatter stringFromDate:[NSDate date]];
    
    [self loadData];
}

- (void)loadData {
    
    NSDictionary *params = @{@"userid" : [[NSUserDefaults standardUserDefaults] objectForKey:@"Login"][@"userid"]};
    
    [[VENNetworkTool sharedManager] requestWithMethod:HTTPMethodGet path:@"/Recordkernel/usercenter" params:params showLoading:YES successBlock:^(id response) {
        
        if ([response[@"ret"] integerValue] == 1) {
            self.model = [VENMinePageSettingPersonalDataModel yy_modelWithJSON:response];
            [self setupTableView];
        }
        
    } failureBlock:^(NSError *error) {
        
    }];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 5;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    VENMinePageSettingPersonalDataTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier forIndexPath:indexPath];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    cell.leftLabel.text = self.titleNameArr[indexPath.row];
    cell.iconButton.hidden = indexPath.row == 0 ? NO : YES;
    cell.rightTextField.hidden = indexPath.row == 0 ? YES : NO;
    cell.rightTextField.tag = indexPath.row;
    cell.rightTextField.delegate = self;
    
    [cell.iconButton sd_setImageWithURL:[NSURL URLWithString:self.model.headpic] forState:UIControlStateNormal];
    [cell.iconButton addTarget:self action:@selector(iconButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    
    if (indexPath.row == 1) {
        cell.rightTextField.placeholder = @"请输入昵称";
        cell.rightTextField.text = self.model.nickname;
        cell.rightTextField.userInteractionEnabled = YES;
    } else if (indexPath.row == 2) {
        cell.rightTextField.placeholder = @"请选择性别";
        cell.rightTextField.text = self.model.gender;
        cell.rightTextField.userInteractionEnabled = NO;
    } else if (indexPath.row == 3) {
        cell.rightTextField.placeholder = @"请选择出生年月日";
        cell.rightTextField.text = self.model.birthday;
        cell.rightTextField.userInteractionEnabled = YES;
        
        UIDatePicker *datePicker = [[UIDatePicker alloc] init];
        datePicker.datePickerMode = UIDatePickerModeDate;
        //监听DataPicker的滚动
        [datePicker addTarget:self action:@selector(dateChange:) forControlEvents:UIControlEventValueChanged];
        cell.rightTextField.inputView = datePicker;
    } else if (indexPath.row == 4) {
        cell.rightTextField.placeholder = @"请输入个性签名";
        cell.rightTextField.text = self.model.signa;
        cell.rightTextField.userInteractionEnabled = YES;
    }
    
    return cell;
}

- (void)textFieldDidEndEditing:(UITextField *)textField {
    if (textField.tag == 1) {
        NSDictionary *params = @{@"userid": [[NSUserDefaults standardUserDefaults] objectForKey:@"Login"][@"userid"],
                                 @"name": textField.text};
        
        [[VENNetworkTool sharedManager] requestWithMethod:HTTPMethodGet path:@"Recordkernel/userheadnickel" params:params showLoading:YES successBlock:^(id response) {
            
            if ([response[@"ret"] integerValue] == 1) {
                self.model.nickname = textField.text;
                [self.tableView reloadData];
                [[NSNotificationCenter defaultCenter] postNotificationName:@"LoginSuccessfully" object:nil];
            }
            
        } failureBlock:^(NSError *error) {
            
        }];
    } else if (textField.tag == 3) {
        NSDictionary *params = @{@"userid": [[NSUserDefaults standardUserDefaults] objectForKey:@"Login"][@"userid"],
                                 @"birthday": self.dateStr};
        
        [[VENNetworkTool sharedManager] requestWithMethod:HTTPMethodGet path:@"Recordkernel/userheadbirthday" params:params showLoading:YES successBlock:^(id response) {
            
            if ([response[@"ret"] integerValue] == 1) {
                self.model.birthday = self.dateStr;
                [self.tableView reloadData];
                [[NSNotificationCenter defaultCenter] postNotificationName:@"LoginSuccessfully" object:nil];
            }
            
        } failureBlock:^(NSError *error) {
            
        }];
    } else if (textField.tag == 4) {
        NSDictionary *params = @{@"userid": [[NSUserDefaults standardUserDefaults] objectForKey:@"Login"][@"userid"],
                                 @"signa": textField.text};
        
        [[VENNetworkTool sharedManager] requestWithMethod:HTTPMethodGet path:@"Recordkernel/userheadsigna" params:params showLoading:YES successBlock:^(id response) {
            
            if ([response[@"ret"] integerValue] == 1) {
                self.model.signa = textField.text;
                [self.tableView reloadData];
                [[NSNotificationCenter defaultCenter] postNotificationName:@"LoginSuccessfully" object:nil];
            }
            
        } failureBlock:^(NSError *error) {
            
        }];
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 2) {
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"" message:@"请选择性别" preferredStyle:UIAlertControllerStyleActionSheet];
        
        UIAlertAction *firstAction = [UIAlertAction actionWithTitle:@"男" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            [self modifyGenderWithString:@"男"];
        }];
        
        UIAlertAction *secondAction = [UIAlertAction actionWithTitle:@"女" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            [self modifyGenderWithString:@"女"];
        }];
        
        UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
        
        [alert addAction:firstAction];
        [alert addAction:secondAction];
        [alert addAction:cancelAction];
        
        [self presentViewController:alert animated:YES completion:nil];
    } else if (indexPath.row == 3) {

    }
}

- (void)dateChange:(UIDatePicker *)datePicker {
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    formatter.dateFormat = @"yyyy年MM月dd日";
    _dateStr = [formatter stringFromDate:datePicker.date];
}

- (void)modifyGenderWithString:(NSString *)string {
    
    NSDictionary *params = @{@"userid": [[NSUserDefaults standardUserDefaults] objectForKey:@"Login"][@"userid"],
                             @"gender": string};
    
    [[VENNetworkTool sharedManager] requestWithMethod:HTTPMethodGet path:@"Recordkernel/userheadgender" params:params showLoading:YES successBlock:^(id response) {
        
        if ([response[@"ret"] integerValue] == 1) {
            self.model.gender = string;
            [self.tableView reloadData];
            [[NSNotificationCenter defaultCenter] postNotificationName:@"LoginSuccessfully" object:nil];
        }
        
    } failureBlock:^(NSError *error) {
        
    }];
}

- (void)setupTableView {
    UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, kMainScreenWidth, kMainScreenHeight - statusNavHeight) style:UITableViewStylePlain];
    //    tableView.backgroundColor = UIColorMake(247, 247, 247);
    tableView.delegate = self;
    tableView.dataSource = self;
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    tableView.rowHeight = 56;
    [tableView registerNib:[UINib nibWithNibName:@"VENMinePageSettingPersonalDataTableViewCell" bundle:nil] forCellReuseIdentifier:cellIdentifier];
    [self.view addSubview:tableView];
    
    _tableView = tableView;
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (void)iconButtonClick:(UIButton *)button {
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
    
    [self modifyGenderWithImage:assets[0].originImage];
}

/**
 *  初始化相册选择器
 */
- (void)presentPhotoPickerViewControllerWithStyle:(LGShowImageType)style {
    LGPhotoPickerViewController *pickerVc = [[LGPhotoPickerViewController alloc] initWithShowType:style];
    pickerVc.status = PickerViewShowStatusCameraRoll;
    pickerVc.maxCount = 1;   // 最多能选9张图片
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
        
        ZLCamera *canamerPhoto = cameras[0];
        
        [self modifyGenderWithImage:canamerPhoto.photoImage];
    };
    [cameraVC showPickerVc:self];
}

- (void)modifyGenderWithImage:(UIImage *)image {
    NSDictionary *params = @{@"userid" : [[NSUserDefaults standardUserDefaults] objectForKey:@"Login"][@"userid"]};
    
    [[VENNetworkTool sharedManager] uploadImageWithPath:@"Recordkernel/userheadimage" photos:@[image] name: @"imaages" params:params success:^(id response) {
        
        if ([response[@"ret"] integerValue] == 1) {
            
        }
        
    } failure:^(NSError *error) {
        
    }];
}

@end
