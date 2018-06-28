//
//  SKPopupHelper.m
//  marketplateform
//
//  Created by vic_wei on 2017/5/17.
//  Copyright © 2017年 com.sjyt. All rights reserved.
//

#import "SKPopupHelper.h"
#import "UIView+CustomAutoLayout.h"


typedef void(^completionBlock)(UIWindow *window, UIView *view);

@interface SKPopupHelper ()

/** 弹窗层的window */
@property (nonatomic , strong) UIWindow             *window;
/** 底部button hide */
@property (nonatomic , strong) UIButton             *btnHide;
/** 记录添加到当前window上的 view */
@property (nonatomic , strong) UIView               *currentView;
/** 队列 */
@property (nonatomic, strong ) dispatch_queue_t     queue;
/** 信号量控制 */
@property (nonatomic, strong ) dispatch_semaphore_t semaphore;
/** 记录类型: 0-自定义 , 1-从下往上弹出 , 2-居中淡出  */
@property (nonatomic, assign ) NSInteger            typeAnimate;
/** 消失后的block  */
@property (nonatomic ,copy) void(^dismissBlock)(UIWindow *window, UIView *view);
/** 点击了背景的block*/
@property (nonatomic ,copy) void(^didTouchBlock)(UIWindow *window, UIView *view);

/** 记录自定义 hide动画时 相关值 */
@property (nonatomic, assign) BOOL           custom_animate;
@property (nonatomic, assign) NSTimeInterval custom_duration;
@property (nonatomic ,copy) void(^custom_willAnimate)(UIWindow *window, UIView *view);
@property (nonatomic ,copy) void(^custom_animating)(UIWindow *window, UIView *view);
@property (nonatomic ,copy) completionBlock custom_completion;

@end

@implementation SKPopupHelper

static SKPopupHelper *shareInstance;
+ (instancetype)shareInstance
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        if (!shareInstance) {
            shareInstance = [[[self class] alloc] init];
        }
    });
    return shareInstance;
}

#pragma mark set get
- (UIWindow *)window
{
    if (!_window) {
        _window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
        _window.windowLevel       = UIWindowLevelNormal+1;
        _window.clipsToBounds = YES;
        _window.hidden = NO;
        
        self.btnHide = [UIButton buttonWithType:UIButtonTypeCustom];
        self.btnHide.backgroundColor = [UIColor clearColor];
        self.btnHide.frame = (CGRect){CGPointZero,_window.frame.size};
        [self.btnHide addTarget:self action:@selector(pop_hide) forControlEvents:UIControlEventTouchUpInside];
        
        [_window addSubview:self.btnHide];
    }
    return _window;
}

- (dispatch_queue_t)queue
{
    if (!_queue) {
        _queue = dispatch_queue_create("SKPopupHelper_DISPATCH_QUEUE_SERIAL", DISPATCH_QUEUE_SERIAL);
    }
    return _queue;
}

- (dispatch_semaphore_t)semaphore
{
    if (!_semaphore) {
        _semaphore = dispatch_semaphore_create(0);
    }
    return _semaphore;
}

#pragma mark - private
/// 弹出
- (void)pop_showView:(UIView *)view
   defaultHideEnable:(BOOL)defaultHideEnable
             animate:(BOOL)animate
            duration:(NSTimeInterval)duration
         willAnimate:(void(^)(UIWindow *window, UIView *view))willAnimate
           animating:(void(^)(UIWindow *window, UIView *view))animating
          completion:(void(^)(UIWindow *window, UIView *view))completion
{
    
//    WeakSelf
    
    
    __weak typeof(self) weakSelf = self;
    void (^task)() = ^(){
//        StrongSelf
        __strong typeof(self) strongSelf = self;
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            // 清空 window 子界面
            //[self.window.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
            
            // 添加 view
            self.currentView = view;
            [self.window addSubview:self.currentView];
            
            // 点击背景是否能 hide
            self.btnHide.enabled = defaultHideEnable;
            
            // 显示 window
            self.window.hidden = NO;
            
            // 弹出逻辑
            if (animate) { // 显示动画
                if (willAnimate)
                    willAnimate(self.window,self.currentView);
                [UIView animateWithDuration:animate ? duration : 0.0 animations:^{
                    if (animating)
                        animating(self.window,self.currentView);
                } completion:^(BOOL finished) {
                    if (completion)
                        completion(self.window,self.currentView);
                }];
            }else{ // 无动画
                if (completion) {
                    self.window.backgroundColor = [UIColor colorWithWhite:0.0 alpha:0.3];
                    completion(self.window,self.currentView);
                }
                
            }
        });
        
        // 等待信号
        dispatch_semaphore_wait(self.semaphore, DISPATCH_TIME_FOREVER);
    };
    
    // 将任务添加到队列 异步
    dispatch_async(self.queue, task);
}

/// 隐藏
- (void)pop_hideView:(UIView *)view animate:(BOOL)animate
              duration:(NSTimeInterval)duration
           willAnimate:(void(^)(UIWindow *window, UIView *view))willAnimate
             animating:(void(^)(UIWindow *window, UIView *view))animating
            completion:(void(^)(UIWindow *window, UIView *view))completion
{
    
//    WeakSelf
    if (view == self.currentView) {
//        StrongSelf
        
        if (animate) {
            if (willAnimate)
                willAnimate(self.window,self.currentView);
            [UIView animateWithDuration:animate ? duration : 0.0 animations:^{
                if (animating)
                    animating(self.window,self.currentView);
            } completion:^(BOOL finished) {
                // 隐藏
                [self.currentView removeFromSuperview];
                self.window.hidden = YES;
                if (completion)
                    completion(self.window,self.currentView);
                self.currentView = nil;
                
                // 隐藏后的block
                if (self.dismissBlock)
                    self.dismissBlock(self.window,self.currentView);
                
                // 发信号
                dispatch_semaphore_signal(self.semaphore);
            }];
            
        }else{
            // 隐藏
            [self.currentView removeFromSuperview];
            self.window.hidden = YES;
            if (completion)
                completion(self.window,self.currentView);
            self.currentView = nil;
            
            // 隐藏后的block
            if (self.dismissBlock)
                self.dismissBlock(self.window,self.currentView);
            
            // 发信号
            dispatch_semaphore_signal(self.semaphore);
        }
    }
    
}

