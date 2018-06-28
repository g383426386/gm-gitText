//
//  BSBaseControl.m
//  BaoSheng
//
//  Created by GML on 2018/4/18.
//  Copyright © 2018年 haozheng. All rights reserved.
//

#import "BSBaseControl.h"
#import "AppDelegate.h"


@interface BSBaseControl ()

@end

@implementation BSBaseControl

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.st_hidesBottomBarWhenPushed = YES;
    }
    return self;
}
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    
    
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    
    
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = kappBackgroundColor;
    
    // 默认显示 navbar ，开启手势 ， 手势全屏
    self.st_hideNavBar = NO;
    self.st_disabledPanPop = NO;
    self.st_SetBaclkNav = NO;
    
    self.edgesForExtendedLayout = UIRectEdgeNone;
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    // 配置默认 nav返回
    if ([self checkIsNeedConfigDefaultNavBack]) {
        [self configDefaultNavBack];
    }else{
        
    }
    
    
}


#pragma mark - set get
- (BOOL)fd_prefersNavigationBarHidden
{
    return self.st_hideNavBar;
}

- (BOOL)fd_interactivePopDisabled
{
    return self.st_disabledPanPop;
}
- (void)setSk_backTitle:(NSString *)sk_backTitle
{
    _sk_backTitle = sk_backTitle;
    
    if (sk_backTitle.length > 0) {
        UIButton *button = [UIButton buttonWithType: UIButtonTypeCustom];
        button.titleLabel.font = [UIFont systemFontOfSize:14.f];
        [button setImage:[UIImage imageNamed:@"return"] forState:UIControlStateNormal];
        [button setFrame:CGRectMake(0, 0, 44.f, 44.f)];
        [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [button setTitle:sk_backTitle forState:UIControlStateNormal];
        [button sizeToFit];
        [button addTarget:self action:@selector(sk_popOrDismiss:) forControlEvents:UIControlEventTouchUpInside];
        
        UIBarButtonItem *leftItem = [[UIBarButtonItem alloc] initWithCustomView:button];
        
        UIBarButtonItem *negativeSpacer = [[UIBarButtonItem alloc]
                                           initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace
                                           target:nil action:nil];
        negativeSpacer.width = -5.0; // 默认边距为 20 ，设置后 为15边距
        
        
        if (self.parentViewController && (![self.parentViewController isKindOfClass:[UINavigationController class]] && ![self.parentViewController isKindOfClass:[UITabBarController class]]) ) {
            [self.parentViewController.navigationItem setLeftBarButtonItems:@[negativeSpacer,leftItem]];
        }else{
            [self.navigationItem setLeftBarButtonItems:@[negativeSpacer,leftItem]];
        }
    }else{
        [self configDefaultNavBack];
    }
    
}
- (void)setSk_hideNavBackItem:(BOOL)sk_hideNavBackItem
{
    UIViewController *owner = nil;
    if (self.parentViewController && (![self.parentViewController isKindOfClass:[UINavigationController class]] && ![self.parentViewController isKindOfClass:[UITabBarController class]]) ) {
        owner = self.parentViewController;
    }else{
        owner = self;;
    }
    
    if (sk_hideNavBackItem) {
        owner.navigationItem.backBarButtonItem.customView.hidden = YES;
        owner.navigationItem.leftBarButtonItem.customView.hidden = YES;
        [owner.navigationItem.leftBarButtonItems enumerateObjectsUsingBlock:^(UIBarButtonItem * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            obj.customView.hidden = YES;
        }];
    }else{
        owner.navigationItem.leftBarButtonItem.customView.hidden = NO;
        [owner.navigationItem.leftBarButtonItems enumerateObjectsUsingBlock:^(UIBarButtonItem * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            obj.customView.hidden = NO;
        }];
    }
    _sk_hideNavBackItem = sk_hideNavBackItem;
}



#pragma mark - privite
- (void)changeNavBackImge:(BOOL)beChange{
    
    self.st_SetBaclkNav = beChange;
    if (beChange) {

        [self.navigationController.navigationBar setBackgroundImage:[UIImage imageFromContextWithColor:[UIColor blackColor]] forBarMetrics:UIBarMetricsDefault];
    }else{
        [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"return"] forBarMetrics:UIBarMetricsDefault];
    }
    
}




- (void)sk_popOrDismiss:(id)sender controller:(UIViewController *)targetController animated:(BOOL)animated
{
    UINavigationController *nav = self.navigationController ?: [AppDelegate sharedAppDelegate].navigationViewController;
    
    if (nav || self.presentingViewController)
    {
        if (nav.viewControllers.count > 1) {
            if (targetController) {
                [nav popToViewController:targetController animated:animated];
            }else{
                [nav popViewControllerAnimated:animated];
            }
        }
        else{
            
            [self dismissViewControllerAnimated:animated completion:nil];
        }
    }
}

- (void)sk_popOrDismiss:(id)sender
{
    [self sk_popOrDismiss:sender controller:nil animated:YES];
}

