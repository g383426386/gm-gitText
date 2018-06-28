//
//  City.h
//  marketplateform
//
//  Created by John on 16/6/28.
//  Copyright © 2016年 com.sjyt. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface City : NSObject



@property(nonatomic,strong)NSArray* allProvinces; //全部省
@property(nonatomic,strong)NSString* cityID;   //当前城市ID
@property(nonatomic,strong)NSString* cityName; //当前城市名字


//@property(nonatomic,strong)NSString* parentID;       //当前城市父ID
//@property(nonatomic,strong)NSString* isProvince;     //当前城市是否是省会
//@property(nonatomic,strong)NSString* pym;      //当前城市拼音首字母


+ (City *)sharedCity;

//根据城市ID获取城市名字
//-(NSString*)getCityNameByID:(NSString*)cityID;

//根据城市ID 获取城市名字  返回0 表示获取id失败  非0表示获取成功
-(int)getCityIDByCityName:(NSString*)cityName;

@end
