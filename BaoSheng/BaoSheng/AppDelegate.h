//
//  AppDelegate.h
//  BaoSheng
//
//  Created by GML on 2018/4/18.
//  Copyright © 2018年 haozheng. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RootTabarControl.h"

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

/** 根 tabbar vc */
@property (nonatomic,strong) RootTabarControl *rootTabBar; //根视图控制器


+ (instancetype)sharedAppDelegate;

// 获取当前活动的navigationcontroller
- (UINavigationController *)navigationViewController;


@end

