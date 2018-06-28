//
//  BSStudyRecordControl.m
//  BaoSheng
//
//  Created by GML on 2018/4/26.
//  Copyright © 2018年 haozheng. All rights reserved.
//

#import "BSStudyRecordControl.h"
#import "BSStudyRecordCell.h"

@implementation learenDto

@end

@interface BSStudyRecordControl ()<UITableViewDelegate,UITableViewDataSource,BsTableViewRefresh>

@property (nonatomic , strong)BSBaseTableView *tableView;
@property (nonatomic , strong)NSMutableArray *dataArr;

@end

@implementation BSStudyRecordControl

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"学习记录";
    
    [self buildUI];
    [self net_BSApi_learningRecord:YES];
}
#pragma mark - UI
- (void)net_BSApi_learningRecord:(BOOL)needShow{
        
    NSDictionary *dic = @{@"userId" :BSContext_shareInstance.currentUser.Id,
                          @"pageIndex" :@(self.tableView.bspageIndex),
                          @"pageSize"  :@20
                          };
    BSAction *action  = [BSAction instanceMethodPostWithApi:BSApi_learningRecord];
    action.paramsDic = dic.mutableCopy;
    
    if (needShow) {
       [STSHUdHelper showLoadingWithLock:NO];
    }
    WeakSelf
    [self sk_requestWithAction:action success:^(BSRes *res) {
       StrongSelf
        [STSHUdHelper hideLoading];
        
        NSArray *arr = [learenDto mj_objectArrayWithKeyValuesArray:res.result];
        
        for (int i = 0; i< arr.count; i++) {
            learenDto *dto  = arr[i];
            dto.createTime = [self turnDateFromTimeInteval:[dto.createTime doubleValue]];
        }
        
        if (self.tableView.bspageIndex == 1) {
            if (arr.count == 0) {
                [STSHUdHelper st_toastMsg:@"暂无学习记录" completion:^{
                    [self.navigationController popViewControllerAnimated:YES];
                }];
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
         [self.tableView noMoreData];
    }];
    
    
}


#pragma mark - UI
- (void)buildUI{
    
    _tableView  = [[BSBaseTableView alloc]initWithFrame:CGRectMake(0, 10, kSCREEN_WIDTH, kSCREEN_HEIGHT - kNavHeight -10) style:UITableViewStylePlain inOrginVc:self];
    [self.view addSubview:_tableView];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.bsDelegate = self;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
}
#pragma mark - BsTableViewRefresh
- (void)BsonRefreshing:(id)control{
    
    self.tableView.bspageIndex = 1;
    [self net_BSApi_learningRecord:NO];
    
}
- (void)BsonLoadingMoreData:(id)control pageNum:(NSNumber *)pageNum{
    
    self.tableView.bspageIndex++;
    [self net_BSApi_learningRecord:NO];
}
#pragma mark - UITableViewDelegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return self.dataArr.count;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 30;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    static  NSString *cellidentfer = @"BSStudyRecordCell";
    BSStudyRecordCell *cell = [tableView dequeueReusableCellWithIdentifier:cellidentfer];
    if (!cell) {
        cell = [[NSBundle mainBundle]loadNibNamed:cellidentfer owner:self options:nil].firstObject;
        
    }
    
    learenDto *Dto = self.dataArr[indexPath.row];
    cell.timelb_.text =  Dto.createTime;
    cell.midllelb_.text = Dto.title;
    if (Dto.isEnd == 1) {
        cell.ringhtlb_.textColor = rgb(3, 179, 24);
        cell.ringhtlb_.text = @"已完成";
    }else{
        cell.ringhtlb_.textColor = rgb(230, 0, 0);
        cell.ringhtlb_.text = @"未完成";
    }
    
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

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
