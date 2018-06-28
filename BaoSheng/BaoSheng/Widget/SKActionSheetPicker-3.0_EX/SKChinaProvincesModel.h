//
//  SKChinaProvincesModel.h
//  marketplateform
//
//  Created by Jajo_ios_lzl on 17/5/16.
//  Copyright © 2017年 com.sjyt. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SKChinaProvincesModel : NSObject

@property (nonatomic, strong) NSNumber *id;
@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSString *initial;
@property (nonatomic, strong) NSString *pin_code;
@property (nonatomic, strong) NSString *longitude;
@property (nonatomic, strong) NSString *latitude;
@property (nonatomic, strong) NSArray *Citys;

@end

@interface SKChinaCitysModel : NSObject

@property (nonatomic, strong) NSNumber *id;
@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSString *initial;
@property (nonatomic, strong) NSString *pin_code;
@property (nonatomic, strong) NSString *longitude;
@property (nonatomic, strong) NSString *latitude;

@end