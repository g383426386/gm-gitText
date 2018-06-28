//
//  BSWebViewFooter.h
//  BaoSheng
//
//  Created by GML on 2018/5/2.
//  Copyright © 2018年 haozheng. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum : NSUInteger {
    CoutButton_Style_Normal,//普通可点击状态
    CoutButton_Style_Sec,//即时状态
    CoutButton_Style_CountEnd,//即时结束
    CoutButton_Style_HasEnd,//初始 不可点击
} CoutButton_Style;

typedef void(^CountDownBlock)(int lefttime,UIButton *SecBtn);
typedef void(^endBlock)(UIButton *SecBtn);
typedef void(^tijiaoBlock)(UIButton *SecBtn);

@interface BSWebViewFooter : UIView

@property (nonatomic , strong)UILabel *totalSeclb;
@property (nonatomic , strong)UIButton*countSecBtn;
@property (nonatomic , assign)CoutButton_Style CountBtnStyle;

- (instancetype)initWithStyle:(CoutButton_Style)style
                     SecCount:(NSNumber *)secCount
               CountDownBlock:(CountDownBlock)countDownBlock
                     endBlock:(endBlock)endBlock
                  upLoadBlock:(tijiaoBlock)upLoadBlcok;


@end
