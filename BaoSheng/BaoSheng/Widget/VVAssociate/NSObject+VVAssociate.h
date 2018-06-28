//
//  NSObject+VVAssociate.h
//  
//
//  Created by nia_wei on 13-10-31.
//  Copyright (c) 2014年 nia_wei. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <objc/runtime.h>


@interface NSObject (VVAssociate)

/** 关联 value for key */
- (void)vv_associateValue:(nullable id)value forKey:(nonnull NSString *)key associationPolicy:(objc_AssociationPolicy)policy;

/** 获取 关联 value for key */
- (nullable id)vv_associateValueForKey:(nonnull NSString *)key;

/** 清除所有关联 */
- (void)vv_cleanAssociate;

@end

