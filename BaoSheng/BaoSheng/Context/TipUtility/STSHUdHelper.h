//
//  STSHUdHelper.h
//  STS_Master
//
//  Created by GML on 2017/9/18.
//  Copyright © 2017年 Jiujian. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface STSHUdHelper : NSObject


/**
 *  弹出loading 样式
 *
 *  @param lock 是否锁住页面
 */
+ (void)showLoadingWithLock:(BOOL)lock;

+ (void)showLoadingWithText:(NSString *)text Lock:(BOOL)lock;

/** 隐藏loading */
+ (void)hideLoading;


/** 从 nav 64.0 位置开始显示 */
+ (void)st_toastMsg:(NSString *)msg completion:(void (^)(void))completion;

/** 从 系统状态栏 20.0 位置开始显示 */
+ (void)st_toastMsgOffNav:(NSString *)msg completion:(void (^)(void))completion;


/**
 *  基础提示
 *
 *  @param msg        消息体
 *  @param seconds    显示时长
 *  @param lock       是否锁住页面
 *  @param offY       y轴偏移值
 *  @param completion 完成的 block
 */
+ (void)st_toastMsg:(NSString *)msg delay:(CGFloat)seconds lockInterface:(BOOL)lock offY:(CGFloat)offY completion:(void (^)(void))completion;

@end
