//
//  AppDelegate.m
//  BaoSheng
//
//  Created by GML on 2018/4/18.
//  Copyright © 2018年 haozheng. All rights reserved.
//


#import "AppDelegate.h"

@interface AppDelegate ()

@end

@implementation AppDelegate

+ (instancetype)sharedAppDelegate
{
    return (AppDelegate *)[UIApplication sharedApplication].delegate;
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    [self appStart:launchOptions];
    
    return YES;
}


- (void)applicationWillResignActive:(UIApplication *)application {
   
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
   
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
   
}


- (void)applicationDidBecomeActive:(UIApplication *)application {

}


- (void)applicationWillTerminate:(UIApplication *)application {
   
}

#pragma mark - AppStart
- (void)appStart:(NSDictionary *)launchOptions{
    //显示状态栏
    [[UIApplication sharedApplication] setStatusBarHidden:NO];
    
    //状态栏样式
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
    
    [RCIMHelper_shareInstance initRongCloud];
    
    if (!self.window) {
        self.window = [[UIWindow alloc]init];
        self.window.frame = [UIScreen mainScreen].bounds;
        self.window.backgroundColor = [UIColor whiteColor];
        [self.window makeKeyAndVisible];
        
        if (!self.rootTabBar) {
            if (BSContext_shareInstance.currentUser.isLogin.integerValue == 1) {
                 self.rootTabBar = [[RootTabarControl alloc]initWithOpenConversation:YES];
                [BSContext_shareInstance netLoginUpDateUerInfo];
                [RCIMHelper_shareInstance LoginIM];
            }else{
                 self.rootTabBar = [[RootTabarControl alloc]init];
            }
            self.window.rootViewController = self.rootTabBar;
            
//            [(UINavigationController*)self.rootTabBar.selectedViewController pushViewController:launchController animated:NO];
        }
    }
}

// 获取当前活动的navigationcontroller
- (UINavigationController *)navigationViewController
{
    if ([self.window.rootViewController isKindOfClass:[UINavigationController class]])
    {
        return (UINavigationController *)self.window.rootViewController;
    }
    else if ([self.window.rootViewController isKindOfClass:[UITabBarController class]])
    {
        UIViewController *selectVc = [((UITabBarController *)self.window.rootViewController) selectedViewController];
        if ([selectVc isKindOfClass:[UINavigationController class]])
        {
            return (UINavigationController *)selectVc;
        }
    }
    
    return nil;
}




@end
