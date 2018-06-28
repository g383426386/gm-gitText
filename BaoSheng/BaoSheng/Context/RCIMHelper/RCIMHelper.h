//
//  RCIMHelper.h
//  BaoSheng
//
//  Created by GML on 2018/4/29.
//  Copyright © 2018年 haozheng. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <RongIMKit/RongIMKit.h>

#ifndef RCIMHelper_shareInstance
#define RCIMHelper_shareInstance [RCIMHelper sharedRCIMHelper]
#endif

@interface RCIMHelper : NSObject



+ (instancetype)sharedRCIMHelper;


- (void)initRongCloud;


- (void)LoginIM;
- (void)loginOutIM;

- (void)connectRCWithToken:(NSString *)token
                   success:(void(^)(NSString *userId))success
                     error:(void(^)(RCConnectErrorCode status))error
            tokenIncorrect:(void(^)(void))tokenIncorrect;

@end
