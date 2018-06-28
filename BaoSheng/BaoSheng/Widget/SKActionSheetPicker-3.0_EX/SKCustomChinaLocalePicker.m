//
//  SKCustomChinaLocalePicker.m
//  marketplateform
//
//  Created by Jajo_ios_lzl on 17/5/15.
//  Copyright © 2017年 com.sjyt. All rights reserved.
//

#import "SKCustomChinaLocalePicker.h"
#import "City.h"


#define kFontSize 15

@interface SKCustomChinaLocalePicker () <UIPickerViewDataSource, UIPickerViewDelegate>

@property (nonatomic, assign) NSInteger firstRow;
@property (nonatomic, assign) NSInteger secondRow;

@property (nonatomic, strong) NSArray *provincesArr;

@end

@implementation SKCustomChinaLocalePicker

- (instancetype)initWithTitle:(NSString *)title initialIndexs:(NSArray *)indexs selectStr:(NSString *)selectStr doneBlock:(ActionStringDictDoneBlock)doneBlock cancelBlock:(ActionStringDictCancelBlock)cancelBlock origin:(id)origin {
    
    self = [super initWithTarget:nil successAction:nil cancelAction:nil origin:origin];
    if (self) {
        
        self.firstRow = 0;
        self.secondRow = 0;
        
        NSArray * array = [City sharedCity].allProvinces;
        self.provincesArr = [SKChinaProvincesModel mj_objectArrayWithKeyValuesArray:array];
        
        if (indexs) {
            self.firstRow = [indexs.firstObject integerValue];
            self.secondRow = [indexs.lastObject integerValue];
        }
        if (selectStr.length>0) {
            NSArray * selectArr = [selectStr componentsSeparatedByString:@"-"];

            [self.provincesArr enumerateObjectsUsingBlock:^(SKChinaProvincesModel  *obj, NSUInteger idx, BOOL * _Nonnull stop) {
                if ([selectArr.firstObject isEqualToString:obj.name]) {
                    self.firstRow = idx;
                    [obj.Citys enumerateObjectsUsingBlock:^(SKChinaCitysModel  * city, NSUInteger cityIdx, BOOL * _Nonnull stop) {
                        if ([selectArr.lastObject isEqualToString:city.name]) {
                            self.secondRow = cityIdx;
                            *stop = YES;
                        }
                    }];
                    *stop = YES;
                }
            }];
        }

        _onActionSheetDone = doneBlock;
        _onActionSheetCancel = cancelBlock;
        self.title = title;
    }
    
    return self;
}


#pragma mark - Override Super Method

- (UIView *)configuredPickerView {

    if (self.provincesArr.count <= 0) {
        return nil;
    }
    CGRect pickerFrame = CGRectMake(0, 40, self.viewSize.width, 216);
    UIPickerView *stringDictPicker = [[UIPickerView alloc] initWithFrame:pickerFrame];
    stringDictPicker.delegate = self;
    stringDictPicker.dataSource = self;
    
    stringDictPicker.showsSelectionIndicator = YES;
    stringDictPicker.userInteractionEnabled = YES;
    
    [self performInitialSelectionInPickerView:stringDictPicker];
    
    self.pickerView = stringDictPicker;
    UIView *lineView = [[UIView alloc]initWithFrame:CGRectMake(0, -25, self.pickerView.frame.size.width, 1)];
    lineView.backgroundColor = UIColorFromHex(0xDBDBDB);
    [stringDictPicker addSubview:lineView];
    
    UILabel * label = [[UILabel alloc]initWithFrame:CGRectMake(0, -20, self.pickerView.frame.size.width, 45)];
    label.backgroundColor = [UIColor clearColor];
    label.numberOfLines = 2;
    label.text = [NSString stringWithFormat:@"%@\n----------",self.title];
    label.textAlignment = NSTextAlignmentCenter;
    label.textColor = UIColorFromHex(0xAFB2C0);
    label.font = [UIFont systemFontOfSize:kFontSize];
    [stringDictPicker addSubview:label];
    
    stringDictPicker.layer.masksToBounds = NO;

    //线线变黑
    for (UIView *view in self.pickerView.subviews) {
        if ([view isKindOfClass:[UIView class]]) {
            if (view.frame.size.height < 1) {
                view.backgroundColor = UIColorFromHex(0x222231);
            }
        }
    }

    return stringDictPicker;
}

- (void)notifyTarget:(id)target didSucceedWithAction:(SEL)successAction origin:(id)origin {
    if (_onActionSheetDone) {
        _onActionSheetDone(self, [self selectedIndexs], [self selection]);
        return;
    }
}

- (void)notifyTarget:(id)target didCancelWithAction:(SEL)cancelAction origin:(id)origin {
    if (_onActionSheetCancel) {
        _onActionSheetCancel(self);
        return;
    }
}


