//
//  SKCustomDatePicker.m
//  marketplateform
//
//  Created by Jajo_ios_lzl on 17/5/15.
//  Copyright © 2017年 com.sjyt. All rights reserved.
//

#import "SKCustomDatePicker.h"
#define kFontSize 15

@interface SKCustomDatePicker ()

@property (nonatomic,assign) NSInteger selectedIndex;

@end

@implementation SKCustomDatePicker


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
    
    
//    [self.pickerView setValue:UIColorFromRGB(0xE84186) forKey:@"textColor"];
    //通过NSSelectorFromString获取setHighlightsToday方法
//    SEL selector = NSSelectorFromString(@"setHighlightsToday:");
//    //创建NSInvocation
//    NSInvocation *invocation = [NSInvocation invocationWithMethodSignature:[UIDatePicker instanceMethodSignatureForSelector:selector]];
//    BOOL no = NO;
//    [invocation setSelector:selector];
//    //setArgument中第一个参数的类picker，第二个参数是SEL，
//    [invocation setArgument:&no atIndex:2];
//    //让invocation执行setHighlightsToday方法
//    [invocation invokeWithTarget:self.pickerView];
//    
//    
//    for(UIView *singleLine in self.pickerView.subviews)
//    {
//        if (singleLine.frame.size.height < 1)
//        {
//            singleLine.backgroundColor = UIColorFromRGB(0x222231);
//        }
//    }

    //线线变黑
    for (UIView *view in self.pickerView.subviews) {
        if ([view isKindOfClass:[UIView class]]) {
            for (UIView *subView in view.subviews) {
                if (subView.frame.size.height < 1) {
                    subView.backgroundColor = UIColorFromHex(0x222231);
                }
            }
        }
    }
    

    return view;
}


@end
