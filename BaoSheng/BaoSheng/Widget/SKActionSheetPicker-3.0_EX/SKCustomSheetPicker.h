//
//  SKCustomSheetPicker.h
//  marketplateform
//
//  Created by Jajo_ios_lzl on 17/5/15.
//  Copyright © 2017年 com.sjyt. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ActionSheetPicker.h"
#import "SKCustomStringPicker.h"
#import "SKCustomDatePicker.h"
#import "SKCustomChinaLocalePicker.h"
#import "SKCustomMultipleStringPicker.h"

@interface SKCustomSheetPicker : NSObject

/**
 *  简单的单选
 *
 *  @param title            标题
 *  @param strings          需要显示的数组
 *  @param selectorStr      需要回填的str
 *  @param doneBlock        成功的回调
 *  @param cancelBlockOrNil 取消的回调
 *  @param origin           谁点的（也可以是展示的view）
 *
 *  @return
 */
+ (SKCustomStringPicker *)showStringPickerWithTitle:(NSString *)title
                                              rows:(NSArray *)strings
                               initialSelectionStr:(NSString *)selectorStr
                                         doneBlock:(ActionStringDoneBlock)doneBlock
                                       cancelBlock:(ActionStringCancelBlock)cancelBlockOrNil
                                            origin:(id)origin;

/**
 *  日期的选择器（暂时只写了date的，倒计时的没有）
 *
 *  @param title          标题
 *  @param datePickerMode 默认UIDatePickerModeDate
 *  @param selectedDate   回填的日期
 *  @param minimumDate    最小日期
 *  @param maximumDate    最大日期
 *  @param doneBlock      成功的回调
 *  @param cancelBlock    取消的回调
 *  @param view           谁点的（也可以是展示的view）
 *
 *  @return
 */
+ (SKCustomDatePicker *)showDatePickerWithTitle:(NSString *)title
                                 datePickerMode:(UIDatePickerMode)datePickerMode
                                   selectedDate:(NSDate *)selectedDate
                                    minimumDate:(NSDate *)minimumDate
                                    maximumDate:(NSDate *)maximumDate
                                      doneBlock:(ActionDateDoneBlock)doneBlock
                                    cancelBlock:(ActionDateCancelBlock)cancelBlock
                                         origin:(UIView*)view;





/**
 *  双选的联动数字选择器，类似身高和年龄的选择器
 *
 *  @param title       标题
 *  @param floor       最小值
 *  @param limit       最大值
 *  @param unitStr     单位
 *  @param indexs      回填的index
 *  @param selectStr   回填的字符串(就用[NSString stringWithFormat:@"%@-%@",first, second]这种格式给我，用-隔开)
 *  @param doneBlock   成功的回调
 *  @param cancelBlock 取消的回调
 *  @param origin      谁点的（也可以是展示的view）
 *
 *  @return
 */
+ (SKCustomMultipleStringPicker *)showMultipleStringPickertWithTitle:(NSString *)title
                                                               floor:(NSInteger)floor
                                                               limit:(NSInteger)limit
                                                             unitStr:(NSString *)unitStr
                                                       initialIndexs:(NSArray *)indexs
                                                           selectStr:(NSString *)selectStr
                                                           doneBlock:(ActionMultipleStringDictDoneBlock)doneBlock
                                                         cancelBlock:(ActionMultipleStringDictCancelBlock)cancelBlock
                                                              origin:(id)origin;

/**
 *  地区的选择器（indexs和selectStr只需要填一个就可以，如果都没传，就默认@[@(0),@(0)]）
 *
 *  @param title       标题
 *  @param indexs      回填的index
 *  @param selectStr   回填的字符串(就用[NSString stringWithFormat:@"%@-%@",province, city]这种格式给我，省市用-隔开)
 *  @param doneBlock   成功的回调
 *  @param cancelBlock 取消的回调
 *  @param origin      谁点的（也可以是展示的view）
 *
 *  @return
 */
+ (SKCustomChinaLocalePicker *)showChinaLocalePickerWithTitle:(NSString *)title
                                                initialIndexs:(NSArray *)indexs
                                                    selectStr:(NSString *)selectStr
                                                    doneBlock:(ActionStringDictDoneBlock)doneBlock
                                                  cancelBlock:(ActionStringDictCancelBlock)cancelBlock
                                                       origin:(id)origin;

@end
