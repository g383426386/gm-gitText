//
//  BSContext.h
//  BaoSheng
//
//  Created by GML on 2018/4/24.
//  Copyright © 2018年 haozheng. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BSBaseUserDto.h"

#ifndef BSContext_shareInstance
#define BSContext_shareInstance [BSContext shareInstance]
#endif

@interface BSContext : NSObject

/** 返回单例  */
+ (instancetype)shareInstance;

/** 当前登录用户 */
@property (nonatomic , strong)BSBaseUserDto *currentUser;

//已经登录 再次调用登录接口更新用户信息
- (void)netLoginUpDateUerInfo;

@end
