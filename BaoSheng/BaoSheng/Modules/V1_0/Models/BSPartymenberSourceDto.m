//
//  BSPartymenberSourceDto.m
//  BaoSheng
//
//  Created by GML on 2018/4/26.
//  Copyright © 2018年 haozheng. All rights reserved.
//

#import "BSPartymenberSourceDto.h"

@implementation hyqdDto

@end

@implementation fpjlDto

@end

@implementation BSPartymenberSourceDto

+ (NSDictionary *)mj_objectClassInArray{
    
    return @{@"hyqd" : [hyqdDto class],
             @"fpjl" : [fpjlDto class]
             };
}

@end
