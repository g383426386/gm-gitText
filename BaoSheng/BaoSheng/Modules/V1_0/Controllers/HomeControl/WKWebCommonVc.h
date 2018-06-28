//
//  WKWebCommonVc.h
//  BaoSheng
//
//  Created by GML on 2018/4/28.
//  Copyright © 2018年 haozheng. All rights reserved.
//

#import "WKWebViewBaseViewController.h"
#import "BSInformationDetailDto.h"
#import "BSPartyMenberDetailDto.h"

@interface WKWebCommonVc : WKWebViewBaseViewController

//传入Id
@property (nonatomic , strong)NSNumber *Id;
@property (nonatomic , assign)WebViewHeader_Style webStyle;

@property (nonatomic , strong)BSInformationDetailDto *infoDetailDto;
@property (nonatomic , strong)BSPartyMenberDetailDto *learningDto;

@end
