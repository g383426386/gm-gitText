//
//  City.m
//  marketplateform
//
//  Created by John on 16/6/28.
//  Copyright © 2016年 com.sjyt. All rights reserved.
//

#import "City.h"

@implementation City

+ (City *)sharedCity {
    static City*  city = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        city = [[self alloc] init];
    });
    
    if(!city.allProvinces){
        [city getData];
    }
    
    return city;
}


-(BOOL)getData
{
    
    NSString*filePath=[[NSBundle mainBundle] pathForResource:@"sjytcity"ofType:@"txt"];
     NSError *error;
     NSString* commentStr = [[NSString alloc]initWithContentsOfFile:filePath encoding:NSUTF8StringEncoding error:&error];
    if(error){
        NSLog(@"error:%@",error.description);
        error = nil;
        return NO;
    }
    
     NSData *resData = [[NSData alloc] initWithData:[commentStr dataUsingEncoding:NSUTF8StringEncoding]];
     NSArray *allProvinces = [NSJSONSerialization JSONObjectWithData:resData options:NSJSONReadingMutableLeaves error:&error];
    if(error){
        NSLog(@"error:%@",error.description);
        return NO;
    }
     self.allProvinces = [[NSArray alloc]initWithArray:allProvinces];
     return YES;
}





//根据城市名字获取城市ID
//-(NSString*)getCityNameByID:(NSString*)cityID
//{
//    //相当耗时哎呀呀
//    for(NSDictionary* city in _allCitys){
//        NSString* lativeCityID = city[@"cityID"];
//        if([lativeCityID isEqualToString:cityID]){
//            return city[@"cityName"];
//        }
//    }
//    return nil;
//}


//根据城市ID 获取城市名字
- (int)getCityIDByCityName:(NSString*)cityName
{
    NSLog(@"%lu",self.allProvinces.count);
    int cityId = 0;
    
    for(NSDictionary* oneProvince in self.allProvinces){
        NSString *provinceName = oneProvince[@"name"];
        
        if([provinceName containsString:cityName] || [cityName containsString:provinceName]){
            cityId = [oneProvince[@"id"] intValue];
            
        }else{
            NSArray* citysForProvince = oneProvince[@"Citys"];
            for(NSDictionary* oneCity in citysForProvince){
                NSString* tempCityName = oneCity[@"name"];
                
                if([cityName containsString:tempCityName] || [tempCityName containsString:cityName]){
                    cityId = [oneCity[@"id"] intValue];
                }else{}
            }
        }
    }
    return cityId;
}


@end
