//
//  GmWidget.m
//  BaoSheng
//
//  Created by GML on 2018/4/23.
//  Copyright © 2018年 haozheng. All rights reserved.
//

#import "GmWidget.h"
#import <CommonCrypto/CommonCrypto.h>

/** 缓存路径 */
#define CLCacheFile(abc) [[NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) firstObject] stringByAppendingPathComponent:abc]

#define kMinuteTimeInterval (60)
#define kHourTimeInterval   (60 * kMinuteTimeInterval)
#define kDayTimeInterval    (24 * kHourTimeInterval)
#define kWeekTimeInterval   (7  * kDayTimeInterval)
#define kMonthTimeInterval  (30 * kDayTimeInterval)
#define kYearTimeInterval   (12 * kMonthTimeInterval)

@implementation GmWidget

static GmWidget *shareInstance;
+ (instancetype)shareInstance
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        if (!shareInstance) {
            shareInstance = [[[self class] alloc] init];
        }
    });
    return shareInstance;
}
- (dispatch_source_t)gm_countDownWithTime:(int)time countDownBlock:(void (^)(int))countDownBlock endBlock:(void (^)(void))endBlock
{
    __block int timeout = time; //倒计时时间
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_source_t _timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0,queue);
    dispatch_source_set_timer(_timer,dispatch_walltime(NULL, 0),1.0*NSEC_PER_SEC, 0); //每秒执行
    dispatch_source_set_event_handler(_timer, ^{
        if(timeout<=0){ //倒计时结束，关闭
            dispatch_source_cancel(_timer);
            dispatch_async(dispatch_get_main_queue(), ^{
                if (endBlock) {
                    endBlock();
                }
            });
        } else {
            dispatch_async(dispatch_get_main_queue(), ^{
                timeout--;
                if (countDownBlock) {
                    countDownBlock(timeout);
                }
            });
        }
    });
    dispatch_resume(_timer); // 开始
    //dispatch_suspend(_timer); // 暂停
    
    return _timer;
}
- (void)gm_cancelCountDown:(dispatch_source_t)source_t
{
    if (source_t)
        dispatch_source_cancel(source_t);
}

- (NSString *)gm_encode64:(NSString *)string
{
    //先将string转换成data
    NSData *data = [string dataUsingEncoding:NSUTF8StringEncoding];
    
    NSData *base64Data = [data base64EncodedDataWithOptions:0];
    
    NSString *baseString = [[NSString alloc]initWithData:base64Data encoding:NSUTF8StringEncoding];
    
    return baseString;
}
- (NSString *)gm_dencode:(NSString *)base64String
{
    //NSData *base64data = [string dataUsingEncoding:NSUTF8StringEncoding];
    
    NSData *data = [[NSData alloc]initWithBase64EncodedString:base64String options:NSDataBase64DecodingIgnoreUnknownCharacters];
    
    NSString *string = [[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
    
    return string;
}
// 32位MD5加密方式
- (NSString *)gm_getMD5_32Bit_String:(NSString *)srcString
{
    const char *cStr = [srcString UTF8String];
    unsigned char digest[CC_MD5_DIGEST_LENGTH];
    CC_MD5(cStr, (unsigned int)strlen(cStr), digest);
    NSMutableString *result = [NSMutableString stringWithCapacity:CC_MD5_DIGEST_LENGTH * 2];
    for (int i = 0; i < CC_MD5_DIGEST_LENGTH; i ++) {
        [result appendFormat:@"%02X", digest[i]];
    }
    return [result lowercaseString];
}


#pragma mark -- 正则相关 -----------
+(BOOL)isMobileNumber:(NSString *)mobile{
    //    if (mobile.length < 11)
    //    {
    //        //        NSLog(@"手机号长度只能是11位");
    //        return @"手机号长度只能是11位";
    //    }else{
    /**
     * 移动号段正则表达式
     */
    NSString *CM_NUM = @"^((13[4-9])|(147)|(15[0-2,7-9])|(178)|(18[2-4,7-8]))\\d{8}|(1705)\\d{7}$";
    /**
     * 联通号段正则表达式
     */
    NSString *CU_NUM = @"^((13[0-2])|(145)|(15[5-6])|(176)|(18[5,6]))\\d{8}|(1709)\\d{7}$";
    /**
     * 电信号段正则表达式
     */
    NSString *CT_NUM = @"^((133)|(153)|(177)|(18[0,1,9]))\\d{8}$";
    /**
     *  座机号码
     */
    NSString * PHS = @"^0(10|2[0-5789]|\\d{3})\\d{7,8}$";
    
    NSPredicate *pred1 = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CM_NUM];
    BOOL isMatch1 = [pred1 evaluateWithObject:mobile];
    NSPredicate *pred2 = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CU_NUM];
    BOOL isMatch2 = [pred2 evaluateWithObject:mobile];
    NSPredicate *pred3 = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CT_NUM];
    BOOL isMatch3 = [pred3 evaluateWithObject:mobile];
    NSPredicate *pred4 = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", PHS];
    BOOL isMatch4 = [pred4 evaluateWithObject:mobile];
    
    
    if (isMatch1 || isMatch2 || isMatch3 || isMatch4) {
        NSLog(@"是电话号码");
        return YES;
    }else{
        NSLog(@"请输入正确的电话号码");
        return NO;
    }
    //    }
    return NO;
}

