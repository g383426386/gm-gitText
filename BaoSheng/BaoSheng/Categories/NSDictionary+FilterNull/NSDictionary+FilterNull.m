//
//  NSDictionary+FilterNull.m
//  marketplateform
//
//  Created by vic_wei on 2017/6/3.
//  Copyright © 2017年 com.sjyt. All rights reserved.
//

#import "NSDictionary+FilterNull.h"

@implementation NSDictionary (FilterNull)

- (NSMutableDictionary *)ndf_filterNull
{
    if (![self isKindOfClass:[NSDictionary class]])
        return (id)self;
    
    __block NSMutableDictionary *temp = [[NSMutableDictionary alloc] initWithDictionary:self];
    
    [self enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
        
        if([obj isKindOfClass:[NSNull class]]) { // 过滤
            [temp removeObjectForKey:key];
        }
        
        if([obj isEqual:[NSNull null]]) { // 过滤
            [temp removeObjectForKey:key];
        }
        
        if ([obj isKindOfClass:[NSString class]]) { // 过滤
            NSString *tempStr = obj;
            if([tempStr isEqualToString:@"<null>"] || [tempStr isEqualToString:@"(null)"]|| [tempStr isEqualToString:@"(null)"]) {
                [temp removeObjectForKey:key];
            }
        }
        
        if ([obj isKindOfClass:[NSArray class]]) { // 递归过滤
            __block NSMutableArray *tempAry = [[NSMutableArray alloc] initWithArray:obj];
            [obj enumerateObjectsUsingBlock:^(id  _Nonnull objSub, NSUInteger idx, BOOL * _Nonnull stopSub) {
                if ([objSub isKindOfClass:[NSDictionary class]]) {
                    NSDictionary *tempDic = objSub;
                    tempDic = [tempDic ndf_filterNull];
                    [tempAry replaceObjectAtIndex:idx withObject:tempDic];
                }
            }];
            
            temp[key] = tempAry;
        }
        
        if ([obj isKindOfClass:[NSDictionary class]]) { // 递归过滤
            NSMutableDictionary *tempDic = [[NSMutableDictionary alloc] initWithDictionary:obj];
            tempDic = [tempDic ndf_filterNull];
            temp[key] = tempDic;
        }
        
    }];
    
    return temp;
}

@end
