//
//  UIScrollView+SKRefresh.m
//  marketplateform
//
//  Created by Jajo_ios_lzl on 17/4/19.
//  Copyright © 2017年 com.sjyt. All rights reserved.
//

#import "UIScrollView+SKRefresh.h"
#import <objc/runtime.h>
#import "SKRefreshHeader.h"

@interface UIScrollView ()

@property (nonatomic, strong) NSNumber *pageIndex;
@property (nonatomic, weak) id <SKRefreshDelegate> reDelegate;

@end
@implementation UIScrollView (SKRefresh)

- (void)addHeaderWithHeaderClass:(NSString *)headerClassName beginRefresh:(BOOL)beginRefresh delegate:(id<SKRefreshDelegate>)delegate animation:(BOOL)animation {
    
    WeakSelf
    self.reDelegate = delegate;

    if (headerClassName == nil || [headerClassName isEqualToString:@""]) {

        SKRefreshHeader * header = [SKRefreshHeader headerWithRefreshingBlock:^{
            StrongSelf
            if([self.reDelegate respondsToSelector:@selector(onRefreshing:)]) {
                [self.reDelegate performSelector:@selector(onRefreshing:) withObject:self];
            }
        }];
        header.f_height = 70.0;
        self.mj_header = header;
        
    }else {
//        Class headerClass = NSClassFromString(headerClassName);
        
//        MJRefreshHeader *header = (MJRefreshHeader *)[headerClass headerWithRefreshingBlock:^{
//            StrongSelf
//            if([self.reDelegate respondsToSelector:@selector(onRefreshing:)])
//                [self.reDelegate performSelector:@selector(onRefreshing:) withObject:self];
//        }];
        
        MJRefreshNormalHeader *header = (MJRefreshNormalHeader*)[MJRefreshNormalHeader headerWithRefreshingBlock:^{
            StrongSelf
            if([self.reDelegate respondsToSelector:@selector(onRefreshing:)])
                [self.reDelegate performSelector:@selector(onRefreshing:) withObject:self];
        }];
        header.lastUpdatedTimeLabel.hidden = YES;
        
        self.mj_header =  header;
    }
    if (beginRefresh && animation) {
        
        //有动画的刷新
        [self beginHeaderRefresh];
    }else if (beginRefresh && !animation){
    
        //刷新，但是没有动画
        [self.mj_header executeRefreshingCallback];
    }
}

