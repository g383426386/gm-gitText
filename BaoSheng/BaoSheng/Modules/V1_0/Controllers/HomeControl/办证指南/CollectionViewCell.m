//
//  CollectionViewCell.m
//  BaoSheng
//
//  Created by GML on 2018/4/28.
//  Copyright © 2018年 haozheng. All rights reserved.
//

#import "CollectionViewCell.h"

@implementation CollectionViewCell

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self buildCellUI];
    }
    return self;
}
- (void)buildCellUI{
    
    UIImageView *bgimage = [UIImageView new];
    [self.contentView addSubview:bgimage];
    bgimage.f_width = 24;
    bgimage.f_height = 24;
    bgimage.f_centerX = self.f_width/2;
    bgimage.f_top = 0;
    
    UILabel *label = [UILabel new];
    [self.contentView addSubview:label];
    label.font = FONTSize(12);
    label.textColor =   kappTextColorDrak;
    label.textAlignment  = NSTextAlignmentCenter;
    label.f_width  = self.f_width;
    label.f_height = 15;
    label.f_top = bgimage.f_bottom + 10;
    label.f_left = 0;
    
    self.imageView = bgimage;
    self.titlelb = label;
    
    
}


@end
