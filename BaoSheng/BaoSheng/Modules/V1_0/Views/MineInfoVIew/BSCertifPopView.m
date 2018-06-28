//
//  BSCertifPopView.m
//  BaoSheng
//
//  Created by GML on 2018/4/25.
//  Copyright © 2018年 haozheng. All rights reserved.
//

#import "BSCertifPopView.h"

@implementation BSCertifPopView
{
    CertifPop_style _style;
    
}

- (instancetype)initWithStyle:(CertifPop_style)Style
{
    self = [super init];
    if (self) {
        
        _style = Style;
        [self buildUI];
    }
    return self;
}

- (void)buildUI{
    
    self.backgroundColor = kWhiteColor;
    self.f_width = kSCREEN_WIDTH - (84 *wSCALE_WIDTH);
    self.f_height = self.f_width;
    self.layer.cornerRadius = 5.f;
    
    UIButton *closeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [self addSubview:closeBtn];
    [closeBtn setImage:[UIImage imageNamed:@"close"] forState:UIControlStateNormal];
    [closeBtn sizeToFit];
    closeBtn.f_top = 5;
    closeBtn.f_right = self.f_width - 10;
    [closeBtn addTarget:self action:@selector(closeBtnCLick:) forControlEvents:UIControlEventTouchUpInside];
    UIImageView *centerImage;
    
    if (_style == CertifPop_style_Suc) {
        centerImage = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"success"]];
    }else{
        centerImage = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"fail"]];
    }
    [self addSubview:centerImage];
    centerImage.f_centerX = self.f_width/2;
    centerImage.f_top = 75 *wSCALE_WIDTH;
    
    UILabel *certiflb = [UILabel new];
    [self addSubview:certiflb];
    certiflb.font = FONTSize(24);
    certiflb.textColor = rgb(230, 0, 0);
    certiflb.text = @"认证失败";
    [certiflb sizeToFit];
    certiflb.f_centerX = centerImage.f_centerX;
    certiflb.f_top = centerImage.f_bottom + (15*wSCALE_WIDTH);
    
    NSString *failStr = @"信息错误，或你所属的支部暂未入住本平台";
    NSString *sucessStr = @"你隶属于中共宝胜村党支部第二小组";
    
    UILabel *bottomlb = [UILabel new];
    [self addSubview:bottomlb];
    bottomlb.font = FONTSize(14);
    bottomlb.textColor = rgb(102, 102, 102);
    bottomlb.f_width = self.f_width - (35 *wSCALE_WIDTH * 2);
    bottomlb.numberOfLines = 2;
    bottomlb.textAlignment = NSTextAlignmentCenter;
   
    
     if (_style == CertifPop_style_Suc) {
         certiflb.text = @"认证成功";
         certiflb.textColor = rgb(18, 179, 18);
         bottomlb.text = sucessStr;
         bottomlb.f_height = [sucessStr sc_calculateHeightInFontSize:14 withStableWidth:bottomlb.f_width];
     }else{
         bottomlb.text = failStr;
         bottomlb.f_height = [failStr sc_calculateHeightInFontSize:14 withStableWidth:bottomlb.f_width];
     }
    
    bottomlb.f_centerX = self.f_width/2;
    bottomlb.f_top = certiflb.f_bottom + (15*wSCALE_WIDTH);
}

#pragma mark - Event
- (void)closeBtnCLick:(UIButton *)sender{
    
    [SKPopupHelper_shareInstance skpop_FadeOut:self completion:^(UIWindow *window, UIView *view) {
        
    }];
}
- (void)show{
    
    [SKPopupHelper_shareInstance skpop_FadeInCenter:self offCenterY:0 defaultHideEnable:YES alphaBG:0.6];
    
}

@end
