//
//  BSRootNavigationController.m
//  BaoSheng
//
//  Created by GML on 2018/4/18.
//  Copyright © 2018年 haozheng. All rights reserved.
//

#import "BSRootNavigationController.h"
#import "BSBaseControl.h"


@interface BSRootNavigationController ()<UINavigationControllerDelegate,UIGestureRecognizerDelegate>

@end

@implementation BSRootNavigationController

- (void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated
{
    
    if (self.viewControllers.count == 0 || [viewController isKindOfClass:[UITabBarController class]]) {
        viewController.hidesBottomBarWhenPushed = NO;
    }else{
        if ([viewController isKindOfClass:[BSBaseControl class]]) {
            BSBaseControl *baseController = (BSBaseControl*)viewController;
            viewController.hidesBottomBarWhenPushed =  baseController.st_hidesBottomBarWhenPushed;
            if (self.viewControllers.count == 1) { // 二级页面 title 始终为 一级页面的title
//                UIViewController *temp = self.viewControllers[0];
                if (![baseController isKindOfClass:NSClassFromString(@"WKWebViewBaseViewController")]) {
                    baseController.sk_backTitle = @""; //temp.title;
                }
            }
        }else{
            if (self.viewControllers.count == 0) {
                viewController.hidesBottomBarWhenPushed = NO;
            }else{
                viewController.hidesBottomBarWhenPushed = YES;
            }
        }
    }
    [super pushViewController:viewController animated:animated];
}

//- (NSArray<UIViewController *> *)popToRootViewControllerAnimated:(BOOL)animated{
//
//  
//
//    return self.viewControllers;
//}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
