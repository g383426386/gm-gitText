//
//  UIScrollView+FDFullscreenPopGesture.h
//  ShareLib
//
//  Created by vic_wei on 16/1/28.
//  Copyright © 2016年 vic_wei. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIScrollView (FDFullscreenPopGesture)

/**
 *  register scroll popGesture nav
 */
- (void)fd_registerPopGestureWithNav:(UINavigationController*)nav;

@end
