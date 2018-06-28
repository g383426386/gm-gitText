//
//  SKNotifyMessage.h
//  marketplateform
//
//  Created by vic_wei on 2017/5/17.
//  Copyright © 2017年 com.sjyt. All rights reserved.
//

#import "NSObject+NotifyMessage.h"

#ifndef SKNotifyMessage_h
#define SKNotifyMessage_h

/** 网络状态变化通知*/
static NSString *const SKNotifyMsg_NetStatusChange      = @"SKNotifyMsg_NetStatusChange";

/** 退出登陆 */
static NSString *const SKNotifyMsg_LoginOut      = @"SKNotifyMsg_LoginOut";

/** 登陆成功 */
static NSString *const SKNotifyMsg_LoginIn      = @"SKNotifyMsg_LoginIn";

/** 刷新用户信息 */
static NSString *const SKNotifyMsg_UserInfoChange      = @"SKNotifyMsg_UserInfoChange";


#endif /* SKNotifyMessage_h */
