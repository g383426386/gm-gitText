//
//  BSWebApiHelper.h
//  BaoSheng
//
//  Created by GML on 2018/4/18.
//  Copyright © 2018年 haozheng. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AFNetworking/AFNetworking.h>

typedef NS_ENUM(NSInteger,SKWebMethod) {
    SKWebMethod_None,
    SKWebMethod_Get,
    SKWebMethod_Post,
    SKWebMethod_Put,
    SKWebMethod_Delete,
};

typedef NS_ENUM(NSInteger,SKResCode) {
    /** 提示服务器返回的 msg */
    SKResCode_TipMsg = -1,
     /** 成功,如果需要提示,返回message */
    SKResCode_Success = 0,
    /** 请求失败 - 服务器 */
    SKResCode_Failure = 1,
    /** 服务器繁忙 */
    SKResCode_Busy    = 2
   
 


};


#pragma mark - === SKAction ===
@interface BSAction : NSObject

+ (instancetype)instanceWithMethod:(SKWebMethod)method;
+ (instancetype)instanceMethodPostWithApi:(NSString *)api;
+ (instancetype)instanceMethodPostWithHost:(NSString*)host api:(NSString*)api;
+ (instancetype)instanceMethodGetWithHost:(NSString*)host api:(NSString*)api;
+ (instancetype)instanceWithMethod:(SKWebMethod)method host:(NSString *)host mutableurl:(NSString *)middleUrl api:(NSString *)api;

@property (nonatomic, assign) SKWebMethod         method;
@property (nonatomic, copy  ) NSString            *href;
@property (nonatomic, strong) NSMutableDictionary *paramsDic;
@property (nonatomic, strong) NSMutableDictionary *fileDataDic;
@property (nonatomic, strong) NSMutableArray      *filePathAry;

@end

#pragma mark - === BSRes ===
@interface BSRes : BSBaseDto

@property (nonatomic, strong) id        result;
@property (nonatomic, assign) NSInteger code;
@property (nonatomic, copy  ) NSString  *msg;
@property (nonatomic, strong) NSNumber  *TimeStamp;
@property (nonatomic, assign) BOOL      sk_platformFailure;

@end

@interface BSWebApiHelper : NSObject

/** 记录网络状态 */
@property (nonatomic, strong) NSNumber *netStatus;


+ (BSWebApiHelper *)shareInstanse;

- (NSURLSessionTask*)requestWithAction:(BSAction*)action
                               success:(void(^)(NSURLSessionDataTask *task , BSRes *res))success
                               failure:(void(^)(NSURLSessionDataTask *task , BSRes *res))failure;


- (NSURLSessionDownloadTask*)downloadWithUrl:(NSString*)url
                                  toFilePath:(NSString*)path
                                    progress:(void (^)(NSProgress *downloadProgress))downloadProgressBlock
                           completionHandler:(void (^)(NSURLResponse *response, NSURL *filePath, NSError *error))completionHandler;

- (NSURLSessionDataTask*)downloadWithUrl:(NSString*)url
                       completionHandler:(void (^)(NSData *data, NSURLResponse *response, NSError *error))completionHandler;

@end