- (BOOL)checkIsNeedConfigDefaultNavBack
{
    BOOL isNeed = NO;
    
    UINavigationController *nav = nil;
    UIViewController *owner = nil;
    if (self.parentViewController && (![self.parentViewController isKindOfClass:[UINavigationController class]] && ![self.parentViewController isKindOfClass:[UITabBarController class]]) ) {
        nav = self.parentViewController.navigationController;
        owner = self.parentViewController;
    }else{
        nav =[AppDelegate sharedAppDelegate].navigationViewController; //self.navigationController;
        owner = self;
    }
    
    if (nav && [nav.viewControllers indexOfObject:owner] > 0 && (!owner.navigationItem.leftBarButtonItem || owner.navigationItem.leftBarButtonItems.count == 0) ) {
        if ([owner isKindOfClass:[BSBaseControl class]]) {
            if (self.sk_backTitle.length == 0)
                isNeed = YES;
        }else{
            isNeed = YES;
        }
    }
    
    return isNeed;
}


- (void)configDefaultNavBack
{
    UIImage *image = [UIImage imageNamed:@"return"];
    UIButton *button = [UIButton buttonWithType: UIButtonTypeCustom];
    [button setFrame:CGRectMake(0, 0, image.size.width, image.size.height)];
    [button setImage:image forState:UIControlStateNormal];
    [button addTarget:self action:@selector(sk_popOrDismiss:) forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem *leftItem = [[UIBarButtonItem alloc] initWithCustomView:button];
    
    UIBarButtonItem *negativeSpacer = [[UIBarButtonItem alloc]
                                       initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace
                                       target:nil action:nil];
    negativeSpacer.width = - 5; // 默认边距为 20 ，设置后 为15边距
    
    
    if (self.parentViewController && (![self.parentViewController isKindOfClass:[UINavigationController class]] && ![self.parentViewController isKindOfClass:[UITabBarController class]]) ) {
        [self.parentViewController.navigationItem setLeftBarButtonItems:@[negativeSpacer,leftItem]];
    }else{
        [self.navigationItem setLeftBarButtonItems:@[negativeSpacer,leftItem]];
    }
}
- (BOOL)checkTopNav{
    if (self.navigationController.viewControllers.count > 1) {
        return NO;
    }else{
        
        return YES;
    }
    
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [super touchesBegan:touches withEvent:event];
    CGPoint location = [[[event allTouches] anyObject] locationInView:[UIApplication sharedApplication].keyWindow];
    CGRect statusBarFrame = [UIApplication sharedApplication].statusBarFrame;
    
    if (CGRectContainsPoint(statusBarFrame, location)) {
        [self statusBarTouchedAction];
    }
}

- (void)statusBarTouchedAction
{
    
}

//---oldApi
- (void)setNavRightItemWithTitle:(NSString *)titleStr titleColor:(UIColor *)titleColor fontsize:(CGFloat)Size selector:(SEL)sel{
    
    UIButton *rightBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [rightBtn setTitle:titleStr forState:UIControlStateNormal];
    rightBtn.titleLabel.font = FONTSize(Size);
    [rightBtn setTitleColor:titleColor forState:UIControlStateNormal];
    [rightBtn sizeToFit];
    if (CGSizeEqualToSize( CGSizeZero , rightBtn.f_size) )
        rightBtn.f_size = CGSizeMake(30.f, 30.f);
    
    
    UIBarButtonItem *rightBar = [[UIBarButtonItem alloc]initWithCustomView:rightBtn];
    
    if (sel != nil) {
        [rightBtn addTarget:self action:sel forControlEvents:UIControlEventTouchUpInside];
    } else {
        rightBtn.enabled = NO;
    }
    
    self.navigationItem.rightBarButtonItem = rightBar;
    
}

//设置nav右边按钮 图片
-(void)setNavRightItemWithImage:(UIImage *)image
                       selector:(SEL)sel
{
    UIButton *button = [UIButton buttonWithType: UIButtonTypeCustom];
    [button setFrame:CGRectMake(0, 0, 25, 44)];
    [button setImage:image forState:UIControlStateNormal];
    UIBarButtonItem *RightItem = [[UIBarButtonItem alloc] initWithCustomView:button];
    [self.navigationItem setRightBarButtonItem:RightItem];
    if (sel != nil) {
        [button addTarget:self action:sel forControlEvents:UIControlEventTouchUpInside];
    } else {
        button.enabled = NO;
    }
}


- (void)setNavLeftItemWithTitle:(NSString *)titleStr titleColor:(UIColor *)titleColor fontsize:(CGFloat)Size selector:(SEL)sel{
    
    UIButton *rightBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [rightBtn setTitle:titleStr forState:UIControlStateNormal];
    rightBtn.titleLabel.font = FONTSize(Size);
    [rightBtn setTitleColor:titleColor forState:UIControlStateNormal];
    [rightBtn sizeToFit];
    if (CGSizeEqualToSize( CGSizeZero , rightBtn.f_size) )
        rightBtn.f_size = CGSizeMake(30.f, 30.f);
    //    [rightBtn addTarget:self action:@selector(navRightBtnAction) forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem *rightBar = [[UIBarButtonItem alloc]initWithCustomView:rightBtn];
    
    if (sel != nil) {
        [rightBtn addTarget:self action:sel forControlEvents:UIControlEventTouchUpInside];
    } else {
        rightBtn.enabled = NO;
    }
    
    self.navigationItem.leftBarButtonItem = rightBar;
}

- (void)dealloc
{
    NSLog(@"----*** dealloc - %@", self);
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
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
