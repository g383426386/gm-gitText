//
//  UIView+FrameRelated.m
//  
//
//  Created by vic_wei on 15/10/18.
//  Copyright © 2015年 vic_wei. All rights reserved.
//


#import "UIView+FrameRelated.h"

@implementation UIView (FrameRelated)

@dynamic f_top;
@dynamic f_bottom;
@dynamic f_left;
@dynamic f_right;

@dynamic f_width;
@dynamic f_height;

@dynamic f_size;

@dynamic f_x;
@dynamic f_y;

- (CGFloat)f_top
{
    return self.frame.origin.y;
}

- (void)setF_top:(CGFloat)f_top
{
    CGRect frame = self.frame;
    frame.origin.y = f_top;
    self.frame = frame;
}

- (CGFloat)f_left
{
    return self.frame.origin.x;
}

- (void)setF_left:(CGFloat)f_left
{
    CGRect frame = self.frame;
    frame.origin.x = f_left;
    self.frame = frame;
}

- (CGFloat)f_bottom
{
    return self.frame.size.height + self.frame.origin.y;
}

- (void)setF_bottom:(CGFloat)f_bottom
{
    CGRect frame = self.frame;
    frame.origin.y = f_bottom - frame.size.height;
    self.frame = frame;
}

- (CGFloat)f_right
{
    return self.frame.size.width + self.frame.origin.x;
}

- (void)setF_right:(CGFloat)f_right
{
    CGRect frame = self.frame;
    frame.origin.x = f_right - frame.size.width;
    self.frame = frame;
}

- (CGFloat)f_x
{
    return self.frame.origin.x;
}

- (void)setF_x:(CGFloat)f_x
{
    CGRect frame = self.frame;
    frame.origin.x = f_x;
    self.frame = frame;
}

- (CGFloat)f_y
{
    return self.frame.origin.y;
}

- (void)setF_y:(CGFloat)f_y
{
    CGRect frame = self.frame;
    frame.origin.y = f_y;
    self.frame = frame;
}

- (CGPoint)f_origin
{
    return self.frame.origin;
}

- (void)setF_origin:(CGPoint)f_origin
{
    CGRect frame = self.frame;
    frame.origin = f_origin;
    self.frame = frame;
}

- (CGFloat)f_centerX
{
    return self.center.x;
}

- (void)setF_centerX:(CGFloat)f_centerX
{
    CGPoint center = self.center;
    center.x = f_centerX;
    self.center = center;
}

- (CGFloat)f_centerY
{
    return self.center.y;
}

- (void)setF_centerY:(CGFloat)f_centerY
{
    CGPoint center = self.center;
    center.y = f_centerY;
    self.center = center;
}

- (CGFloat)f_width
{
    return self.frame.size.width;
}

- (void)setF_width:(CGFloat)f_width
{
    CGRect frame = self.frame;
    frame.size.width = f_width;
    self.frame = frame;
}

- (CGFloat)f_height
{
    return self.frame.size.height;
}

- (void)setF_height:(CGFloat)f_height
{
    CGRect frame = self.frame;
    frame.size.height = f_height;
    self.frame = frame;
}

- (CGSize)f_size
{
    return self.frame.size;
}

- (void)setF_size:(CGSize)f_size
{
    CGRect frame = self.frame;
    frame.size = f_size;
    self.frame = frame;
}

@end