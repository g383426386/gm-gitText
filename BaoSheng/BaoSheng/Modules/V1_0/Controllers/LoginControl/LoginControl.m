//
//  LoginControl.m
//  BaoSheng
//
//  Created by GML on 2018/4/23.
//  Copyright © 2018年 haozheng. All rights reserved.
//

#import "LoginControl.h"
#import "AppDelegate.h"

@interface LoginControl ()<UITextFieldDelegate>

@property (nonatomic , strong)UITextField *phoneTF;
@property (nonatomic , strong)UITextField *PassWorldTF;
@property (nonatomic , strong)UITextField *checkNumTF;

@property (nonatomic , strong)UIView *bottomView;//注册部分

@property (nonatomic , strong)BSGlobalButton *globalCheckNumBtn;

@end

@implementation LoginControl

- (void)viewDidLoad {
    [super viewDidLoad];
    
    if (self.loginStle == LoginVc_Style_Login) {
         self.navigationItem.title = @"登录";
    }else if (self.loginStle == LoginVc_Style_Regis){
        self.navigationItem.title = @"注册";
    }else if (self.loginStle == LoginVc_Style_ForgetPW){
        self.navigationItem.title = @"找回密码";
    }
    
    
    [self buildUI];
    if (self.loginStle == LoginVc_Style_Login) {
        NSString *phone = [SKUserDefaults_shareInstance storedObjectForKey:STStore_RemenberAccount];
        self.phoneTF.text = phone ?:@"";
    }
    
}
#pragma mark - Net
- (void)net_BSApi_login{
    
    NSString *phoneBase64 = [[GmWidget shareInstance]gm_encode64:self.phoneTF.text];
    NSString *passWmd5 = [[GmWidget shareInstance]gm_getMD5_32Bit_String:self.PassWorldTF.text];
    
    NSDictionary *dic = @{@"phone"    :phoneBase64,
                          @"password" :passWmd5
                          };
    
    BSAction *action = [BSAction instanceMethodPostWithApi:BSApi_login];
    action.paramsDic =dic.mutableCopy;
    
    [STSHUdHelper showLoadingWithLock:YES];
    WeakSelf
    [self sk_requestWithAction:action success:^(BSRes *res) {
        StrongSelf
        [STSHUdHelper hideLoading];
       
        BSBaseUserDto *userDto = [BSBaseUserDto mj_objectWithKeyValues:res.result];
        userDto.isLogin = @1;
        BSContext_shareInstance.currentUser = userDto;
        //存储用户信息
        BOOL succec =  [SKUserDefaults_shareInstance storeObject:userDto forKey:STStore_CurrentUserInfo];
        NSLog(@"userInfo----存储成功 - %d",succec);
        //登陆通知
        [self sk_postNotificationName:SKNotifyMsg_LoginIn object:nil userInfo:nil];
        [RCIMHelper_shareInstance LoginIM];
        
        [STSHUdHelper st_toastMsg:@"登陆成功" completion:^{
            [self.navigationController popViewControllerAnimated:YES];
            
            [AppDelegate sharedAppDelegate].rootTabBar = [[RootTabarControl alloc]initWithOpenConversation:YES];
            [AppDelegate sharedAppDelegate].rootTabBar.openConverSation = YES;
            [AppDelegate sharedAppDelegate].window.rootViewController = [AppDelegate sharedAppDelegate].rootTabBar;
        }];
        
    } failure:^(BSRes *res) {
        
        [STSHUdHelper hideLoading];
        
    }];
    
}
//验证码
- (void)net_BSApi_getVerifyCodeSuc:(void(^)(void))Suc faild:(void(^)(void))feild{
    
     NSString *phoneBase64 = [[GmWidget shareInstance]gm_encode64:self.phoneTF.text];
    
    NSDictionary *dic = @{@"phone" :phoneBase64,
                          @"type"  :@(self.loginStle)
                          };
    BSAction *action = [BSAction instanceMethodPostWithApi:BSApi_getVerifyCode];
    action.paramsDic = dic.mutableCopy;
    WeakSelf
    [self sk_requestWithAction:action success:^(BSRes *res) {
        StrongSelf
        if (Suc) {
            Suc();
        }
        [STSHUdHelper st_toastMsg:[NSString stringWithFormat:@"验证码已发送至%@",self.phoneTF.text] completion:nil];
        
    } failure:^(BSRes *res) {
        if (feild) {
            feild();
        }
    }];
    
}
//注册
- (void)net_BSApi_register{
    
    NSString *phoneBase64 = [[GmWidget shareInstance]gm_encode64:self.phoneTF.text];
    NSString *passWmd5 = [[GmWidget shareInstance]gm_getMD5_32Bit_String:self.PassWorldTF.text];
    
    NSDictionary *dic = @{@"verifyCode" :self.checkNumTF.text,
                          @"password"   :passWmd5,
                          @"phone"      :phoneBase64
                          };
    BSAction *action = [BSAction instanceMethodPostWithApi:BSApi_register];
    action.paramsDic = dic.mutableCopy;
    
    [STSHUdHelper showLoadingWithLock:YES];
    WeakSelf
    [self sk_requestWithAction:action success:^(BSRes *res) {
        StrongSelf
        [STSHUdHelper hideLoading];
        [STSHUdHelper st_toastMsg:[NSString stringWithFormat:@"注册成功"] completion:^(void){
            [self.navigationController popViewControllerAnimated:YES];
        }];
        
    } failure:^(BSRes *res) {
        [STSHUdHelper hideLoading];
    }];
}
//修改密码
- (void)net_BSApi_updatePassword{
    
    NSString *phoneBase64 = [[GmWidget shareInstance]gm_encode64:self.phoneTF.text];
    NSString *passWmd5 = [[GmWidget shareInstance]gm_getMD5_32Bit_String:self.PassWorldTF.text];
    
    NSDictionary *dic = @{@"phone" :phoneBase64,
                          @"password" :passWmd5,
                          @"verifyCode" :self.checkNumTF.text
                          };
    BSAction *action = [BSAction instanceMethodPostWithApi:BSApi_updatePassword];
    action.paramsDic = dic.mutableCopy;
    
     [STSHUdHelper showLoadingWithLock:YES];
    WeakSelf
    [self sk_requestWithAction:action success:^(BSRes *res) {
        StrongSelf
        [STSHUdHelper hideLoading];
        [STSHUdHelper st_toastMsg:[NSString stringWithFormat:@"修改密码成功"] completion:^(void){
            [self.navigationController popViewControllerAnimated:YES];
        }];
        
    } failure:^(BSRes *res) {
         [STSHUdHelper hideLoading];
    }];
    
}

