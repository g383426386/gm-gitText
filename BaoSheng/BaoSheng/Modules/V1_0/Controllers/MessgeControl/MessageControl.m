//
//  MessageControl.m
//  BaoSheng
//
//  Created by GML on 2018/4/18.
//  Copyright © 2018年 haozheng. All rights reserved.
//

#import "MessageControl.h"
#import "MessageCell.h"
#import "BSMessageDto.h"

#import "BSMessageDetailDto.h"
#import "WKWebViewBaseViewController.h"
#import "LoginControl.h"

@interface MessageControl ()<UITableViewDelegate,UITableViewDataSource,BsTableViewRefresh>

@property (nonatomic , strong)BSBaseTableView *tableView;
@property (nonatomic , strong)NSMutableArray *dataArr;

@property (nonatomic , strong)BSDefaultView *defaultView;

@end

@implementation MessageControl

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = @"我的消息";
    [self initData];
    [self buildUI];
    BOOL hasLogin =  BSContext_shareInstance.currentUser.isLogin.integerValue == 1;
    if (hasLogin) {
          [self net_BSApi_inform:YES];
    }else{
        
         [self configNoLoginView];
    }
    [self addObserver];
   
}
- (void)initData{
    
    self.dataArr = [@[]mutableCopy];
    
}
- (void)configNoLoginView{
    
    self.tableView.hidden = YES;
    self.dataArr  = @[].mutableCopy;
    WeakSelf
    self.defaultView = [[BSDefaultView alloc]initWithImage:[UIImage imageNamed:@"nologin"] Des:@"" BtnTitle:@"去登陆" BtnClick:^{
        StrongSelf
        LoginControl *Vc = [[LoginControl alloc]init];
        [self.navigationController pushViewController:Vc animated:YES];
        
    } orginframe:self.view.frame];
    [self.view addSubview:self.defaultView];
    self.defaultView.f_centerY = (kSCREEN_HEIGHT - kTableBarHeight)/2 - kNavHeight;
    
}
#pragma mark - Observer
- (void)addObserver{
    WeakSelf
    [self sk_addObserverForName:SKNotifyMsg_LoginIn block:^(NSNotification * _Nullable note) {
        StrongSelf
        if (self.defaultView) {
            [self.defaultView removeFromSuperview];
            self.defaultView = nil;
        }
        self.tableView.bspageIndex = 1;
        [self net_BSApi_inform:YES];
    }];
    [self sk_addObserverForName:SKNotifyMsg_LoginOut block:^(NSNotification * _Nullable note) {
        StrongSelf
        
        if (self.defaultView) {
            [self.defaultView removeFromSuperview];
            self.defaultView = nil;
        }
        [self configNoLoginView];
        
    }];
    
}
#pragma mark - net
- (void)net_BSApi_inform:(BOOL)needShow{
    
    BOOL isform = BSContext_shareInstance.currentUser.partyMemberInformation ?YES:NO;
    NSDictionary *dic = @{@"informFor" :isform ?@1:@2,
                          @"pageIndex" :@(self.tableView.bspageIndex),
                          @"pageSize"   :@(20)
                          };
    BSAction *action = [BSAction instanceMethodPostWithApi:BSApi_inform];
    action.paramsDic = dic.mutableCopy;
    if (needShow) {
        [STSHUdHelper showLoadingWithLock:NO];
    }
    WeakSelf
    [self sk_requestWithAction:action success:^(BSRes *res) {
        StrongSelf
        [STSHUdHelper hideLoading];
        
        NSArray *arr = [BSMessageDto mj_objectArrayWithKeyValuesArray:res.result];
        if (self.tableView.bspageIndex == 1) {
            if (arr.count == 0) {
                BSDefaultView *defaultView = [[BSDefaultView alloc]initWithImage:[UIImage imageNamed:@"tu"] Des:nil BtnTitle:nil BtnClick:nil orginframe:self.view.frame];
                self.defaultView = defaultView;
                [self.view addSubview:defaultView];
                
                self.tableView.hidden = YES;
            }else{
                self.tableView.hidden = NO;
            }
            self.dataArr = arr.mutableCopy;
            [self.tableView endHeaderRefresh];
        }else{
            if (arr.count) {
                [self.dataArr addObjectsFromArray:arr];
                [self.tableView endFooterRefresh];
            }else{
                [self.tableView noMoreData];
            }
        }
        [self.tableView reloadData];
        
    } failure:^(BSRes *res) {
        [STSHUdHelper hideLoading];
          [self.tableView endHeaderRefresh];
          [self.tableView endFooterRefresh];
    }];
}
- (void)net_BSApi_informDetailWithId:(NSNumber *)Id{
    
    NSDictionary *dic = @{@"id" :Id};
    BSAction *action = [BSAction instanceMethodPostWithApi:BSApi_informDetail];
    action.paramsDic = dic.mutableCopy;
    
    [STSHUdHelper showLoadingWithLock:NO];
    
    WeakSelf
    [self sk_requestWithAction:action success:^(BSRes *res) {
        StrongSelf
        [STSHUdHelper hideLoading];
        
        BSMessageDetailDto *detailDto = [BSMessageDetailDto mj_objectWithKeyValues:res.result];
        
        WKWebViewBaseViewController *web = [[WKWebViewBaseViewController alloc]init];
        web.messgeDto = detailDto;
        [web WebViewInit:detailDto.contentUrl Frame:CGRectMake(0, 0, kSCREEN_WIDTH, kSCREEN_HEIGHT - kNavHeight) headStyle:WebViewHeader_Style_Messge];
        
        [self.navigationController pushViewController:web animated:YES];
        
        
        
    } failure:^(BSRes *res) {
        [STSHUdHelper hideLoading];
      
    }];
    
}

#pragma mark - UI
- (void)buildUI{
    
    _tableView  = [[BSBaseTableView alloc]initWithFrame:CGRectMake(0, 0, kSCREEN_WIDTH, kSCREEN_HEIGHT - kNavHeight - kTableBarHeight) style:UITableViewStylePlain inOrginVc:self];
    [self.view addSubview:_tableView];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.bsDelegate = self;
    
}

#pragma mark - BsTableViewRefresh
- (void)BsonRefreshing:(id)control{
    
    self.tableView.bspageIndex = 1;
    [self net_BSApi_inform:NO];
    
}
- (void)BsonLoadingMoreData:(id)control pageNum:(NSNumber *)pageNum{
    
    self.tableView.bspageIndex++;
    [self net_BSApi_inform:YES];
}
#pragma mark - UITableViewDelegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return self.dataArr.count;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 145.f;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString *messageIdent = @"MessageCell";
    MessageCell *cell = [tableView dequeueReusableCellWithIdentifier:messageIdent];
    if (!cell) {
        cell = [[NSBundle mainBundle]loadNibNamed:messageIdent owner:self options:nil].firstObject;
        
    }
    BSMessageDto *messgeDto = self.dataArr[indexPath.row];
    
    [cell configCellWithDto:messgeDto];
    cell.checkDetailBtn_.tag = indexPath.row;
    
    WeakSelf
    cell.checkBtnBlock = ^(NSInteger index) {
        StrongSelf
        [self net_BSApi_informDetailWithId:messgeDto.Id];
    };
  
    
    return cell;
}

- (NSString *)turnDateFromTimeInteval:(double)timeInterval{
    
    NSDate*detaildate=[NSDate dateWithTimeIntervalSince1970:timeInterval/1000];
    NSDateFormatter*dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm"];
    
    NSString * currentDateStr = [dateFormatter stringFromDate:detaildate];
    
    return currentDateStr;
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}



@end
