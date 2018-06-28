//
//  SKCustomSheetPicker.m
//  marketplateform
//
//  Created by Jajo_ios_lzl on 17/5/15.
//  Copyright © 2017年 com.sjyt. All rights reserved.
//

#import "SKCustomSheetPicker.h"
#import "AbstractActionSheetPicker+SKToolBarInterface.h"

@implementation SKCustomSheetPicker

//单选的picker
+ (SKCustomStringPicker *)showStringPickerWithTitle:(NSString *)title
                                              rows:(NSArray *)strings
                               initialSelectionStr:(NSString *)selectorStr
                                         doneBlock:(ActionStringDoneBlock)doneBlock
                                       cancelBlock:(ActionStringCancelBlock)cancelBlockOrNil
                                            origin:(id)origin {
    
    //计算选中的那项，回填
    NSInteger selectionIndex = [strings indexOfObject:selectorStr];
    if(selectionIndex == NSNotFound) {
        selectionIndex = 0;
    }
    SKCustomStringPicker *actionPicker = [[SKCustomStringPicker alloc]initWithTitle:title rows:strings initialSelection:selectionIndex doneBlock:doneBlock cancelBlock:cancelBlockOrNil origin:origin];
    
    [actionPicker customizeInterface];
    [actionPicker showActionSheetPicker];
    
    return actionPicker;
}

//日期选择(现在只考虑了选择生日类型的)
+ (SKCustomDatePicker *)showDatePickerWithTitle:(NSString *)title
                                 datePickerMode:(UIDatePickerMode)datePickerMode
                                   selectedDate:(NSDate *)selectedDate
                                    minimumDate:(NSDate *)minimumDate
                                    maximumDate:(NSDate *)maximumDate
                                      doneBlock:(ActionDateDoneBlock)doneBlock
                                    cancelBlock:(ActionDateCancelBlock)cancelBlock
                                         origin:(UIView*)view {
    
    SKCustomDatePicker *datePicker = [[SKCustomDatePicker alloc] initWithTitle:title
                                                                datePickerMode:datePickerMode
                                                                  selectedDate:selectedDate
                                                                     doneBlock:doneBlock
                                                                   cancelBlock:cancelBlock
                                                                        origin:view];
    [datePicker setMinimumDate:minimumDate];
    [datePicker setMaximumDate:maximumDate];
    [datePicker setLocale:[NSLocale localeWithLocaleIdentifier:@"zh_CN"]];
//    NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
//    [formatter setDateFormat:@"yyyy-MM-dd"];
    NSTimeZone* sourceTimeZone = [NSTimeZone systemTimeZone];
    datePicker.timeZone = sourceTimeZone;
    [datePicker customizeInterface];
    [datePicker showActionSheetPicker];

    return datePicker;
    
}


/** 双选的*/
+ (SKCustomMultipleStringPicker *)showMultipleStringPickertWithTitle:(NSString *)title
                                                               floor:(NSInteger)floor
                                                               limit:(NSInteger)limit
                                                             unitStr:(NSString *)unitStr
                                                       initialIndexs:(NSArray *)indexs
                                                           selectStr:(NSString *)selectStr
                                                           doneBlock:(ActionMultipleStringDictDoneBlock)doneBlock
                                                         cancelBlock:(ActionMultipleStringDictCancelBlock)cancelBlock
                                                              origin:(id)origin {
    
 
    SKCustomMultipleStringPicker *multipleStrPicker = [[SKCustomMultipleStringPicker alloc]initWithTitle:title floor:floor limit:limit unitStr:unitStr initialIndexs:indexs selectStr:selectStr doneBlock:doneBlock cancelBlock:cancelBlock origin:origin];
    
    [multipleStrPicker customizeInterface];
    [multipleStrPicker showActionSheetPicker];

    return multipleStrPicker;
    
}

+ (SKCustomChinaLocalePicker *)showChinaLocalePickerWithTitle:(NSString *)title
                                                initialIndexs:(NSArray *)indexs
                                                    selectStr:(NSString *)selectStr
                                                    doneBlock:(ActionStringDictDoneBlock)doneBlock
                                                  cancelBlock:(ActionStringDictCancelBlock)cancelBlock
                                                       origin:(id)origin {
    
    SKCustomChinaLocalePicker * localePicker = [[SKCustomChinaLocalePicker alloc]initWithTitle:title initialIndexs:indexs selectStr:selectStr doneBlock:doneBlock cancelBlock:cancelBlock origin:origin];
    [localePicker customizeInterface];
    [localePicker showActionSheetPicker];
    
    return localePicker;
}


@end
