//
//  HomeItem.m
//  BaoSheng
//
//  Created by GML on 2018/4/22.
//  Copyright © 2018年 haozheng. All rights reserved.
//

#import "HomeItem.h"

@implementation HomeItem

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self addOwnViews];
    }
    return self;
}

- (void)addOwnViews{
    
    UIImageView *imageView = [[UIImageView alloc]init];
    [self addSubview:imageView];
    self.imageView = imageView;
    
    UILabel *titlelb = [UILabel new];
    [self addSubview:titlelb];
    titlelb.font = FONTSize(13);
    titlelb.textAlignment = NSTextAlignmentCenter;
    titlelb.textColor = kappTextColorDrak;
    titlelb.f_width = self.f_width;
    self.titlelb = titlelb;

}

- (void)layoutSubviews{
    [super layoutSubviews];
    
    self.imageView.f_width = self.imageView.f_height = 40;
    
    self.titlelb.f_width = self.f_width;
    self.titlelb.f_height = 20;
    
    self.imageView.f_centerX = self.f_width/2;
    self.imageView.f_top = 0;
    
    self.titlelb.f_left = 0;
    self.titlelb.f_top = self.imageView.f_bottom + 5;

}

@end