- (void)addFooterWithFooterClass:(NSString *)footerClassName automaticallyRefresh:(BOOL)automaticallyRefresh delegate:(id<SKRefreshDelegate>)delegate {
    
    WeakSelf
    self.reDelegate = delegate;
    if (footerClassName == nil || [footerClassName isEqualToString:@""]) {
        if (automaticallyRefresh) {
            MJRefreshAutoNormalFooter * footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
                StrongSelf
                if([self.reDelegate respondsToSelector:@selector(onLoadingMoreData:pageNum:)])
                    [self.reDelegate performSelector:@selector(onLoadingMoreData:pageNum:) withObject:self withObject:self.pageIndex];
            }];
            footer.automaticallyRefresh = automaticallyRefresh;
            
            footer.stateLabel.font = [UIFont systemFontOfSize:13.0];
            footer.stateLabel.textColor = [UIColor colorWithWhite:0.400 alpha:1.000];
            [footer setTitle:@"加载中…" forState:MJRefreshStateRefreshing];
            [footer setTitle:@"这是我的底线啦~" forState:MJRefreshStateNoMoreData];
            
            self.mj_footer = footer;
        }else {
            MJRefreshBackNormalFooter * footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
                StrongSelf
                if([self.reDelegate respondsToSelector:@selector(onLoadingMoreData:pageNum:)]) {
                    [self.reDelegate performSelector:@selector(onLoadingMoreData:pageNum:) withObject:self withObject:self.pageIndex];
                }
            }];
            
            footer.stateLabel.font = [UIFont systemFontOfSize:13.0];
            footer.stateLabel.textColor = [UIColor colorWithWhite:0.400 alpha:1.000];
            [footer setTitle:@"加载中…" forState:MJRefreshStateRefreshing];
            [footer setTitle:@"这是我的底线啦~" forState:MJRefreshStateNoMoreData];
            
            self.mj_footer = footer;
        }
    }else {
        Class headerClass = NSClassFromString(footerClassName);
        
        if (automaticallyRefresh) {
            MJRefreshAutoFooter *footer =(MJRefreshAutoFooter *)[headerClass footerWithRefreshingBlock:^{
                StrongSelf
                if([self.reDelegate respondsToSelector:@selector(onLoadingMoreData:pageNum:)])
                    [self.reDelegate performSelector:@selector(onLoadingMoreData:pageNum:) withObject:self withObject:self.pageIndex];
                
            }];
            footer.automaticallyRefresh = automaticallyRefresh;
            self.mj_footer = footer;

        }else {
            MJRefreshFooter *footer =(MJRefreshFooter *)[headerClass footerWithRefreshingBlock:^{
                StrongSelf
                if([self.reDelegate respondsToSelector:@selector(onLoadingMoreData:pageNum:)])
                    [self.reDelegate performSelector:@selector(onLoadingMoreData:pageNum:) withObject:self withObject:self.pageIndex];
                
            }];
            self.mj_footer = footer;
        }
    }
    
    if (self.mj_footer) { // 未满一屏时 隐藏 上拉 
        [RACObserve(self, contentSize) subscribeNext:^(NSValue* x) {
            if (x.CGSizeValue.height > self.frame.size.height) {
                self.mj_footer.hidden = NO;
            }else{
                self.mj_footer.hidden = YES;
            }
        }];
    }
    

}



#pragma mark - action
-(void)beginHeaderRefresh {
    
    [self resetPageNum];
    [self.mj_header beginRefreshing];
}

-(void)beginFooterRefresh {
    
    [self.mj_footer beginRefreshing];
}

-(void)endHeaderRefresh {
    
    [self.mj_header endRefreshing];
    [self resetNoMoreData];
    
}

-(void)endFooterRefresh {
    
    [self.mj_footer endRefreshing];
}

-(void)endHeaderRefreshWithChangePageIndex:(BOOL)change {
    
    [self resetPageNum];
    if (change) {
        self.pageIndex = @(self.pageIndex.integerValue+1);
    }
    [self endHeaderRefresh];
}

-(void)endFooterRefreshWithChangePageIndex:(BOOL)change {
    
    if (change) {
        self.pageIndex = @(self.pageIndex.integerValue+1);
    }
    [self endFooterRefresh];
    
}

- (void)noMoreData {
    [self.mj_footer endRefreshingWithNoMoreData];
}

- (void)resetNoMoreData {

    [self.mj_footer resetNoMoreData];
}
- (void)removeHeaderRefresh {
    self.mj_header = nil;
}

- (void)removeFooterRefresh {
    self.mj_footer = nil;
}

- (void)resetPageNum {

    self.pageIndex = @(1);
}
#pragma mark - sett && gett
static void *pagaIndexKey = &pagaIndexKey;
- (NSNumber *)pageIndex {
    return objc_getAssociatedObject(self, &pagaIndexKey);
}
- (void)setPageIndex:(NSNumber *)pageIndex {
    
    objc_setAssociatedObject(self, &pagaIndexKey, pageIndex, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

static void *reDelegateKey = &reDelegateKey;
- (void)setReDelegate:(id<SKRefreshDelegate>)reDelegate {
    
    objc_setAssociatedObject(self, &reDelegateKey, reDelegate, OBJC_ASSOCIATION_ASSIGN);
  
}
- (id<SKRefreshDelegate>)reDelegate {
    return objc_getAssociatedObject(self, &reDelegateKey);

}

//- (void)dealloc {
//    NSLog(@"\n\nUIScrollView+SKRefresh--------dealloc\n\n");
//}

@end
