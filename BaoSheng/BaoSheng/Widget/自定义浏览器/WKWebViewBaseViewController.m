//
//  WKWebViewBaseViewController.m
//  marketplatform
//
//  Created by kxkj on 16/7/6.
//  Copyright © 2016年 chenwei. All rights reserved.
//

#import "WKWebViewBaseViewController.h"


#define getCusInfo          @"getCusInfo"                       //H5获取验证信息回调方法（获取cus-info）
#define getCityInfo         @"chooseAddress"                    //H5获取获取城市信息回调方法
#define getPhoneAndFaceCoin @"getPhoneAndFaceCoin"              //H5获取电话和尖椒币余额
#define goHome              @"goHome"                           //返回首页
#define rechargeFaceCoin    @"rechargeFaceCoin"                 //前往充值页面
#define refreshWearHome     @"refreshWearHome"                  //刷新页面
#define welfareShare        @"share"                   //分享
#define rightTitle          @"rightTitle"              //右边标题
#define copyText            @"copyText"                // 复制内容
#define getUserLevel        @"getUserLevel"            //回传颜值等级
#define getUserInfo         @"getUserInfo"             //获取用户信息
#define initShare           @"initShare"               //获取分享信息
#define webTest             @"test"                    //服务器验证



@interface WKWebViewBaseViewController ()

{
    UIButton *_leftButton1;//导航栏左边关闭按钮
    UIButton *_rightButton;//导航栏右边按钮
    BOOL _isChange;
    BOOL _rightType;//右上角按钮类型（YES 分享，NO返回首页）
    
}

@property (nonatomic, assign ) int                    cityMenber;
@property (nonatomic, assign ) int                    proviceMenber;
@property (nonatomic, strong ) NSMutableDictionary    *addresDic;
@property (nonatomic, strong ) NSDictionary           *orgDic; //原数据
@property (nonatomic, strong ) NSMutableString        *webUrl; //用于存储更换的链接
@property (nonatomic, strong ) WKWebViewConfiguration *config;
@property (nonatomic, assign ) BOOL                   isAddScript;

@property (nonatomic , assign)CGRect cusFrame;

@end

@implementation WKWebViewBaseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
//    [self WebViewInit:self.mainUrl Frame:self.view.frame];
    self.st_disabledPanPop = YES;
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];

}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    [self removeScriptMessageHandler];
}


-(void)WebViewInit:(NSString*)url Frame:(CGRect)rect headStyle:(WebViewHeader_Style)style
{
    self.mainUrl = [NSMutableString stringWithString:url?:@""];
    self.cusFrame = rect;
    
     BSWebViewHeader *header = nil;
    if (style == WebViewHeader_Style_Messge) {
        
        header  = [[BSWebViewHeader alloc]init];
        [self.view addSubview:header];
        header.titlelb_.text = self.messgeDto.title;
        header.leftTimelb_.text = [self turnDateFromTimeInteval:[self.messgeDto.publishTime doubleValue]];
        if (self.messgeDto.informFor.integerValue == 1) {
            header.partymenberlb_.hidden = NO;
        }else{
            header.partymenberlb_.hidden = YES;
        }
        
        header.top = 0;
        header.f_left = 0;
    }else if (style == WebViewHeader_Style_Home_cycle){
        header  = [[BSWebViewHeader alloc]init];
        [self.view addSubview:header];
        header.titlelb_.text = self.cycleDto.title;
        header.ringtTimelb_.text = [self turnDateFromTimeInteval:[self.cycleDto.publishDate doubleValue]];
        if (self.messgeDto.informFor.integerValue == 1) {
            header.partymenberlb_.hidden = NO;
        }else{
            header.partymenberlb_.hidden = YES;
        }
        
        header.top = 0;
        header.f_left = 0;
    }
    
     [self.view addSubview:self.webView];
    
    WeakSelf
    [self.webView mas_updateConstraints:^(MASConstraintMaker *make) {
        StrongSelf
        make.left.equalTo(self.view.mas_left);
        make.right.equalTo(self.view.mas_right);
        make.top.equalTo(header ? header.mas_bottom:self.view.mas_top);
        make.bottom.equalTo(self.view.mas_bottom);
    }];

    //传入header信息
    
    //js注入Cookie
//    NSString * cookie = [NSString stringWithFormat:@"document.cookie='%@'",@"ceshi"];
//    WKUserScript * cookieScript = [[WKUserScript alloc] initWithSource:cookie
//                                                        injectionTime:WKUserScriptInjectionTimeAtDocumentStart
//                                                        forMainFrameOnly:NO];
//    [self.webView.configuration.userContentController addUserScript:cookieScript];
    
    
    // 添加进入条
    self.progressView = [[UIProgressView alloc] init];
    //--------------add -gml --------↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓
    self.progressView.frame = CGRectMake(0, 0, kSCREEN_WIDTH, 0);
    self.progressView.tintColor = kappButtonBackgroundColor;
    self.progressView.trackTintColor = kappButtonBackgroundColor;
    //--------------add -gml -------↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑
    
    [self.view addSubview:self.progressView];
    
    [self webBegienload_url:self.mainUrl];
    
}

