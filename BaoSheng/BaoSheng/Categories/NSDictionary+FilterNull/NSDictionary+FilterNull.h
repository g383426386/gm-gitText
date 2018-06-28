//
//  NSDictionary+FilterNull.h
//  marketplateform
//
//  Created by vic_wei on 2017/6/3.
//  Copyright © 2017年 com.sjyt. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSDictionary (FilterNull)

/** 过滤 null */
- (NSMutableDictionary*)ndf_filterNull;

@end
