//
//  STSCustomCell.m
//  STS_Master
//
//  Created by GML on 2017/9/26.
//  Copyright © 2017年 Jiujian. All rights reserved.
//

#import "STSCustomCell.h"

@interface STSCustomCell()
{
    CGRect _frame;
}



@end


@implementation STSCustomCell

- (instancetype)initWithFrame:(CGRect)frame
                        index:(NSInteger)index
                     delegate:(id<CustomcellDelegate>)delegate
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = kWhiteColor;
        _frame = frame;
        self.index = index;
        if (delegate) {
            self.delegate = delegate;
        }
        
        [self gmaddOwnViews];
        [self gmconfigOwnViews];
        
        self.deslb.userInteractionEnabled = NO;
    }
    return self;
}

- (void)gmaddOwnViews{
    
    _titlelb  = [UILabel new];

    
    _deslb = [UITextField new];
    _deslb.tag = self.index;
    
    _arrowdImg = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"cellright"]];
    
    [self addSubview:_titlelb];
    [self addSubview:_deslb];
    [self addSubview:_arrowdImg];
    

}
- (void)gmconfigOwnViews{
    
    _frame = self.frame;
    
    _arrowdImg.f_centerY = _frame.size.height/2;
    _arrowdImg.f_right = kSCREEN_WIDTH - 15;
    
    _titlelb.font = FONTSize(15);
    _titlelb.textColor = kappTextColorDrak;
   
    _titlelb.f_width = kSCREEN_WIDTH/2 - 80;
    _titlelb.f_height = 20;
    
    _titlelb.f_centerY = _arrowdImg.f_centerY;
    _titlelb.f_left  = 15;

    
    _deslb.font = FONTSize(15);
    _deslb.textColor = kappTextColorDrak;
    _deslb.textAlignment = NSTextAlignmentRight;
    
    _deslb.f_width = kSCREEN_WIDTH - 20 - _titlelb.f_right;
    _deslb.f_height = 20;
    
    _deslb.f_centerY = _arrowdImg.f_centerY;
    _deslb.f_right = _arrowdImg.f_left - 10;
    
    
    UITapGestureRecognizer *cellTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(cellTap:)];
    self.userInteractionEnabled = YES;
    [self addGestureRecognizer:cellTap];
    
    
}

- (void)changeSubViews{

    [_titlelb sizeToFit];
    
    _titlelb.f_centerY = _arrowdImg.f_centerY;
    _titlelb.f_left  = 15;

    _deslb.f_width = kSCREEN_WIDTH - _arrowdImg.f_width - 15 - _titlelb.f_right - 20;
    
    _deslb.f_centerY = _arrowdImg.f_centerY;
    _deslb.f_right = _arrowdImg.f_left - 10;
    

    
    
    
}

- (void)relayoutFrameOfSubViews{
    
   
    
}

- (void)setIndex:(NSInteger)index{
    _index = index;
    
    self.tag = index;
    
}


- (void)cellTap:(UIGestureRecognizer *)sender{

    if (self.delegate && [self.delegate respondsToSelector:@selector(customCell:didClickAtIndex:)]) {
        [self.delegate customCell:self didClickAtIndex:self.index];
    }
    

}




@end
