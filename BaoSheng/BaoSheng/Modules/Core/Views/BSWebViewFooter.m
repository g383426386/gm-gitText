//
//  BSWebViewFooter.m
//  BaoSheng
//
//  Created by GML on 2018/5/2.
//  Copyright © 2018年 haozheng. All rights reserved.
//

#import "BSWebViewFooter.h"

@interface BSWebViewFooter()

@property (nonatomic , copy)CountDownBlock CountBlock;
@property (nonatomic , copy)endBlock endCountBlock;
@property (nonatomic , strong)tijiaoBlock uploadBlock;
@property (nonatomic , strong)NSNumber *secCount;

@property (nonatomic , assign)int min;
@property (nonatomic , assign)int sec;

@end

@implementation BSWebViewFooter

- (instancetype)initWithStyle:(CoutButton_Style)style
                     SecCount:(NSNumber *)secCount
               CountDownBlock:(CountDownBlock)countDownBlock
                     endBlock:(endBlock)endBlock
                  upLoadBlock:(tijiaoBlock)upLoadBlcok
{
    self = [super init];
    if (self) {
        self.CountBlock = countDownBlock;
        self.endCountBlock = endBlock;
        self.uploadBlock = upLoadBlcok;
        
        self.CountBtnStyle = style;
        self.secCount = secCount;
        
        [self buildUI];
    }
    return self;
}
- (void)buildUI{
    
    self.backgroundColor = kWhiteColor;
    self.f_width = kSCREEN_WIDTH;
    self.f_height = 49.f;
    
    UILabel *totalNum = [UILabel new];
    [self addSubview:totalNum];
    totalNum.font = FONTSize(12);
    totalNum.textColor = kappTextColorlingtGray;
    totalNum.textAlignment = NSTextAlignmentCenter;
    totalNum.f_width = 149 *wSCALE_WIDTH;
    totalNum.f_height = 20;
    totalNum.f_centerY = self.f_height/2;
    totalNum.f_left = 0;
    totalNum.text = [NSString stringWithFormat:@"学习时长:%@分钟",self.secCount];
    
    UIButton *secBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    secBtn.backgroundColor = kappButtonBackgroundColor;
    [secBtn setTitleColor:kWhiteColor forState:UIControlStateNormal];
    [secBtn setTitle:@"开始学习" forState:UIControlStateNormal];
    secBtn.titleLabel.font = FONTSize(17);
    [self addSubview:secBtn];
    secBtn.f_width = self.f_width - totalNum.f_right;
    secBtn.f_height = self.f_height;
    secBtn.f_left = totalNum.f_right;
    secBtn.f_top =0;
    
    [secBtn addTarget:self action:@selector(secBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    
    if (self.CountBtnStyle == CoutButton_Style_HasEnd) {
        secBtn.backgroundColor = rgb(210, 210, 210);
        [secBtn setTitle:@"已完成学习" forState:UIControlStateNormal];
        secBtn.enabled = NO;
    }
    
    self.totalSeclb = totalNum;
    self.countSecBtn = secBtn;
    
}

#pragma mark - Event
- (void)secBtnClick:(UIButton *)sender{
    
    if (self.CountBtnStyle == CoutButton_Style_Normal) {
        
        int totalSec = self.secCount.floatValue * 60;
        
        [[GmWidget shareInstance]gm_countDownWithTime:totalSec countDownBlock:^(int timeLeft) {
            
            if (self.CountBlock) {
                self.CountBlock(timeLeft, sender);
            }
            
            self.min = timeLeft/60;
            self.sec = timeLeft%60;
            NSString *leftStr =  [NSString stringWithFormat:@"倒计时 %02d:%02d",self.min,self
                                  .sec];
            sender.backgroundColor = rgb(210, 210, 210);
            [sender setTitle:leftStr forState:UIControlStateNormal];
            sender.userInteractionEnabled = NO;
            
            self.CountBtnStyle = CoutButton_Style_Sec;
            
        } endBlock:^{
            sender.backgroundColor = kappButtonBackgroundColor;
            sender.userInteractionEnabled = YES;
            [sender setTitle:@"提交结果" forState:UIControlStateNormal];
            self.CountBtnStyle = CoutButton_Style_CountEnd;
            if (self.endCountBlock) {
                self.endCountBlock(sender);
            }
            
        }];
    }else if (self.CountBtnStyle == CoutButton_Style_CountEnd){
        if (self.uploadBlock) {
            self.uploadBlock(sender);
        }
        
    }
    
    
}

@end