#pragma mark - UI
- (void)buildUI{
    
    UIImageView *logoView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"logo"]];
    [self.view addSubview:logoView];
    logoView.f_centerX = kSCREEN_WIDTH/2;
    logoView.f_top = 40.f ;
    
    UIView *phoneView =  [self buildCommonInputViewWithImage:[UIImage imageNamed:@"phone"] placeholder:@"请输入手机号" keybordType:UIKeyboardTypeNumberPad needSecure:NO textFeildTag:TextField_EM_Phone];
    
    [self.view addSubview:phoneView];
    
    phoneView.f_centerX = kSCREEN_WIDTH/2;
    phoneView.top = logoView.f_bottom + 59;
    
    UIView *passworld = [self buildCommonInputViewWithImage:[UIImage imageNamed:@"password"] placeholder:@"请输入密码" keybordType:UIKeyboardTypeDefault needSecure:YES textFeildTag:TextField_EM_PassW];
    [self.view addSubview:passworld];
    
    passworld.f_top = phoneView.f_bottom + 20;
    passworld.f_left = phoneView.f_left;
    
    BSGlobalButton *loginBtn = [BSGlobalButton buttonWithButtonSize:CGSizeMake(kSCREEN_WIDTH - 88, 44) coner:22 title:@"登  录" titleFont:18 backgroundColor:kappButtonBackgroundColor globalButtonStyle:GlobalButtonStyle_Conerhaf];
    [self.view addSubview:loginBtn];
    
    
    loginBtn.f_centerX = kSCREEN_WIDTH/2;
    loginBtn.f_top = passworld.f_bottom + 34;
    
    //注册部分
    _bottomView = [UIView new];
    [self.view addSubview:_bottomView];
    _bottomView.f_width = 100;
    _bottomView.f_height = 20;
    
    UIButton *regisBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [_bottomView addSubview:regisBtn];
    [regisBtn setTitle:@"点击注册" forState:UIControlStateNormal];
    [regisBtn setTitleColor:kappButtonBackgroundColor forState:UIControlStateNormal];
    regisBtn.titleLabel.font = FONTSize(13);
    [regisBtn sizeToFit];
    regisBtn.f_left = 0;
    regisBtn.f_top = 0;
    
    UIView *Vline = [UIView new];
    [_bottomView addSubview:Vline];
    Vline.f_width = 1.f;
    Vline.f_height = 11.f;
    Vline.backgroundColor = rgb(153, 153, 153);
    Vline.f_left = regisBtn.f_right + 10;
    Vline.f_centerY = regisBtn.f_centerY;
    
    UIButton *forgetPWBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [_bottomView addSubview:forgetPWBtn];
    [forgetPWBtn setTitle:@"忘记密码？" forState:UIControlStateNormal];
    [forgetPWBtn setTitleColor:rgb(153, 153, 153) forState:UIControlStateNormal];
    forgetPWBtn.titleLabel.font = FONTSize(13);
    [forgetPWBtn sizeToFit];
    forgetPWBtn.f_left = Vline.f_right+ 10;
    forgetPWBtn.f_top  = regisBtn.f_top;
    
    [regisBtn addTarget:self action:@selector(regisBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [forgetPWBtn addTarget:self action:@selector(forgetPWBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    
    _bottomView.f_width  = forgetPWBtn.f_right;
    _bottomView.f_height = forgetPWBtn.f_bottom;
    
    _bottomView.f_centerX = kSCREEN_WIDTH/2;
    _bottomView.f_top = loginBtn.f_bottom + 20;
    
    if (self.loginStle == LoginVc_Style_Regis || self.loginStle == LoginVc_Style_ForgetPW) {
        self.bottomView.hidden = YES;
        
        UIView *checkNumView = [self buildCommonInputViewWithImage:[UIImage imageNamed:@"code"] placeholder:@"请输入验证码" keybordType:UIKeyboardTypeNumberPad needSecure:NO textFeildTag:TextField_EM_CheckNum];
        
        [self.view addSubview:checkNumView];
        checkNumView.f_left = passworld.f_left;
        checkNumView.f_top = passworld.f_bottom + 20;
        
        BSGlobalButton *checkNum = [BSGlobalButton buttonWithButtonSize:CGSizeMake(45, 20) coner:10 title:@"获取" titleFont:13 backgroundColor:kappButtonBackgroundColor globalButtonStyle:GlobalButtonStyle_Conerhaf];
        [checkNumView addSubview:checkNum];
        
        checkNum.f_right = checkNumView.f_right - checkNum.f_width;
        checkNum.f_top = 0;
        [checkNum addTarget:self action:@selector(checkNumBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        
        self.globalCheckNumBtn = checkNum;
        loginBtn.f_top = checkNumView.f_bottom + 34;
        
        if (self.loginStle ==LoginVc_Style_Regis ) {
             [loginBtn setTitle:@"注  册" forState:UIControlStateNormal];
        }else if (self.loginStle == LoginVc_Style_ForgetPW){
            
            self.PassWorldTF.placeholder = @"请输入新密码";
            [loginBtn setTitle:@"确  认" forState:UIControlStateNormal];
        }
    }
    
    [loginBtn addTarget:self action:@selector(LoginBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    
}
#pragma mark - Btn Click
- (void)LoginBtnClick:(UIButton *)sender{
    //common
    if (self.phoneTF.text.length == 0) {
        [STSHUdHelper st_toastMsg:@"请输入手机号" completion:nil];
        return;
    }
    if (self.phoneTF.text.length != 11) {
        [STSHUdHelper st_toastMsg:@"请输入正确的手机号" completion:nil];
        return;
    }
    if (self.PassWorldTF.text.length == 0) {
        [STSHUdHelper st_toastMsg:@"请输入密码" completion:nil];
        return;
    }
    
    if (self.loginStle == LoginVc_Style_Login) {
        
        [self net_BSApi_login];
        [SKUserDefaults_shareInstance storeObject:self.phoneTF.text forKey:STStore_RemenberAccount];
        
    }else if (self.loginStle == LoginVc_Style_Regis){
        
        if ([self checkNumFormart]) {
            [self net_BSApi_register];
        }
        
    }else if (self.loginStle == LoginVc_Style_ForgetPW){
        if ([self checkNumFormart]) {
            [self net_BSApi_updatePassword];
        }
        
    }
    
}
- (void)regisBtnClick:(UIButton *)sender{
    
    LoginControl *Vc = [[LoginControl alloc]init];
    Vc.loginStle = LoginVc_Style_Regis;
    [self.navigationController pushViewController:Vc animated:YES];
    
}
- (void)forgetPWBtnClick:(UIButton *)sender{
    LoginControl *Vc = [[LoginControl alloc]init];
    Vc.loginStle = LoginVc_Style_ForgetPW;
    [self.navigationController pushViewController:Vc animated:YES];
    
}
- (void)checkNumBtnClick:(UIButton *)sender{
    
    if (self.phoneTF.text.length != 11) {
        [STSHUdHelper st_toastMsg:@"请输入正确的手机号" completion:nil];
        return;
    }
    
    [self net_BSApi_getVerifyCodeSuc:^{
        
        sender.enabled = NO;
        [[GmWidget shareInstance]gm_countDownWithTime:60 countDownBlock:^(int timeLeft) {
            [sender setTitleColor:kLightGrayColor forState:UIControlStateNormal];
            [sender setTitle:[NSString stringWithFormat:@"%d",timeLeft] forState:UIControlStateNormal];
        } endBlock:^{
            sender.enabled = YES;
            [sender setTitleColor:kWhiteColor forState:UIControlStateNormal];
            [sender setTitle:@"获取" forState:UIControlStateNormal];
        }];
        
    } faild:^{
        
    }];
    
   
    
}

#pragma mark - UITextFieldDelegate
- (void)textfieldDidChange:(UITextField *)textField{
    
    NSString *text = textField.text;
    
    if (textField == self.phoneTF) {
        if (textField.text.length >  11) {
            textField.text = [text substringToIndex:11];
        }
    }else if (textField == self.PassWorldTF){
        if (textField.text.length >  15) {
            textField.text = [text substringToIndex:15];
        }
    }else if (textField == self.checkNumTF){
        if (textField.text.length > 4) {
            textField.text = [text substringToIndex:4];
        }
    }
}
- (BOOL)checkNumFormart{
    
    if (self.checkNumTF.text.length == 0) {
        [STSHUdHelper st_toastMsg:@"请输入验证码" completion:nil];
        return NO;
    }
    if (self.checkNumTF.text.length != 4) {
        [STSHUdHelper st_toastMsg:@"请输入正确的验证码" completion:nil];
        return NO;
    }
    return YES;
}

- (UIView *)buildCommonInputViewWithImage:(UIImage *)image
                          placeholder:(NSString *)placeholder
                          keybordType:(UIKeyboardType)keybordtype
                           needSecure:(BOOL)needSecure
                         textFeildTag:(NSInteger)textFeildTag{
    
    UIView *contentView = [UIView new];
    contentView.f_width = kSCREEN_WIDTH - 88;
    contentView.f_height = 60;
//    contentView.backgroundColor = kWhiteColor;
    
    UIImageView *leftImge = [[UIImageView alloc]initWithImage:image];
    [contentView addSubview:leftImge];
    leftImge.f_left = 0;
    leftImge.f_top = 0;
    
    UITextField *feild = [[UITextField alloc]initWithFrame:CGRectMake(leftImge.f_right + 15, 0, contentView.f_width - leftImge.f_right - 15 - 20, 20)];
    [contentView addSubview:feild];
    feild.f_centerY = leftImge.f_centerY;
    feild.font = FONTSize(14);
    feild.clearButtonMode =  UITextFieldViewModeWhileEditing;
    feild.placeholder = placeholder;
    feild.keyboardType = keybordtype;
    feild.secureTextEntry = needSecure;
    feild.tag = textFeildTag;
//    feild.delegate = self;
    [feild addTarget:self action:@selector(textfieldDidChange:) forControlEvents:UIControlEventEditingChanged];
    
    if (textFeildTag == TextField_EM_Phone) {
        self.phoneTF = feild;
    }else if (textFeildTag == TextField_EM_PassW){
        self.PassWorldTF = feild;
    }else if (textFeildTag == TextField_EM_CheckNum){
        self.checkNumTF = feild;
    }
    
    UIView *lineView = [UIView new];
    [contentView addSubview:lineView];
    lineView.backgroundColor = rgb(204, 204, 204);
    lineView.f_width = contentView.f_width - feild.f_left;
    lineView.f_height = 1.f;
    lineView.f_left = feild.f_left;
    lineView.f_top = leftImge.f_bottom + 20;
    
    contentView.f_height = lineView.f_bottom;
    
    return contentView;
}


@end
