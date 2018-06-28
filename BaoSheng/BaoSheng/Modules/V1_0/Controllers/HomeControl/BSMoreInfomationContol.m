//
//  BSMoreInfomationContol.m
//  BaoSheng
//
//  Created by GML on 2018/4/27.
//  Copyright © 2018年 haozheng. All rights reserved.
//

#import "BSMoreInfomationContol.h"
#import "TableViewCell.h"
#import "BSInformationListDto.h"
#import "WKWebCommonVc.h"

@interface BSMoreInfomationContol ()<BsTableViewRefresh,UITableViewDelegate,UITableViewDataSource>

@property (nonatomic , strong)BSBaseTableView *tableView;
@property (nonatomic , strong)NSMutableArray *DataArr;


@end

@implementation BSMoreInfomationContol

- (void)viewDidLoad {
    [super viewDidLoad];
 
    if (!self.navigationItem.title || self.navigationItem.title.length == 0) {
         self.navigationItem.title = @"资讯动态";
        self.Id = @28;
    }
    
    [self initData];
    [self buildUI];
    [self.tableView beginHeaderRefresh];
}
- (void)initData{
    
    self.DataArr = [@[]mutableCopy];
    
}
#pragma mark - Net
- (void)net_BSApi_getNineteenSpiritList{
    
    NSDictionary *dic = @{@"typeId" :self.Id,
                          @"pageIndex" :@(self.tableView.bspageIndex)
                          };
    BSAction *action = [BSAction instanceMethodPostWithApi:BSApi_getNineteenSpiritList];
    action.paramsDic = dic.mutableCopy;
    WeakSelf
    [self sk_requestWithAction:action success:^(BSRes *res) {
        StrongSelf
        
        BSInformationListDto *Dto = [BSInformationListDto mj_objectWithKeyValues:res.result];
        if (self.tableView.bspageIndex == 1) {
            self.DataArr = Dto.list.mutableCopy;
            [self.tableView endHeaderRefresh];
        }else{
            if (Dto.list.count) {
                [self.DataArr addObjectsFromArray:Dto.list];
                [self.tableView endFooterRefresh];
            }else{
                [self.tableView noMoreData];
            }
        }
        [self.tableView reloadData];
        
    } failure:^(BSRes *res) {
        
    }];
    
}
#pragma mark - UI
- (void)buildUI{
    
    self.tableView = [[BSBaseTableView alloc]initWithFrame:CGRectMake(0, 10, kSCREEN_WIDTH, kSCREEN_HEIGHT - 64 - 10) style:UITableViewStylePlain inOrginVc:self];
    self.tableView.delegate  = self;
    self.tableView.dataSource = self;
    self.tableView.bsDelegate = self;
    [self.view addSubview:self.tableView];
    
}
#pragma mark - BsTableViewRefresh
- (void)BsonRefreshing:(id)control{
    
    self.tableView.bspageIndex = 1;
    [self net_BSApi_getNineteenSpiritList];
}
- (void)BsonLoadingMoreData:(id)control pageNum:(NSNumber *)pageNum{
    self.tableView.bspageIndex++;
    [self net_BSApi_getNineteenSpiritList];
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
