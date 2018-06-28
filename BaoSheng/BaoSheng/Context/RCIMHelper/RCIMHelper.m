//
//  RCIMHelper.m
//  BaoSheng
//
//  Created by GML on 2018/4/29.
//  Copyright © 2018年 haozheng. All rights reserved.
//

#import "RCIMHelper.h"


@interface RCIMHelper()<RCIMConnectionStatusDelegate>

@end

@implementation RCIMHelper

static RCIMHelper *shareRCIMHelper;
+ (instancetype)sharedRCIMHelper{
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        if (!shareRCIMHelper) {
            shareRCIMHelper = [[[self class] alloc]init];
        }
    });
    return shareRCIMHelper;
}

//初始化融云
- (void)initRongCloud{
    
    [[RCIM sharedRCIM]initWithAppKey:RCIMAppKey];
    [RCIM sharedRCIM].connectionStatusDelegate = self;
    
}
//从服务器获取token 链接融云服务器
- (void)connectRCWithToken:(NSString *)token
                   success:(void(^)(NSString *userId))success
                     error:(void(^)(RCConnectErrorCode status))error
            tokenIncorrect:(void(^)(void))tokenIncorrect{
    
    [[RCIM sharedRCIM] connectWithToken:token     success:^(NSString *userId) {
        success(userId);
        NSLog(@"登陆成功。当前登录的用户ID：%@", userId);
    } error:^(RCConnectErrorCode status) {
        error(status);
        NSLog(@"登陆的错误码为:%ld",(long)status);
    } tokenIncorrect:^{
        tokenIncorrect();
        //token过期或者不正确。
        //如果设置了token有效期并且token过期，请重新请求您的服务器获取新的token
        //如果没有设置token有效期却提示token错误，请检查您客户端和服务器的appkey是否匹配，还有检查您获取token的流程。
        NSLog(@"token错误");
    }];
}

- (void)LoginIM{
    
    if (BSContext_shareInstance.currentUser.isLogin.integerValue != 1) {
        NSLog(@"用户未登录，不登录IM");
        return;
    }
    
    NSString *token = BSContext_shareInstance.currentUser.ryToken;
    
    [self connectRCWithToken:token success:^(NSString *userId) {
        
    } error:^(RCConnectErrorCode status) {
        
    } tokenIncorrect:^{
        
    }];
}
- (void)loginOutIM{
    
    [[RCIM sharedRCIM]logout];
    
}
#pragma mark - RCIMConnectionStatusDelegate
- (void)onRCIMConnectionStatusChanged:(RCConnectionStatus)status{
    
    NSLog(@"融云链接状态----- %ld",(long)status);
    
}

@end
