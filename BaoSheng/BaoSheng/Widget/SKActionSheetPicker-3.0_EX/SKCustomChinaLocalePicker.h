//
//  SKCustomChinaLocalePicker.h
//  marketplateform
//
//  Created by Jajo_ios_lzl on 17/5/15.
//  Copyright © 2017年 com.sjyt. All rights reserved.
//

#import "AbstractActionSheetPicker.h"
#import "SKChinaProvincesModel.h"

@class SKCustomChinaLocalePicker;

typedef void (^ActionStringDictDoneBlock)(SKCustomChinaLocalePicker *picker, NSArray *selectedIndexs, id selectedValues);
typedef void (^ActionStringDictCancelBlock)(SKCustomChinaLocalePicker *picker);

@interface SKCustomChinaLocalePicker : AbstractActionSheetPicker

@property (nonatomic, copy) ActionStringDictDoneBlock onActionSheetDone;
@property (nonatomic, copy) ActionStringDictCancelBlock onActionSheetCancel;

- (instancetype)initWithTitle:(NSString *)title initialIndexs:(NSArray *)indexs selectStr:(NSString *)selectStr doneBlock:(ActionStringDictDoneBlock)doneBlock cancelBlock:(ActionStringDictCancelBlock)cancelBlock origin:(id)origin;

/** 提供给外面，让外面判断是不是要显示选择器*/
+ (NSArray *)findLocationCityModelWithProvincesName:(NSString *)ProvincesName CityName:(NSString *)cityName;

@end
