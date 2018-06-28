//
//  BSPartymenberControl.m
//  BaoSheng
//
//  Created by GML on 2018/4/24.
//  Copyright © 2018年 haozheng. All rights reserved.
//

#import "BSPartymenberControl.h"
#import "STSCustomCell.h"
#import "BSCertifPopView.h"

@interface BSPartymenberControl ()

@property (nonatomic , strong)UIScrollView *scrolView;
@property (nonatomic , strong)UITextField *cardTF;
@property (nonatomic , strong)UITextField *nameTF;


@end

@implementation BSPartymenberControl

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = @"党员认证";
    [self addOwnViews];
}
#pragma mark - Net

- (void)net_BSApi_authPartyMember{
    
    NSDictionary *dic = @{@"userId" :BSContext_shareInstance.currentUser.Id,
                          @"idCard" :self.cardTF.text
                          };
    BSAction *action = [BSAction instanceMethodPostWithApi:BSApi_authPartyMember];
    action.paramsDic = dic.mutableCopy;
    
    [STSHUdHelper showLoadingWithLock:YES];
    WeakSelf
    [self sk_requestWithAction:action success:^(BSRes *res) {
        StrongSelf
        [STSHUdHelper hideLoading];
    
        BSCertifPopView *popView = [[BSCertifPopView alloc]initWithStyle:CertifPop_style_Suc];
        [popView show];
        [SKPopupHelper_shareInstance skpop_dismissBlock:^(UIWindow *window, UIView *view) {
                [self.navigationController popViewControllerAnimated:YES];
            }];
       
    } failure:^(BSRes *res) {
        
        if (res.code == SKResCode_Failure) {
            
            BSCertifPopView *popView = [[BSCertifPopView alloc]initWithStyle:CertifPop_style_Fail];
            [popView show];
        }
       
    }];
    
}


#pragma mark - UI
- (void)addOwnViews{
    
    _scrolView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 10, kSCREEN_WIDTH, kSCREEN_HEIGHT - kNavHeight - 10)];
    [self.view addSubview:_scrolView];
    _scrolView.showsHorizontalScrollIndicator = NO;
    _scrolView.showsVerticalScrollIndicator = NO;
    
    STSCustomCell *cell = [[STSCustomCell alloc]initWithFrame:CGRectMake(0, 10, kSCREEN_WIDTH, 52) index:10 delegate:nil];
    [_scrolView addSubview:cell];
    cell.arrowdImg.hidden = YES;
    cell.titlelb.text = @"真实姓名";
    cell.deslb.placeholder = @"请输入姓名";
    cell.deslb.textAlignment = NSTextAlignmentLeft;
    cell.deslb.userInteractionEnabled = YES;
    [cell.deslb addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
    [cell.titlelb sizeToFit];
    cell.titlelb.f_left =  15;
    cell.deslb.f_left = cell.titlelb.f_right + 15;
    
    STSCustomCell *cell1 = [[STSCustomCell alloc]initWithFrame:CGRectMake(0, cell.f_bottom + 1, kSCREEN_WIDTH, 52) index:11 delegate:nil];
    [_scrolView addSubview:cell1];
    cell1.arrowdImg.hidden = YES;
    cell1.titlelb.text = @"身份证号";
    cell1.deslb.placeholder = @"请输入身份证号码";
    cell1.deslb.textAlignment = NSTextAlignmentLeft;
    cell1.deslb.userInteractionEnabled = YES;
    [cell1.deslb addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
    [cell.titlelb sizeToFit];
    cell1.titlelb.f_left =  15;
    cell1.deslb.f_left = cell.titlelb.f_right + 15;
    
    self.nameTF = cell.deslb;
    self.cardTF = cell1.deslb;
    
    UILabel *desclb = [UILabel new];
    [_scrolView addSubview:desclb];
    desclb.font = FONTSize(13);
    desclb.textColor = rgb(102, 102, 102);
    desclb.text = @"认证后才能查看我的支部等内容，请填写真实数据";
    [desclb sizeToFit];
    desclb.f_left = 15;
    desclb.f_top = cell1.f_bottom + 12;
    
    
    BSGlobalButton *tijiaoBtn = [BSGlobalButton buttonWithButtonSize:CGSizeMake(kSCREEN_WIDTH - 30, 44) coner:0 title:@"提交认证" titleFont:18 backgroundColor:kappButtonBackgroundColor globalButtonStyle:GlobalButtonStyle_Conerhaf];
    [_scrolView addSubview:tijiaoBtn];
    tijiaoBtn.f_centerX = kSCREEN_WIDTH/2;
    tijiaoBtn.f_top = desclb.f_bottom + 25;
    
    [tijiaoBtn addTarget:self action:@selector(tijiaoBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    
    _scrolView.contentSize = CGSizeMake(kSCREEN_WIDTH, _scrolView.f_height + 1);
    
}

#pragma mark - Event
- (void)textFieldDidChange:(UITextField *)sender{
    
    if (sender.tag == 10) {
        if (sender.text.length > 10) {
            sender.text = [sender.text substringToIndex:10];
        }
    }else{
        if (sender.text.length > 18) {
            sender.text = [sender.text substringToIndex:18];
        }
    }
}
- (void)tijiaoBtnClick:(UIButton *)sender{
    
    if (!self.nameTF.text.length) {
        [STSHUdHelper st_toastMsg:@"请输入名字" completion:nil];
        return;
    }
    if (!self.cardTF.text.length) {
        [STSHUdHelper st_toastMsg:@"请输入身份证" completion:nil];
        return;
    }
    if (self.cardTF.text.length != 18) {
        [STSHUdHelper st_toastMsg:@"身份证号码不正确" completion:nil];
        return;
    }
    [self net_BSApi_authPartyMember];
    
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}



@end
