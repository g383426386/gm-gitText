//
//  GmWidget.h
//  BaoSheng
//
//  Created by GML on 2018/4/23.
//  Copyright © 2018年 haozheng. All rights reserved.
//

#import <Foundation/Foundation.h>

// 金额计算方式
typedef enum {
    Adding,
    Subtracting,
    Multiplying,
    Dividing,
}calucateWay;


typedef enum : NSUInteger {
    TimeStyle_UserActive,
    TimeStyle_Besnise,
} Time_Style;



@interface GmWidget : NSObject


/** 返回单例  */
+ (instancetype)shareInstance;

/** 判断是否是手机号 */
+(BOOL)isMobileNumber:(NSString *)mobile;

//判断纯数字
+ (BOOL)deptNumInputShouldNumber:(NSString *)text;
//字母或数字
+ (BOOL) deptIdInputShouldAlphaNum:(NSString *)text;

//验证密码 （数字+字母+字符 任意组合  需过滤空格 换行符）
+ (NSString *)checkpassword:(NSString *)text;
/** 检测是否是中文 */
- (BOOL)deptNameInputShouldChinese:(NSString *)text;

//判断全是空格
+ (BOOL) isEmpty:(NSString *) str ;

//检测身份证
+ (BOOL)checkCodeCertificate:(NSString *)text;

//验证金额
+ (BOOL)validateMoney:(NSString *)money;

//计算金额
+ (NSString *)decimalNumberCalucate:(NSString *)originValue1 originValue2:(NSString *)originValue2 calucateWay:(calucateWay)calucateWay;


//图片缩放
- (UIImage *)scaleImage:(UIImage *)image toScale:(float)scaleSize;

//-================================
/** 时间戳转当前时间 （毫秒）*/
+ (NSString * )dateFromTimeInterval:(double )timeInterval;
/** 时间转时间戳 (毫秒)*/
+ (NSString *)timeIntervalFromDate:(NSString *)date;

+ (NSString *)dateFromTimeIntervalWithHHmm:(double)timeInterval;

//字符串时间转时间
+ (NSDate * ) dateToTimeStamp:(NSString * )strTime;
//日期转时间戳
+ (NSNumber *)trundata:(NSDate *)date;
+ (NSString *)trunStrFormdata:(NSDate *)date;

//计算相差天数
+(NSInteger)getDaysFrom:(NSDate *)serverDate To:(NSDate *)endDate;

//倒计时
- (dispatch_source_t)gm_countDownWithTime:(int)time countDownBlock:(void (^)(int timeLeft))countDownBlock endBlock:(void (^)(void))endBlock;
- (void)gm_cancelCountDown:(dispatch_source_t)source_t;
/** 字符串64编码 */
- (NSString *)gm_encode64:(NSString *)string;
/** 字符串64解码 */
- (NSString *)gm_dencode:(NSString *)base64String;
/** 32MD5 */
- (NSString *)gm_getMD5_32Bit_String:(NSString *)srcString;
@end
