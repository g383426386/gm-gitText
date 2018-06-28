//
//  WKWebViewBaseViewController.h
//  marketplatform
//
//  Created by kxkj on 16/7/6.
//  Copyright © 2016年 chenwei. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <WebKit/WebKit.h>
#import "BSBaseControl.h"
#import "BSWebViewHeader.h"
#import "BSMessageDetailDto.h"
#import "BSCycleImgeDetailDto.h"

typedef enum : NSUInteger {
    WebViewHeader_Style_None,
    WebViewHeader_Style_Messge,//通知详情
    WebViewHeader_Style_Home_cycle,//首页轮播
    WebViewHeader_Style_Home_Info,//资讯
    WebViewHeader_Style_Certf,//办证
    WebViewHeader_Style_HeaderAndFooter,//党员学习 
} WebViewHeader_Style;

@interface WKWebViewBaseViewController : BSBaseControl <WKScriptMessageHandler, WKNavigationDelegate, WKUIDelegate>

@property (nonatomic, strong) WKWebView       *webView;
@property (nonatomic,strong ) NSMutableString * mainUrl; //主 url，记录第一次的请求url
@property (nonatomic, strong) UIProgressView  *progressView;
@property (assign, nonatomic) NSUInteger      loadCount;

@property (nonatomic , strong)BSMessageDetailDto *messgeDto;
@property (nonatomic , strong)BSCycleImgeDetailDto *cycleDto;
/** 是否显示title */
@property (nonatomic , assign)BOOL enableShowTitle;


-(void)WebViewInit:(NSString*)url Frame:(CGRect)rect headStyle:(WebViewHeader_Style)style;
- (void)webBegienload_url:(NSString *)url;

-(void)goback;
-(void)gofarward;
-(void)setDefaultNavBackItemClicked:(UIButton *)sender;
@end
