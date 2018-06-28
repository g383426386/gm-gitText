//
//  BSBaseTableView.m
//  BaoSheng
//
//  Created by GML on 2018/4/21.
//  Copyright © 2018年 haozheng. All rights reserved.
//

#import "BSBaseTableView.h"

@interface BSBaseTableView()<SKRefreshDelegate>

@end


@implementation BSBaseTableView


- (instancetype)initWithFrame:(CGRect)frame style:(UITableViewStyle)style inOrginVc:(id)orginVc{
    
    self = [super initWithFrame:frame style:style];
    if (self) {
        self.orginVC = orginVc;
        [self defaultConfig];
        self.backgroundColor = [UIColor clearColor];
    }
    return self;
}

- (void)defaultConfig{
    self.tableFooterView = [UIView new];
    self.showsVerticalScrollIndicator = NO;
    self.showsHorizontalScrollIndicator = NO;
    self.bspageIndex  = 1;
    if (self.orginVC) {
        self.refresh_EM = RefreshModle_EM_Normal;
        self.atuomaticallRefreshFooter = NO;
        self.openHeader = YES;
        self.openfooter = YES;
       
    }
  
}
#pragma mark - skrefresh
- (void)onRefreshing:(id)control{
    
    if (self.bsDelegate && [self.bsDelegate respondsToSelector:@selector(BsonRefreshing:)]) {
        [self.bsDelegate BsonRefreshing:control];
    }
}
- (void)onLoadingMoreData:(id)control pageNum:(NSNumber *)pageNum{
    
    if (self.bsDelegate && [self.bsDelegate respondsToSelector:@selector(BsonLoadingMoreData:pageNum:)]) {
        [self.bsDelegate BsonLoadingMoreData:control pageNum:pageNum];
    }
    
}

#pragma mark - PraviteEvent
- (void)ConfigRefreshBy:(RefreshModle_EM)refreshModle{
    
    if (self.mj_header) [self removeHeaderRefresh];
    
    switch (refreshModle) {
        case RefreshModle_EM_None:
        {
            [self removeHeaderRefresh];
        }
            break;
        case RefreshModle_EM_Normal:
        {
            [self addHeaderWithHeaderClass:@"custom" beginRefresh:NO delegate:self animation:NO];
        }
            break;
            
        default:
            break;
    }
}
- (void)configRefreshFooter{
    
    if (self.mj_footer) [self removeFooterRefresh];
    
    if (self.atuomaticallRefreshFooter) {
        [self addFooterWithFooterClass:@"" automaticallyRefresh:YES delegate:self];
    }else{
        [self addFooterWithFooterClass:@"" automaticallyRefresh:NO delegate:self];
    }
    
}

#pragma mark - Setter
- (void)setRefresh_EM:(RefreshModle_EM)refresh_EM{
    
   _refresh_EM = refresh_EM;
    [self ConfigRefreshBy:refresh_EM];
}
- (void)setAtuomaticallRefreshFooter:(BOOL)atuomaticallRefreshFooter{
    
    _atuomaticallRefreshFooter = atuomaticallRefreshFooter;
    [self configRefreshFooter];
}
- (void)setOpenHeader:(BOOL)openHeader{
    _openHeader = openHeader;
    if (!self.openHeader) {
        [self removeHeaderRefresh];
    }
}
- (void)setOpenfooter:(BOOL)openfooter{
    
    _openfooter = openfooter;
    if (!self.openfooter) {
        [self removeFooterRefresh];
    }
}


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
