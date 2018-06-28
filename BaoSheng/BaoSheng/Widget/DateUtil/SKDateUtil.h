//
//  SKDateUtil.h
//  SY_Customer
//
//  Created by vic_wei on 15/10/12.
//  Copyright © 2015年 vic_wei. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface SKDateUtil : NSObject
// 日期选择器
+ (UIDatePicker *)datePicker;

/**
 *  格式化时间
 *  当天的显示：小时和分钟，24小时制，如 15：23
 *  昨天的显示：昨天 上午（凌晨/下午/晚上）, 凌晨是0-7点，上午是7-12点，下午是12-19点，晚上是19-24点。
 *  前天的显示：前天 上午（凌晨/下午/晚上）
 *  本年内，且是3天前的显示：X月X日
 *  非本年内的，且是3天前的显示：XXXX年X月X日
 *
 *  @param date 时间
 *
 *  @return 格式化之后的时间字符串
 */
+ (NSString *)formatedChatDate:(NSDate *)date;

/**
 *  格式化时间
 *  xx年xx月xx日
 *
 *  @param date 时间啊
 *
 *  @return 格式化之后的时间字符串
 */
+ (NSString *)formatedValidityDate:(NSDate *)date;

+ (NSString *)formatedValidityDateWithMillSecs:(long long) date;

/**
 *  格式化时间
 *  xx月xx日
 *
 *  @param date 时间
 *
 *  @return 格式化之后的时间字符串
 */
+ (NSString *)formatedMonthDate:(NSDate *)date;

/**
 *  格式化时间
 *
 *  @param date      时间
 *  @param aSeparate 年月日的分隔符
 *
 *  @return 格式化之后的时间字符串
 */
+ (NSString *)formatedDate:(NSDate *)date bySeparate:(NSString *)aSeparate;

+ (NSString *)formatedDate:(NSDate *)date;

/**
 *  格式化时间
 *
 *  @param aTime     毫秒时间
 *  @param aSeparate 年月日的分隔符
 *
 *  @return 格式化之后的时间字符串
 */
+ (NSString *)formatedTimeInMillisecond:(long long)aTime bySeparate:(NSString *)aSeparate;

// 时长 %ld:%02ld:%02ld
+ (NSString *)timeDescriptionOfTimeInterval:(NSTimeInterval)timeInterval;

// 是否是同一天
+ (BOOL)isSameDay:(NSDate *)date1 date2:(NSDate *)date2;

// 当前时间
+ (NSTimeInterval)curTime;

// 当前时间字符串：yyyy-mm-dd HH:mm:ss
+ (NSString*)curTimeStr;

// 当前时间毫秒级
+ (long long)curTimeMillisecond;

// 当前小时
+ (NSInteger)curHour;

/**
 *  格式化时间 聊天消息显示用
 1 当天的显示：小时和分钟，24小时制，如 15:23
 2 昨天的显示：昨天 时间（24小时制）, 如:昨天 15:23
 3 前天的显示：前天 时间（24小时制）, 如:前天 15:23
 4 本年内，且是3天前的显示：X月X日 时间，如：3月1日 15:23
 5 非本年内的，且是3天前的显示：XXXX年X月X日 时间，如：2012年3月1日 15:23
 *
 *  @param aTimeInterval 时间戳 13位 毫秒
 *
 *  @return 格式化之后的字符串
 */
+(NSString *)formatDateForMessageCellWithTimeInterval:(long long)aTimeInterval;

/**
 *  格式化时间，用于动态显示
 
 24小时内发布的动态显示发布时时间，时间的展示形式为“xx小时前”,其中：
 -一个小时以内显示文案为“刚刚”。
 -时间显示精确到小时，向下取整，例如：2小时30分前发布，显示“2小时前”。
 -发布超过24小时的，不显示时间，即时间最多显示到“23小时前”
 
 *  @param aTimeInterval 时间戳 13位 毫秒
 *
 *  @return 格式化之后的字符串
 */
+(NSString *)formatDateForStatusCellWithTimeInterval:(long long)aTimeInterval;

/*!
 将描述转为时间字符串。例如：5天14小时14分
 
 @param seconds 需要转换的秒数
 
 @return string
 */
+(NSString*)formatedTimeStrFromSeconds:(long)seconds;

+(NSString*)formatedAgeFromMiliseconds: (long long)miliseconds;
+(NSString*)formatedExperienceTimeFromMiliseconds: (long long)miliseconds;

+ (NSString*)formatedBirthdayDate: (long long)miliseconds;


#pragma mark - 年龄相关新借口
//获取出生日期的时间戳
+ (long long) birthMiliTimeStampWithYear : (int) year andMonth : (int) month;
+ (long long) birthMiliTimeStampWithYear : (int) year;

//获取年龄
+ (NSString*) getAgeStrWithBirthDayTimeStamp : (double) birthDayTimeStamp;
+ (int) getAgeYearWithBirthDayTimeStamp : (double) birthDayTimeStamp;
+ (int) getAgeMonthWithBirthDayTimeStamp : (double) birthDayTimeStamp;

//获取出生日期，关联医生时用
+ (NSString*) birthStrWithYear:(int) year andMonth : (int) month;
+ (NSString*) birthStrWithYear:(int) year;
+ (NSString*) birthStrWithBirthMill : (double) birthMili;

+(NSDate *)stringDateToDate:(NSString *)dateStr;

+ (BOOL )compareCurrentTime:(NSDate *)date;

@end
