//
//  MineInfoControl.m
//  BaoSheng
//
//  Created by GML on 2018/4/18.
//  Copyright © 2018年 haozheng. All rights reserved.
//

#import "MineInfoControl.h"
#import "NavView.h"
#import "LoginControl.h"
#import "BSSetViewControl.h"
#import "BSUserInfoUnCertfVc.h"
#import "BSPartymenberControl.h"
#import "BSUserInfoCertfVC.h"
#import "PartyMenberSourceVC.h"
#import "BSCommonCell.h"
#import "BSStudyRecordControl.h"

@interface MineInfoControl ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic , strong)BSBaseTableView *mainTableView;
@property (nonatomic , strong)NSMutableArray  *mainTableData;
//背景图
@property (weak, nonatomic) IBOutlet UIImageView *imgeBG_;
@property (weak, nonatomic) IBOutlet UIButton    *loginBtn_;
@property (nonatomic , assign)CGFloat imageBGrealHeight;
/** 图片白色背景*/
@property (weak, nonatomic) IBOutlet UIView *headBGView_;
/** 头像图片 */
@property (weak, nonatomic) IBOutlet UIImageView *headImageView_;
/** 名字 */
@property (weak, nonatomic) IBOutlet UILabel *namelb_;
/** 党员标志 */
@property (weak, nonatomic) IBOutlet UIImageView *dangyuanImage_;
/** 认证图标 */
@property (weak, nonatomic) IBOutlet UIImageView *certificationImge_;
/** 查看详情按钮 */
@property (weak, nonatomic) IBOutlet UIButton *checkDetailBtn_;
/** 白色箭头 */
@property (weak, nonatomic) IBOutlet UIImageView *arrowdWhite_;

@property (nonatomic , strong)NavView *nav;

@end

@implementation MineInfoControl

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    self.tabBarController.tabBar.hidden = NO;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"个人中心";
    self.st_hideNavBar = YES;
    
    [self initData];
    [self addOwnViews];
    
    [self addObserver];
    
}
- (void)initData{
    
    self.mainTableData = [@[@"会议签到",@"党员积分",@"学习记录"] mutableCopy];
}

- (void)refreshUserInfo{
    
    BSBaseUserDto *user = BSContext_shareInstance.currentUser;
    
    
    self.mainTableView.tableHeaderView = [self buildTableHeaderView:YES];
    [self.headImageView_ sd_setImageWithURL:[NSURL URLWithString:user.headUrl] placeholderImage:[UIImage imageNamed:@"my_head_n"]];
    self.namelb_.text = user.names;
    if (user.partyMemberInformation.timeToJoinTheParty.length > 5) {
        self.dangyuanImage_.hidden = NO;
        self.certificationImge_.image = [UIImage imageNamed:@"my_dangyuan"];
        self.certificationImge_.userInteractionEnabled = NO;
    }else{
        self.dangyuanImage_.hidden = YES;
        self.certificationImge_.image = [UIImage imageNamed:@"dianjirenzheng"];
    }
}
#pragma mark - ObServer
- (void)addObserver{
    
    WeakSelf
    [self sk_addObserverForName:SKNotifyMsg_LoginIn block:^(NSNotification * _Nullable note) {
        StrongSelf
        [self refreshUserInfo];
    }];
    
    [self sk_addObserverForName:SKNotifyMsg_LoginOut block:^(NSNotification * _Nullable note) {
        StrongSelf
        self.mainTableView.tableHeaderView = [self buildTableHeaderView:NO];
        
    }];
    [self sk_addObserverForName:SKNotifyMsg_UserInfoChange block:^(NSNotification * _Nullable note) {
        [self refreshUserInfo];
    }];
    
    if (BSContext_shareInstance.currentUser.isLogin.integerValue == 1) {
        [self refreshUserInfo];
    }
}
#pragma mark - UI

