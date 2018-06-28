//
//  BSContext.m
//  BaoSheng
//
//  Created by GML on 2018/4/24.
//  Copyright © 2018年 haozheng. All rights reserved.
//

#import "BSContext.h"

@implementation BSContext

static BSContext *shareInstance;
+ (instancetype)shareInstance
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        if (!shareInstance) {
            shareInstance = [[[self class] alloc] init];
            
            shareInstance.currentUser = [SKUserDefaults_shareInstance storedObjectForKey:STStore_CurrentUserInfo];
//            [shareInstance addObserver];
//
//            @weakify(shareInstance);
//            [shareInstance fetchWANIPAddressWithCompletion:^(NSString *ipAddress) {
//                @strongify(shareInstance);
//                shareInstance.ipStr = ipAddress;
//            }];
        }
    });
    return shareInstance;
}

- (void)netLoginUpDateUerInfo{
    
    NSString *phoneBase64 = [[GmWidget shareInstance]gm_encode64:self.currentUser.mobile];
//    NSString *passWmd5 = [[GmWidget shareInstance]gm_getMD5_32Bit_String:self.PassWorldTF.text];
    
    NSDictionary *dic = @{@"phone"    :phoneBase64,
                          @"password" :self.currentUser.password
                          };
    
    BSAction *action = [BSAction instanceMethodPostWithApi:BSApi_login];
    action.paramsDic =dic.mutableCopy;
    
    [STSHUdHelper showLoadingWithLock:YES];
//    WeakSelf
    [self sk_requestWithAction:action success:^(BSRes *res) {
        
        [STSHUdHelper hideLoading];
        
        BSBaseUserDto *userDto = [BSBaseUserDto mj_objectWithKeyValues:res.result];
        userDto.isLogin = @1;
        BSContext_shareInstance.currentUser = userDto;
        //存储用户信息
        BOOL succec =  [SKUserDefaults_shareInstance storeObject:userDto forKey:STStore_CurrentUserInfo];
        NSLog(@"userInfo----更新用户信息成功 - %d",succec);
       
    } failure:^(BSRes *res) {
        
        [STSHUdHelper hideLoading];
        
    }];
    
}


@end
