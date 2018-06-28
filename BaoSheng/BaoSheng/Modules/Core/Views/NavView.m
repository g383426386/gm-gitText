//
//  NavView.m
//  BaoSheng
//
//  Created by GML on 2018/4/22.
//  Copyright © 2018年 haozheng. All rights reserved.
//

#import "NavView.h"

@implementation NavView
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.frame = CGRectMake(0, 0, kSCREEN_WIDTH, kNavHeight);
        [self initialize];
    }
    return self;
}

- (void)awakeFromNib{
    [super awakeFromNib];
    
    [self initialize];
}
- (void)initialize{
    
    UIView *wrapper = [[[NSBundle mainBundle] loadNibNamed:@"NavView" owner:self options:nil] lastObject];
    [self addSubview:wrapper];
    
    WeakSelf
    [wrapper mas_updateConstraints:^(MASConstraintMaker *make) {
        StrongSelf
        make.left.equalTo(self.mas_left);
        make.right.equalTo(self.mas_right);
        make.top.equalTo(self.mas_top);
        make.bottom.equalTo(self.mas_bottom);
    }];
    
}

@end
