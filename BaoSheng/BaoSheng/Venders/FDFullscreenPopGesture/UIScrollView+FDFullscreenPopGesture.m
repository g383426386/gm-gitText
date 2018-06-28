//
//  UIScrollView+FDFullscreenPopGesture.m
//  ShareLib
//
//  Created by vic_wei on 16/1/28.
//  Copyright © 2016年 vic_wei. All rights reserved.
//

#import "UIScrollView+FDFullscreenPopGesture.h"
#import <objc/runtime.h>
#import "Aspects.h"

@interface UIScrollView ()

@property (nonatomic , strong) NSObject *fd_internalTarget;

@property (nonatomic , strong) UINavigationController *fd_nav;

@property (nonatomic , assign) BOOL fd_startAop;

@property (nonatomic , assign) BOOL fd_isHook;

/**
 *  superView 将要remove
 */
- (void)fd_dealloc;

@end

@implementation UIScrollView (FDFullscreenPopGesture)

#pragma mark - get set
static char internalTarget_key;
- (void)setFd_internalTarget:(NSObject *)fd_internalTarget
{
    objc_setAssociatedObject(self, &internalTarget_key, fd_internalTarget, OBJC_ASSOCIATION_RETAIN);
}

- (NSObject *)fd_internalTarget
{
    NSObject *_fd_internalTarget = objc_getAssociatedObject(self, &internalTarget_key);
    return _fd_internalTarget;
}

static char fd_nav_key;
- (void)setFd_nav:(UINavigationController *)fd_nav
{
    objc_setAssociatedObject(self, &fd_nav_key, fd_nav, OBJC_ASSOCIATION_RETAIN);
}

- (UINavigationController *)fd_nav
{
    UINavigationController *_fd_nav = objc_getAssociatedObject(self, &fd_nav_key);
    return _fd_nav;
}

static void *fd_startAop_key = &fd_startAop_key;
- (void)setFd_startAop:(BOOL)fd_startAop
{
    objc_setAssociatedObject(self, &fd_startAop_key, [NSNumber numberWithBool:fd_startAop], OBJC_ASSOCIATION_RETAIN);
}

- (BOOL)fd_startAop
{
    NSNumber *_fd_startAop = objc_getAssociatedObject(self, &fd_startAop_key);
    return _fd_startAop.boolValue;
}

static char fd_isHook_key;
- (void)setFd_isHook:(BOOL)fd_isHook
{
    objc_setAssociatedObject(self, &fd_isHook_key, [NSNumber numberWithBool:fd_isHook], OBJC_ASSOCIATION_RETAIN);
}

- (BOOL)fd_isHook
{
    NSNumber *_fd_isHook = objc_getAssociatedObject(self, &fd_isHook_key);
    return _fd_isHook.boolValue;
}

#pragma mark - api
- (void)fd_registerPopGestureWithNav:(UINavigationController*)nav
{
    if (!nav) return;
    
    if (!self.fd_isHook) {
        
        self.fd_nav = nav;
        
        //add hook swizz
        SEL sel = NSSelectorFromString(@"dealloc");
        [self aspect_hookSelector:sel withOptions:AspectPositionBefore usingBlock:^(id<AspectInfo> info){
            NSLog(@"%@" , info.instance);
            UIScrollView *scroll = info.instance;
            [scroll fd_dealloc];
            
        } error:NULL];
        
        [self.panGestureRecognizer addTarget:self action:@selector(aopPan:)];
        
        self.fd_isHook = YES;
    }
    
    /**
     [self addObserver:self forKeyPath:@"contentOffset" options:NSKeyValueObservingOptionNew|NSKeyValueObservingOptionOld context:nil];
     NSArray *internalTargets = [nav.interactivePopGestureRecognizer valueForKey:@"targets"];
     NSObject *internalTarget = [internalTargets.firstObject valueForKey:@"target"];
     SEL internalAction = NSSelectorFromString(@"handleNavigationTransition:");
     [self.panGestureRecognizer addTarget:internalTarget action:internalAction];
     */
    
}

- (void)aopPan:(UIPanGestureRecognizer*)panGesture
{
    if (!self.fd_internalTarget) {
        NSArray *internalTargets = [self.fd_nav.interactivePopGestureRecognizer valueForKey:@"targets"];
        NSObject *internalTarget = [internalTargets.firstObject valueForKey:@"target"];
        self.fd_internalTarget = internalTarget;
    }
    SEL internalAction = NSSelectorFromString(@"handleNavigationTransition:");
    if (panGesture.state == UIGestureRecognizerStateBegan) {
        // .x>0 向右滑动
        CGPoint offsetPan = [panGesture translationInView:panGesture.view];
        if (offsetPan.x > 0 && self.contentOffset.x < 0) {
            self.fd_startAop = YES;
            [self performTarget:self.fd_internalTarget selector:internalAction withObject:panGesture];
            self.contentOffset = (CGPoint){0.0 , self.contentOffset.y};
        }
    }else{
        if (self.fd_startAop)
        {
            [self performTarget:self.fd_internalTarget selector:internalAction withObject:panGesture];
            self.contentOffset = (CGPoint){0.0 , self.contentOffset.y};
            
            if (panGesture.state == UIGestureRecognizerStateEnded) {
                self.fd_startAop = NO;
            }
        }
    }
    
}

- (void)performTarget:(id)target selector:(SEL)aSelector withObject:(id)object
{
    if ([target respondsToSelector:aSelector]) {
        [target performSelector:aSelector withObject:object];
    }
}

- (void)fd_dealloc
{
    if (self.fd_internalTarget) {
        SEL internalAction = NSSelectorFromString(@"handleNavigationTransition:");
        [self.panGestureRecognizer removeTarget:self.fd_internalTarget action:internalAction];
        self.fd_internalTarget = nil;
    }
    self.fd_nav = nil;
//    [self removeObserver:self forKeyPath:@"contentOffset"];
}

//- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSString *,id> *)change context:(void *)context
//{
//    
//    if ( [@"contentOffset" isEqualToString:keyPath] && [object isKindOfClass:[UIScrollView class]] && object == self ) {
//        
//        UIScrollView *scroll = object;
//        CGPoint offset = scroll.contentOffset;
//        if (offset.x <= 0) {
//            scroll.bounces = NO;
//            if (!scroll.fd_internalTarget) {
//                NSArray *internalTargets = [self.fd_nav.interactivePopGestureRecognizer valueForKey:@"targets"];
//                id internalTarget = [internalTargets.firstObject valueForKey:@"target"];
//                SEL internalAction = NSSelectorFromString(@"handleNavigationTransition:");
//                [scroll.panGestureRecognizer addTarget:internalTarget action:internalAction];
//               scroll.fd_internalTarget = internalTarget;
//            }
//        }else{
////            scroll.bounces = YES;
//            scroll.bounces = NO;
//            if (scroll.fd_internalTarget) {
//                if (scroll.panGestureRecognizer.state != UIGestureRecognizerStateBegan && scroll.panGestureRecognizer.state != UIGestureRecognizerStateChanged) {
//                    SEL internalAction = NSSelectorFromString(@"handleNavigationTransition:");
//                    [scroll.panGestureRecognizer removeTarget:scroll.fd_internalTarget action:internalAction];
//                    scroll.fd_internalTarget = nil;
//                }
//            }
//        }
//        
//    }else{
//        [super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
//    }
//}

@end
