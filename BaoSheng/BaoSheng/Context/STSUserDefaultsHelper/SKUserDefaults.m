//
//  SKUserDefaults.m
//  marketplateform
//
//  Created by vic_wei on 2017/4/20.
//  Copyright © 2017年 com.sjyt. All rights reserved.
//

#import "SKUserDefaults.h"
#import "NSObject+MJCoding.h"

/** root key */
#define SKStore_RootKey [[[NSBundle mainBundle] infoDictionary] objectForKey:(__bridge NSString *)kCFBundleIdentifierKey]

static SKUserDefaults *shareInstance;

@interface SKUserDefaults ()

@property (strong, nonatomic) NSUserDefaults *userDefaults;

@end

@implementation SKUserDefaults

/** 返回单例  */
+ (instancetype)shareInstance
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        if (!shareInstance) {
            shareInstance = [[[self class] alloc] init];
        }
    });

    return shareInstance;
}

/** 多字段 生成 store key  */
+ (nonnull NSString *)storeKeyWithKeys:(nonnull NSString *)firstKey, ...
{
    NSCParameterAssert(firstKey != nil);
    NSString *resultKey = nil;
    
    va_list args;
    va_start(args, firstKey);
    for (NSString *currentKey = firstKey; currentKey != nil; currentKey = va_arg(args, id)) {
        if (!resultKey) {
            resultKey = [@"SKStore_" stringByAppendingString:currentKey];
        }else{
            resultKey = [[resultKey stringByAppendingString:@"_"] stringByAppendingString:currentKey];
        }
    }
    va_end(args);
    
    return resultKey;
}

/** 根据 key 存储 对象 */
- (BOOL)storeObject:(nullable NSObject *)object forKey:(nonnull NSString*)key
{
    if (object) {
        NSData *archivedData  = [NSKeyedArchiver archivedDataWithRootObject:object];
        [self.userDefaults setObject:archivedData forKey:key];
    }else{
        [self.userDefaults setObject:nil forKey:key];
    }
    return [self.userDefaults synchronize];
}

/** 根据 key 删除 对象 */
- (BOOL)storedObjectRemoveForKey:(nonnull NSString*)key
{
    [self.userDefaults removeObjectForKey:key];
    return [self.userDefaults synchronize];
}

/** 根据 key 获取 存储对象 */
- (nullable id)storedObjectForKey:(nonnull NSString*)key
{
    id result;
    NSData *archivedData = [self.userDefaults objectForKey:key];
    result = [NSKeyedUnarchiver unarchiveObjectWithData:archivedData];
    return result;
}

#pragma mark - setter getter

- (NSUserDefaults *)userDefaults
{
    return [NSUserDefaults standardUserDefaults];
}

@end
