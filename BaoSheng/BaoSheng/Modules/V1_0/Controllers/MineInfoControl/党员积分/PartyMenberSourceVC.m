//
//  PartyMenberSourceVC.m
//  BaoSheng
//
//  Created by GML on 2018/4/26.
//  Copyright © 2018年 haozheng. All rights reserved.
//

#import "PartyMenberSourceVC.h"
#import "BSSourceCell.h"
#import "BSPartymenberSourceDto.h"

@interface PartyMenberSourceVC ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic , strong)BSBaseTableView *tableView;
@property (nonatomic , strong)NSMutableArray *dataArr;

@property (nonatomic , strong)BSPartymenberSourceDto *partMenberSourceDto;

@end

@implementation PartyMenberSourceVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = @"党员积分";
    
    [self net_BSApi_partyManIntegral];
}
#pragma mark - Net
- (void)net_BSApi_partyManIntegral{
    
    NSDictionary *dic = @{@"userId" :BSContext_shareInstance.currentUser.Id};
    BSAction *action = [BSAction instanceMethodPostWithApi:BSApi_partyManIntegral];
    action.paramsDic = dic.mutableCopy;
    
    [STSHUdHelper showLoadingWithLock:NO];
    WeakSelf
    [self sk_requestWithAction:action success:^(BSRes *res) {
        StrongSelf
        [STSHUdHelper hideLoading];
        
        self.partMenberSourceDto = [BSPartymenberSourceDto mj_objectWithKeyValues:res.result];
        
        [self buildUI];
        
        
    } failure:^(BSRes *res) {
        [STSHUdHelper hideLoading];
    }];
    
    
}
#pragma mark - UI
- (void)buildUI{
    
    _tableView  = [[BSBaseTableView alloc]initWithFrame:CGRectMake(0, 0, kSCREEN_WIDTH, kSCREEN_HEIGHT - kNavHeight) style:UITableViewStylePlain inOrginVc:self];
    [self.view addSubview:_tableView];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.openfooter = NO;
    _tableView.openHeader = NO;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    NSMutableArray *cellData = [@[]mutableCopy];
    for (hyqdDto *Dto in self.partMenberSourceDto.hyqd) {
        fpjlDto *fpDto = [fpjlDto new];
        fpDto.explanation = @"会议签到";
        fpDto.type = 1;
        fpDto.integral = Dto.integral;
        fpDto.createDate = [self turnDateFromTimeInteval:[Dto.createDate doubleValue]];
        [cellData addObject:fpDto];
    }
    [self.partMenberSourceDto.fpjl enumerateObjectsUsingBlock:^(fpjlDto * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        obj.explanation = @"扶贫互助";
        obj.createDate = [self turnDateFromTimeInteval:[obj.createDate doubleValue]];
        
        [cellData addObject:obj];
    }];
    if (cellData.count) {
        _tableView.tableHeaderView = [self buildTableViewheaderNeedSource:YES];
        self.dataArr = cellData.mutableCopy;
    }else{
        _tableView.tableHeaderView = [self buildTableViewheaderNeedSource:NO];
    }
    
}
- (UIView *)buildTableViewheaderNeedSource:(BOOL)needSource{
    
    UIView *bgview = [UIView new];
    bgview.backgroundColor = kappBackgroundColor;
    bgview.f_width = kSCREEN_WIDTH;
    
    STSCustomCell *cell = [[STSCustomCell alloc]initWithFrame:CGRectMake(0, 10, kSCREEN_WIDTH, 52) index:10 delegate:nil];
    [bgview addSubview:cell];
    cell.titlelb.text = @"党员姓名";
    cell.arrowdImg.hidden = YES;
    cell.deslb.textColor = rgb(102, 102, 102);
    cell.deslb.f_right = cell.f_width - 15;
    
    STSCustomCell *cell1 = [[STSCustomCell alloc]initWithFrame:CGRectMake(0, cell.f_bottom +1, kSCREEN_WIDTH, 52) index:10 delegate:nil];
    [bgview addSubview:cell1];
    cell1.titlelb.text = @"当前积分";
    cell1.arrowdImg.hidden = YES;
    cell1.deslb.textColor = rgb(102, 102, 102);
    cell1.deslb.f_right = cell.f_width - 15;
    
    STSCustomCell *cell2 = [[STSCustomCell alloc]initWithFrame:CGRectMake(0, cell1.f_bottom +1, kSCREEN_WIDTH, 52) index:10 delegate:nil];
    [bgview addSubview:cell2];
    cell2.titlelb.text = @"当前星级";
    cell2.arrowdImg.hidden = YES;
    cell2.deslb.hidden = YES;
    
    for (int i = 0; i < 5; i++) {
        UIImageView *startImage = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"greystar"]];
        [cell2 addSubview:startImage];
        startImage.f_centerY = cell2.f_height/2;
        startImage.f_right = kSCREEN_WIDTH - (i * startImage.f_width) -  (i * 5) -15;
        
    }
    
    if (needSource) {
        UIView *sourceView = [self buildSectionViewWithTitle:@"积分详情"];
        [bgview addSubview:sourceView];
        sourceView.backgroundColor = kWhiteColor;
        sourceView.f_left = 0;
        sourceView.f_top = cell2.f_bottom + 10;
        
        bgview.f_height = sourceView.f_bottom;
    }else{
        bgview.f_height = cell2.f_bottom + 10;
    }
    cell.deslb.text = self.partMenberSourceDto.dyName;
    cell1.deslb.text = [NSString stringWithFormat:@"%@",self.partMenberSourceDto.grades?:@0];
