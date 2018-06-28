//
//  SKCustomMultipleStringPicker.m
//  marketplateform
//
//  Created by Jajo_ios_lzl on 17/6/5.
//  Copyright © 2017年 com.sjyt. All rights reserved.
//

#import "SKCustomMultipleStringPicker.h"

#define kFontSize 15

@interface SKCustomMultipleStringPicker ()<UIPickerViewDataSource, UIPickerViewDelegate>


@property (nonatomic, assign) NSInteger firstRow;
@property (nonatomic, assign) NSInteger secondRow;
@property (nonatomic, strong) NSMutableArray *dataArr;
@property (nonatomic, strong) NSString *unitStr;
@end

@implementation SKCustomMultipleStringPicker


- (instancetype)initWithTitle:(NSString *)title floor:(NSInteger)floor limit:(NSInteger)limit unitStr:(NSString *)unitStr initialIndexs:(NSArray *)indexs selectStr:(NSString *)selectStr doneBlock:(ActionMultipleStringDictDoneBlock)doneBlock cancelBlock:(ActionMultipleStringDictCancelBlock)cancelBlock origin:(id)origin {
    
    self = [super initWithTarget:nil successAction:nil cancelAction:nil origin:origin];
    if (self) {
        
        self.firstRow = 0;
        self.secondRow = 0;
        self.unitStr = unitStr;
        
        self.dataArr = [[NSMutableArray alloc]init];
        [self.dataArr addObject:@"不限"];
        for (int i = floor; i <= limit; i ++) {
            [self.dataArr addObject:[NSString stringWithFormat:@"%d",i]];
        }
        if (indexs) {
            self.firstRow = [indexs.firstObject integerValue];
            self.secondRow = [indexs.lastObject integerValue];
        }
        if (selectStr.length>0) {
            NSArray * selectArr = [selectStr componentsSeparatedByString:@"-"];
            
            [self.dataArr enumerateObjectsUsingBlock:^(NSString *  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                if ([selectArr.firstObject isEqualToString:obj]) {
                    self.firstRow = idx;
                }
                if ([selectArr.lastObject isEqualToString:obj]) {
                    self.secondRow = idx;
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
    
    if (self.dataArr.count <= 0) {
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
    NSString *firstStr = self.dataArr[self.firstRow];
    NSString *secondStr = self.dataArr[self.secondRow];
    if ([firstStr isEqualToString:@"不限"] && [secondStr isEqualToString:@"不限"]) {
        firstStr = @"";
        secondStr = @"";
    }else if ([firstStr isEqualToString:@"不限"] && ![secondStr isEqualToString:@"不限"]){
        firstStr = self.dataArr[0];
    }
    if (_onActionSheetDone) {
        _onActionSheetDone(self, [self selectedIndexs], firstStr, secondStr);
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
    
    return self.dataArr.count;
}

- (NSAttributedString *)pickerView:(UIPickerView *)pickerView attributedTitleForRow:(NSInteger)row forComponent:(NSInteger)component {
    
    id obj = nil;
    
    NSString * str = self.dataArr[row];
    if ([str isEqualToString:@"不限"]) {
        obj = str;
    }else {
        obj = [NSString stringWithFormat:@"%@%@",str,self.unitStr];
    }
    
    if ((component == 0 &&  self.firstRow == row) || (component == 1 && self.secondRow == row)) {
        return [[NSAttributedString alloc] initWithString:obj attributes:@{NSForegroundColorAttributeName:UIColorFromHex(0xE84186)}];
    }else
        return [[NSAttributedString alloc] initWithString:obj attributes:self.pickerTextAttributes];
        
    
    return nil;
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    
    if (component == 0) {
        
        self.firstRow = row;
        if (self.firstRow >= self.secondRow) {
            [pickerView selectRow:row inComponent:1 animated:YES];
            self.secondRow = self.firstRow;
        }
    } else {
        
        self.secondRow = row;
        if (self.firstRow >= self.secondRow) {
            
            [pickerView selectRow:self.firstRow inComponent:1 animated:YES];
            self.secondRow = self.firstRow;
        }
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




@end