- (void)addOwnViews{
   
    
    self.mainTableView = [[BSBaseTableView alloc]initWithFrame:CGRectMake(0, 0, kSCREEN_WIDTH, kSCREEN_HEIGHT - kTableBarHeight) style:UITableViewStylePlain inOrginVc:self];
    self.mainTableView.delegate = self;
    self.mainTableView.dataSource = self;
    self.mainTableView.openfooter = NO;
    self.mainTableView.openHeader = NO;
    self.mainTableView.backgroundColor = [UIColor clearColor];
   
    BOOL  currentStatus = BSContext_shareInstance.currentUser.isLogin.integerValue == 1 ?YES:NO;
    self.mainTableView.tableHeaderView = [self buildTableHeaderView:currentStatus];
    
    
    [self.view addSubview:self.mainTableView];
    
    if (@available(iOS 11.0, *)) {
        self.mainTableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    }else {
        self.automaticallyAdjustsScrollViewInsets = NO;
        
    }
    
    _nav = [[NavView alloc]initWithFrame:CGRectZero];
    [_nav.ringtItem_ addTarget:self action:@selector(setBtnClik:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_nav];
    _nav.navTitle_.text = @"个人中心";
}
- (UIView *)buildTableHeaderView:(BOOL)isLogin{
    
    UIView *wrapper = [[[NSBundle mainBundle] loadNibNamed:@"MineHeader" owner:self options:nil] lastObject];
    wrapper.f_width = kSCREEN_WIDTH;
    self.imageBGrealHeight = [UIImage imageNamed:@"minebg"].size.height;
    wrapper.f_height = self.imageBGrealHeight + 5;
    
    if (isLogin) {//已登录
        self.loginBtn_.hidden = YES;
        
        self.headBGView_.layer.cornerRadius = self.headImageView_.f_height/2;
        self.headBGView_.layer.masksToBounds = YES;
        self.headImageView_.layer.cornerRadius = self.headImageView_.f_height/2;
        self.headImageView_.layer.masksToBounds = YES;
        self.certificationImge_.image = [UIImage imageNamed:@"my_dangyuan"];
        UITapGestureRecognizer *certifiTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(certificationImgeTap:)];
        [self.certificationImge_ addGestureRecognizer:certifiTap];
        self.certificationImge_.userInteractionEnabled = YES;
        
        
    }else{
        self.loginBtn_.layer.borderWidth = 1.f;
        self.loginBtn_.layer.cornerRadius = self.loginBtn_.f_height/2;
        self.loginBtn_.layer.borderColor = kWhiteColor.CGColor;
        self.loginBtn_.layer.masksToBounds = YES;
        [self.loginBtn_ addTarget:self action:@selector(loginBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        
        self.arrowdWhite_.hidden = YES;
        self.checkDetailBtn_.hidden = YES;
        self.namelb_.hidden = YES;
        self.certificationImge_.hidden =YES;
        self.headBGView_.hidden = YES;
        self.headImageView_.hidden = YES;
        self.dangyuanImage_.hidden = YES;
        self.nav.ringtItem_.hidden = YES;
        
    }
    return wrapper;
    
}
#pragma mark - Events
- (void)loginBtnClick:(UIButton *)sender{
    
    LoginControl *Vc = [[LoginControl alloc]init];
    Vc.loginStle = LoginVc_Style_Login;
    [self.navigationController pushViewController:Vc animated:YES];
}

-(void)certificationImgeTap:(UITapGestureRecognizer *)sender{
    NSLog(@"Tap");
    
    //未认证
//    BSPartymenberControl *Vc = [[BSPartymenberControl alloc]init];
//    [self.navigationController pushViewController:Vc animated:YES];
    //已认证
    BSUserInfoCertfVC *Vc = [[BSUserInfoCertfVC alloc]init];
    [self.navigationController pushViewController:Vc animated:YES];
    
}
- (IBAction)checkDetail:(id)sender {
    NSLog(@"checkDetail");
    
    if (BSContext_shareInstance.currentUser.partyMemberInformation) {
        BSUserInfoCertfVC *Vc = [[BSUserInfoCertfVC alloc]init];
         [self.navigationController pushViewController:Vc animated:YES];
    }else{
        BSUserInfoUnCertfVc *Vc = [[BSUserInfoUnCertfVc alloc]init];
        [self.navigationController pushViewController:Vc animated:YES];
    }
}
- (void)setBtnClik:(UIButton *)sender{
    BSSetViewControl *Vc = [[BSSetViewControl alloc]init];
    [self.navigationController pushViewController:Vc animated:YES];
    
}

#pragma mark - scrolViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    
    if (scrollView == self.mainTableView) {
        //背景放大效果
        
        if (self.imgeBG_.f_height > 0) {
            CGFloat originHeight = self.imageBGrealHeight;
            self.imgeBG_.translatesAutoresizingMaskIntoConstraints = YES;

            float ratio =  (-scrollView.contentOffset.y + originHeight)/originHeight;
            if (ratio < 1) ratio = 1;
            self.imgeBG_.f_height = originHeight * ratio;
            self.imgeBG_.f_width = kSCREEN_WIDTH;
            self.imgeBG_.f_x = 0.0;
            self.imgeBG_.f_y = originHeight - self.imgeBG_.f_height;
        }
    }
}

#pragma mark - UITableViewDelegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.mainTableData.count;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 50;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString *cellidentfer = @"BSCommonCell";
    BSCommonCell *cell = [tableView dequeueReusableCellWithIdentifier:cellidentfer];
    if (!cell) {
        cell = [[NSBundle mainBundle]loadNibNamed:cellidentfer owner:self options:nil].firstObject;
        
    }
    
    cell.titlelb_.text = self.mainTableData[indexPath.row];
    
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    BSBaseUserDto *user = BSContext_shareInstance.currentUser;
    if (user.isLogin.integerValue != 1) {
        LoginControl *Vc = [[LoginControl alloc]init];
        [self.navigationController pushViewController:Vc animated:YES];
        return;
    }
    
    if (user.isLogin.integerValue != 1 || !user.partyMemberInformation) {
        [STSHUdHelper st_toastMsg:@"请先认证党员" completion:nil];
        return;
    }
    
    if (indexPath.row == 0) {
        
    }else if (indexPath.row == 1) {
        PartyMenberSourceVC *Vc = [[PartyMenberSourceVC alloc]init];
        [self.navigationController pushViewController:Vc animated:YES];
    }else if (indexPath.row == 2){
        BSStudyRecordControl *Vc = [[BSStudyRecordControl alloc]init];
        [self.navigationController pushViewController:Vc animated:YES];
        
    }
    
}

#pragma mark - 分割线
//分割线设置
- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath{
    CGFloat leftPading =  0;
    if ([cell respondsToSelector:@selector(setSeparatorInset:)]) {
        [cell setSeparatorInset:UIEdgeInsetsMake(0,leftPading,0,0)];
    }
    
    if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
        [cell setLayoutMargins:UIEdgeInsetsMake(0,leftPading,0,0)];
    }
}
-(void)viewDidLayoutSubviews
{
    CGFloat leftPading =  0;
    if ([self.mainTableView respondsToSelector:@selector(setSeparatorInset:)]) {
        [self.mainTableView setSeparatorInset:UIEdgeInsetsMake(0,leftPading,0,0)];
    }
    
    if ([self.mainTableView respondsToSelector:@selector(setLayoutMargins:)]) {
        [self.mainTableView setLayoutMargins:UIEdgeInsetsMake(0,leftPading,0,0)];
    }
}


@end
