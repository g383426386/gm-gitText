//
//  SKDateUtil.m
//  SY_Customer
//
//  Created by vic_wei on 15/10/12.
//  Copyright © 2015年 vic_wei. All rights reserved.
//

#import "SKDateUtil.h"

@implementation SKDateUtil

+ (UIDatePicker *)datePicker
{
    UIDatePicker *dataPicker = [[UIDatePicker alloc] initWithFrame:CGRectZero];
    
    // 日期模式
    [dataPicker setDatePickerMode:UIDatePickerModeDate];
    
    // 中文显示p;
    NSLocale *locale = [[NSLocale alloc] initWithLocaleIdentifier:@"zh_CN"];
    [dataPicker setLocale:locale];
    
    //定义最小最大日期
    NSCalendar* calendar = [NSCalendar currentCalendar];
    unsigned unitFlags = NSYearCalendarUnit | NSMonthCalendarUnit |  NSDayCalendarUnit;
    
    NSDateComponents* compMin = [calendar components:unitFlags fromDate:[NSDate date]];
    [compMin setYear:compMin.year - 120];
    NSDate *minDate =[calendar dateFromComponents:compMin];
    [dataPicker setMinimumDate:minDate];
    
    NSDateComponents* compMax = [calendar components:unitFlags fromDate:[NSDate date]];
    [compMax setYear:compMax.year];
    NSDate *maxDate =[calendar dateFromComponents:compMax];
    [dataPicker setMaximumDate:maxDate];
    
    // 默认日期
    //[compMax setMonth:1];
    //[compMax setDay:1];
    NSDate *defaultDate = [calendar dateFromComponents:compMax];
    [dataPicker setDate:defaultDate];
    
    return dataPicker;
}

+ (NSString *)formatedChatDate:(NSDate *)date
{
    NSString *dateString = nil;
    NSCalendar* calendar = [NSCalendar currentCalendar];
    unsigned unitFlags = NSYearCalendarUnit | NSMonthCalendarUnit |  NSDayCalendarUnit;
    NSDateComponents* curComp = [calendar components:unitFlags fromDate:[NSDate date]];
    NSDateComponents* comp = [calendar components:unitFlags|NSHourCalendarUnit|NSMinuteCalendarUnit fromDate:date];
    
    //    if (curComp.year == comp.year)
    //    {
    if (curComp.month == comp.month && curComp.day - comp.day < 3)
    {
        if (curComp.day == comp.day)
        {
            dateString = [NSString stringWithFormat:@"%02ld:%02ld",comp.hour,comp.minute];
        }
        else if (curComp.day - comp.day == 1)
        {
            dateString = [NSString stringWithFormat:@"昨天 %@",[self _timeOfhour:comp.hour]];
        }
        else if (curComp.day - comp.day == 2)
        {
            dateString = [NSString stringWithFormat:@"前天 %@",[self _timeOfhour:comp.hour]];
        }
    }
    else
    {
        dateString = [NSString stringWithFormat:@"%ld月%ld日", comp.month, comp.day];
    }
    //    }
    //    else
    //    {
    //        dateString = [NSString stringWithFormat:@"%d年%d月%d日", comp.year, comp.month, comp.day];
    //    }
    
    return dateString;
}

+ (NSString *)formatedValidityDate:(NSDate *)date
{
    NSCalendar* calendar = [NSCalendar currentCalendar];
    unsigned unitFlags = NSYearCalendarUnit | NSMonthCalendarUnit |  NSDayCalendarUnit;
    NSDateComponents* comp = [calendar components:unitFlags fromDate:date];
    
    if (comp.month < 10 && comp.day < 10) {
        return [NSString stringWithFormat:@"%ld-0%ld-0%ld",comp.year, comp.month, comp.day];
    }
    if (comp.month < 10) {
        return [NSString stringWithFormat:@"%ld-0%ld-%ld",comp.year, comp.month, comp.day];
    }
    
    if (comp.day < 10) {
        return [NSString stringWithFormat:@"%ld-%ld-0%ld",comp.year, comp.month, comp.day];
    }
    
    return [NSString stringWithFormat:@"%ld-%ld-%ld",comp.year, comp.month, comp.day];
}

