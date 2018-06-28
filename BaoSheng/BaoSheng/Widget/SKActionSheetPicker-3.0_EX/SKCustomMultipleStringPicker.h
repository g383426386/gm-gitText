//
//  SKCustomMultipleStringPicker.h
//  marketplateform
//
//  Created by Jajo_ios_lzl on 17/6/5.
//  Copyright © 2017年 com.sjyt. All rights reserved.
//

#import "AbstractActionSheetPicker.h"
@class SKCustomMultipleStringPicker;

typedef void (^ActionMultipleStringDictDoneBlock)(SKCustomMultipleStringPicker *picker, NSArray *selectedIndexs, NSString *firstStr, NSString *seconderStr);
typedef void (^ActionMultipleStringDictCancelBlock)(SKCustomMultipleStringPicker *picker);

@interface SKCustomMultipleStringPicker : AbstractActionSheetPicker

@property (nonatomic, copy) ActionMultipleStringDictDoneBlock onActionSheetDone;
@property (nonatomic, copy) ActionMultipleStringDictCancelBlock onActionSheetCancel;

- (instancetype)initWithTitle:(NSString *)title floor:(NSInteger)floor limit:(NSInteger)limit unitStr:(NSString *)unitStr initialIndexs:(NSArray *)indexs selectStr:(NSString *)selectStr doneBlock:(ActionMultipleStringDictDoneBlock)doneBlock cancelBlock:(ActionMultipleStringDictCancelBlock)cancelBlock origin:(id)origin;

@end
