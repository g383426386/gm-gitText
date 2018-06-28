//
//  WKWebCommonVc.m
//  BaoSheng
//
//  Created by GML on 2018/4/28.
//  Copyright © 2018年 haozheng. All rights reserved.
//

#import "WKWebCommonVc.h"
#import "BSWebViewFooter.h"
#import "STAlertView.h"

@interface WKWebCommonVc ()

@property (nonatomic , strong)BSWebViewFooter *footerView;

@end

@implementation WKWebCommonVc

- (void)viewDidLoad {
    [super viewDidLoad];
    
    if (self.webStyle == WebViewHeader_Style_Home_Info) {
        [self net_BSApi_getNineteenSpiritDetailWithId:self.Id];
    }else if (self.webStyle == WebViewHeader_Style_Certf){
        self.enableShowTitle = YES;
        [self webConfigUIWithStyle:WebViewHeader_Style_Certf reqUrl:self.mainUrl];
    }else if (self.webStyle == WebViewHeader_Style_HeaderAndFooter){
        [self net_learningDetail];
    }
}

#pragma mark - UI

- (void)webConfigUIWithStyle:(WebViewHeader_Style)headerStyle reqUrl:(NSString *)Url{
    
    self.mainUrl = [NSMutableString stringWithString:Url?:@""];
     BSWebViewHeader *header = nil;
    if (headerStyle == WebViewHeader_Style_Home_Info){
        header  = [[BSWebViewHeader alloc]init];
        [self.view addSubview:header];
        header.titlelb_.text = self.infoDetailDto.title;
        header.ringtTimelb_.text = [GmWidget dateFromTimeIntervalWithHHmm:[self.infoDetailDto.createDate doubleValue]];
        header.partymenberlb_.hidden = YES;
        header.top = 0;
        header.f_left = 0;
    }
    BSWebViewFooter *footer = nil;
    if (headerStyle == WebViewHeader_Style_HeaderAndFooter) {
        
        header  = [[BSWebViewHeader alloc]init];
        [self.view addSubview:header];
        header.titlelb_.text = self.learningDto.partyMemberLearning.title;
        header.ringtTimelb_.text = [GmWidget dateFromTimeIntervalWithHHmm:[self.learningDto.partyMemberLearning.publishTime doubleValue]];
        header.leftTimelb_.text = [NSString stringWithFormat:@"来源 %@",self.learningDto.partyMemberLearning.contentSource];
        header.partymenberlb_.hidden = YES;
        header.top = 0;
        header.f_left = 0;
        
        //判断是否已学完
        BOOL hasDownLearn = self.learningDto.isEnd == 1;
        
        WeakSelf
        footer = [[BSWebViewFooter alloc]initWithStyle: hasDownLearn ? CoutButton_Style_HasEnd :CoutButton_Style_Normal SecCount:self.learningDto.partyMemberLearning.learningTime CountDownBlock:^(int lefttime, UIButton *SecBtn) {
            
        } endBlock:^(UIButton *SecBtn) {
            
        } upLoadBlock:^(UIButton *SecBtn) {
            StrongSelf
            [self net_BSApi_addLearningRecord:self.learningDto.partyMemberLearning.Id];
        }];
        self.footerView = footer;
        [self.view addSubview:footer];
        footer.f_left = 0;
        footer.f_bottom = kSCREEN_HEIGHT - kNavHeight - kiphoneXsafeBottom;
        
    }
    
     [self.view addSubview:self.webView];
    
    WeakSelf
    [self.webView mas_updateConstraints:^(MASConstraintMaker *make) {
        StrongSelf
        make.left.equalTo(self.view.mas_left);
        make.right.equalTo(self.view.mas_right);
        make.top.equalTo(header ? header.mas_bottom:self.view.mas_top);
        if (footer) {
         make.bottom.equalTo(footer.mas_top).offset(-10);
        }else{
         make.bottom.equalTo(self.view.mas_bottom);
        }
        
    }];
    
    // 添加进入条
    self.progressView = [[UIProgressView alloc] init];
    self.progressView.frame = CGRectMake(0, 0, kSCREEN_WIDTH, 0);
    self.progressView.tintColor = kappButtonBackgroundColor;
    self.progressView.trackTintColor = kappButtonBackgroundColor;
    [self.view addSubview:self.progressView];
    
    [self webBegienload_url:self.mainUrl];
}