+ (NSString *)checkpassword:(NSString *)text{
    
    NSLog(@"检测密码 == %@",text);
    if (text.length < 6) {
        return @"密码长度至少6位";
    }
    if (text.length > 16) {
        return @"密码长度6-16位";
    }
    
    return @"密码格式正确";
    
    //    char abc;
    //    int flag  = 0;
    //    int flag2 = 0;
    //    int flag3 = 0;
    //    for (int i = 0; i < text.length; i++) {
    //        abc = [text characterAtIndex:i];
    //
    //        if (abc >= '0' && abc <= '9'  ) {
    //            flag = 1;//数字
    //        }
    //       else if ((abc > 'A' && abc < 'Z') ||( abc > 'a' && abc < 'z' ) ) {
    //            flag2 = 2;//字母
    //        }
    //       else {
    //           flag3 = 3;//其他字符
    //       }
    //    }
    //    if ((flag == 1 && flag2 == 0 && flag3 == 0)|| (flag == 0 && flag2 == 2 && flag3 == 0)||(flag == 0 && flag2 == 0 && flag3 == 3)) {
    //        return @"密码过于简单";
    //    }
    
    //    if ((flag == 1 && flag2 == 2 )||(flag == 1 && flag3 == 3) || (flag2 == 2 && flag3 == 3)) {
    //        return @"密码格式正确";
    //    }else{
    //        return @"密码格式不正确";
    //    }
    
}

+ (BOOL)checkName_Chinese:(NSString *)text{
    
    //纯中文或纯英文正则
    //    /^[A-z]+$|^[\u4E00-\u9FA5]+$/
    NSString *abc = @"^[\u4e00-\u9fa5]*$";
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", abc];
    BOOL isMatch = [pred evaluateWithObject:text];
    if (isMatch) {
        return YES;
    }else{
        return NO;
    }
    
}

+ (BOOL)checkCodeCertificate:(NSString *)text{
    
    int flag = 0;
    for (int i = 0; i< text.length; i++) {
        char abc = [text characterAtIndex:i-1 >= 0 ? i : 0];
        if (abc >= '0' && abc <= '9') {
            flag = 1;
        }
        if (i == 17) {
            char abc = [text characterAtIndex:i];
            if ((abc >= '0' && abc <= '9') || (abc == 'X' || abc == 'x')) {
                flag = 1;
            }else{
                flag = 0;
            }
        }
        
    }
    
    if (flag == 1) {
        return YES;
    }else{
        return NO;
    }
}

+ (BOOL)validateMoney:(NSString *)money
{
    // ^(([0-9]|([1-9][0-9]{0,9}))((\\.[0-9]{1,2})?))$
    NSString *phoneRegex = @"^[0-9]{1,5}+(\\.[0-9]{1,2})|^[0-9]{1,5}+(\\.)?$";
    NSPredicate *phoneTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",phoneRegex];
    return [phoneTest evaluateWithObject:money];
}

//=====================================================

//等比缩放
- (UIImage *)scaleImage:(UIImage *)image toScale:(float)scaleSize
{
    
    UIGraphicsBeginImageContext(CGSizeMake(image.size.width * scaleSize, image.size.height * scaleSize));
    [image drawInRect:CGRectMake(0, 0, image.size.width * scaleSize, image.size.height * scaleSize)];
    UIImage *scaledImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return scaledImage;
    
}


#pragma mark -- 时间转换  -----------
- (NSString *)trunDateFormatter:(NSString *)TimeInterval{
    
    NSTimeInterval time = [TimeInterval doubleValue];
    NSDate *detaildate=[NSDate dateWithTimeIntervalSince1970:time];
    NSLog(@"date:%@",[detaildate description]);
    //实例化一个NSDateFormatter对象
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    //设定时间格式,这里可以设置成自己需要的格式
    [dateFormatter setDateFormat:@"MM月dd日 HH:mm"];
    
    NSString *currentDateStr = [dateFormatter stringFromDate: detaildate];
    
    return currentDateStr;
    
}

#pragma mark--
#pragma mark 输入中文
- (BOOL)deptNameInputShouldChinese:(NSString *)text
{
    NSString *regex = @"[\u4e00-\u9fa5]+";
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",regex];
    if (![pred evaluateWithObject:text]) {
        return YES;
    }
    return NO;
}