//    cell2
    
    
    return bgview;
}
- (UIView *)buildSectionViewWithTitle:(NSString *)title{
    
    UIView *sectionView = [UIView new];
    sectionView.f_width = kSCREEN_WIDTH;
    sectionView.f_height = 44;
    sectionView.backgroundColor = kWhiteColor;
    
    UIView *leftView = [UIView new];
    [sectionView addSubview:leftView];
    leftView.f_width = 3;
    leftView.f_height = sectionView.f_height - 30;
    leftView.backgroundColor = kRedColor;
    leftView.f_centerY = sectionView.f_height/2;
    leftView.f_left = 15;
    
    UILabel *titlelb = [UILabel new];
    [sectionView addSubview:titlelb];
    titlelb.font = FONTSize(18);
    titlelb.textColor =  kappTextColorDrak;
    titlelb.text = title;
    [titlelb sizeToFit];
    titlelb.f_centerY = leftView.f_centerY;
    titlelb.f_left = leftView.f_right + 15;
    
//    UIButton  *moreBtn = [UIButton buttonWithType:UIButtonTypeCustom];
//    [sectionView addSubview:moreBtn];
//    moreBtn.titleLabel.font = FONTSize(13);
//    [moreBtn setTitleColor:kappTextColorlingtGray forState:UIControlStateNormal];
//    [moreBtn setTitle:@"更多 >" forState:UIControlStateNormal];
//    [moreBtn sizeToFit];
//
//    [sectionView addSubview:moreBtn];
//    moreBtn.f_centerY = titlelb.f_centerY;
//    moreBtn.f_right = sectionView.f_width - 20;
    
    return sectionView;
}

#pragma mark - UITableViewDelegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataArr.count;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 30.f;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *cellIdentfer_sourcecell = @"BSSourceCell";
    BSSourceCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentfer_sourcecell];
    if (!cell) {
        cell = [[NSBundle mainBundle]loadNibNamed:cellIdentfer_sourcecell owner:self options:nil].firstObject;
    }
    
    fpjlDto *Dto = self.dataArr[indexPath.row];
    
    cell.leftlb_.text = Dto.explanation;
    cell.midllelb_.text = Dto.createDate;
    
    if (Dto.type == 2) {//减分
        cell.ringhtlb_.textColor = rgb(230, 0, 0);
        cell.ringhtlb_.text = [NSString stringWithFormat:@"积分-%@",Dto.integral];
    }else{
        cell.ringhtlb_.textColor = rgb(3, 179, 24);
        cell.ringhtlb_.text = [NSString stringWithFormat:@"积分+%@",Dto.integral];
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
