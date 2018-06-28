//
//  STSHUdHelper.m
//  STS_Master
//
//  Created by GML on 2017/9/18.
//  Copyright © 2017年 Jiujian. All rights reserved.
//

#import "STSHUdHelper.h"

NSInteger hasShowHud;

static UIView *toastContentView;
static MBProgressHUD *loadingHud;

static MBProgressHUD *textloadingHud;

@implementation STSHUdHelper

+ (void)showLoadingWithLock:(BOOL)lock{

    dispatch_async(dispatch_get_main_queue(), ^{
       
        UIWindow *window = [UIApplication sharedApplication].keyWindow;
        
        if (!loadingHud) {
            loadingHud = [[MBProgressHUD alloc]initWithView:window];
            loadingHud.mode = MBProgressHUDModeIndeterminate;
            loadingHud.bezelView.style           = MBProgressHUDBackgroundStyleSolidColor;
            loadingHud.bezelView.backgroundColor = [UIColor clearColor];
            loadingHud.removeFromSuperViewOnHide = YES;
        }
        [window addSubview:loadingHud];
        loadingHud.userInteractionEnabled = lock;
        
        [loadingHud showAnimated:YES];
        
    });
    

}

+ (void)hideLoading{
    
    dispatch_async(dispatch_get_main_queue(), ^{
        if (loadingHud) {
            [loadingHud hideAnimated:YES];
        }
        
        if (textloadingHud) {
            [textloadingHud hideAnimated:YES];
        }
    });
    
    
}

+ (void)showLoadingWithText:(NSString *)text Lock:(BOOL)lock{
    
    dispatch_async(dispatch_get_main_queue(), ^{
        
        UIWindow *window = [UIApplication sharedApplication].keyWindow;

        if (!textloadingHud) {
            textloadingHud = [[MBProgressHUD alloc]initWithView:window];
            textloadingHud.mode = MBProgressHUDModeIndeterminate;
//            loadingHud.bezelView.style           = MBProgressHUDBackgroundStyleSolidColor;
//            loadingHud.bezelView.backgroundColor = [UIColor clearColor];
            textloadingHud.label.text = text;
            textloadingHud.removeFromSuperViewOnHide = YES;
        }
        [window addSubview:textloadingHud];
        textloadingHud.userInteractionEnabled = lock;
        
        [textloadingHud showAnimated:YES];
        
    });
    
    
}



+ (void)st_toastMsg:(NSString *)msg completion:(void (^)(void))completion
{
    [STSHUdHelper st_toastMsg:msg delay:1.9f lockInterface:NO offY:0.f completion:completion];
}

+ (void)st_toastMsgOffNav:(NSString *)msg completion:(void (^)(void))completion
{
    [STSHUdHelper st_toastMsg:msg delay:1.9f lockInterface:NO offY:0.f completion:completion];
}


+ (void)st_toastMsg:(NSString *)msg delay:(CGFloat)seconds lockInterface:(BOOL)lock offY:(CGFloat)offY completion:(void (^)(void))completion {
    
    if (![msg isKindOfClass:[NSString class]] || msg.length == 0)
        return;
    
    hasShowHud = 1;
    
    dispatch_async(dispatch_get_main_queue(), ^{
       
        UIWindow *window = [UIApplication sharedApplication].keyWindow;
        
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:window animated:YES];
        hud.mode = MBProgressHUDModeCustomView;
        hud.bezelView.style = MBProgressHUDBackgroundStyleSolidColor;
        hud.bezelView.backgroundColor = [UIColor clearColor];
        hud.removeFromSuperViewOnHide = YES;
        hud.userInteractionEnabled = lock;
        
        CGFloat horizontaOff = 33.f;
        CGFloat verticalOff = 12.f + (kSCREEN_HEIGHT == 812 ?12:0);
        CGFloat msgHeight = [msg sc_calculateHeightInFontSize:13.f withStableWidth:window.frame.size.width - 2*horizontaOff];
         msgHeight            = MAX(40.0 - 2*verticalOff, msgHeight);
        
        CGRect rect          = CGRectMake(0.0, offY, window.frame.size.width, msgHeight + 2*verticalOff +24.f );
        
        if (!toastContentView) {
            toastContentView                 = [[UIView alloc] init];
            toastContentView.backgroundColor = rgba(51, 51, 51, 0.8);//[UIColor colorWithRed:0.925 green:0.286 blue:0.533 alpha:1];
        }
        [hud.backgroundView addSubview:toastContentView];
        toastContentView.frame = rect;
        
        UILabel *lab = [toastContentView viewWithTag:299];
        if (!lab) {
            lab                 = [[UILabel alloc] init];
            lab.tag             = 299;
            lab.backgroundColor = [UIColor clearColor];
            lab.textColor       = [UIColor whiteColor];
            lab.font            = [UIFont systemFontOfSize:13.0];
            lab.numberOfLines   = 0;
            [toastContentView addSubview:lab];
        }
        lab.textAlignment   = (rect.size.height > 40.0+ verticalOff*2 ) ? NSTextAlignmentLeft : NSTextAlignmentCenter;
        lab.frame = CGRectMake(horizontaOff, verticalOff +24.f, window.frame.size.width - 2*horizontaOff, msgHeight);
        lab.text = msg;
        
        hud.completionBlock = ^(){
            hasShowHud = 2;
            if (completion)
                completion();
            if (toastContentView)
                [toastContentView removeFromSuperview];
        };
        
        [hud hideAnimated:YES afterDelay:seconds!=0?seconds:3.f];
        
        
    });

}




@end