- (void)webBegienload_url:(NSString *)url{
    //请求头传入cookie
    NSURL * requestUrl = [NSURL URLWithString:url];
    
    NSMutableURLRequest * req=  [NSMutableURLRequest requestWithURL:requestUrl];
    //    [req setValue:@"ceshi" forHTTPHeaderField:@"Cookie"];
    [self.webView loadRequest:req];
    
}


- (void)addScriptMessageHandler
{
    
    if (!self.isAddScript) {
        // 通过JS与webview内容交互
        [self.config.userContentController addScriptMessageHandler:self name:getCusInfo];
        self.isAddScript = YES;
    }
}

- (void)removeScriptMessageHandler
{
    if (self.isAddScript) {
        [self.config.userContentController removeScriptMessageHandlerForName:getCusInfo];
       
        self.isAddScript = NO;
    }
}

//--------------add -gml --------↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓
// 计算webView进度条
- (void)setLoadCount:(NSUInteger)loadCount {
    _loadCount = loadCount;
//    if (loadCount == 0) {
//        self.progressView.hidden = YES;
//        [self.progressView setProgress:0 animated:NO];
//    }else {
//        self.progressView.hidden = NO;
//        CGFloat oldP = self.progressView.progress;
//        CGFloat newP = (1.0 - oldP) / (loadCount + 1) + oldP;
//        if (newP > 0.95) {
//            newP = 0.95;
//        }
//        [self.progressView setProgress:newP animated:YES];
//    }
}

- (void)dealloc{
    
    [self.webView removeObserver:self forKeyPath:@"loading"];
    [self.webView removeObserver:self forKeyPath:@"title"];
    [self.webView removeObserver:self forKeyPath:@"estimatedProgress"];

}
//--------------add -gml -------↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑

- (void)goback
{
    
    if ([self.webView canGoBack]) {
        [self.webView goBack];
    }
}

- (void)gofarward
{
    
    if ([self.webView canGoForward]) {
        [self.webView goForward];
    }
}


#pragma mark - WKScriptMessageHandler

/** 代理方法二 */
- (void)userContentController:(WKUserContentController *)userContentController
      didReceiveScriptMessage:(WKScriptMessage *)message {
    
    if ([message.name isEqualToString:copyText]) {
            UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
            pasteboard.string = message.body[@"text"];
        
    }
    
  
    
    if ([message.name isEqualToString:webTest]) {
        [self webTestWith:message];
    }
    
    if ([message.name isEqualToString:initShare]) {
    
        
        
        
    }else if ([message.name isEqualToString:rightTitle]) {
        
        _rightType = NO;
        
    }else{
  
        _rightButton.hidden = YES;

       
    }
}


