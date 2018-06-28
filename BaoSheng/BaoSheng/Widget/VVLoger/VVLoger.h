//
//  VVLoger.h
//  
//
//  Created by vic_wei on 15/8/13.
//  Copyright (c) 2015年 cc. All rights reserved.
//

#import <Foundation/Foundation.h>

/* NSLog -> NSLog */
#ifdef DEBUG
#define NSLog( fmt, ... ) \
[VVLoger vv_log: \
[[NSString stringWithUTF8String:__FILE__] lastPathComponent]\
method: [NSString stringWithUTF8String:__PRETTY_FUNCTION__] \
lineNr: [NSNumber numberWithInt:__LINE__] \
text: [NSString stringWithFormat:(fmt), ##__VA_ARGS__] \
]
#else
#define NSLog( fmt, ... )
#endif

/* printfs -> printf */
#ifdef DEBUG
#define printfs(fmt,...) \
[VVLoger vv_print: \
[[NSString stringWithUTF8String:__FILE__] lastPathComponent]\
method: [NSString stringWithUTF8String:__PRETTY_FUNCTION__] \
lineNr: [NSNumber numberWithInt:__LINE__] \
text: [NSString stringWithFormat:([NSString stringWithUTF8String:fmt]), ##__VA_ARGS__] \
]
#else
#define printf( fmt, ... )
#endif

/* v_printf -> printf */
#ifdef DEBUG
#define v_printf(format,...) \
printf("=======\n< -FILE:%s -METHOD:%s -LINE:%d > \n<---LOG:>" format"\n\n", \
[[[NSString stringWithUTF8String:__FILE__] lastPathComponent] UTF8String],  __PRETTY_FUNCTION__, __LINE__, ##__VA_ARGS__)
#else
#define v_printf(format,...)
#endif

@interface VVLoger : NSObject

/*
 * fileName:类名文件 ； method:方法名 ；lineNr:行数 ；format,.. ：输出文本
 *
 */
+ (void)vv_log:(NSString*)fileName method:(NSString*)method lineNr:(NSNumber*)lineNr text:(NSString *)formatStr;


/*
 * fileName:类名文件 ； method:方法名 ；lineNr:行数 ；format,.. ：输出文本
 *
 */
+ (void)vv_print:(NSString*)fileName method:(NSString*)method lineNr:(NSNumber*)lineNr text:(NSString*)formatStr;

@end
