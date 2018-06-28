//
//  UIView+FrameRelated.h
//
//
//  Created by vic_wei on 15/10/18.
//  Copyright © 2015年 vic_wei. All rights reserved.
//

#import <Foundation/Foundation.h>

#import <UIKit/UIKit.h>

@interface UIView (FrameRelated)

@property (assign, nonatomic) CGFloat    f_top;
@property (assign, nonatomic) CGFloat    f_bottom;
@property (assign, nonatomic) CGFloat    f_left;
@property (assign, nonatomic) CGFloat    f_right;

@property (assign, nonatomic) CGFloat    f_x;
@property (assign, nonatomic) CGFloat    f_y;
@property (assign, nonatomic) CGPoint    f_origin;

@property (assign, nonatomic) CGFloat    f_centerX;
@property (assign, nonatomic) CGFloat    f_centerY;

@property (assign, nonatomic) CGFloat    f_width;
@property (assign, nonatomic) CGFloat    f_height;
@property (assign, nonatomic) CGSize     f_size;

@end