+ (NSString *)formatedValidityDateWithMillSecs:(long long) date
{
    NSDate* d = [[NSDate alloc]initWithTimeIntervalSince1970:date/1000.0];
    return [self formatedValidityDate:d];
    //return [self formatedDate:d];
}

+ (NSString *)formatedMonthDate:(NSDate *)date
{
    NSCalendar* calendar = [NSCalendar currentCalendar];
    unsigned unitFlags = NSYearCalendarUnit | NSMonthCalendarUnit |  NSDayCalendarUnit;
    NSDateComponents* comp = [calendar components:unitFlags fromDate:date];
    return [NSString stringWithFormat:@"%ld月%ld日", comp.month, comp.day];
}

+ (NSString *)formatedTimeInMillisecond:(long long)aTime bySeparate:(NSString *)aSeparate
{
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:aTime/1000];
    return [self formatedDate:date bySeparate:aSeparate];
}

+ (NSString *)formatedDate:(NSDate *)date bySeparate:(NSString *)aSeparate
{
    NSCalendar* calendar = [NSCalendar currentCalendar];
    unsigned unitFlags = NSYearCalendarUnit | NSMonthCalendarUnit |  NSDayCalendarUnit;
    NSDateComponents* comp = [calendar components:unitFlags fromDate:date];
    return [NSString stringWithFormat:@"%ld%@%02ld%@%02ld",comp.year,aSeparate, comp.month,aSeparate, comp.day];
}

+ (NSString *)formatedDate:(NSDate *)date{
    return [SKDateUtil formatedDate:date bySeparate:@"-" ];
}

+ (NSString *)_timeOfhour:(NSInteger)aHour
{
    if (aHour < 7)
    {
        return @"凌晨";
    }
    else if (aHour < 12)
    {
        return @"上午";
    }
    else if(aHour < 19)
    {
        return @"下午";
    }else{
        return @"晚上";
    }
}

+ (NSString *)timeDescriptionOfTimeInterval:(NSTimeInterval)timeInterval
{
    NSDateComponents *components = [self.class componetsWithTimeInterval:timeInterval];
    NSInteger roundedSeconds = lround(timeInterval - (components.hour * 60 * 60) - (components.minute * 60));
    
    if (components.hour > 0)
        return [NSString stringWithFormat:@"%ld:%02ld:%02ld", (long)components.hour, (long)components.minute, (long)roundedSeconds];
    
    else
        return [NSString stringWithFormat:@"%ld:%02ld", (long)components.minute, (long)roundedSeconds];
}

+ (NSDateComponents *)componetsWithTimeInterval:(NSTimeInterval)timeInterval
{
    NSCalendar *calendar = [NSCalendar currentCalendar];
    
    NSDate *date1 = [[NSDate alloc] init];
    NSDate *date2 = [[NSDate alloc] initWithTimeInterval:timeInterval sinceDate:date1];
    
    unsigned int unitFlags =
    NSSecondCalendarUnit | NSMinuteCalendarUnit | NSHourCalendarUnit |
    NSDayCalendarUnit | NSMonthCalendarUnit | NSYearCalendarUnit;
    
    return [calendar components:unitFlags
                       fromDate:date1
                         toDate:date2
                        options:0];
}

+ (BOOL)isSameDay:(NSDate *)date1 date2:(NSDate *)date2
{
    NSCalendar* calendar = [NSCalendar currentCalendar];
    unsigned unitFlags = NSYearCalendarUnit | NSMonthCalendarUnit |  NSDayCalendarUnit;
    NSDateComponents* comp1 = [calendar components:unitFlags fromDate:date1];
    NSDateComponents* comp2 = [calendar components:unitFlags fromDate:date2];
    return [comp1 day]   == [comp2 day] &&
    [comp1 month] == [comp2 month] &&
    [comp1 year]  == [comp2 year];
}

+ (NSTimeInterval)curTime
{
    return [[NSDate date] timeIntervalSince1970];
}

