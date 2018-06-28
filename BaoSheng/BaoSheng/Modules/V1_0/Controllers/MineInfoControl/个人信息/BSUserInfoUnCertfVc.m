//
//  BSUserInfoUnCertfVc.m
//  BaoSheng
//
//  Created by GML on 2018/4/24.
//  Copyright © 2018年 haozheng. All rights reserved.
//

#import "BSUserInfoUnCertfVc.h"
#import "SKCustomSheetPicker.h"
#import "SKImagePickerManager.h"

@interface BSUserInfoUnCertfVc ()<SKImagePickerManagerDelegate>
@property (weak, nonatomic) IBOutlet UIImageView *headImge_;
@property (weak, nonatomic) IBOutlet UITextField *nameTF_;
@property (weak, nonatomic) IBOutlet UIButton *manBtn_;
@property (weak, nonatomic) IBOutlet UIButton *womanBtn_;
@property (weak, nonatomic) IBOutlet UIButton *birthdayBtn_;
@property (weak, nonatomic) IBOutlet UILabel *birthdaylb_;

@property (nonatomic , strong)SKImagePickerManager *imagePic;
@property (nonatomic , strong)NSString *headUrlNew;
@property (nonatomic , strong)NSData *imageData;

@end

@implementation BSUserInfoUnCertfVc

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = @"个人信息";
    [self setNavRightItemWithTitle:@"保存" titleColor:kappTextColorDrak fontsize:14 selector:@selector(navRinghtItemClick)];
    
    
    self.headImge_.layer.cornerRadius = self.headImge_.f_height/2;
    self.headImge_.layer.masksToBounds = YES;
    UITapGestureRecognizer *headTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(headImageTap:)];
    self.headImge_.userInteractionEnabled = YES;
    [self.headImge_ addGestureRecognizer:headTap];
    
    [self.nameTF_ addTarget:self action:@selector(nameTFDidChange:) forControlEvents:UIControlEventEditingChanged];
    self.imagePic = [[SKImagePickerManager alloc]initWithManagerDelegate:self];
    
    BSBaseUserDto *user = BSContext_shareInstance.currentUser;
    [self.headImge_ sd_setImageWithURL:[NSURL URLWithString:user.headUrl] placeholderImage:[UIImage imageNamed:@"my_head_n"]];
    self.nameTF_.text = user.names;
    if (user.gender.integerValue == 1) {
        self.manBtn_.selected = YES;
    }else if (user.gender.integerValue == 2){
        self.womanBtn_.selected = YES;
    }
    self.birthdaylb_.text = [GmWidget dateFromTimeInterval:[user.birthTime longLongValue]];
    
    
}
#pragma mark - Net
- (void)net_uploadHeadPic:(BOOL)needShow{
    
    NSDictionary *dic = @{@"file" :self.imageData};
    
    BSAction *action = [BSAction instanceMethodPostWithApi:BSApi_uploadHeadPic];
    action.fileDataDic = dic.mutableCopy;
    if (needShow) {
        [STSHUdHelper showLoadingWithLock:YES];
    }
    
    WeakSelf
    [self sk_requestWithAction:action success:^(BSRes *res) {
        StrongSelf
        
        NSLog(@"%@",res);
        NSArray *arr = res.result;
        if (arr.count) {
            NSDictionary *dic    = arr[0];
            NSString     *picUrl =  dic[@"url"];
            self.headUrlNew = picUrl;
        }
        [self net_BSApi_editUser:NO];
        
    } failure:^(BSRes *res) {
        [STSHUdHelper hideLoading];
    }];
    
}
- (void)net_BSApi_editUser:(BOOL)needShow{
    
    NSNumber *gender ;
    if (!self.manBtn_.selected && !self.womanBtn_.selected) {
        gender = @0;
    }else if (self.manBtn_.selected){
        gender = @1;
    }else{
        gender = @2;
    }

    NSMutableDictionary *dic = @{@"headUrl" :self.headUrlNew?:@"",
                                 @"id"     :BSContext_shareInstance.currentUser.Id,
                                 @"names"  :self.nameTF_.text?:@"",
                                 @"gender" :gender
                                 }.mutableCopy;
    
    if (self.birthdaylb_.text.length > 0) {
        NSDateFormatter* dateFormat = [[NSDateFormatter alloc] init];
        [dateFormat setDateFormat:@"yyyy年MM月dd日"];
        NSDate *date =[dateFormat dateFromString:self.birthdaylb_.text];
        [dateFormat setDateFormat:@"yyyy-MM-dd"];
        NSString *dateStr = [dateFormat stringFromDate:date];
        
        [dic setObject:dateStr forKey:@"birthTime"];
    }
    
//    [dic enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
//
//        if ([obj isKindOfClass:[NSString class]]) {
//            if ([obj isEqualToString:@""]) {
//                  [dic removeObjectForKey:key];
//            }
//
//        }
//    }];
    
    BSAction *action = [BSAction instanceMethodPostWithApi:BSApi_editUser];
    action.paramsDic = dic;
    
    if (needShow) {
           [STSHUdHelper showLoadingWithLock:YES];
    }
    WeakSelf
    [self sk_requestWithAction:action success:^(BSRes *res) {
        StrongSelf
        [STSHUdHelper hideLoading];
        
        //修改用户信息
        BSBaseUserDto *user = BSContext_shareInstance.currentUser;
        user.gender = gender;
        user.names = self.nameTF_.text;
        user.birthTime = [GmWidget timeIntervalFromDate:self.birthdaylb_.text];
        //拼接地址
        if (self.headUrlNew.length) {
             user.headUrl = [NSString stringWithFormat:@"%@/%@/%@",BS_HOST_Master,BS_hostapend,self.headUrlNew];
        }
       
        
        [SKUserDefaults_shareInstance storeObject:user forKey:STStore_CurrentUserInfo];
        
        [self sk_postNotificationName:SKNotifyMsg_UserInfoChange object:nil userInfo:nil];
        
        [STSHUdHelper st_toastMsg:@"修改成功" completion:^{
          
            [self.navigationController popViewControllerAnimated:YES];
        }];
        
    }failure:^(BSRes *res) {
        [STSHUdHelper hideLoading];
        
    }];
    
}

