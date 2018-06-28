//
//  BSCommonMacro.h
//  BaoSheng
//
//  Created by GML on 2018/4/21.
//  Copyright © 2018年 haozheng. All rights reserved.
//

#ifndef BSCommonMacro_h
#define BSCommonMacro_h

/** ReativeCocoa */
#define WeakSelf @weakify(self);
#define StrongSelf @strongify(self);

#define FONTSize(size) [UIFont systemFontOfSize:size]

/** 是否是某种类(含父类) */
#define SK_KindClass(target,class) [target isKindOfClass:class]
/** 是否是某种类 */
#define SK_MemberClass(target,class) [target isMemberOfClass:class]

/** 基础配置 */
#define kTabBarItemTextColorNormal RGB(72, 72, 72) //tabBarItem 点击以前的文字颜色
#define kTabBarItemTextColorSelected   [UIColor redColor]  // tabBarItem 点击以后的文字颜色
#define kNaviBarBackItemColor  [UIColor blackColor] //naviBar返回按钮以及文字颜色
#define kNaviBarTitleFont [UIFont systemFontOfSize:18] //naviBar 字体
#define kNaviBarTitleColor [UIColor blackColor]        //naviBar 字体颜色



/** 机型 相关 */
#define IS_IPAD (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
#define IS_IPHONE (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
#define IS_RETINA ([[UIScreen mainScreen] scale] >= 2.0)
#define IS_IPHONE_4_OR_LESS (IS_IPHONE && SCREEN_MAX_LENGTH < 568.0)
#define IS_IPHONE_5 (IS_IPHONE && SCREEN_MAX_LENGTH == 568.0)
#define IS_IPHONE_6 (IS_IPHONE && SCREEN_MAX_LENGTH == 667.0)
#define IS_IPHONE_6P (IS_IPHONE && SCREEN_MAX_LENGTH == 736.0)


/** frame 相关 */
#define SCREEN_MAX_LENGTH (MAX(SCREEN_WIDTH, SCREEN_HEIGHT))
#define SCREEN_MIN_LENGTH (MIN(SCREEN_WIDTH, SCREEN_HEIGHT))
#define TabBarHeight [RootTabBarController getTabBarHeight]

#define kNavHeight (kSCREEN_HEIGHT == 812.0 ? 88 : 64)
#define kTableBarHeight (kSCREEN_HEIGHT == 812.0 ? 83:49)
#define kBottomBar (kSCREEN_HEIGHT == 812.0 ? kNavHeight + 20 : kNavHeight)
#define kiphoneXsafeBottom (kSCREEN_HEIGHT == 812.0 ?  20 : 0)

#define kSCREEN_WIDTH  [UIScreen mainScreen].bounds.size.width
#define kSCREEN_HEIGHT [UIScreen mainScreen].bounds.size.height

#define wSCALE_WIDTH            [UIScreen mainScreen].bounds.size.width/375.f
#define wSCALE_HEIGHT           [UIScreen mainScreen].bounds.size.height/667.f

#define GET_WIDTH(rect) CGRectGetWidth(rect)
#define GET_HEIGHT(rect) CGRectGetHeight(rect)

#define GET_MinX(rect) CGRectGetMinX(rect)
#define GET_MidX(rect) CGRectGetMidX(rect)
#define GET_MaxX(rect) CGRectGetMaxX(rect)
#define GET_MinY(rect) CGRectGetMinY(rect)
#define GET_MidY(rect) CGRectGetMidY(rect)
#define GET_MaxY(rect) CGRectGetMaxY(rect)

/** 项目配色 */
#define kappBackgroundColor RGB(246, 246, 246)
//按钮背景色
#define kappButtonBackgroundColor RGB(230, 0, 0)
//分割线
#define kapplineColor RGB(218, 218, 218)
//字体颜色 深灰
#define kappTextColorDrak RGB(51, 51, 51)
//字体颜色 浅灰
#define kappTextColorlingtGray RGB(153, 153, 153)



/** 取色相关 */

#define RGB(r,g,b)          [UIColor colorWithRed:(r)/255.f \
green:(g)/255.f \
blue:(b)/255.f \
alpha:1.f]

/** 16进制颜色 */
#define UIColorFromHex(s)  [UIColor colorWithRed:(((s & 0xFF0000) >> 16))/255.0 green:(((s &0xFF00) >>8))/255.0 blue:((s &0xFF))/255.0 alpha:1.0]
// 定义通用颜色
#define kBlackColor         [UIColor blackColor]
#define kDarkGrayColor      [UIColor darkGrayColor]
#define kLightGrayColor     [UIColor lightGrayColor]
#define kWhiteColor         [UIColor whiteColor]
#define kGrayColor          [UIColor grayColor]
#define kRedColor           [UIColor redColor]
#define kGreenColor         [UIColor greenColor]
#define kBlueColor          [UIColor blueColor]
#define kCyanColor          [UIColor cyanColor]
#define kYellowColor        [UIColor yellowColor]
#define kMagentaColor       [UIColor magentaColor]
#define kOrangeColor        [UIColor orangeColor]
#define kPurpleColor        [UIColor purpleColor]
#define kClearColor         [UIColor clearColor]


#endif /* BSCommonMacro_h */
