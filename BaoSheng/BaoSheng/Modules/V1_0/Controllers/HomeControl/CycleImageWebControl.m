//
//  CycleImageWebControl.m
//  BaoSheng
//
//  Created by GML on 2018/4/27.
//  Copyright © 2018年 haozheng. All rights reserved.
//

#import "CycleImageWebControl.h"
#import "BSCycleImgeDetailDto.h"

@interface CycleImageWebControl ()

@end

@implementation CycleImageWebControl

- (void)viewDidLoad {
    [super viewDidLoad];
  
    [self net_BSApi_cycleInformationDetail];
}
#pragma mark - net
- (void)net_BSApi_cycleInformationDetail{
    
    NSDictionary *dic = @{@"id" :self.Id?:@""};
    BSAction *action = [BSAction instanceMethodPostWithApi:BSApi_cycleInformationDetail];
    action.paramsDic = dic.mutableCopy;
    
    [STSHUdHelper showLoadingWithLock:YES];
    WeakSelf
    [self sk_requestWithAction:action success:^(BSRes *res) {
        StrongSelf
        [STSHUdHelper hideLoading];
        
        BSCycleImgeDetailDto *Dto = [BSCycleImgeDetailDto mj_objectWithKeyValues:res.result];
        
        self.cycleDto = Dto;
        [self WebViewInit:Dto.contentUrl Frame:CGRectMake(0, 0, kSCREEN_WIDTH, kSCREEN_HEIGHT - kNavHeight) headStyle:WebViewHeader_Style_Home_cycle];
        
        
    } failure:^(BSRes *res) {
        [STSHUdHelper hideLoading];
        
    }];
    
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
