//
//  MineHeader.m
//  BaoSheng
//
//  Created by GML on 2018/4/22.
//  Copyright © 2018年 haozheng. All rights reserved.
//

#import "MineHeader.h"

@implementation MineHeader

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self initialize];
    }
    return self;
}
- (void)initialize{
    
    UIView *wrapper = [[[NSBundle mainBundle] loadNibNamed:@"MineHeader" owner:self options:nil] lastObject];
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
