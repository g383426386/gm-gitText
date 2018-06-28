//
//  BSBaseTableView.h
//  BaoSheng
//
//  Created by GML on 2018/4/21.
//  Copyright © 2018年 haozheng. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum : NSUInteger {
    RefreshModle_EM_None,
    RefreshModle_EM_Normal,
} RefreshModle_EM;

@protocol BsTableViewRefresh <NSObject>

@optional
- (void)BsonRefreshing:(id)control;
- (void)BsonLoadingMoreData:(id)control pageNum:(NSNumber *)pageNum;

@end

@interface BSBaseTableView : UITableView

@property (nonatomic , assign)NSInteger bspageIndex;

/** 代理VC */
@property (nonatomic , weak)id orginVC;
@property (nonatomic , weak)id<BsTableViewRefresh> bsDelegate;

/** 默认开启刷新 RefreshModle_EM_Normal样式 required:orginVC != nil */
@property (nonatomic , assign)RefreshModle_EM refresh_EM;

/** 是否开启自动加载footer -default NO required:orginVC != nil */
@property (nonatomic , assign)BOOL atuomaticallRefreshFooter;

/** 是否开启刷新 default yes required:orginVC != nil */
@property (nonatomic , assign)BOOL openHeader;
@property (nonatomic , assign)BOOL openfooter;


- (instancetype)initWithFrame:(CGRect)frame style:(UITableViewStyle)style inOrginVc:(id)orginVc;

@end
