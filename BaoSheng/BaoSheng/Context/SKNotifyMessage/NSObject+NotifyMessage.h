//
//  NSObject+NotifyMessage.h
//  marketplateform
//
//  Created by vic_wei on 2017/5/5.
//  Copyright © 2017年 com.sjyt. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSObject (NotifyMessage)

/** 发通知 */
- (void)sk_postNotificationName:(nonnull NSString *)aName object:(nullable id)anObject userInfo:(nullable NSDictionary *)aUserInfo;

/** 注册通知 */
- (nullable id <NSObject>)sk_addObserverForName:(nonnull NSString *)name block:(nullable void (^)( NSNotification * _Nullable note))block;

@end