#pragma mark - KVO
- (void)observeValueForKeyPath:(NSString *)keyPath
                      ofObject:(id)object
                        change:(NSDictionary<NSString *,id> *)change
                       context:(void *)context {
    
    if ([keyPath isEqualToString:@"loading"]) {
        //NSLog(@"loading");
    } else if ([keyPath isEqualToString:@"title"]) {
        self.navigationItem.title =  self.enableShowTitle ?self.webView.title:@"";
    } else if ([keyPath isEqualToString:@"estimatedProgress"]) {
        
        //NSLog(@"progress: %f", self.webView.estimatedProgress);
        
        //--------------add -gml --------↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓
        CGFloat newprogress = [[change objectForKey:NSKeyValueChangeNewKey] doubleValue];

            if (newprogress == 1) {
                self.progressView.hidden = YES;
                [self.progressView setProgress:0 animated:NO];
                
            }else {
                
                self.progressView.hidden = NO;
                [self.progressView setProgress:newprogress animated:YES];
                
            }
        //--------------add -gml -------↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑
        
    }
    
    if (!self.webView.loading) {
        // 手动调用JS代码
        
        if ([self.webView canGoBack]) {
            _leftButton1.hidden = NO;
        }
         //--------------add -gml --------↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓
        self.progressView.hidden = YES;
        //--------------add -gml -------↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑
        
//        [UIView animateWithDuration:0.5 animations:^{
//            self.progressView.alpha = 0;
//        }];
    }
}

#pragma mark - WKNavigationDelegate
/**
 代理方法三：
 请求开始前，会先调用此代理方法，与UIWebView的
 - (BOOL)webView:(UIWebView *)webView
 shouldStartLoadWithRequest:(NSURLRequest *)request
 navigationType:(UIWebViewNavigationType)navigationType;
 方法类似，此方法在上篇博客中分析过
 */


- (void)webView:(WKWebView *)webView decidePolicyForNavigationAction:(WKNavigationAction *)navigationAction decisionHandler:(void (^)(WKNavigationActionPolicy))decisionHandler {
    NSString *hostname = navigationAction.request.URL.host.lowercaseString;
    if (navigationAction.navigationType == WKNavigationTypeLinkActivated
        && ![hostname containsString:@".lanou.com"]) {
        // 对于跨域，需要手动跳转
        //[[UIApplication sharedApplication] openURL:navigationAction.request.URL];
        [self.webView loadRequest:[NSURLRequest requestWithURL:navigationAction.request.URL]];
        // 不允许web内跳转
        decisionHandler(WKNavigationActionPolicyCancel);
    } else {
//        self.progressView.alpha = 1.0;
        decisionHandler(WKNavigationActionPolicyAllow);
    }
    
//    NSLog(@"%s", __FUNCTION__);
    
}


/**
 代理方法五：
 在响应完成时，会回调此方法
 如果设置为不允许响应，web内容就不会传过来
 */
- (void)webView:(WKWebView *)webView decidePolicyForNavigationResponse:(WKNavigationResponse *)navigationResponse decisionHandler:(void (^)(WKNavigationResponsePolicy))decisionHandler {
    decisionHandler(WKNavigationResponsePolicyAllow);
//    NSLog(@"%s", __FUNCTION__);
}


/**
 代理方法四
 开始导航跳转时会回调
 */
- (void)webView:(WKWebView *)webView didStartProvisionalNavigation:(null_unspecified WKNavigation *)navigation {
//    NSLog(@"%s", __FUNCTION__);
    
    if ([_rightButton.titleLabel.text isEqualToString:@"分享"]) {
        _rightButton.hidden = YES;
    }
    
}

// 接收到重定向时会回调
- (void)webView:(WKWebView *)webView
didReceiveServerRedirectForProvisionalNavigation:(null_unspecified WKNavigation *)navigation {
//    NSLog(@"%s", __FUNCTION__);
}


// 导航失败时会回调
- (void)webView:(WKWebView *)webView
didFailProvisionalNavigation:(null_unspecified WKNavigation *)navigation withError:(NSError *)error {
//    NSLog(@"%s", __FUNCTION__);
}


/**
 代理方法六：
 页面内容到达main frame时回调
 */
- (void)webView:(WKWebView *)webView didCommitNavigation:(null_unspecified WKNavigation *)navigation {
//    NSLog(@"%s", __FUNCTION__);
}


/**
 代理方法七：
 导航完成时，会回调（也就是页面载入完成了）
 */
