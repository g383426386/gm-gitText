//
//  SKRefreshHeader.m
//  marketplateform
//
//  Created by vic_wei on 2017/6/7.
//  Copyright © 2017年 com.sjyt. All rights reserved.
//

#import "SKRefreshHeader.h"
#import "Masonry.h"


//    MJRefreshNormalHeader
@interface SKRefreshHeader ()
{
    NSArray *_aryNibs;
}
@property (nonatomic, strong, readonly ,getter=getAryNibs) NSArray *aryNibs;

@property (strong, nonatomic) IBOutlet UIView      *wrapperView_;
@property (strong, nonatomic) IBOutlet UIImageView *imageLoading_;
@property (strong, nonatomic) IBOutlet UILabel     *labStatus_;
@property (strong, nonatomic) IBOutlet UIImageView *imageStatus_;

@end

@implementation SKRefreshHeader


- (instancetype)init
{
    if (self = [super init]) {
        [self initialize];
    }
    return self;
}

- (void)initialize
{
    //NSArray *ary = self.aryNibs;
    [self getAryNibs];
    [self addSubview:self.wrapperView_];
    [self.wrapperView_ mas_updateConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left);
        make.right.equalTo(self.mas_right);
        make.top.equalTo(self.mas_top);
        make.bottom.equalTo(self.mas_bottom);
    }];
    
    NSArray *ary = @[[UIImage imageNamed:@"refresh_1.png"],
                     [UIImage imageNamed:@"refresh_2.png"],
                     [UIImage imageNamed:@"refresh_3.png"],
                     [UIImage imageNamed:@"refresh_4.png"],
                     [UIImage imageNamed:@"refresh_5.png"],
                     [UIImage imageNamed:@"refresh_6.png"],
                     [UIImage imageNamed:@"refresh_7.png"],
                     [UIImage imageNamed:@"refresh_8.png"]];
    
    [self.imageLoading_ setAnimationImages:ary];
    float animationDuration = [self.imageLoading_.animationImages count] * 0.100; // 100ms per frame
    [self.imageLoading_ setAnimationRepeatCount:0];
    [self.imageLoading_ setAnimationDuration:animationDuration];
    
}

- (NSArray *)getAryNibs
{
    if (!_aryNibs) {
        _aryNibs = [[NSBundle mainBundle] loadNibNamed:@"SkRefreshHeader_" owner:self options:nil];
    }
    return _aryNibs;
}

#pragma mark - 重写父类的方法
- (void)prepare
{
    [super prepare];
    
}

- (void)placeSubviews
{
    [super placeSubviews];
    
}

- (void)setState:(MJRefreshState)state
{
    MJRefreshCheckState
    
    [self getAryNibs];
    
    // 根据状态做事情
    if (state == MJRefreshStateIdle) {
        
        // 普通 状态
        [self.imageLoading_ stopAnimating];
        self.labStatus_.text = @"下拉刷新";
        self.imageStatus_.image = [UIImage imageNamed:@"refresh_normal"];
        
        self.imageLoading_.hidden = YES;
        self.labStatus_.hidden = NO;
        
    } else if (state == MJRefreshStatePulling) {
        
        // 下拉 触发 状态
        [self.imageLoading_ stopAnimating];
        self.labStatus_.text = @"松开刷新";
        self.imageStatus_.image = [UIImage imageNamed:@"refresh_pulloff"];
        
        self.imageLoading_.hidden = YES;
        self.labStatus_.hidden = NO;
    } else if (state == MJRefreshStateRefreshing) {
        
        // 刷新中 状态
        [self.imageLoading_ startAnimating];
        self.labStatus_.text = @"正在刷新";
        self.imageStatus_.image = [UIImage imageNamed:@"refresh_loading"];
        
        self.imageLoading_.hidden = NO;
        self.labStatus_.hidden = YES;
    }
}

@end
