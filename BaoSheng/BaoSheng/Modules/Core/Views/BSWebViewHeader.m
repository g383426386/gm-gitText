//
//  BSWebViewHeader.m
//  BaoSheng
//
//  Created by GML on 2018/4/27.
//  Copyright © 2018年 haozheng. All rights reserved.
//

#import "BSWebViewHeader.h"

@implementation BSWebViewHeader

- (instancetype)init
{
    self = [super init];
    if (self) {
        [self buildUI];
    }
    return self;
}
- (void)buildUI{
    
    self.backgroundColor = kWhiteColor;
    self.f_width = kSCREEN_WIDTH;
    
    UILabel *titlelb = [UILabel new];
    [self addSubview:titlelb];
    titlelb.font = FONTSize(24);
    titlelb.textColor = rgb(51, 51, 51);
    titlelb.f_width = self.f_width - 30;
    titlelb.f_height = 30;
    titlelb.numberOfLines = 0;
    
    UILabel *dangyunLb = [UILabel new];
    [self addSubview:dangyunLb];
    dangyunLb.font = FONTSize(12);
    dangyunLb.textColor = rgb(230, 0, 0);
    dangyunLb.text = @"党员";
    [dangyunLb sizeToFit];
    
    UILabel *timelb = [UILabel new];
    [self addSubview:timelb];
    timelb.textColor = rgb(153, 153, 153);
    timelb.font = FONTSize(12);
    
    UILabel *timelb2 = [UILabel new];
    [self addSubview:timelb2];
    timelb2.textColor = rgb(153, 153, 153);
    timelb2.font = FONTSize(12);

    self.titlelb_ = titlelb;
    self.leftTimelb_ = timelb;
    self.partymenberlb_ = dangyunLb;
    self.ringtTimelb_ = timelb2;
}
- (void)layoutSubviews{
    [super layoutSubviews];
    
    self.titlelb_.f_height = [self.titlelb_.text sc_calculateHeightInFontSize:24 withStableWidth:self.f_width - 30];
    self.titlelb_.f_centerX = self.f_width/2;
    self.titlelb_.f_top = 15;
    
    self.partymenberlb_.f_left = 15;
    self.partymenberlb_.f_top = self.titlelb_.f_bottom + 15;
    
    [self.leftTimelb_ sizeToFit];
    if (self.partymenberlb_.hidden == YES) {
        self.leftTimelb_.f_left = 15;
        self.leftTimelb_.f_top = self.titlelb_.f_bottom + 15;
        
    }else{
        self.leftTimelb_.f_left = self.partymenberlb_.f_right + 15;
        self.leftTimelb_.f_top = self.titlelb_.f_bottom + 15;
        
    }
    [self.ringtTimelb_ sizeToFit];
    self.ringtTimelb_.f_right = self.f_width - 15;
    self.ringtTimelb_.f_top = self.titlelb_.f_bottom + 15;
    
//    if (self.ringtTimelb_.hidden) {
        self.f_height = self.partymenberlb_.f_bottom + 15;
//    }else{
//        self.f_height = self.ringtTimelb_.f_bottom + 15;
//    }
    
    
    
}

@end
