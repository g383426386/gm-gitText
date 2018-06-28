//
//  BSApis.h
//  BaoSheng
//
//  Created by GML on 2018/4/23.
//  Copyright © 2018年 haozheng. All rights reserved.
//

#ifndef BSApis_h
#define BSApis_h

//#define BS_HOST_Master @"http://192.168.5.3:8081"

//#define BS_HOST_Master  @"http://192.168.5.3:8083"

//测试地址2
#define BS_HOST_Master  @"http://192.168.5.2:8080"  //baoshengcun

//测试地址1
//#define BS_HOST_Master @"http://192.168.5.2:8081"

//线上地址
//#define BS_HOST_Master @"https://www.wllzpt.com"

#define BS_hostapend @"baoshengcun"//wzt baoshengcun

#define BS_Mutable_Url @"appApi"

#define BSApi_Path(host ,hostapend,mutableUrl,api) [NSString stringWithFormat:@"%@/%@/%@/%@" ,host,hostapend,mutableUrl, api]

static NSString *RCIMAppKey = @"6tnym1br64j57";//6tnym1br64j57 82hegw5u8yejx

/**
 *  POST - 登陆
 */
static NSString *const BSApi_login = @"login";

/**
 *  POST - 退出登陆
 */
static NSString *const BSApi_exit = @"exit";

/**
 *  POST - 注册
 */
static NSString *const BSApi_register = @"register";

/**
 *  POST - 发送验证码
 */
static NSString *const BSApi_getVerifyCode = @"getVerifyCode";

/**
 *  POST - 修改密码
 */
static NSString *const BSApi_updatePassword = @"updatePassword";

/**
 *  POST - 修改用户信息
 */
static NSString *const BSApi_editUser = @"editUser";

/**
 *  POST - 获取首页轮播图
 */
static NSString *const BSApi_cycleInformation = @"cycleInformation";

/**
 *  POST - 获取首页轮播图详情
 */
static NSString *const BSApi_cycleInformationDetail = @"cycleInformationDetail";

/**
 *  POST - 上传头像
 */
static NSString *const BSApi_uploadHeadPic = @"uploadHeadPic";

/**
 *  POST - 党员认证
 */
static NSString *const BSApi_authPartyMember = @"authPartyMember";

/**
 *  POST - 党员积分
 */
static NSString *const BSApi_partyManIntegral = @"partyManIntegral";

/**
 *  POST - 学习记录
 */
static NSString *const BSApi_learningRecord = @"learningRecord";

/**
 *  POST - 通知列表
 */
static NSString *const BSApi_inform = @"inform";

/**
 *  POST - 通知详情
 */
static NSString *const BSApi_informDetail = @"informDetail";

/**
 *  POST - 资讯列表
 */
static NSString *const BSApi_getNineteenSpiritList = @"getNineteenSpiritList";

/**
 *  POST - 资讯详情
 */
static NSString *const BSApi_getNineteenSpiritDetail = @"getNineteenSpiritDetail";

/**
 *  POST - 获取学习列表
 */
static NSString *const BSApi_learn = @"learn";

/**
 *  POST - 获取学习类型的列表
 */
static NSString *const BSApi_learnList = @"learnList";

/**
 *  POST - 党员学习详情
 */
static NSString *const BSApi_learningDetail = @"learningDetail";

/**
 *  POST - 增加党员学习记录
 */
static NSString *const BSApi_addLearningRecord = @"addLearningRecord";

/**
 *  POST - 意见反馈
 */
static NSString *const BSApi_opinionFeedback = @"opinionFeedback";

#endif /* BSApis_h */
