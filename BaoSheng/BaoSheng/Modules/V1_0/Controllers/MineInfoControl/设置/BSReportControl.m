//
//  BSReportControl.m
//  BaoSheng
//
//  Created by GML on 2018/5/3.
//  Copyright © 2018年 haozheng. All rights reserved.
//

#import "BSReportControl.h"
#import <YYText/YYTextView.h>

@interface BSReportControl ()<YYTextViewDelegate>


@property (nonatomic , strong)YYTextView *DesTextView;
@property (nonatomic , strong)UILabel    *Numlb;

@end

@implementation BSReportControl

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = @"反馈";
    [self setNavRightItemWithTitle:@"提交" titleColor:kappButtonBackgroundColor fontsize:14 selector:@selector(navRinghtItemCLick)];
    [self buildUI];
}
- (void)navRinghtItemCLick{
    
    if ([GmWidget isEmpty:_DesTextView.text]) {
        [STSHUdHelper st_toastMsg:@"请输入内容" completion:nil];
        return;
    }
    
    [self net_BSApi_opinionFeedback];
}
#pragma mark - Net
- (void)net_BSApi_opinionFeedback{
    
    NSDictionary *dic = @{@"content":_DesTextView.text,
                          @"userId" :BSContext_shareInstance.currentUser.Id
                          };
    
    BSAction *action = [BSAction instanceMethodPostWithApi:BSApi_opinionFeedback];
    action.paramsDic = dic.mutableCopy;
    
    [STSHUdHelper showLoadingWithLock:YES];
    WeakSelf
    [self sk_requestWithAction:action success:^(BSRes *res) {
        StrongSelf
        [STSHUdHelper hideLoading];
        [STSHUdHelper st_toastMsg:@"提交成功" completion:^{
            [self.navigationController popViewControllerAnimated:YES];
        }];
        
    } failure:^(BSRes *res) {
        [STSHUdHelper hideLoading];
    }];
    
}


#pragma mark - UI
- (void)buildUI{
    
    _DesTextView = [[YYTextView alloc] initWithFrame:CGRectMake(15, 15, kSCREEN_WIDTH - 30, 200)];
    [self.view addSubview:_DesTextView];
    _DesTextView.delegate = self;
    _DesTextView.backgroundColor = [UIColor whiteColor];
    _DesTextView.textColor = RGB(0, 0, 0);
    _DesTextView.font = FONTSize(14);
    _DesTextView.returnKeyType = UIReturnKeyDone;
    _DesTextView.placeholderFont = FONTSize(13);
    _DesTextView.textContainerInset = UIEdgeInsetsMake(10, 10, 10, 10);
    NSString * placeStr = @"请填写您宝贵的意见";
   
    
    _DesTextView.placeholderText = placeStr;
    _DesTextView.placeholderTextColor = RGB(128, 130, 141);
    
    _Numlb = [UILabel new];
    [self.view addSubview:_Numlb];
    _Numlb.font = FONTSize(13);
    _Numlb.text = [NSString stringWithFormat:@"%lu/250",_DesTextView.text.length];
    _Numlb.width = 80;
    _Numlb.height = 15;
    _Numlb.textColor = rgb(153, 153, 153);
    _Numlb.textAlignment = NSTextAlignmentRight;
    _Numlb.right = self.view.width - 15;
    _Numlb.f_top = _DesTextView.f_bottom + 15;
    
    
}

#pragma mark - YYTextViewDelegate
- (void)textViewDidChange:(YYTextView *)textView{
    NSString *toBeString = textView.text;
    if (textView.text.length > 250) {
        toBeString = [toBeString substringToIndex:250];
    }
    textView.text = toBeString;
    _Numlb.text = [NSString stringWithFormat:@"%lu/100",(unsigned long)toBeString.length];
    
}

- (void)textViewDidEndEditing:(YYTextView *)textView{
    _Numlb.text = [NSString stringWithFormat:@"%lu/100",(unsigned long)textView.text.length];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
