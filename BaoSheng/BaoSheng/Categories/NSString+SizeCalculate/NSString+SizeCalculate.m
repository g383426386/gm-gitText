//
//  NSString+SizeCalculate.m
//  ucar_customer
//
//  Created by nia_wei on 15-4-29.
//  Copyright (c) 2015年 gogotown. All rights reserved.
//

#import "NSString+SizeCalculate.h"
#import <UIKit/UIKit.h>
@implementation NSString (SizeCalculate)

- (CGFloat)sc_calculateWidthInFontSize:(CGFloat)fontSize withStableHeight:(CGFloat)stableHeight
{
    CGFloat result = 0.0f;
    
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc]init];
    paragraphStyle.lineBreakMode = NSLineBreakByWordWrapping;
    NSDictionary *attributes = @{NSFontAttributeName:[UIFont systemFontOfSize:fontSize], NSParagraphStyleAttributeName:paragraphStyle.copy};
    CGSize resultSize = [self boundingRectWithSize:CGSizeMake(MAXFLOAT , stableHeight) options:NSStringDrawingUsesLineFragmentOrigin attributes:attributes context:nil].size;
    result = resultSize.width;
    result = ceilf(result);
    if (self.length==0) result = 0.0;
    return result;
}

- (CGFloat)sc_calculateHeightInFontSize:(CGFloat)fontSize withStableWidth:(CGFloat)stableWidth
{
    CGFloat result = 0.0f;
    
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc]init];
    paragraphStyle.lineBreakMode = NSLineBreakByWordWrapping;
    NSDictionary *attributes = @{NSFontAttributeName:[UIFont systemFontOfSize:fontSize], NSParagraphStyleAttributeName:paragraphStyle.copy};
    CGSize resultSize = [self boundingRectWithSize:CGSizeMake(stableWidth , MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:attributes context:nil].size;
    result = resultSize.height;
    result = ceilf(result);
    
    if (self.length==0) result = 0.0;
    return result;
}

+ (NSString *)modifyJsonStr:(NSString *)string
{
    NSString *modifyStr = [string stringByReplacingOccurrencesOfString:@"\n" withString:@""];
//    modifyStr = [string stringByReplacingOccurrencesOfString:@"|" withString:@""];
//    modifyStr = [string stringByReplacingOccurrencesOfString:@"\r" withString:@""];
    modifyStr = [string stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    
    return modifyStr;
}

+ (NSString *)tojsonString:(id)C_Obj{

     BOOL isYes = [NSJSONSerialization isValidJSONObject:C_Obj];
    if (isYes) {
        NSError *error;
         NSData *jsonData = [NSJSONSerialization dataWithJSONObject:C_Obj options:0 error:&error];
        if (error) {
            NSLog(@"%@",@"json解析错误");
            return nil;
        }
        
        return  [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    }
    
    NSLog(@"%@",@"传入对象不可转为json");
    return nil;
}


@end
