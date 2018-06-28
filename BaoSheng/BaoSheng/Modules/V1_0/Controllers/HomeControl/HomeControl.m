//
//  HomeControl.m
//  BaoSheng
//
//  Created by GML on 2018/4/18.
//  Copyright © 2018年 haozheng. All rights reserved.
//

#import "HomeControl.h"
#import "BSHomeTableHeader.h"
#import "TableViewCell.h"
#import "WKWebViewBaseViewController.h"
#import "CycleImageWebControl.h"
#import "BSMoreInfomationContol.h"
#import "BSInformationListDto.h"
#import "BSNineteenCollectionVC.h"
#import "WKWebCommonVc.h"
#import "BSCertfHelperControl.h"
#import "BSPartyMenberStudyListVc.h"

@interface HomeControl ()<BsTableViewRefresh,UITableViewDelegate,UITableViewDataSource>

@property (nonatomic , strong)BSBaseTableView *tableView;
@property (nonatomic , strong)NSMutableArray *DataArr;

@property (nonatomic , strong)BSHomeTableHeader *tableHeader;
@property (nonatomic , strong)NSMutableArray *imageArr;

@end

@implementation HomeControl

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    self.tabBarController.tabBar.hidden = NO;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initData];
    self.tableView = [[BSBaseTableView alloc]initWithFrame:CGRectMake(0, 0, kSCREEN_WIDTH, kSCREEN_HEIGHT - kNavHeight -kTableBarHeight) style:UITableViewStylePlain inOrginVc:nil];
    self.tableView.delegate  = self;
    self.tableView.dataSource = self;
    self.tableHeader = [[BSHomeTableHeader alloc]init];
    self.tableView.tableHeaderView = self.tableHeader;
    [self.view addSubview:self.tableView];
    [self netRequest_cycleImage];
    [self cycleScrollImageBlock];
    
    [self net_BSApi_getNineteenSpiritList];
    
   
}
- (void)initData{
    
    self.DataArr = [@[]mutableCopy];
    self.imageArr = [@[]mutableCopy];
}
#pragma mark - Net
//轮播图
- (void)netRequest_cycleImage{
    
    BSAction *action = [BSAction instanceMethodPostWithHost:BS_HOST_Master api:BSApi_cycleInformation];
    action.paramsDic = @{}.mutableCopy;
    WeakSelf
    [self sk_requestWithAction:action success:^(BSRes *res) {
        StrongSelf
        
        self.imageArr = [res.result mutableCopy];
        NSMutableArray *imageUrl = [@[]mutableCopy];
        for (NSDictionary *dic in self.imageArr) {
            [imageUrl addObject:dic[@"thumbnailUrl"]];
        }
        self.tableHeader.cycleScrolView.imageURLStringsGroup = imageUrl;
        
    } failure:^(BSRes *res) {
        
        NSLog(@"%@",res);
        
    }];
}
//资讯
- (void)net_BSApi_getNineteenSpiritList{
    
    NSDictionary *dic = @{@"typeId" :@28,
                          @"pageIndex" :@1
                          };
    BSAction *action = [BSAction instanceMethodPostWithApi:BSApi_getNineteenSpiritList];
    action.paramsDic = dic.mutableCopy;
    
    [STSHUdHelper showLoadingWithLock:NO];
    WeakSelf
    [self sk_requestWithAction:action success:^(BSRes *res) {
        StrongSelf
        [STSHUdHelper hideLoading];
        
        BSInformationListDto *Dto = [BSInformationListDto mj_objectWithKeyValues:res.result];
        self.DataArr = Dto.list.mutableCopy;
        [self.tableView reloadData];
        
    } failure:^(BSRes *res) {
        [STSHUdHelper hideLoading];
    }];
}

#pragma mark - refresh
- (void)BsonRefreshing:(id)control{
    self.tableView.bspageIndex = 1;
}
- (void)BsonLoadingMoreData:(id)control pageNum:(NSNumber *)pageNum{
    self.tableView.bspageIndex++;
}

#pragma mark - UITableViewDelegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return self.DataArr.count;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 80;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    TableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"asdaf"];
    if (!cell) {
        cell = [[NSBundle mainBundle]loadNibNamed:@"TableViewCell" owner:self options:nil].firstObject;
    }
    
    InfoListDto *infoDto = self.DataArr[indexPath.row];
    
    [cell configCellWithDto:infoDto];
   
    
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
     InfoListDto *infoDto = self.DataArr[indexPath.row];
    
    WKWebCommonVc *Vc = [[WKWebCommonVc alloc]init];
    Vc.Id = infoDto.Id;
    Vc.webStyle = WebViewHeader_Style_Home_Info;
    [self.navigationController pushViewController:Vc animated:YES];
}

#pragma mark - Events
- (void)cycleScrollImageBlock{
    
    WeakSelf
    self.tableHeader.cycleScrolView.clickItemOperationBlock = ^(NSInteger currentIndex) {
        StrongSelf
        
        NSLog(@"%@",self.imageArr[currentIndex]);
        NSDictionary *dic = [self.imageArr objectAtIndex:currentIndex];
        CycleImageWebControl *Vc = [[CycleImageWebControl alloc]init];
        Vc.Id = dic[@"id"];
        [self.navigationController pushViewController:Vc animated:YES];
    };
    
    
    self.tableHeader.moreBtnClickBlock = ^{
        StrongSelf
        BSMoreInfomationContol *Vc = [[BSMoreInfomationContol alloc]init];
        [self.navigationController pushViewController:Vc animated:YES];
    };
    
    self.tableHeader.itemClickAtIndex = ^(NSInteger index) {
      StrongSelf
        NSLog(@"%ld",(long)index);
        if (index == 0) {
            BSNineteenCollectionVC *Vc = [[BSNineteenCollectionVC alloc]init];
            [self.navigationController pushViewController:Vc animated:YES];
        }else if (index == 1){
            
            BSBaseUserDto *user = BSContext_shareInstance.currentUser;
            if (user.isLogin.integerValue != 1) {
                LoginControl *Vc = [[LoginControl alloc]init];
                [self.navigationController pushViewController:Vc animated:YES];
                return;
            }
            
            BSPartyMenberStudyListVc *Vc = [[BSPartyMenberStudyListVc alloc]init];
            [self.navigationController pushViewController:Vc animated:YES];
            
        }else if (index == 2){
            BSCertfHelperControl *Vc = [[BSCertfHelperControl alloc]init];
            [self.navigationController pushViewController:Vc animated:YES];
            
        }
    };
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