+ (NSString*)curTimeStr{
    
    NSDateFormatter* formatter = [[NSDateFormatter alloc]init];
    [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSString* timeStr = [formatter stringFromDate:[NSDate date]];
    return timeStr;
}

+ (long long)curTimeMillisecond
{
    return [self curTime] *1000;
}

+ (NSInteger)curHour
{
    NSCalendar* calendar = [NSCalendar currentCalendar];
    NSDateComponents* comp = [calendar components:NSHourCalendarUnit fromDate:[NSDate date]];
    NSInteger hour = comp.hour;
    return hour;
}

+(NSString *)formatDateForMessageCellWithTimeInterval:(long long)aTimeInterval
{
    NSString *dateString = nil;
    
    time_t intervalInSecond = aTimeInterval / 1000.f;
    time_t ltime;
    time(&ltime);
    
    struct tm today;
    localtime_r(&ltime, &today);
    struct tm nowdate;
    localtime_r(&intervalInSecond, &nowdate);
    struct tm yesterday;
    localtime_r(&ltime, &yesterday);
    yesterday.tm_mday -= 1;
    struct tm theDayBeforeYesterday;
    localtime_r(&ltime, &theDayBeforeYesterday);
    theDayBeforeYesterday.tm_mday -= 2;
    
    if(today.tm_year == nowdate.tm_year && today.tm_mday == nowdate.tm_mday && today.tm_mon == nowdate.tm_mon)//今天
    {
        char s[100];
        strftime(s,sizeof(s),"%R", &nowdate);
        dateString = [NSString stringWithCString:s encoding:NSUTF8StringEncoding];
    }
    else if((yesterday.tm_year == nowdate.tm_year && yesterday.tm_mon == nowdate.tm_mon && yesterday.tm_mday  == nowdate.tm_mday))//昨天
    {
        char s[100];
        strftime(s,sizeof(s),"昨天 %R", &nowdate);
        dateString = [NSString stringWithCString:s encoding:NSUTF8StringEncoding];
    }else if((theDayBeforeYesterday.tm_year == nowdate.tm_year && theDayBeforeYesterday.tm_mon == nowdate.tm_mon && theDayBeforeYesterday.tm_mday  == nowdate.tm_mday))//前天
    {
        char s[100];
        strftime(s,sizeof(s),"前天 %R", &nowdate);
        dateString = [NSString stringWithCString:s encoding:NSUTF8StringEncoding];
    }
    else if(today.tm_year == nowdate.tm_year)//今年内
    {
        char s[100];
        strftime(s,sizeof(s),"%m月%d日 %R", &nowdate);
        dateString = [NSString stringWithCString:s encoding:NSUTF8StringEncoding];
    }
    else//其他年份
    {
        char s[100];
        strftime(s,sizeof(s),"%y年%m月%d日 %R", &nowdate);
        dateString = [NSString stringWithCString:s encoding:NSUTF8StringEncoding];
    }
    
    return dateString;
}

+(NSString *)formatDateForStatusCellWithTimeInterval:(long long)aTimeInterval
{
    NSString *dateString = nil;
    
    time_t intervalInSecond = aTimeInterval / 1000.f;
    time_t ltime;
    time(&ltime);
    
    struct tm today;
    localtime_r(&ltime, &today);
    struct tm nowdate;
    localtime_r(&intervalInSecond, &nowdate);
    struct tm yesterday;
    localtime_r(&ltime, &yesterday);
    yesterday.tm_mday -= 1;
    struct tm theDayBeforeYesterday;
    localtime_r(&ltime, &theDayBeforeYesterday);
    theDayBeforeYesterday.tm_mday -= 2;
    
    if (ltime - intervalInSecond < 3600) {
        dateString = [NSString stringWithFormat:@"刚刚"];
    } else if (ltime - intervalInSecond < 86400) {
        dateString = [NSString stringWithFormat:@"%d小时前", (int)roundf((ltime - intervalInSecond) / 3600)];
    } else {
        dateString = [NSString stringWithFormat:@"%d月%d日", nowdate.tm_mon + 1, nowdate.tm_mday];
    }
    
    //    if(today.tm_year == nowdate.tm_year && today.tm_mday == nowdate.tm_mday && today.tm_mon == nowdate.tm_mon)//今天
    //    {
    //        if(today.tm_hour - nowdate.tm_hour < 1)
    //        {
    //            dateString = [NSString stringWithFormat:@"刚刚"];
    //        }else if(today.tm_hour -nowdate.tm_hour >= 1 )
    //        {
    //            dateString = [NSString stringWithFormat:@"%d个小时前", (today.tm_hour -  nowdate.tm_hour)];
    //        }
    //    }
    //    else
    //    {
    //        dateString = @"";
    //    }
    //    else if((yesterday.tm_year == nowdate.tm_year && yesterday.tm_mon == nowdate.tm_mon && yesterday.tm_mday  == nowdate.tm_mday))//昨天
    //    {
    //        dateString = @"昨天";
    //    }else if((theDayBeforeYesterday.tm_year == nowdate.tm_year && theDayBeforeYesterday.tm_mon == nowdate.tm_mon && theDayBeforeYesterday.tm_mday  == nowdate.tm_mday))//前天
    //    {
    //        dateString = @"前天";
    //    }
    //    else if(today.tm_year == nowdate.tm_year)//今年内
    //    {
    //        char s[100];
    //        strftime(s,sizeof(s),"%m月%d日", &nowdate);
    //        dateString = [NSString stringWithCString:s encoding:NSUTF8StringEncoding];
    //    }
    //    else//其他年份
    //    {
    //        char s[100];
    //        strftime(s,sizeof(s),"%y年%m月%d日", &nowdate);
    //        dateString = [NSString stringWithCString:s encoding:NSUTF8StringEncoding];
    //    }
    
    return dateString;
}

+(NSString*)formatedTimeStrFromSeconds:(long)seconds
{
    if(seconds<0)
    {
        seconds = 0;
    }
    long day = seconds / (60*60*24);
    long hour = (seconds - (60*60*24)* day) / (60*60);
    long leftSeconds =(seconds - (60*60*24)* day - (60*60) * hour);
    long minute = leftSeconds / 60;
    if(leftSeconds%60 !=0 && minute!=59)
    {
        minute ++;
    }
    
    if(day != 0)
    {
        return [NSString stringWithFormat:@"%ld天%ld时%ld分",day,hour,minute];
    }else {
        if (hour != 0) {
            return [NSString stringWithFormat:@"%ld时%ld分",hour,minute];
        } else {
            return [NSString stringWithFormat:@"%ld分",minute];
        }
    }
    
}

+(NSString*)formatedAgeFromMiliseconds: (long long)miliseconds
{
    
    long long yearMili = 365ll * 24ll * 60ll * 60ll * 1000ll;
    long long monthMili = 30ll * 24ll * 60ll * 60ll * 1000ll;
    long long dayMili = 24ll * 60ll * 60ll * 1000ll;
    
    long long year = miliseconds /  yearMili;
    int month = (miliseconds % (yearMili) ) / monthMili;
    if (year < 0) {
        return @"";
    }
    if (year < 6) {
        if (month == 0) {
            return [NSString stringWithFormat:@"%lld岁不足1月", year];
        }
        
        return [NSString stringWithFormat:@"%lld岁%d个月", year, month ];
    }
    return [NSString stringWithFormat:@"%lld岁", year];
}

+(NSString*)formatedExperienceTimeFromMiliseconds: (long long)miliseconds
{
    long long yearMili = 365ll * 24ll * 60ll * 60ll * 1000ll;
    long long monthMili = 30ll * 24ll * 60ll * 60ll * 1000ll;
    long long dayMili = 24ll * 60ll * 60ll * 1000ll;
    
    long long year = miliseconds /  yearMili;
    if (year < 1) {
        return [NSString stringWithFormat:@"不足1年"];
    }
    return [NSString stringWithFormat:@"%lld年", year];
}

+ (NSString*)formatedBirthdayDate: (long long)miliseconds
{
    
    //525600000ll  43800000ll
    
    long long yearMili = 365ll * 24ll * 60ll * 60ll * 1000ll;
    long long monthMili = 30ll * 24ll * 60ll * 60ll * 1000ll;
    long long dayMili = 24ll * 60ll * 60ll * 1000ll;
    
    long long spanYear = miliseconds / yearMili;
    long spanMonth = (miliseconds % (yearMili) ) / monthMili;
    long spanDay =  ( ((miliseconds % (yearMili) ) % monthMili) % monthMili ) / dayMili;
    
    //获得系统日期
    
    NSCalendar  * cal=[NSCalendar  currentCalendar];
    NSUInteger  unitFlags=NSDayCalendarUnit|NSMonthCalendarUnit|NSYearCalendarUnit;
    NSDateComponents * conponent= [cal components:unitFlags fromDate:[NSDate date]];
    
    NSInteger currentYear=[conponent year];
    NSInteger currentMonth=[conponent month];
    NSInteger currentDay=[conponent day];
    
    NSString *  nsDateString= [NSString  stringWithFormat:@"%4d年%2d月%2d日",currentYear,currentMonth , currentDay];
    //NSLog(@"%@", nsDateString);
    
    NSInteger birthYear = 0;
    NSInteger birthMonth = 0;
    NSInteger birthDay = 0;
    
    if (currentDay >= spanDay) {
        
        birthDay = currentDay - spanDay;
        
        if (currentMonth >= spanMonth) {
            birthMonth = currentMonth - spanMonth;
        }
        else
        {
            birthMonth = currentMonth + 12 - spanMonth;
            currentYear-- ;
        }
        
    }
    else
    {
        birthDay = currentDay + 30 - spanDay;
        currentMonth--;
        
        if (currentMonth >= spanMonth) {
            birthMonth = currentMonth - spanMonth;
        }
        else
        {
            birthMonth = currentMonth + 12 - spanMonth;
            currentYear-- ;
        }
    }
    
    birthYear = currentYear - spanYear;
    
    if (birthYear > currentYear  || birthYear < currentYear - 109 ) {
        return nil;
    }
    
    if (birthDay < 10  && birthMonth >= 10) {
        return [NSString  stringWithFormat:@"%d-%d-0%d",birthYear,birthMonth , birthDay];
    }
    
    if (birthDay >= 10  && birthMonth < 10) {
       return [NSString  stringWithFormat:@"%d-0%d-%d",birthYear,birthMonth , birthDay];
    }
    
    if (birthDay < 10  && birthMonth < 10) {
      return [NSString  stringWithFormat:@"%d-0%d-0%d",birthYear,birthMonth , birthDay];
    }
    
    if (birthDay >= 10 && birthMonth >= 10) {
        return [NSString  stringWithFormat:@"%d-%d-%d",birthYear,birthMonth , birthDay];
    }
    
    return nil;
}


+ (long long) birthMiliTimeStampWithYear : (int) year andMonth : (int) month
{
    //获得系统日期
    NSCalendar  * cal=[NSCalendar  currentCalendar];
    NSUInteger  unitFlags=NSDayCalendarUnit|NSMonthCalendarUnit|NSYearCalendarUnit;
    NSDateComponents * conponent= [cal components:unitFlags fromDate:[NSDate date]];
    
    NSInteger currentYear=[conponent year];
    NSInteger currentMonth=[conponent month];
    NSInteger currentDay=[conponent day];
    
    NSInteger birthYear = currentYear - year;
    
    if (birthYear > currentYear  || birthYear < currentYear - 109 ) {
        return 0;
    }
    
    NSInteger birthMonth = currentMonth;
    NSInteger birthDay = currentDay;
    
    if (currentMonth >= month) {
        birthMonth = currentMonth - month;
    }
    else
    {
        birthMonth = currentMonth + 12 - month;
        birthYear = currentYear - year - 1;
    }
    
    NSDateFormatter* formatter = [NSDateFormatter new];
    formatter.dateFormat = @"yyyy-MM-dd";
    
    NSDate* birthDate = [formatter dateFromString:[NSString  stringWithFormat:@"%d-%d-%d",birthYear,birthMonth , birthDay]];
    
    return [birthDate timeIntervalSince1970] * 1000;
}

+ (long long) birthMiliTimeStampWithYear : (int) year
{
    //获得系统日期
    NSCalendar  * cal=[NSCalendar  currentCalendar];
    NSUInteger  unitFlags=NSDayCalendarUnit|NSMonthCalendarUnit|NSYearCalendarUnit;
    NSDateComponents * conponent= [cal components:unitFlags fromDate:[NSDate date]];
    
    NSInteger currentYear=[conponent year];
    NSInteger currentMonth=[conponent month];
    NSInteger currentDay=[conponent day];
    
    NSInteger birthYear = currentYear - year;
    
    if (birthYear > currentYear  || birthYear < currentYear - 109 ) {
        return 0;
    }

    
    NSInteger birthMonth = currentMonth;
    NSInteger birthDay = currentDay;
    
    
    NSDateFormatter* formatter = [NSDateFormatter new];
    formatter.dateFormat = @"yyyy-MM-dd";
    
    NSDate* birthDate = [formatter dateFromString:[NSString  stringWithFormat:@"%ld-%ld-%ld",birthYear,birthMonth , birthDay]];
    return [birthDate timeIntervalSince1970] * 1000;
}

+ (NSString*) getAgeStrWithBirthDayTimeStamp : (double) birthDayTimeStamp
{
    NSCalendar  * cal=[NSCalendar  currentCalendar];
    NSUInteger  unitFlags=NSDayCalendarUnit|NSMonthCalendarUnit|NSYearCalendarUnit;
    NSDateComponents * conponent= [cal components:unitFlags fromDate:[NSDate date]];
    
    NSInteger currentYear=[conponent year];
    NSInteger currentMonth=[conponent month];
    NSInteger currentDay=[conponent day];
    
//    NSDateFormatter* formatter = [NSDateFormatter new];
//    formatter.dateFormat = @"YY-MM-DD";

    NSDate* birthDate = [NSDate dateWithTimeIntervalSince1970: (birthDayTimeStamp / 1000 )];
    NSDateComponents * birthConponent= [cal components:unitFlags fromDate:birthDate];
    
    NSInteger birthYear = [birthConponent year];
    NSInteger birthMonth = [birthConponent month];
    NSInteger birthDay = [birthConponent day];
    
    NSInteger ageYear;
    NSInteger ageMonth;
    
    if (currentMonth >= birthMonth) {
        ageMonth = currentMonth - birthMonth;
        ageYear = currentYear - birthYear;
    }
    else
    {
        ageMonth = currentMonth + 12 - birthMonth;
        ageYear = currentYear - birthYear - 1;
    }
    
    if (ageYear < 6) {
        if (ageMonth == 0) {
            return [NSString stringWithFormat:@"%ld岁不足一月", ageYear];
        }
        return [NSString stringWithFormat:@"%ld岁%ld月", ageYear, ageMonth];
        
    }
    else
    {
        return [NSString stringWithFormat:@"%ld岁", ageYear];
    }
}

+ (int) getAgeYearWithBirthDayTimeStamp : (double) birthDayTimeStamp
{
    NSCalendar  * cal=[NSCalendar  currentCalendar];
    NSUInteger  unitFlags=NSDayCalendarUnit|NSMonthCalendarUnit|NSYearCalendarUnit;
    NSDateComponents * conponent= [cal components:unitFlags fromDate:[NSDate date]];
    
    NSInteger currentYear=[conponent year];
    NSInteger currentMonth=[conponent month];
    NSInteger currentDay=[conponent day];
    
    //    NSDateFormatter* formatter = [NSDateFormatter new];
    //    formatter.dateFormat = @"YY-MM-DD";
    
    NSDate* birthDate = [NSDate dateWithTimeIntervalSince1970: (birthDayTimeStamp / 1000 )];
    NSDateComponents * birthConponent= [cal components:unitFlags fromDate:birthDate];
    
    NSInteger birthYear = [birthConponent year];
    NSInteger birthMonth = [birthConponent month];
    NSInteger birthDay = [birthConponent day];
    
    NSInteger ageYear;
    NSInteger ageMonth;
    
    if (currentMonth >= birthMonth) {
        ageMonth = currentMonth - birthMonth;
        ageYear = currentYear - birthYear;
    }
    else
    {
        ageMonth = currentMonth + 12 - birthMonth;
        ageYear = currentYear - birthYear - 1;
    }
    
    return ageYear;
    
}

+ (int) getAgeMonthWithBirthDayTimeStamp : (double) birthDayTimeStamp
{
    NSCalendar  * cal=[NSCalendar  currentCalendar];
    NSUInteger  unitFlags=NSDayCalendarUnit|NSMonthCalendarUnit|NSYearCalendarUnit;
    NSDateComponents * conponent= [cal components:unitFlags fromDate:[NSDate date]];
    
    NSInteger currentYear=[conponent year];
    NSInteger currentMonth=[conponent month];
    NSInteger currentDay=[conponent day];
    
    NSDate* birthDate = [NSDate dateWithTimeIntervalSince1970: (birthDayTimeStamp / 1000 )];
    NSDateComponents * birthConponent= [cal components:unitFlags fromDate:birthDate];
    
    NSInteger birthYear = [birthConponent year];
    NSInteger birthMonth = [birthConponent month];
    NSInteger birthDay = [birthConponent day];
    
    NSInteger ageYear;
    NSInteger ageMonth;
    
    if (currentMonth >= birthMonth) {
        ageMonth = currentMonth - birthMonth;
        ageYear = currentYear - birthYear;
    }
    else
    {
        ageMonth = currentMonth + 12 - birthMonth;
        ageYear = currentYear - birthYear - 1;
    }
    
    return ageMonth;
}

+ (NSString*) birthStrWithYear:(int) year
{
    NSCalendar  * cal=[NSCalendar  currentCalendar];
    NSUInteger  unitFlags=NSDayCalendarUnit|NSMonthCalendarUnit|NSYearCalendarUnit;
    NSDateComponents * conponent= [cal components:unitFlags fromDate:[NSDate date]];
    
    NSInteger currentYear=[conponent year];
    NSInteger currentMonth=[conponent month];
    NSInteger currentDay=[conponent day];
    
    NSInteger birthYear = currentYear - year;
    
    if (birthYear > currentYear  || birthYear < currentYear - 109 ) {
        return nil;
    }
    
    NSInteger birthMonth = currentMonth;
    NSInteger birthDay = currentDay;
    
    if (birthDay < 10  && birthMonth >= 10) {
        return [NSString  stringWithFormat:@"%ld-%ld-0%ld",birthYear,birthMonth , birthDay];
    }
    
    if (birthDay >= 10  && birthMonth < 10) {
        return [NSString  stringWithFormat:@"%ld-0%ld-%ld",birthYear,birthMonth , birthDay];
    }
    
    if (birthDay < 10  && birthMonth < 10) {
        return [NSString  stringWithFormat:@"%ld-0%ld-0%ld",birthYear,birthMonth , birthDay];
    }
    
    if (birthDay >= 10 && birthMonth >= 10) {
        return [NSString  stringWithFormat:@"%ld-%ld-%ld",birthYear,birthMonth , birthDay];
    }

    return nil;
}

+ (NSString*) birthStrWithYear:(int) year andMonth : (int) month
{
    NSCalendar  * cal=[NSCalendar  currentCalendar];
    NSUInteger  unitFlags=NSDayCalendarUnit|NSMonthCalendarUnit|NSYearCalendarUnit;
    NSDateComponents * conponent= [cal components:unitFlags fromDate:[NSDate date]];
    
    NSInteger currentYear=[conponent year];
    NSInteger currentMonth=[conponent month];
    NSInteger currentDay=[conponent day];
    
    NSInteger birthYear = currentYear - year;
    
    if (birthYear > currentYear  || birthYear < currentYear - 109 ) {
        return nil;
    }
    
    NSInteger birthMonth = currentMonth;
    NSInteger birthDay = currentDay;
    
    if (currentMonth >= month) {
        birthMonth = currentMonth - month;
    }
    else
    {
        birthMonth = currentMonth + 12 - month;
        birthYear = currentYear - year - 1;
    }

    
    if (birthDay < 10  && birthMonth >= 10) {
        return [NSString  stringWithFormat:@"%ld-%ld-0%ld",birthYear,birthMonth , birthDay];
    }
    
    if (birthDay >= 10  && birthMonth < 10) {
        return [NSString  stringWithFormat:@"%ld-0%ld-%ld",birthYear,birthMonth , birthDay];
    }
    
    if (birthDay < 10  && birthMonth < 10) {
        return [NSString  stringWithFormat:@"%ld-0%ld-0%ld",birthYear,birthMonth , birthDay];
    }
    
    if (birthDay >= 10 && birthMonth >= 10) {
        return [NSString  stringWithFormat:@"%ld-%ld-%ld",birthYear,birthMonth , birthDay];
    }
    
    return nil;
}

+ (NSString*) birthStrWithBirthMill : (double) birthMili
{
    NSDate* birthDate = [NSDate dateWithTimeIntervalSince1970: birthMili / 1000];
    NSCalendar  * cal=[NSCalendar  currentCalendar];
    NSUInteger  unitFlags = NSDayCalendarUnit|NSMonthCalendarUnit|NSYearCalendarUnit;
    NSDateComponents * birthConponent= [cal components:unitFlags fromDate: birthDate];
    
    NSInteger birthYear = [birthConponent year];
    NSInteger birthMonth = [birthConponent month];
    NSInteger birthDay = [birthConponent day];
    
    if (birthDay < 10  && birthMonth >= 10) {
        return [NSString  stringWithFormat:@"%ld-%ld-0%ld",birthYear,birthMonth , birthDay];
    }
    
    if (birthDay >= 10  && birthMonth < 10) {
        return [NSString  stringWithFormat:@"%ld-0%ld-%ld",birthYear,birthMonth , birthDay];
    }
    
    if (birthDay < 10  && birthMonth < 10) {
        return [NSString  stringWithFormat:@"%ld-0%ld-0%ld",birthYear,birthMonth , birthDay];
    }
    
    if (birthDay >= 10 && birthMonth >= 10) {
        return [NSString  stringWithFormat:@"%ld-%ld-%ld",birthYear,birthMonth , birthDay];
    }
    return nil;
}

+(NSDate *)stringDateToDate:(NSString *)dateStr{
    
    NSDate *resultDate;
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    
    [formatter setDateFormat:@"yyyy-MM-dd"];
    
    NSTimeZone* sourceTimeZone = [NSTimeZone systemTimeZone];
    
    formatter.timeZone = sourceTimeZone;
    
    resultDate = [formatter dateFromString:[NSString stringWithFormat:@"%@",dateStr]];
    
    return resultDate;
}


+ (BOOL )compareCurrentTime:(NSDate *)date
{
    
    //把字符串转为NSdate
//    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
//    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSDate *timeDate = date;
    
    //得到与当前时间差
    NSTimeInterval  timeInterval = [timeDate timeIntervalSinceNow];
    timeInterval = -timeInterval;
    //标准时间和北京时间差8个小时
//    timeInterval = timeInterval + 8*60*60;
    NSLog(@"相差 %.2f秒",timeInterval);
    BOOL result = NO;
    if (timeInterval >= 180) {//大于3 分钟
        result = YES;
    }else{
        result = NO;
    }
    
//    long temp = 0;
//    NSString *result;
//    if (timeInterval < 60) {
//        result = [NSString stringWithFormat:@"刚刚"];
//    }
//    else if((temp = timeInterval/60) <60){
//        result = [NSString stringWithFormat:@"%d分钟前",temp];
//    }
//
//    else if((temp = temp/60) <24){
//        result = [NSString stringWithFormat:@"%d小时前",temp];
//    }
//
//    else if((temp = temp/24) <30){
//        result = [NSString stringWithFormat:@"%d天前",temp];
//    }
//
//    else if((temp = temp/30) <12){
//        result = [NSString stringWithFormat:@"%d月前",temp];
//    }
//    else{
//        temp = temp/12;
//        result = [NSString stringWithFormat:@"%d年前",temp];
//    }
    
    return  result;
}


@end
