//
//  BSGlobalButton.h
//  BaoSheng
//
//  Created by GML on 2018/4/23.
//  Copyright © 2018年 haozheng. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, GlobalButtonStyle) {
    
    GlobalButtonStyle_None,
    /** 一半圆角 红色背景*/
    GlobalButtonStyle_Conerhaf,
    /** 空心button 红色layer*/
    GlobalButtonStyle_Empty_RedLayer,
    /** 矩形 红色背景*/
    GlobalButtonStyle_RedBK,
    
};

@interface BSGlobalButton : UIButton

+ (BSGlobalButton *)buttonWithButtonSize:(CGSize)size
                                   coner:(CGFloat)coner
                                   title:(NSString *)title
                               titleFont:(CGFloat)font
                         backgroundColor:(UIColor *)backgroundColor
                       globalButtonStyle:(GlobalButtonStyle)style;

@end
