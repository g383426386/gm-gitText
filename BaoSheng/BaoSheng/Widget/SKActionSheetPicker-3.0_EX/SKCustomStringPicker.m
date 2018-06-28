//
//  SKCustomStringPicker.m
//  marketplateform
//
//  Created by Jajo_ios_lzl on 17/5/15.
//  Copyright © 2017年 com.sjyt. All rights reserved.
//  单选的picker

#import "SKCustomStringPicker.h"

#define kFontSize 15

@interface SKCustomStringPicker ()

@property (nonatomic,assign) NSInteger selectedIndex;

@end

@implementation SKCustomStringPicker


- (UIView *)configuredPickerView {
    
    [super configuredPickerView];
    
    UIView *view = self.pickerView;
    
    
    UIView *lineView = [[UIView alloc]initWithFrame:CGRectMake(0, -25, self.pickerView.frame.size.width, 1)];
    lineView.backgroundColor = UIColorFromHex(0xDBDBDB);
    [view addSubview:lineView];
    
    UILabel * label = [[UILabel alloc]initWithFrame:CGRectMake(0, -20, self.pickerView.frame.size.width, 45)];
    label.backgroundColor = [UIColor clearColor];
    label.numberOfLines = 2;
    label.text = [NSString stringWithFormat:@"%@\n----------",self.title];
    label.textAlignment = NSTextAlignmentCenter;
    label.textColor = UIColorFromHex(0xAFB2C0);
    label.font = [UIFont systemFontOfSize:kFontSize];
    [view addSubview:label];
    
    view.layer.masksToBounds = NO;
    
    return view;
}



//为了完成<选中的颜色还要变一下需求>
- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    [super pickerView:pickerView didSelectRow:row inComponent:component];
    self.selectedIndex = row;
    [pickerView reloadAllComponents];
}
- (UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view {
    
    
    UIView * superview = [super pickerView:pickerView viewForRow:row forComponent:component reusingView:view];
    for(UIView *singleLine in pickerView.subviews)
    {
        if (singleLine.frame.size.height < 1)
        {
            singleLine.backgroundColor = UIColorFromHex(0x222231);
        }
    }

    UILabel * label = (UILabel *)superview;
    
    if (self.selectedIndex == row) {
        label.textColor = kappButtonBackgroundColor; //UIColorFromHex(0xE84186);
    }
    return label;
    
}


@end
