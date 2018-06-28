//
//  SKRefreshDelegate.h
//  RefreshTest
//
//  Created by Jajo_ios_lzl on 17/4/21.
//  Copyright © 2017年 Jajo_ios_lzl. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol SKRefreshDelegate <NSObject>

@optional
/**
 *	下拉 重新加载数据
 */
- (void)onRefreshing:(id)control;

@optional
/**
 *	上拉 加载更多数据
 */
- (void)onLoadingMoreData:(id)control pageNum:(NSNumber *)pageNum;

@end
