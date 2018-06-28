//
//  CertifColltionHeader.m
//  BaoSheng
//
//  Created by GML on 2018/4/28.
//  Copyright © 2018年 haozheng. All rights reserved.
//

#import "CertifColltionHeader.h"

@implementation CertifColltionHeader

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self buildUI];
    }
    return self;
}
- (void)buildUI{
    
    UIView *line = [UIView new];
    [self addSubview:line];
    line.backgroundColor = kappBackgroundColor;
    line.frame = CGRectMake(0, 0, kSCREEN_WIDTH, 1);

    
    UIView *leftView = [UIView new];
    [self addSubview:leftView];
    leftView.f_width = 3;
    leftView.f_height = self.f_height - 30;
    leftView.backgroundColor = kRedColor;
    leftView.f_centerY = self.f_height/2;
    leftView.f_left = 15;
    
    UILabel *titlelb = [UILabel new];
    [self addSubview:titlelb];
    titlelb.font = FONTSize(15);
    titlelb.textColor =  kappTextColorlingtGray;
    titlelb.f_width = self.f_width - leftView.right - 50;
    titlelb.f_height = 18;
    titlelb.f_centerY = leftView.f_centerY;
    titlelb.f_left = leftView.f_right + 10;
    
    self.sectionTitle = titlelb;
    self.lineView = line;
}

@end