#pragma mark - Net
//资讯详情
- (void)net_BSApi_getNineteenSpiritDetailWithId:(NSNumber *)Id{
    
    NSDictionary *dic = @{@"nsId" : Id?:@0};
    BSAction *action = [BSAction instanceMethodPostWithApi:BSApi_getNineteenSpiritDetail];
    action.paramsDic = dic.mutableCopy;
    
    [STSHUdHelper showLoadingWithLock:YES];
    WeakSelf
    [self sk_requestWithAction:action success:^(BSRes *res) {
        StrongSelf
        [STSHUdHelper hideLoading];
            
        BSInformationDetailDto *Dto = [BSInformationDetailDto mj_objectWithKeyValues:res.result];
        
        self.infoDetailDto = Dto;
        [self webConfigUIWithStyle:WebViewHeader_Style_Home_Info reqUrl:Dto.content];
        
        
    } failure:^(BSRes *res) {
        
        [STSHUdHelper hideLoading];
    }];
    
}
//党员学习详情
- (void)net_learningDetail{
    
    NSDictionary *dicc = @{@"userId" :BSContext_shareInstance.currentUser.Id,
                           @"learningId" :self.Id
                           };
    BSAction *action = [BSAction instanceMethodPostWithApi:BSApi_learningDetail];
    action.paramsDic = dicc.mutableCopy;
    
    WeakSelf
    [STSHUdHelper showLoadingWithLock:NO];
    [self sk_requestWithAction:action success:^(BSRes *res) {
        [STSHUdHelper hideLoading];
        StrongSelf
       BSPartyMenberDetailDto *Dto = [BSPartyMenberDetailDto mj_objectWithKeyValues:res.result];
        self.learningDto = Dto;
        [self webConfigUIWithStyle:WebViewHeader_Style_HeaderAndFooter reqUrl:Dto.partyMemberLearning.contentUrl];
        
    } failure:^(BSRes *res) {
        [STSHUdHelper hideLoading];
    }];
    
}

- (void)net_BSApi_addLearningRecord:(NSNumber *)learnId{
    
    NSDictionary *dic = @{@"userId" :BSContext_shareInstance.currentUser.Id,
                          @"learningId" : learnId
                          };
    BSAction *action = [BSAction instanceMethodPostWithApi:BSApi_addLearningRecord];
    action.paramsDic = dic.mutableCopy;
    
    WeakSelf
    [STSHUdHelper showLoadingWithLock:NO];
    [self sk_requestWithAction:action success:^(BSRes *res) {
        [STSHUdHelper hideLoading];
        StrongSelf
        
        if (res.code == 0) {
            [self.footerView.countSecBtn setTitle:@"已完成学习" forState:UIControlStateNormal];
            self.footerView.countSecBtn.backgroundColor = rgb(210, 210, 210);
            self.footerView.countSecBtn.userInteractionEnabled = NO;
            self.footerView.CountBtnStyle = CoutButton_Style_HasEnd;
        }
        
        
    } failure:^(BSRes *res) {
        [STSHUdHelper hideLoading];
    }];
    
}


#pragma mark - BackNav
- (void)setDefaultNavBackItemClicked:(UIButton *)sender{
    
    NSLog(@"23425235");
    if (self.webStyle == WebViewHeader_Style_HeaderAndFooter) {
        
        if (self.footerView.CountBtnStyle == CoutButton_Style_Sec) {
            
            STAlertView *alert = [[STAlertView alloc]initWithDes:@"你的学习时长未满，退出后需要重新学习" title:@"温馨提示" style:AlertVIewStyle_Nomarl btnArr:@[@"继续学习",@"下次再学"] bodyColor:kWhiteColor];
            alert.alertBtnClickBlock = ^(BOOL yesOrNo, UIButton *Btn) {
                if (yesOrNo) {
                    [self.navigationController popViewControllerAnimated:YES];
                }
            };
            [alert showAlert];
        }else if (self.footerView.CountBtnStyle == CoutButton_Style_CountEnd){
            STAlertView *alert = [[STAlertView alloc]initWithDes:@"你还未提交学习结果，退出后需要重新学习" title:@"温馨提示" style:AlertVIewStyle_Nomarl btnArr:@[@"不提交",@"提交"] bodyColor:kWhiteColor];
            alert.alertBtnClickBlock = ^(BOOL yesOrNo, UIButton *Btn) {
                if (yesOrNo) {
                    [self net_BSApi_addLearningRecord:self.learningDto.partyMemberLearning.Id];
                }else{
                    [self.navigationController popViewControllerAnimated:YES];
                }
            };
            [alert showAlert];
        }else{
            [self.navigationController popViewControllerAnimated:YES];
        }
        
    }else{
        
        [self.navigationController popViewControllerAnimated:YES];
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
