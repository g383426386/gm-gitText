//
//  BSBaseUserDto.h
//  BaoSheng
//
//  Created by GML on 2018/4/24.
//  Copyright © 2018年 haozheng. All rights reserved.
//

#import "BSBaseDto.h"

@interface partyMemberDto :BSBaseDto

/** 地址 */
@property (nonatomic , strong)NSString * address;
/** xxx */
@property (nonatomic , strong)NSString * commitment;
/** 创建时间 */
@property (nonatomic , strong)NSString * createDate;
/** brith? */
@property (nonatomic , strong)NSString * dateBirth;
/** ?? */
@property (nonatomic , strong)NSString * education;
/** 头像 */
@property (nonatomic , strong)NSString * headPortraitUrl;
/** ID */
@property (nonatomic , strong)NSNumber * Id;
/** 身份证号 */
@property (nonatomic , strong)NSString * idcard;
/** ?? */
@property (nonatomic , strong)NSNumber * integral;
/** 姓名 */
@property (nonatomic , strong)NSString * names;
/** ？？ */
@property (nonatomic , strong)NSString * nation;
/** ?? */
@property (nonatomic , strong)NSString * partyGroup;
/** ？？ */
@property (nonatomic , strong)NSString * partyMembersPovertyHelpNames;
/** 手机号 */
@property (nonatomic , strong)NSString * phone;

/** ?? */
@property (nonatomic , strong)NSString * placeOfOrigin;
/** ?? */
@property (nonatomic , strong)NSString * posts;
/** 性别 */
@property (nonatomic , strong)NSNumber * sex;
/** ?? */
@property (nonatomic , strong)NSNumber * state;
/** 入党时间 */
@property (nonatomic , strong)NSString * timeToJoinTheParty;
/** ?? */
@property (nonatomic , strong)NSString * workUnit;

@end

@interface BSBaseUserDto : BSBaseDto

//******************  基本信息 *********
/** ID */
@property (nonatomic , strong)NSNumber * Id;
/** 生日 */
@property (nonatomic , strong)NSString * birthTime;
/** 身份证号 */
@property (nonatomic , strong)NSString * idCard;
/** 性别 */
@property (nonatomic , strong)NSNumber * gender;
/** 头像 */
@property (nonatomic , strong)NSString * headUrl;
/** 手机号 */
@property (nonatomic , strong)NSString * mobile;
/** 用户名 */
@property (nonatomic , strong)NSString * names;


/** 密码 */
@property (nonatomic , strong)NSString * password;
/** token */
@property (nonatomic , strong)NSString * ryToken;
/** 状态 */
@property (nonatomic , strong)NSNumber * status;
/** uuid */
@property (nonatomic , strong)NSString * uuid;

/** 创建时间 */
@property (nonatomic , strong)NSNumber * createTime;
/** xxxx */
@property (nonatomic , strong)NSNumber * errorLoginSum;
/** xxxx */
@property (nonatomic , strong)NSNumber * errorLoginTime;

/** 党员信息 */
@property (nonatomic , strong)partyMemberDto * partyMemberInformation;

@property (nonatomic , strong)NSNumber *isLogin;

- (NSString *)getUsergender;

@end
