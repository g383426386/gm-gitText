//
//  NSObject+VVAssociate.m
//  
//
//  Created by nia_wei on 13-10-31.
//  Copyright (c) 2014年 nia_wei. All rights reserved.
//

#import "NSObject+VVAssociate.h"


@interface NSObject ()

@property (nonatomic , strong , nullable) NSMutableDictionary *vv_associateKey;

@end

@implementation NSObject (VVAssociate)

- (void)vv_associateValue:(id)value forKey:(NSString *)key associationPolicy:(objc_AssociationPolicy)policy
{
//    self.vv_associateKey[key] = @(policy);
    const void *k = (__bridge const void *)(key); //key.UTF8String; CFBridgingRetain(key);
    objc_setAssociatedObject(self, k, value, policy);
}

- (id)vv_associateValueForKey:(NSString *)key
{
    id result = nil;
//    if ([self.vv_associateKey.allKeys containsObject:key]) {
        result = objc_getAssociatedObject(self, (__bridge const void *)(key));
//    }
    return result;
}

-(void)vv_cleanAssociate
{
    objc_removeAssociatedObjects(self);
}

#pragma mark - setter getter
//static void *vv_associateKey_key = &vv_associateKey_key;
//static char vv_associateKey_key;
- (void)setVv_associateKey:(NSMutableDictionary *)vv_associateKey
{
    objc_setAssociatedObject(self, (const void *)(@selector(vv_associateKey)), vv_associateKey, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
//    objc_setAssociatedObject(self, &vv_associateKey_key, vv_associateKey, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (NSMutableDictionary *)vv_associateKey
{
    NSMutableDictionary *result = objc_getAssociatedObject(self, (const void *)(_cmd));
    if (!result) {
        result = [NSMutableDictionary new];
        [self setVv_associateKey:result];
    }
    return result;
}

@end

