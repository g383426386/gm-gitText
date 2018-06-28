//
//  AbstractActionSheetPicker+SKToolBarInterface.m
//  marketplateform
//
//  Created by Jajo_ios_lzl on 17/5/15.
//  Copyright © 2017年 com.sjyt. All rights reserved.
//

#import "AbstractActionSheetPicker+SKToolBarInterface.h"

#define kFontSize 15
@implementation AbstractActionSheetPicker (SKToolBarInterface)

- (void)customizeInterface{
    //干掉toolbar的title
    self.titleTextAttributes = [NSDictionary dictionaryWithObjectsAndKeys:
                                [UIColor clearColor], NSForegroundColorAttributeName,
                                [UIFont systemFontOfSize:kFontSize], NSFontAttributeName, nil];
    
    UIButton *doneBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 47, 25)];
    [doneBtn.titleLabel setFont:[UIFont boldSystemFontOfSize:kFontSize]];
    [doneBtn setTitle:@"确定" forState:UIControlStateNormal];
    [doneBtn setTitleColor:kappButtonBackgroundColor forState:UIControlStateNormal];
    UIBarButtonItem *doneItem = [[UIBarButtonItem alloc] initWithCustomView:doneBtn];
    UIButton *cancelBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 47, 25)];
    [cancelBtn.titleLabel setFont:[UIFont boldSystemFontOfSize:kFontSize]];
    [cancelBtn setTitle:@"取消" forState:UIControlStateNormal];
    [cancelBtn setTitleColor:RGB(128, 130, 141) forState:UIControlStateNormal];
    UIBarButtonItem *cancelItem = [[UIBarButtonItem alloc] initWithCustomView:cancelBtn];
    
    [self setDoneButton:doneItem];
    [self setCancelButton:cancelItem];
    
//    UIColorFromHex(0xE84186)
    
    //增加点击空白区域的手势
     self.tapDismissAction = TapActionCancel;
}

@end
