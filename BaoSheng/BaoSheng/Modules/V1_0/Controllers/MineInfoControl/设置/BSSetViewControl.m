//
//  BSSetViewControl.m
//  BaoSheng
//
//  Created by GML on 2018/4/24.
//  Copyright © 2018年 haozheng. All rights reserved.
//

#import "BSSetViewControl.h"
#import "BSCommonCell.h"
#import "AppDelegate.h"
#import "LoginControl.h"
#import "BSReportControl.h"

@interface BSSetViewControl ()<UITableViewDelegate,UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic , strong)NSMutableArray *DataArr;

@end

@implementation BSSetViewControl

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = @"设置";
    
    [self initData];
    
    self.tableView.tableFooterView = [self buildTableFooter];
}
- (void)initData{
    
    self.DataArr = @[@"修改密码",@"关于宝胜村",@"意见反馈"].mutableCopy;
    
}
- (UIView *)buildTableFooter{
    
    UIView *bgView = [UIView new];
    bgView.backgroundColor =kappBackgroundColor;
    bgView.f_width  = kSCREEN_WIDTH;
    bgView.f_height = 52+ 20;
    
    UIButton *excitBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [bgView addSubview:excitBtn];
    [excitBtn setTitle:@"退出登陆" forState:UIControlStateNormal];
    excitBtn.titleLabel.font = FONTSize(15);
    [excitBtn setTitleColor:kappButtonBackgroundColor forState:UIControlStateNormal];
    excitBtn.backgroundColor = kWhiteColor;
    excitBtn.frame = CGRectMake(0, 20, kSCREEN_WIDTH, 52);
    [excitBtn addTarget:self action:@selector(exitBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    
    return bgView;
}
#pragma mark - Net -
- (void)net_BSApi_exit{
    
    NSDictionary *dic = @{@"id" :BSContext_shareInstance.currentUser.Id};
    BSAction *action = [BSAction instanceMethodPostWithApi:BSApi_exit];
    action.paramsDic = dic.mutableCopy;
    [STSHUdHelper showLoadingWithLock:YES];
    WeakSelf
    [self sk_requestWithAction:action success:^(BSRes *res) {
       StrongSelf
        [STSHUdHelper hideLoading];
        //发送通知
        [self sk_postNotificationName:SKNotifyMsg_LoginOut object:nil userInfo:nil];
        
        [RCIMHelper_shareInstance loginOutIM];
        
        [STSHUdHelper st_toastMsg:@"已成功退出" completion:^{
            
            BSContext_shareInstance.currentUser.isLogin = @0;
            [SKUserDefaults_shareInstance storedObjectRemoveForKey:STStore_CurrentUserInfo];
            
            [self.navigationController popToRootViewControllerAnimated:NO];
//            AppDelegate * thedelegate = (AppDelegate*)[UIApplication sharedApplication].delegate;
//            [thedelegate.rootTabBar.nc1.tabBarController setHidesBottomBarWhenPushed:NO];
//            thedelegate.rootTabBar.selectedViewController = thedelegate.rootTabBar.nc1;
            [AppDelegate sharedAppDelegate].rootTabBar = [[RootTabarControl alloc]init];
            [AppDelegate sharedAppDelegate].window.rootViewController = [AppDelegate sharedAppDelegate].rootTabBar;
            
        }];
    } failure:^(BSRes *res) {
        [STSHUdHelper hideLoading];
        
    }];
    
}

#pragma mark - exit
- (void)exitBtnClick:(UIButton *)sender{

    [self net_BSApi_exit];

}
- (void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
    self.st_hidesBottomBarWhenPushed = NO;
}

#pragma mark - UITableViewDelegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return 3;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 52;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString *cellidentfer = @"BSCommonCell";
    BSCommonCell *cell = [tableView dequeueReusableCellWithIdentifier:cellidentfer];
    if (!cell) {
        cell = [[NSBundle mainBundle]loadNibNamed:cellidentfer owner:self options:nil].firstObject;
        
    }
    cell.titlelb_.text = self.DataArr[indexPath.row];
    
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (indexPath.row == 0) {
        LoginControl *Vc = [[LoginControl alloc]init];
        Vc.loginStle = LoginVc_Style_ForgetPW;
        [self.navigationController pushViewController:Vc animated:YES];
    }else if (indexPath.row == 1){
        
    }else if (indexPath.row == 2){
        BSReportControl *Vc = [[BSReportControl alloc]init];
        
        [self.navigationController pushViewController:Vc animated:YES];
        
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
