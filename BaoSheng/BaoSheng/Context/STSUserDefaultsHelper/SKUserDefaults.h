//
//  SKUserDefaults.h
//  marketplateform
//
//  Created by vic_wei on 2017/4/20.
//  Copyright © 2017年 com.sjyt. All rights reserved.
//

#import <Foundation/Foundation.h>

#define SKUserDefaults_shareInstance [SKUserDefaults shareInstance]

/**
 * tip: 自定义对象 存储是需在 .m 添加 宏 - MJCodingImplementation
 */

/** 是否选择记住密码 */
static NSString *const _Nonnull STStore_RemenberCode      = @"STStore_RemenberCode";

/** 存储账号用户名 */
static NSString *const _Nonnull STStore_RemenberAccount   = @"STStore_RemenberAccount";
/** 存储账号密码 */
static NSString *const _Nonnull STStore_RemenberPassW     = @"STStore_RemenberPassW";

/** 是否自动登录 */
static NSString *const _Nonnull STStore_AtuoLogin         = @"STStore_AtuoLogin";

/** 当前用户信息 */
static NSString *const _Nonnull STStore_CurrentUserInfo         = @"STStore_CurrentUserInfo";

@interface SKUserDefaults : NSObject

/** 返回单例  */
+ (nonnull instancetype)shareInstance;

/** 多字段 生成 store key  */
+ (nonnull NSString *)storeKeyWithKeys:(nonnull NSString *)firstKey, ... ;

/** 根据 key 存储 对象 */
- (BOOL)storeObject:(nullable NSObject *)object forKey:(nonnull NSString*)key;

/** 根据 key 删除 对象 */
- (BOOL)storedObjectRemoveForKey:(nonnull NSString*)key;

/** 根据 key 获取 存储对象 */
- (nullable id)storedObjectForKey:(nonnull NSString*)key;

@end
