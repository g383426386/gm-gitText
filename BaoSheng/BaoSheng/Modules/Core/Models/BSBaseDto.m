//
//  BSBaseDto.m
//  BaoSheng
//
//  Created by GML on 2018/4/18.
//  Copyright © 2018年 haozheng. All rights reserved.
//

#import "BSBaseDto.h"
#import "MJExtension.h"

@implementation BSBaseDto

/** 实现 coding 协议 */
MJCodingImplementation

+ (NSDictionary *)mj_replacedKeyFromPropertyName
{
    return @{@"Id": @"id"};
}


@end