#pragma mark - Events

- (IBAction)manBtnClick:(UIButton *)sender {
    sender.selected = YES;
    self.womanBtn_.selected = NO;
}
- (IBAction)womanBtnCLick:(UIButton *)sender {
    sender.selected = YES;
    self.manBtn_.selected = NO;
}
- (IBAction)bitthdayBtnClick:(UIButton *)sender {
    
    WeakSelf
    [SKCustomSheetPicker showDatePickerWithTitle:@"请选择生日" datePickerMode:UIDatePickerModeDate selectedDate:[NSDate date] minimumDate:nil maximumDate:nil doneBlock:^(ActionSheetDatePicker *picker, id selectedDate, id origin) {
        StrongSelf
       self.birthdaylb_.text  = [GmWidget trunStrFormdata:selectedDate];
        
    } cancelBlock:^(ActionSheetDatePicker *picker) {
        
    } origin:self.view];

}
- (void)headImageTap:(UITapGestureRecognizer *)sender{
    
    WeakSelf
    LCActionSheet *sheet0 = [LCActionSheet sheetWithTitle:nil cancelButtonTitle:@"取消" clicked:^(LCActionSheet *actionSheet, NSInteger buttonIndex) {
        StrongSelf
        if (buttonIndex == 1) {
            
            [self.imagePic showSystemPicker];
        }else if(buttonIndex == 2){
            [self.imagePic showCameraPicker];
        }
        
    } otherButtonTitleArray:@[@"从相册选" , @"拍照"]];
    sheet0.buttonColor = kappTextColorDrak;
    sheet0.unBlur = YES;
    [sheet0 show];
    
}
- (void)nameTFDidChange:(UITextField *)sender{
    
    
}
- (void)navRinghtItemClick{
    
   BOOL isempty =  [GmWidget isEmpty:self.nameTF_.text];
    if (isempty) {
        [STSHUdHelper st_toastMsg:@"请输入昵称" completion:nil];
        return;
    }
    if (self.nameTF_.text.length == 0) {
        [STSHUdHelper st_toastMsg:@"请输入昵称" completion:nil];
        return;
    }
    
    if (self.imageData && self.headUrlNew.length == 0) {
        [self net_uploadHeadPic:YES];
    }else{
        [self net_BSApi_editUser:YES];
    }
    
}

#pragma mark - SKImagePickerManagerDelegate
- (void)skImagePickerDidFinishChoseImages:(NSMutableArray *)images{
    
    if (images.count) {
        self.headUrlNew = @"";
        self.headImge_.image = images[0];
        self.imageData = UIImageJPEGRepresentation(images[0], 0.5);
        
    }
   
    
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