/// tap 背景 退出
- (void)pop_hide
{
    if (0 == self.typeAnimate) {
        [self skpop_hideView:self.currentView animate:self.custom_animate duration:self.custom_duration willAnimate:self.custom_willAnimate animating:self.custom_animating completion:self.custom_completion];
    }
    else if (1 == self.typeAnimate) {
        [self skpop_FlyOutToBottom:self.currentView completion:self.custom_completion];
    }
    else if (2 == self.typeAnimate) {
        [self skpop_FadeOut:self.currentView completion:self.custom_completion];
    }
    else{
        [self skpop_FadeOut:self.currentView completion:self.custom_completion];
    }
 
    if (self.didTouchBlock) {
        self.didTouchBlock(self.window,self.currentView);
    }
}


#pragma mark - api
/** dissmiss 后的 block */
- (void)skpop_dismissBlock:(void (^)(UIWindow *, UIView *))dismissBlock
{
    self.dismissBlock = dismissBlock;
}

/** 点击了背景的block*/
- (void)skpop_didTouchBackgroundView:(void(^)(UIWindow *window, UIView *view))didTouchBlock {

    self.didTouchBlock = didTouchBlock;
}
/** 淡入 */
- (void)skpop_FadeInCenter:(UIView *)view offCenterY:(CGFloat)offCenterY defaultHideEnable:(BOOL)defaultHideEnable alphaBG:(CGFloat)alpha
{
    self.typeAnimate = 2;
    
    [self pop_showView:view defaultHideEnable:defaultHideEnable animate:YES duration:0.19f willAnimate:^(UIWindow *window, UIView *view) {
        window.backgroundColor = [UIColor clearColor];
        [view alignParentCenter:CGPointMake(0, offCenterY)];
        view.alpha = 0.0;
    } animating:^(UIWindow *window, UIView *view) {
        window.backgroundColor = [UIColor colorWithWhite:0.0 alpha:alpha == 0 ? 0.3 : alpha];
        view.alpha = 1.0;
    } completion:nil];
}

/** 淡出 */
- (void)skpop_FadeOut:(UIView *)view completion:(void (^)(UIWindow *window, UIView *view))completion
{
    [self pop_hideView:view animate:YES duration:0.19f willAnimate:nil animating:^(UIWindow *window, UIView *view) {
        window.backgroundColor = [UIColor clearColor];
        view.alpha = 0.0;
    } completion:^(UIWindow *window, UIView *view) {
        view.alpha = 1.0;
        if (completion)
            completion(window,view);
    }];
}

/** 从下弹入 */
- (void)skpop_FlyInFromBottom:(UIView *)view defaultHideEnable:(BOOL)defaultHideEnable alphaBG:(CGFloat)alpha
{
    self.typeAnimate = 1;
    
    [self pop_showView:view defaultHideEnable:defaultHideEnable animate:YES duration:0.3f willAnimate:^(UIWindow *window, UIView *view) {
        window.backgroundColor = [UIColor clearColor];
        
        [view alignParentCenter:CGPointMake(0.0, 0.0)];
        [view alignParentBottomWithMargin:-view.f_height];
    } animating:^(UIWindow *window, UIView *view) {
        window.backgroundColor = [UIColor colorWithWhite:0.0 alpha: alpha == 0 ? 0.3 : alpha];
        
        [view alignParentBottom];
    } completion:nil];
}

/** 从下弹出 */
- (void)skpop_FlyOutToBottom:(UIView *)view completion:(void (^)(UIWindow *window, UIView *view))completion
{
    [self pop_hideView:view animate:YES duration:0.3f willAnimate:nil animating:^(UIWindow *window, UIView *view) {
        window.backgroundColor = [UIColor clearColor];
        [view alignParentBottomWithMargin:-view.f_height];
    } completion:completion];
}

/** 自定义 弹出 */
- (void)skpop_showView:(UIView *)view defaultHideEnable:(BOOL)defaultHideEnable animate:(BOOL)animate duration:(NSTimeInterval)duration willAnimate:(void (^)(UIWindow *window, UIView *view))willAnimate animating:(void (^)(UIWindow *window, UIView *view))animating completion:(void (^)(UIWindow *window, UIView *view))completion
{
    self.typeAnimate = 0;
    
    [self pop_showView:view defaultHideEnable:defaultHideEnable animate:animate duration:duration willAnimate:willAnimate animating:animating completion:completion];
}

/** 自定义 隐藏 */
- (void)skpop_hideView:(UIView *)view animate:(BOOL)animate duration:(NSTimeInterval)duration willAnimate:(void (^)(UIWindow *window, UIView *view))willAnimate animating:(void (^)(UIWindow *window, UIView *view))animating completion:(void (^)(UIWindow *window, UIView *view))completion
{
    
    self.custom_animate = animate;
    self.custom_duration = duration;
    self.custom_willAnimate = willAnimate;
    self.custom_animating = animating;
    self.custom_completion = completion;
    
    [self pop_hideView:view animate:animate duration:duration willAnimate:willAnimate animating:animating completion:completion];
}

@end