//判断全数字：
+ (BOOL)deptNumInputShouldNumber:(NSString *)text
{
    NSString *regex =@"[0-9]*";
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",regex];
    if (![pred evaluateWithObject:text]) {
        return YES;
    }
    return NO;
}


//判断全字母：

+ (BOOL) deptPassInputShouldAlpha:(NSString *)text
{
    NSString *regex =@"[a-zA-Z]*";
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",regex];
    if (![pred evaluateWithObject:text]) {
        return YES;
    }
    return NO;
}

//判断仅输入字母或数字：
+ (BOOL) deptIdInputShouldAlphaNum:(NSString *)text
{
    NSString *regex =@"[a-zA-Z0-9]*";
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",regex];
    if (![pred evaluateWithObject:text]) {
        return YES;
    }
    return NO;
}

#pragma mark -- 金额计算
#pragma mark 货币计算
+ (NSString *)decimalNumberCalucate:(NSString *)originValue1 originValue2:(NSString *)originValue2 calucateWay:(calucateWay)calucateWay
{
    NSDecimalNumber *decimalNumber1 = [NSDecimalNumber decimalNumberWithString:originValue1];
    NSDecimalNumber *decimalNumber2 = [NSDecimalNumber decimalNumberWithString:originValue2];
    NSDecimalNumber *product;
    switch (calucateWay) {
        case Adding:
            NSLog(@"+++++++++");
            product = [decimalNumber1 decimalNumberByAdding:decimalNumber2];
            break;
            
        case Subtracting:
            NSLog(@"---------");
            product = [decimalNumber1 decimalNumberBySubtracting:decimalNumber2];
            break;
            
        case Multiplying:
            NSLog(@"*********");
            product = [decimalNumber1 decimalNumberByMultiplyingBy:decimalNumber2];
            break;
            
        case Dividing:
            NSLog(@"/////////");
            product = [decimalNumber1 decimalNumberByDividingBy:decimalNumber2];
            break;
            
        default:
            break;
    }
    return [product stringValue];
}
+(NSString *)timeToAge:(NSString *)timeStr{
    
    
    NSTimeInterval time = [timeStr doubleValue]/1000;
    NSDate *date1 = [NSDate dateWithTimeIntervalSince1970:time];
    NSDate *date2 = [NSDate date];
    
    NSCalendar * calendar = [NSCalendar currentCalendar];
    NSCalendarUnit unit = NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay | NSCalendarUnitHour | NSCalendarUnitMinute | NSCalendarUnitSecond;
    NSDateComponents * cmps = [calendar components:unit fromDate:date1 toDate:date2 options:0];
    
    return  [NSString stringWithFormat:@"%ld",cmps.year];
}
+(NSString *)getCurrentTime{
    
    NSDateFormatter * formatter = [[NSDateFormatter alloc]init];
    [formatter setDateFormat:@"YYYY-MM-dd HH:mm:ss"];
    
    NSString *timesting = [formatter stringFromDate:[NSDate date]];
    
    return timesting;
}



+ (NSString *)dateFromTimeInterval:(double)timeInterval

{
    //    NSString*str=@"1368082020";//时间戳
    //
    //    long  NSTimeIntervaltime= strTime + 28800;//因为时差问题要加8小时 == 28800 sec
    if (timeInterval < 0) {
        timeInterval = timeInterval * -1;
    }
    
    NSDate*detaildate=[NSDate dateWithTimeIntervalSince1970:timeInterval/1000];
    
//    NSLog(@"date:%@",[detaildate description]);
    
    //实例化一个NSDateFormatter对象
    
    NSDateFormatter*dateFormatter = [[NSDateFormatter alloc] init];
    
    //设定时间格式,这里可以设置成自己需要的格式
    [dateFormatter setDateFormat:@"yyyy年MM月dd日"];
    
    NSString * currentDateStr = [dateFormatter stringFromDate:detaildate];

    return currentDateStr;
}
+ (NSString *)dateFromTimeIntervalWithHHmm:(double)timeInterval

{
    //    NSString*str=@"1368082020";//时间戳
    //
    //    long  NSTimeIntervaltime= strTime + 28800;//因为时差问题要加8小时 == 28800 sec
    if (timeInterval < 0) {
        timeInterval = timeInterval * -1;
    }
    
    NSDate*detaildate=[NSDate dateWithTimeIntervalSince1970:timeInterval/1000];
    
    //    NSLog(@"date:%@",[detaildate description]);
    
    //实例化一个NSDateFormatter对象
    
    NSDateFormatter*dateFormatter = [[NSDateFormatter alloc] init];
    
    //设定时间格式,这里可以设置成自己需要的格式
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm"];
    
    NSString * currentDateStr = [dateFormatter stringFromDate:detaildate];
    
    return currentDateStr;
}

