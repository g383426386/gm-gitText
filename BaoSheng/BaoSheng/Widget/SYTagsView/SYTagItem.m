//
//  SYTagItem.m
//  SY_Doctor
//
//  Created by vic_wei on 16/1/26.
//  Copyright © 2016年 SY. All rights reserved.
//

#import "SYTagItem.h"

@implementation SYTagItem
{
    IBOutlet NSLayoutConstraint *top_;
    IBOutlet NSLayoutConstraint *left_;
    IBOutlet NSLayoutConstraint *bottom_;
    IBOutlet NSLayoutConstraint *right_;
}
@synthesize titleInset = _titleInset;

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
//        NSBundle *bundle = [NSBundle bundleWithURL:[[NSBundle mainBundle] URLForResource:@"ShareBundle" withExtension:@"bundle"]];
        NSBundle *bundle = [NSBundle mainBundle];
        self = [[bundle loadNibNamed:@"SYTagItem" owner:self options:nil] lastObject];
        [self initialize];
    }
    return self;
}

- (void)awakeFromNib {
    [self initialize];
}

- (void)initialize
{
    self.defaultTitleLab_.text = @"";
}

- (void)setTitleInset:(UIEdgeInsets)titleInset
{
    _titleInset = titleInset;
    top_.constant = titleInset.top;
    left_.constant = titleInset.left;
    bottom_.constant = titleInset.bottom;
    right_.constant = titleInset.right;
}

@end