- (void)webView:(WKWebView *)webView didFinishNavigation:(null_unspecified WKNavigation *)navigation {
//    NSLog(@"%s", __FUNCTION__);
//    NSLog(@"----*** web url -%@",webView.URL);
    //如果是主页，就让右边bottom出来
    NSURL   * nowUrl = [NSURL URLWithString:self.mainUrl];
    if ([webView.URL isEqual:nowUrl]) {
        
        if (![_rightButton.titleLabel.text isEqualToString:@"分享"]) {
            _rightButton.hidden = NO;
        }
    }
    
}


// 导航失败时会回调
- (void)webView:(WKWebView *)webView didFailNavigation:(null_unspecified WKNavigation *)navigation withError:(NSError *)error {
//    NSLog(@"%s", __FUNCTION__);
  
    
}
// 对于HTTPS的都会触发此代理，如果不要求验证，传默认就行
// 如果需要证书验证，与使用AFN进行HTTPS证书验证是一样的
- (void)webView:(WKWebView *)webView didReceiveAuthenticationChallenge:(NSURLAuthenticationChallenge *)challenge completionHandler:(void (^)(NSURLSessionAuthChallengeDisposition disposition,NSURLCredential *__nullable credential))completionHandler {
//    NSLog(@"%s", __FUNCTION__);
    completionHandler(NSURLSessionAuthChallengePerformDefaultHandling, nil);
}


// 9.0才能使用，web内容处理中断时会触发
- (void)webViewWebContentProcessDidTerminate:(WKWebView *)webView {
//    NSLog(@"%s", __FUNCTION__);
}

#pragma mark - WKUIDelegate
- (void)webViewDidClose:(WKWebView *)webView {
//    NSLog(@"%s", __FUNCTION__);
}


/** 代理方法一 */
// 在JS端调用alert函数时，会触发此代理方法。
// JS端调用alert时所传的数据可以通过message拿到
// 在原生得到结果后，需要回调JS，是通过completionHandler回调
- (void)webView:(WKWebView *)webView runJavaScriptAlertPanelWithMessage:(NSString *)message initiatedByFrame:(WKFrameInfo *)frame completionHandler:(void (^)(void))completionHandler {
    
//    NSLog(@"%s", __FUNCTION__);
    NSLog(@"------>%@", message);
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"alert" message:message preferredStyle:UIAlertControllerStyleAlert];
    [alert addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        completionHandler();
    }]];
    
    [self presentViewController:alert animated:YES completion:NULL];
}
//
//// JS端调用confirm函数时，会触发此方法
//// 通过message可以拿到JS端所传的数据
//// 在iOS端显示原生alert得到YES/NO后
//// 通过completionHandler回调给JS端
//- (void)webView:(WKWebView *)webView
//runJavaScriptConfirmPanelWithMessage:(NSString *)message
//initiatedByFrame:(WKFrameInfo *)frame
//completionHandler:(void (^)(BOOL result))completionHandler {
//    NSLog(@"%s", __FUNCTION__);
//
//}
//
//
//// JS端调用prompt函数时，会触发此方法
//// 要求输入一段文本
//// 在原生输入得到文本内容后，通过completionHandler回调给JS
- (void)webView:(WKWebView *)webView runJavaScriptTextInputPanelWithPrompt:(NSString *)prompt defaultText:(nullable NSString *)defaultText initiatedByFrame:(WKFrameInfo *)frame completionHandler:(void (^)(NSString * __nullable result))completionHandler {
//    NSLog(@"%s", __FUNCTION__);
}
-(void)setDefaultNavBackItemClicked:(UIButton *)sender{
    

    
    if (sender.tag == 500) {//点击返回按钮
        if ([self.webView canGoBack]) {
            [self.webView goBack];
        }
        else{
            [self.navigationController popViewControllerAnimated:YES];
        }
    }else{//点击关闭按钮
        [self.navigationController popViewControllerAnimated:YES];
    }
    
    
    
}

#pragma mark -- 服务器回调方法

//服务器验证

- (void) webTestWith:(WKScriptMessage *) message
{
    
//    NSDictionary * dic = [AFResponseSerializer responseSerializerWithResponseData:message.body];
//    
//    NSString * postStr = [NSString stringWithFormat:@"%@()",dic[@"callBackJsFun"]];
//    
//    [self.webView evaluateJavaScript:postStr completionHandler:^(id _Nullable response, NSError * _Nullable error) {
//        //TODO
//        NSLog(@"%@ %@",response,error);
//        
//    }];
}

