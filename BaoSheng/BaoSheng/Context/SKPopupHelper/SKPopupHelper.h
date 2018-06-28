//
//  SKPopupHelper.h
//  marketplateform
//
//  Created by vic_wei on 2017/5/17.
//  Copyright © 2017年 com.sjyt. All rights reserved.
//

#import <Foundation/Foundation.h>

#ifndef SKPopupHelper_shareInstance
#define SKPopupHelper_shareInstance [SKPopupHelper shareInstance]
#endif

#define kDefaultAlpha 0.3

@interface SKPopupHelper : NSObject

/** 返回单例  */
+ (instancetype)shareInstance;

/** 点击了背景的block*/
- (void)skpop_didTouchBackgroundView:(void(^)(UIWindow *window, UIView *view))didTouchBlock;

/** dissmiss 后的 block */
- (void)skpop_dismissBlock:(void(^)(UIWindow *window, UIView *view))dismissBlock;

/** 淡入 alpha默认值为0.3 */
- (void)skpop_FadeInCenter:(UIView*)view offCenterY:(CGFloat)offCenterY defaultHideEnable:(BOOL)defaultHideEnable alphaBG:(CGFloat)alpha;;

/** 淡出 */
- (void)skpop_FadeOut:(UIView*)view completion:(void(^)(UIWindow *window, UIView *view))completion;

/** 从下弹入 alpha默认值为0.3 */
- (void)skpop_FlyInFromBottom:(UIView*)view defaultHideEnable:(BOOL)defaultHideEnable alphaBG:(CGFloat)alpha;

/** 从下弹出  */
- (void)skpop_FlyOutToBottom:(UIView*)view completion:(void(^)(UIWindow *window, UIView *view))completion;

/**
 *  自定义 弹出
 *
 *  @param view              目标view
 *  @param defaultHideEnable 控制点击背景是否隐藏
 *  @param animate           是否有动画
 *  @param duration          动画时长
 *  @param willAnimate       开始动画前的 block
 *  @param animating         动画中的 block
 *  @param completion        动画完成后 block
 */
- (void)skpop_showView:(UIView *)view
     defaultHideEnable:(BOOL)defaultHideEnable
               animate:(BOOL)animate
              duration:(NSTimeInterval)duration
           willAnimate:(void(^)(UIWindow *window, UIView *view))willAnimate
             animating:(void(^)(UIWindow *window, UIView *view))animating
            completion:(void(^)(UIWindow *window, UIView *view))completion;


/**
 *  自定义 隐藏
 *
 *  @param view              目标view
 *  @param animate           是否有动画
 *  @param duration          动画时长
 *  @param willAnimate       开始动画前的 block
 *  @param animating         动画中的 block
 *  @param completion        动画完成后 block
 */
- (void)skpop_hideView:(UIView *)view
               animate:(BOOL)animate
              duration:(NSTimeInterval)duration
           willAnimate:(void(^)(UIWindow *window, UIView *view))willAnimate
             animating:(void(^)(UIWindow *window, UIView *view))animating
            completion:(void(^)(UIWindow *window, UIView *view))completion;

@end
