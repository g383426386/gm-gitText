//
//  BSSubStudyListVc.m
//  BaoSheng
//
//  Created by GML on 2018/4/28.
//  Copyright © 2018年 haozheng. All rights reserved.
//

#import "BSSubStudyListVc.h"
#import "SubStudyListCell.h"
#import "BSSubStudyListDto.h"
#import "WKWebCommonVc.h"

@interface BSSubStudyListVc ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic , strong)BSBaseTableView *tableView;
@property (nonatomic , strong)NSMutableArray *DataArr;

@property (nonatomic , strong)UILabel *hasStudylb;
@property (nonatomic , strong)UIView *headView;

@end

@implementation BSSubStudyListVc

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initData];
    [self buildUI];
    [self net_BSApi_learnList];
}
- (void)initData{
    
    self.DataArr = [@[]mutableCopy];
}

#pragma mark - Net
- (void)net_BSApi_learnList{
    
    NSDictionary *dic = @{@"userId" :BSContext_shareInstance.currentUser.Id,
                          @"learningTypeId" :self.learningTypeId
                          };
    BSAction *action = [BSAction instanceMethodPostWithApi:BSApi_learnList];
    action.paramsDic =dic.mutableCopy;
    [STSHUdHelper showLoadingWithLock:NO];
    WeakSelf
    [self sk_requestWithAction:action success:^(BSRes *res) {
        StrongSelf
        [STSHUdHelper hideLoading];
        
        BSSubStudyListDto *Dto = [BSSubStudyListDto mj_objectWithKeyValues:res.result];
        self.DataArr = Dto.learnList;
        
        self.headView = [self buildHeader:Dto];
        [self.view addSubview:self.headView];
        self.tableView.f_top = self.headView.f_bottom + 10;
        self.tableView.f_height = self.tableView.f_height - self.headView.f_height  - 10;
        [self.tableView reloadData];
        
        
    } failure:^(BSRes *res) {
        
        [STSHUdHelper hideLoading];
    }];
    
    
}

#pragma mark - UI
- (void)buildUI{
    
    self.tableView = [[BSBaseTableView alloc]initWithFrame:CGRectMake(0, 0, kSCREEN_WIDTH, kSCREEN_HEIGHT - 64 - 0) style:UITableViewStylePlain inOrginVc:nil];
    self.tableView.delegate  = self;
    self.tableView.dataSource = self;
//    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:self.tableView];
}
- (UIView *)buildHeader:(BSSubStudyListDto *)dto{
    
    UIView *headView = [UIView new];
    headView.backgroundColor = kWhiteColor;
    headView.f_width = kSCREEN_WIDTH;
    headView.f_height = 44;
    
    UIView *lineView  = [UIView new];
    [headView addSubview:lineView];
    lineView.f_width  = 1.f;
    lineView.f_height = 15;
    lineView.backgroundColor = kappTextColorlingtGray;
    lineView.f_centerX = headView.f_width/2;
    lineView.f_centerY = headView.f_height/2;
    
    UILabel *totallb = [UILabel new];
    [headView addSubview:totallb];
    totallb.font = FONTSize(15);
    totallb.textColor = kappTextColorDrak;
    totallb.f_width = headView.f_width/2 - 10;
    totallb.f_height = 18;
    totallb.textAlignment = NSTextAlignmentCenter;
    totallb.f_centerX = lineView.f_left /2;
    totallb.f_centerY = headView.f_height/2;
    
    UILabel *hasDownlb = [UILabel new];
    [headView addSubview:hasDownlb];
    hasDownlb.font = FONTSize(15);
    hasDownlb.textColor = kappTextColorDrak;
    hasDownlb.f_width = headView.f_width/2 - 10;
    hasDownlb.f_height = 18;
    hasDownlb.textAlignment = NSTextAlignmentCenter;
    hasDownlb.f_centerX =  lineView.f_right +  lineView.f_left /2;
    hasDownlb.f_centerY = headView.f_height/2;
    
    self.hasStudylb = hasDownlb;
    
    NSString *totalNum = [NSString stringWithFormat:@"%@",dto.count?:@0];
    NSString *totalStr = [NSString stringWithFormat:@"全部%@篇",totalNum];
    NSMutableAttributedString *totalAttri = [[NSMutableAttributedString alloc]initWithString:totalStr];
    [totalAttri addAttribute:NSForegroundColorAttributeName value:kappTextColorlingtGray range:NSMakeRange([totalStr rangeOfString:totalNum].location, totalNum.length)];
    totallb.attributedText = totalAttri;
    
    NSString *hasDownNum = [NSString stringWithFormat:@"%@",dto.learnEndCount?:@0];
    NSString *hasDownStr = [NSString stringWithFormat:@"已学%@篇",hasDownNum];
    NSMutableAttributedString *hasDownAttri = [[NSMutableAttributedString alloc]initWithString:hasDownStr];
    [hasDownAttri addAttribute:NSForegroundColorAttributeName value:rgb(230, 0, 0) range:NSMakeRange([hasDownStr rangeOfString:hasDownNum].location, hasDownNum.length)];
    self.hasStudylb.attributedText = hasDownAttri;
    
    return headView;
}

#pragma mark - UITableViewDelegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return self.DataArr.count;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 73;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    SubStudyListCell *cell = [tableView dequeueReusableCellWithIdentifier:@"SubStudyListCell"];
    if (!cell) {
        cell = [[NSBundle mainBundle]loadNibNamed:@"SubStudyListCell" owner:self options:nil].firstObject;
    }
 
    learnListDto *listDto = self.DataArr[indexPath.row];
    
    if (listDto.isEnd.integerValue == 1) {
        cell.statulb_.text = @"已完成学习";
        cell.statulb_.hidden = NO;
    }else{
        cell.statulb_.hidden = YES;
    }
    
    cell.titlelb_.text = listDto.title;
    cell.timelb_.text = [GmWidget dateFromTimeIntervalWithHHmm:[listDto.publishTime doubleValue]];

    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    learnListDto *listDto = self.DataArr[indexPath.row];
    
    WKWebCommonVc *Vc = [[WKWebCommonVc alloc]init];
    Vc.webStyle = WebViewHeader_Style_HeaderAndFooter;
    Vc.Id =listDto.Id;
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
