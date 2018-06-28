//
//  BSPartyMenberStudyListVc.m
//  BaoSheng
//
//  Created by GML on 2018/4/28.
//  Copyright © 2018年 haozheng. All rights reserved.
//

#import "BSPartyMenberStudyListVc.h"
#import "PartyStudyCell.h"
#import "BSSubStudyListVc.h"


@interface BSStudylistDto :BSBaseDto

@property (nonatomic , strong)NSString *typeName;
@property (nonatomic , strong)NSNumber *typeId;
@property (nonatomic , strong)NSString *typeCount;

@end

@implementation BSStudylistDto
@end

//党员学习列表
@interface BSPartyMenberStudyListVc ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic , strong)BSBaseTableView *tableView;
@property (nonatomic , strong)NSMutableArray *DataArr;

@property (nonatomic , strong)NSArray *colorImageArr;

@end

@implementation BSPartyMenberStudyListVc

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = @"党员学习";
    
    [self initData];
    [self buildUI];
    [self net_BSApi_learn];
    
}
- (void)initData{
    
    self.DataArr = [@[] mutableCopy];
    self.colorImageArr = @[@"orange1",@"orange2",@"orange4",@"yellow",@"green1",@"green2",@"green3"];
    
}
#pragma mark - Net
- (void)net_BSApi_learn{
    
    BSAction *action = [BSAction instanceMethodPostWithApi:BSApi_learn];
    action.paramsDic = @{}.mutableCopy;
    [STSHUdHelper showLoadingWithLock:NO];
    WeakSelf
    [self sk_requestWithAction:action success:^(BSRes *res) {
        StrongSelf
        [STSHUdHelper hideLoading];
        
        NSMutableArray *arr = [BSStudylistDto mj_objectArrayWithKeyValuesArray:res.result];
        
        self.DataArr  = arr;
        
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
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:self.tableView];
}
#pragma mark - UITableViewDelegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return self.DataArr.count;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 74;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    PartyStudyCell *cell = [tableView dequeueReusableCellWithIdentifier:@"PartyStudyCell"];
    if (!cell) {
        cell = [[NSBundle mainBundle]loadNibNamed:@"PartyStudyCell" owner:self options:nil].firstObject;
    }
    BSStudylistDto *listDto = self.DataArr[indexPath.row];
    cell.bookName_.text = listDto.typeName;
    cell.Numlb_.text = listDto.typeCount;
    
    NSInteger index = indexPath.row % 7;
    cell.ColorImge_.image = [UIImage imageNamed:self.colorImageArr[index]];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    BSStudylistDto *listDto = self.DataArr[indexPath.row];
    BSSubStudyListVc *Vc = [[BSSubStudyListVc alloc]init];
    Vc.learningTypeId = listDto.typeId;
    Vc.navigationItem.title = listDto.typeName;
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