+ (NSString *)timeIntervalFromDate:(NSString *)formdate{
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    //设置格式：zzz表示时区
    [dateFormatter setDateFormat:@"yyyy年MM月dd日"];
    
    NSDate *date = [dateFormatter  dateFromString:formdate];
    
    NSTimeInterval time = [date timeIntervalSince1970];
 
    return [NSString stringWithFormat:@"%.lf",time * 1000];
}


+ (NSDate * ) dateToTimeStamp:(NSString * )strTime{
    
    
    NSString* timeStr = strTime;
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init] ;
    [formatter setDateStyle:NSDateFormatterMediumStyle];
    [formatter setTimeStyle:NSDateFormatterShortStyle];
    [formatter setDateFormat:@"YYYY-MM-dd HH:mm:ss"];
    
    NSDate* date = [formatter dateFromString:timeStr]; //------------将字符串按formatter转成nsdate
    
    //    时间转时间戳的方法:
    //    NSString *timeSp = [NSString stringWithFormat:@"%lld", (long long)[date timeIntervalSince1970] * 1000];
    //    NSLog(@"timeSp:%@",timeSp);
    return date;
}






+(NSInteger)getDaysFrom:(NSDate *)serverDate To:(NSDate *)endDate
{
    NSCalendar *gregorian = [[NSCalendar alloc]
                             initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    
    [gregorian setFirstWeekday:2];
    
    //去掉时分秒信息
    NSDate *fromDate;
    NSDate *toDate;
    [gregorian rangeOfUnit:NSCalendarUnitDay startDate:&fromDate interval:NULL forDate:serverDate];
    [gregorian rangeOfUnit:NSCalendarUnitDay startDate:&toDate interval:NULL forDate:endDate];
    NSDateComponents *dayComponents = [gregorian components:NSCalendarUnitDay fromDate:fromDate toDate:toDate options:0];
    
    return dayComponents.day;
}


+ (NSString *)ca_timeIntervalDescription:(NSTimeInterval)fromTimeInterval toTimeInterval:(NSTimeInterval)toTimeInterval
{
    
    NSDate *fromDate =  [NSDate dateWithTimeIntervalSince1970:(fromTimeInterval*0.001)];
    NSDate * toDate = [NSDate dateWithTimeIntervalSince1970:(toTimeInterval*0.001)];
    //    NSTimeInterval chazhi = (toTimeInterval*0.001) - (fromTimeInterval*0.001);
    
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSCalendarUnit unit = NSCalendarUnitHour | NSCalendarUnitMinute;
    NSDateComponents *dateCom = [calendar components:unit fromDate:fromDate toDate:toDate options:0];
    
    NSString *dateString = [NSString stringWithFormat:@"%ld小时%ld分钟",(long)dateCom.hour,(long)dateCom.minute];
    
    return dateString;
}


// =============
//每次调用该方法都生成一个新的UUID
+ (NSString *)getUUIDString
{
    CFUUIDRef uuidRef = CFUUIDCreate(kCFAllocatorDefault);
    CFStringRef strRef = CFUUIDCreateString(kCFAllocatorDefault , uuidRef);
    NSString *uuidString = [(__bridge NSString*)strRef stringByReplacingOccurrencesOfString:@"-" withString:@""];
    CFRelease(strRef);
    CFRelease(uuidRef);
    return uuidString;
}

+ (BOOL) isEmpty:(NSString *) str {
    
    if (!str) {
        return true;
    } else {
        //A character set containing only the whitespace characters space (U+0020) and tab (U+0009) and the newline and nextline characters (U+000A–U+000D, U+0085).
        NSCharacterSet *set = [NSCharacterSet whitespaceAndNewlineCharacterSet];
        
        //Returns a new string made by removing from both ends of the receiver characters contained in a given character set.
        NSString *trimedString = [str stringByTrimmingCharactersInSet:set];
        
        if ([trimedString length] == 0) {
            return true;
        } else {
            return false;
        }
    }
}


+ (NSNumber *)trundata:(NSDate *)date{
    
    
    NSString *timeSp = [NSString stringWithFormat:@"%.0f", [date timeIntervalSince1970]];
    NSLog(@"timeSp:%@",timeSp); //时间戳的值
    
    double time = [timeSp doubleValue] * 1000;
    NSNumber *newNUm = [NSNumber numberWithDouble:time];
    return newNUm;
}
+ (NSString *)trunStrFormdata:(NSDate *)date{
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    //设置格式：zzz表示时区
    [dateFormatter setDateFormat:@"yyyy年MM月dd日"];
    //NSDate转NSString
    NSString *currentDateString = [dateFormatter stringFromDate:date];
    
    
    return currentDateString;
}


@end