//刷新首页响应
- (void) refreshWearHomeWith:(WKScriptMessage *) message
{
    
}
//重写基类返回方法
- (void)configDefaultNavBack
{
    
    // 边距
    UIBarButtonItem *negativeSpacer = [[UIBarButtonItem alloc]
                                       initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace
                                       target:nil action:nil];
    negativeSpacer.width = -5.0; // 默认边距为 20 ，设置后 为15边距
    
    // 返回
    UIButton *leftButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [leftButton setFrame:CGRectMake(0, 0, 44.f, 44.f)];
    leftButton.tag = 500;
    [leftButton setImage:[UIImage imageNamed:@"return"] forState:UIControlStateNormal];
    [leftButton addTarget:self action:@selector(setDefaultNavBackItemClicked:) forControlEvents:UIControlEventTouchUpInside];
    [leftButton sizeToFit];
    UIBarButtonItem *leftItem = [[UIBarButtonItem alloc] initWithCustomView:leftButton];
    
    // 关闭
    UIImage *image1 = [UIImage imageNamed:@"nav_close"];
    _leftButton1 = [UIButton buttonWithType:UIButtonTypeCustom];
    [_leftButton1 setFrame:CGRectMake(leftButton.f_right , 0, 25, 44)];
    [_leftButton1 setImage:image1 forState:UIControlStateNormal];
    _leftButton1.tag = 501;
    _leftButton1.hidden = YES;
    [_leftButton1 addTarget:self action:@selector(setDefaultNavBackItemClicked:) forControlEvents:UIControlEventTouchUpInside];
    [_leftButton1 sizeToFit];
    UIBarButtonItem *leftItem1 = [[UIBarButtonItem alloc] initWithCustomView:_leftButton1];
    
    
    if (self.parentViewController && (![self.parentViewController isKindOfClass:[UINavigationController class]] && ![self.parentViewController isKindOfClass:[UITabBarController class]]) ) {
        [self.parentViewController.navigationItem setLeftBarButtonItems:@[negativeSpacer,leftItem,leftItem1]];
    }else{
        [self.navigationItem setLeftBarButtonItems:@[negativeSpacer,leftItem,leftItem1]];
    }
    
}


- (NSString *)turnDateFromTimeInteval:(double)timeInterval{
    
    NSDate*detaildate=[NSDate dateWithTimeIntervalSince1970:timeInterval/1000];
    NSDateFormatter*dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm"];
    
    NSString * currentDateStr = [dateFormatter stringFromDate:detaildate];
    
    return currentDateStr;
}


#pragma mark - Getter
- (WKWebView *)webView{
    
    if (!_webView) {
        self.config = [[WKWebViewConfiguration alloc] init];
        self.config.userContentController = [[WKUserContentController alloc] init];
        
        // 设置偏好设置
        self.config.preferences = [[WKPreferences alloc] init];
        //        config.applicationNameForUserAgent = @"TTZCMobile/1.0";
        // web内容处理池
        //        config.processPool = [[WKProcessPool alloc] init];
        
        _webView = [[WKWebView alloc] initWithFrame:self.cusFrame configuration:self.config];
        _webView.allowsBackForwardNavigationGestures = YES;
        // 导航代理
        _webView.navigationDelegate = self;
        // 与webview UI交互代理
        _webView.UIDelegate = self;
        _webView.scrollView.showsHorizontalScrollIndicator = NO;
        
        // 添加js
        [self addScriptMessageHandler];
        
        // 添加KVO监听
        [_webView addObserver:self
                       forKeyPath:@"loading"
                          options:NSKeyValueObservingOptionNew
                          context:nil];
        [_webView addObserver:self
                       forKeyPath:@"title"
                          options:NSKeyValueObservingOptionNew
                          context:nil];
        [_webView addObserver:self
                       forKeyPath:@"estimatedProgress"
                          options:NSKeyValueObservingOptionNew
                          context:nil];
    }
    
    return _webView;
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
