//
//  NSString+SizeCalculate.h
//  ucar_customer
//
//  Created by nia_wei on 15-4-29.
//  Copyright (c) 2015年 gogotown. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface NSString (SizeCalculate)

/**
 *  根据 fontSize大小 ，固定高度，计算文本宽度
 */
- (CGFloat)sc_calculateWidthInFontSize:(CGFloat)fontSize withStableHeight:(CGFloat)stableHeight;

/**
 *  根据 fontSize大小 ，固定宽度，计算文本高度
 */
- (CGFloat)sc_calculateHeightInFontSize:(CGFloat)fontSize withStableWidth:(CGFloat)stableWidth;

/**
 *  去掉字符串中 \n
 */
+ (NSString *)modifyJsonStr:(NSString *)string;

/**
 *  转化json字符串
 */
+ (NSString *)tojsonString:(id)C_Obj;

@end
