//
//  BSBaseUserDto.m
//  BaoSheng
//
//  Created by GML on 2018/4/24.
//  Copyright © 2018年 haozheng. All rights reserved.
//

#import "BSBaseUserDto.h"

@implementation partyMemberDto

@end

@implementation BSBaseUserDto

- (NSString *)getUsergender{
    
    if (self.gender.integerValue == 0) {
        return @"";
    }else if (self.gender.integerValue == 1){
        
        return @"男";
    }else if (self.gender.integerValue == 2){
        return @"女";
    }else{
        return @"";
    }
    
}

@end