#pragma mark - UIPickerView DataSource && Delegate

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    return 2;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    if (component == 0) {
        return self.provincesArr.count;
    } else {
        SKChinaProvincesModel *provincesModel = self.provincesArr[self.firstRow];
        return provincesModel.Citys.count;
    }
}
//-(UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view{
//
//    UILabel *lbl = (UILabel *)view;
//
//    if (lbl == nil) {
//
//        lbl = [[UILabel alloc]init];
//
//        //在这里设置字体相关属性
//
//        lbl.font = [UIFont systemFontOfSize:14];
//
//        [lbl setTextAlignment:0];
//
//        [lbl setBackgroundColor:[UIColor clearColor]];
//
//    }
//
//    //重新加载lbl的文字内容
//
//    lbl.text = [self pickerView:pickerView titleForRow:row forComponent:component];
//
//    return lbl;
//}
- (NSAttributedString *)pickerView:(UIPickerView *)pickerView attributedTitleForRow:(NSInteger)row forComponent:(NSInteger)component {

    id obj = nil;
    if (component == 0) {
        SKChinaProvincesModel *provincesModel = self.provincesArr[row];

        obj = provincesModel.name;
        
    } else {
        SKChinaProvincesModel *provincesModel = self.provincesArr[self.firstRow];
        SKChinaCitysModel *city = provincesModel.Citys[row];
        obj = city.name;
    }
   
    if ([obj isKindOfClass:[NSString class]]) {
        
        
        if (component == 0 &&  self.firstRow == row) {
            return [[NSAttributedString alloc] initWithString:obj attributes:@{NSForegroundColorAttributeName:kappButtonBackgroundColor
                                                                               }];

        }else if (component == 1 && self.secondRow == row) {
            return [[NSAttributedString alloc] initWithString:obj attributes:@{NSForegroundColorAttributeName:kappButtonBackgroundColor
                                                                              
                                                                               }];
            
        }else
            return [[NSAttributedString alloc] initWithString:obj attributes:self.pickerTextAttributes];

    }
    
    if ([obj respondsToSelector:@selector(description)])
        return [[NSAttributedString alloc] initWithString:[obj performSelector:@selector(description)] attributes:self.pickerTextAttributes];
    
    return nil;
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    
    if (component == 0) {
        
        self.firstRow = row;
        self.secondRow = 0;
        [pickerView selectRow:0 inComponent:1 animated:NO];
    } else {
        self.secondRow = row;
    }
    [pickerView reloadAllComponents];

}


#pragma mark - Private Method

- (void)performInitialSelectionInPickerView:(UIPickerView *)pickerView {
    [pickerView selectRow:self.firstRow inComponent:0 animated:NO];
    [pickerView selectRow:self.secondRow inComponent:1 animated:NO];
}

- (NSArray *)selectedIndexs {
    NSArray *selectedIndexs = [[NSArray alloc] initWithObjects:@(self.firstRow),@(self.secondRow), nil];
    return selectedIndexs;
}

- (NSArray *)selection {
    SKChinaProvincesModel *provincesModel = self.provincesArr[self.firstRow];
    SKChinaCitysModel *cityModel = provincesModel.Citys[self.secondRow];
    
    NSMutableArray *selections = [NSMutableArray array];
    [selections addObject:provincesModel];
    [selections addObject:cityModel];
    
    return selections;
}

#pragma mark - other
//提供给外面，让外面判断是不是要显示选择器
+ (NSArray *)findLocationCityModelWithProvincesName:(NSString *)ProvincesName CityName:(NSString *)cityName {
    
    NSArray * allProvincesArray = [City sharedCity].allProvinces;
    NSArray * provincesArr = [SKChinaProvincesModel mj_objectArrayWithKeyValuesArray:allProvincesArray];
    
    if (ProvincesName.length == 0 || cityName.length == 0) {
        return [[NSArray alloc]init];
    }
    
    NSMutableArray *array = [[NSMutableArray alloc]init];
    cityName = [cityName stringByReplacingOccurrencesOfString:@"市" withString:@""];
    ProvincesName = [ProvincesName stringByReplacingOccurrencesOfString:@"市" withString:@""];
    ProvincesName = [ProvincesName stringByReplacingOccurrencesOfString:@"省" withString:@""];
    
    [provincesArr enumerateObjectsUsingBlock:^(SKChinaProvincesModel  *obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([ProvincesName isEqualToString:obj.name]) {
            [array addObject:obj];
            [obj.Citys enumerateObjectsUsingBlock:^(SKChinaCitysModel  * city, NSUInteger cityIdx, BOOL * _Nonnull stop) {
                if ([cityName isEqualToString:city.name]) {
                    [array addObject:city];
                    *stop = YES;
                }
            }];
            *stop = YES;
        }
    }];
    if (array.count == 2) {
        return array;
    }else
        return [[NSArray alloc]init];
    
}
@end
