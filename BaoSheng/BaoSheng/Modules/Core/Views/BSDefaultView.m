//
//  BSDefaultView.m
//  BaoSheng
//
//  Created by GML on 2018/5/2.
//  Copyright © 2018年 haozheng. All rights reserved.
//

#import "BSDefaultView.h"



@interface BSDefaultView()



@property (nonatomic , strong)UIImage *image;
@property (nonatomic , strong)NSString *des;
@property (nonatomic , strong)NSString *btntitle;

@property (nonatomic , copy)BtnBlock BtnClickBlock;

@end


@implementation BSDefaultView

- (instancetype)initWithImage:(UIImage *)image Des:(NSString *)Des BtnTitle:(NSString *)btnTitle BtnClick:(BtnBlock)BtnClick orginframe:(CGRect)frame;
{
    self = [super init];
    if (self) {
        self.image = image;
        self.des = Des;
        self.btntitle = btnTitle;
        self.BtnClickBlock = BtnClick;
        self.f_width = frame.size.width;
        [self buildUI];
        self.f_centerX  = self.f_width/2;
        self.f_centerY = frame.size.height/2;
    }
    return self;
}


- (void)buildUI{
    
    UIImageView *imageView  = [[UIImageView alloc]initWithImage:self.image];
    [self addSubview:imageView];
    imageView.f_centerX = self.f_width/2;
    imageView.f_top = 0;
    
    self.f_height = imageView.f_bottom;
    
    UILabel *deslb = nil;
    if (self.des.length) {
        deslb = [UILabel new];
        [self addSubview:deslb];
        deslb.font = FONTSize(15);
        deslb.textColor = kappTextColorlingtGray;
        deslb.numberOfLines = 0;
        deslb.textAlignment = NSTextAlignmentCenter;
        deslb.f_width = self.f_width - 40;
        deslb.f_height = [self.des sc_calculateHeightInFontSize:15 withStableWidth:self.f_width- 40];
        
        deslb.f_centerX = self.ImageView.centerX;
        deslb.f_top = self.ImageView.f_bottom + 10;
        self.f_height  =deslb.f_bottom;
    }
    BSGlobalButton *button = nil;
    if (self.btntitle.length) {
        button = [BSGlobalButton buttonWithButtonSize:CGSizeMake(self.f_width - 88, 40) coner:0 title:self.btntitle titleFont:17 backgroundColor:kappButtonBackgroundColor globalButtonStyle:GlobalButtonStyle_Empty_RedLayer];
        [self addSubview:button];
        button.f_centerX = self.f_width/2;
        button.f_top = deslb ?deslb.f_bottom + 10:imageView.f_bottom + 10;
        [button addTarget:self action:@selector(defaultBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        self.f_height = button.f_bottom;
    }
    
    self.ImageView  = imageView;
    self.deslb = deslb;
    self.defaultBtn = button;
    
}

- (void)defaultBtnClick:(BSGlobalButton *)sender{
    
    if (self.BtnClickBlock) {
        self.BtnClickBlock();
    }
    
}

@end
