//
//  BSInformationListDto.m
//  BaoSheng
//
//  Created by GML on 2018/4/27.
//  Copyright © 2018年 haozheng. All rights reserved.
//

#import "BSInformationListDto.h"

@implementation InfoListDto

@end

@implementation BSInformationListDto

+ (NSDictionary *)mj_objectClassInArray{
    
    return @{@"list" : [InfoListDto class]};
}

@end
