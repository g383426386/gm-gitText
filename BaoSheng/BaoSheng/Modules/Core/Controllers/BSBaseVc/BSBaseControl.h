//
//  BSBaseControl.h
//  BaoSheng
//
//  Created by GML on 2018/4/18.
//  Copyright © 2018年 haozheng. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BSBaseControl : UIViewController

@property (nonatomic , assign) BOOL st_hideNavBar;

@property (nonatomic , assign) BOOL st_disabledPanPop;

@property (nonatomic , assign) BOOL st_hidesBottomBarWhenPushed;

@property (nonatomic , assign) BOOL st_SetBaclkNav;

@property (nonatomic , strong) NSString *sk_backTitle;

@property (nonatomic , assign) BOOL sk_hideNavBackItem;

- (void)configDefaultNavBack;

- (void)changeNavBackImge:(BOOL)beChange;

- (void)sk_popOrDismiss:(id)sender;

- (void)sk_popOrDismiss:(id)sender controller:(UIViewController *)targetController animated:(BOOL)animated;


// old api
- (void)setNavRightItemWithTitle:(NSString *)titleStr titleColor:(UIColor *)titleColor fontsize:(CGFloat)Size selector:(SEL)sel;
- (void)setNavRightItemWithImage:(UIImage *)image selector:(SEL)sel;


- (void)setNavLeftItemWithTitle:(NSString *)titleStr titleColor:(UIColor *)titleColor fontsize:(CGFloat)Size selector:(SEL)sel;


@end
