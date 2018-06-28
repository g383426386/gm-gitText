//
//  RootTabarControl.m
//  BaoSheng
//
//  Created by GML on 2018/4/18.
//  Copyright © 2018年 haozheng. All rights reserved.
//

#import "RootTabarControl.h"

@interface RootTabarControl ()<UITabBarDelegate,UITabBarControllerDelegate>
{
    
    UITabBarItem* _tabBarItem1;//首页
    UITabBarItem* _tabBarItem2;//通知
    UITabBarItem* _tabBarItem3;//我的
    UITabBarItem* _tabBarItem4;//聊天
    
}


@end

@implementation RootTabarControl


- (instancetype)initWithOpenConversation:(BOOL)OpenConversation
{
    self = [super init];
    if (self) {
        self.delegate = self;
        self.openConverSation = YES;
        [self setUpViewControllers];
    }
    return self;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.delegate = self;
        
        [self setUpViewControllers];
    }
    return self;
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    [[UIApplication sharedApplication] setStatusBarHidden:NO withAnimation:UIStatusBarAnimationFade];
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}
- (void)setUpViewControllers{
    
    [[UITabBar appearance] setBarTintColor:[UIColor whiteColor]];
    [UITabBar appearance].translucent = NO;
    
    self.tabBar.opaque = YES;
    self.tabBar.translucent = NO;
    self.delegate = (id)self;
    
    //3个控制器
    self.homeControl = [[HomeControl alloc]init];
    self.messageControl = [[MessageControl alloc]init];
    self.mineInfoControl = [[MineInfoControl alloc]init];
 
    
    //创建tabbaritem1 绑定VC
    _tabBarItem1 = [[UITabBarItem alloc]initWithTitle:@"首页" image:[self createItemImageForSelected:NO imageName:@"home_normal"] selectedImage:[self createItemImageForSelected:YES imageName:@"home"]];
    [self ConfigTabarItem:_tabBarItem1]; //tabbaritem1 文字颜色
    self.homeControl.tabBarItem = _tabBarItem1;
    self.homeControl.title = @"首页";
    //创建tabbaritem2 绑定VC
    _tabBarItem2 = [[UITabBarItem alloc]initWithTitle:@"通知" image:[self createItemImageForSelected:NO imageName:@"xiaoxin_n-1"] selectedImage:[self createItemImageForSelected:YES imageName:@"xiaoxi_s"]];
    [self ConfigTabarItem:_tabBarItem2]; //tabbaritem2 文字颜色
    self.messageControl.tabBarItem = _tabBarItem2;
    self.messageControl.title = @"通知";

    
    //创建tabbaritem1 绑定VC
    _tabBarItem3 = [[UITabBarItem alloc]initWithTitle:@"我的" image:[self createItemImageForSelected:NO imageName:@"my_n"] selectedImage:[self createItemImageForSelected:YES imageName:@"my_s"]];
  
    [self ConfigTabarItem:_tabBarItem3];//tabbaritem3 文字颜色
    self.mineInfoControl.tabBarItem = _tabBarItem3;
    self.mineInfoControl.title = @"我的";


    //4个navigationController 管理4个控制器
    self.nc1 = [[BSRootNavigationController alloc]initWithRootViewController:self.homeControl];
    self.nc2 = [[BSRootNavigationController alloc]initWithRootViewController:self.messageControl];
    self.nc3 = [[BSRootNavigationController alloc]initWithRootViewController:self.mineInfoControl];
   
    //自定义navigationController
    UIImage* navBar_v_3_image = [UIImage imageFromContextWithColor:[UIColor whiteColor]];  //导航栏背景
    [_nc1.navigationBar setBackgroundImage:navBar_v_3_image forBarMetrics:UIBarMetricsDefault];
    [_nc2.navigationBar setBackgroundImage:navBar_v_3_image forBarMetrics:UIBarMetricsDefault];
    [_nc3.navigationBar setBackgroundImage:navBar_v_3_image forBarMetrics:UIBarMetricsDefault];
 
    //navbar返回按钮 以及文字颜色
    _nc1.navigationBar.tintColor = kNaviBarBackItemColor;
    _nc2.navigationBar.tintColor = kNaviBarBackItemColor;
    _nc3.navigationBar.tintColor = kNaviBarBackItemColor;

    //navbar tittle 字体 以及颜色
    [_nc1.navigationBar setTitleTextAttributes:
     @{NSFontAttributeName:kNaviBarTitleFont,
       NSForegroundColorAttributeName:kNaviBarTitleColor}];
    
    [_nc2.navigationBar setTitleTextAttributes:
     @{NSFontAttributeName:kNaviBarTitleFont,
       NSForegroundColorAttributeName:kNaviBarTitleColor}];
    
    [_nc3.navigationBar setTitleTextAttributes:
     @{NSFontAttributeName:kNaviBarTitleFont,
       NSForegroundColorAttributeName:kNaviBarTitleColor}];
    
    if (self.openConverSation) {
        self.ConversationControl = [[BSConversationLIstControl alloc]init];
        _tabBarItem4 = [[UITabBarItem alloc]initWithTitle:@"我的" image:[self createItemImageForSelected:NO imageName:@"liaotian_n"] selectedImage:[self createItemImageForSelected:YES imageName:@"liaotian_s"]];
        [self ConfigTabarItem:_tabBarItem4];//tabbaritem3 文字颜色
        self.ConversationControl.tabBarItem = _tabBarItem4;
        self.ConversationControl.title = @"聊天";
        
         self.nc4 = [[BSRootNavigationController alloc]initWithRootViewController:self.ConversationControl];
        _tabBarItem1.tag = 1;
        _tabBarItem2.tag = 3;
        _tabBarItem3.tag = 4;
        _tabBarItem4.tag = 2;
        
         [_nc4.navigationBar setBackgroundImage:navBar_v_3_image forBarMetrics:UIBarMetricsDefault];
        _nc4.navigationBar.tintColor = kNaviBarBackItemColor;
        [_nc4.navigationBar setTitleTextAttributes:
         @{NSFontAttributeName:kNaviBarTitleFont,
           NSForegroundColorAttributeName:kNaviBarTitleColor}];
        
         self.viewControllers = @[_nc1,_nc4,_nc2,_nc3];
    }else{
        _tabBarItem1.tag = 1;
        _tabBarItem2.tag = 2;
        _tabBarItem3.tag = 3;
        
         self.viewControllers = @[_nc1,_nc2,_nc3];
    }
    
   
}
#pragma mark - Common
- (UIImage *)createItemImageForSelected:(BOOL)seleted imageName:(NSString *)imageName{
    
    if (seleted) {
        UIImage* barItem3ImageSelect = [UIImage imageNamed:imageName];
        
        barItem3ImageSelect = [barItem3ImageSelect imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
        return barItem3ImageSelect;
        
    }
     UIImage* barItem3Image = [UIImage imageNamed:imageName];
     barItem3Image = [barItem3Image imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    
    return barItem3Image;
}
- (void)ConfigTabarItem:(UITabBarItem *)tabBarItem{
    
    [tabBarItem setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys: kTabBarItemTextColorNormal, NSForegroundColorAttributeName, nil] forState:UIControlStateNormal];
    [tabBarItem setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:
                                          kTabBarItemTextColorSelected, NSForegroundColorAttributeName, nil] forState:UIControlStateSelected];
}


#pragma mark - UITabBarControllerDelegate
- (BOOL)tabBarController:(UITabBarController *)tabBarController shouldSelectViewController:(UIViewController *)viewController {
    
    //    NSInteger idx = [tabBarController.viewControllers indexOfObject:viewController];
    //
    //    if (2 == idx || 3 == idx) {
    //
    //        if (SKVerifyUserLogin_ShowVC(YES)) {
    //            return YES;
    //        }else{
    //            return NO;
    //        }
    //    }
    
    return YES;
}

- (void)tabBarController:(UITabBarController *)tabBarController didSelectViewController:(UIViewController *)viewController {
    //    if (tabBarController.selectedIndex == 3) {
    //        [_redEnvelopeVC setSelectedAtIndex:0];
    //    }
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
