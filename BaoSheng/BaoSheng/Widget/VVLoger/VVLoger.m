//
//  VVLoger.m
//  
//
//  Created by vic_wei on 15/8/13.
//  Copyright (c) 2015年 cc. All rights reserved.
//

#import "VVLoger.h"

@implementation VVLoger

#define NSLog( s, ... ) \
NSLog(@"%@" ,[NSString stringWithFormat:(s), ##__VA_ARGS__]);

+ (void)vv_log:(NSString *)fileName method:(NSString *)method lineNr:(NSNumber *)lineNr text:(NSString *)formatStr
{
#ifdef DEBUG
    if (formatStr.length > 0) {
        __block NSString* logText = formatStr?formatStr:@"";
        logText = [NSString stringWithFormat:@"=======\n< -CLASS:%@ -METHOD:%@ -LINE:%@ > \n<---LOG:> %@\n\n",fileName, method, lineNr.stringValue, logText];
//        va_list vList;
//        NSLogv(logText, vList);
        NSLog(logText);
    }
#endif
}


+ (void)vv_print:(NSString*)fileName method:(NSString*)method lineNr:(NSNumber*)lineNr text:(NSString*)formatStr
{
    if (formatStr.length > 0) {
        __block NSString* logText = formatStr?formatStr:@"";
        logText = [NSString stringWithFormat:@"=======\n< -CLASS:%@ -METHOD:%@ -LINE:%@ > \n<---LOG:> %@\n\n",fileName, method, lineNr.stringValue, logText];
        
//        NSLog(logText);
    
    }
}

@end

//NSLog(@"%@" , [NSThread callStackSymbols]);
//
//void* callstack[128];
//int i, frames = backtrace(callstack, 128);
//char** strs = backtrace_symbols(callstack, frames);
//for (i = 0; i < frames; ++i) {
//    printf("%s\n", strs[i]);
//}
//free(strs);