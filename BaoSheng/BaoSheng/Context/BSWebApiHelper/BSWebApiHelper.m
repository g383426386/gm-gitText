//
//  BSWebApiHelper.m
//  BaoSheng
//
//  Created by GML on 2018/4/18.
//  Copyright © 2018年 haozheng. All rights reserved.
//

#import "BSWebApiHelper.h"
#import <AFNetworking/UIKit+AFNetworking.h>

#pragma mark - === BSAction ===
@implementation BSAction

+ (instancetype)instanceWithMethod:(SKWebMethod)method
{
    BSAction *action = [BSAction new];
    
    return action;
}
+ (instancetype)instanceMethodPostWithApi:(NSString *)api{
    
    return [self instanceMethodPostWithHost:BS_HOST_Master api:api];
}

+ (instancetype)instanceMethodGetWithHost:(NSString *)host api:(NSString *)api
{
    return [[self class] instanceWithMethod:SKWebMethod_Get host:host hostapend:BS_hostapend mutableurl:BS_Mutable_Url  api:api];
}

+ (instancetype)instanceMethodPostWithHost:(NSString *)host api:(NSString *)api
{
    return [[self class] instanceWithMethod:SKWebMethod_Post host:host hostapend:BS_hostapend mutableurl:BS_Mutable_Url  api:api];
}

+ (instancetype)instanceWithMethod:(SKWebMethod)method host:(NSString *)host hostapend:(NSString *)hostapend mutableurl:(NSString *)middleUrl api:(NSString *)api
{
    BSAction *action = [BSAction new];
    
    action.method = method;
    action.href = BSApi_Path(host,hostapend,middleUrl,api);
    
    
    return action;
}

- (instancetype)init
{
    if (self = [super init]) {
        _paramsDic = [NSMutableDictionary new];
        _fileDataDic = [NSMutableDictionary new];
        _filePathAry = [NSMutableArray new];
    }
    return self;
}

@end


#pragma mark - === BSRes ===
@implementation BSRes

@end

@interface BSWebApiHelper()

@property (nonatomic , strong)AFHTTPSessionManager         *manager;
@property (nonatomic , strong)AFHTTPSessionManager         *managerAsync;
@property (nonatomic , strong)AFHTTPSessionManager         *managerSync;
@property (nonatomic , strong)AFNetworkReachabilityManager *reachabilityManager;

@end


@implementation BSWebApiHelper


static BSWebApiHelper *shareInstanse;

+ (instancetype)shareInstanse
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        if (!shareInstanse) {
            shareInstanse = [[[self class] alloc] init];
        }
    });
    return shareInstanse;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        //设置状态栏 网络请求缓慢时 loading 可见
        [AFNetworkActivityIndicatorManager sharedManager].enabled = YES;
        [self afNetworkStatus];
//        [self configHostUrl];
    }
    return self;
}

- (NSURLSessionTask*)requestWithAction:(BSAction *)action inManager:(AFHTTPSessionManager*)manager success:(void (^)(NSURLSessionDataTask *, BSRes *))success failure:(void (^)(NSURLSessionDataTask *, BSRes *))failure
{
    
    
    self.manager = manager;
    
    if (self.manager == self.managerAsync) { //设置 主线程 回调
        self.manager.completionQueue = dispatch_get_main_queue();
    }
    if (self.manager == self.managerSync) { // 设置 非主线程 回调
        if (self.manager.completionQueue == nil || self.manager.completionQueue == dispatch_get_main_queue()) {
            self.manager.completionQueue = dispatch_queue_create("AFNetworking+Synchronous", NULL);
        }
    }
    
    void (^successHandler)(NSURLSessionDataTask *task, id responseObject) = ^(NSURLSessionDataTask *task, id responseObject) {
        
        BSRes *res = [BSRes mj_objectWithKeyValues:responseObject];
        NSLog(@"res message = %@",res.msg);
        
//        self.responseSeverTime = res.TimeStamp.longLongValue;
//        self.systemUptime = [NSProcessInfo processInfo].systemUptime;
        
        if (SKResCode_Success == res.code) {
            if (success)
                success(task,res);
        }else{
            if (failure)
                failure(task,res);
            [STSHUdHelper st_toastMsg:res.msg completion:nil];

        }
        
    };
    
    
    void (^failureHandler)(NSURLSessionDataTask *task, NSError *error) = ^(NSURLSessionDataTask *task, NSError *error){
        
        NSLog(@"error ****** %@",error.localizedDescription);
    
        if (-999 == error.code) { // 主动 cancel task，忽略处理
            if (failure)
                failure(task,nil);
        }else{
            BSRes *res = [BSRes new];
            res.code = error.code;
            res.msg = error.localizedDescription;
            if (failure)
                failure(task,res);
        }
        
    };
    
    //请求类型
    self.manager.requestSerializer = [self sk_requestSerializer];
    
    //接收类型
    self.manager.responseSerializer = [self sk_responseSerializer];
    
    //设置 action
    self.manager.requestSerializer.sk_action = action;
    
    NSLog(@"------- ******* http request *** - :%@" , action.href);
    
    NSURLSessionTask *requestTask = nil;
    switch (action.method) {
        case SKWebMethod_Get:
        {
            requestTask = [self.manager GET:action.href parameters:action.paramsDic progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                successHandler(task,responseObject);
            } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                failureHandler(task,error);
            }];
        }
            break;
            
        case SKWebMethod_Post:
        {
            
            if (action.fileDataDic.count > 0 || action.filePathAry.count > 0) {
                requestTask = [self.manager POST:action.href parameters:action.paramsDic constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
                    
                    //[formData appendPartWithFormData:[action.paramsDic mj_JSONData] name:@""];
                    
                    [action.fileDataDic enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, NSData*  _Nonnull obj, BOOL * _Nonnull stop) {
                        if ( SK_KindClass(obj, [NSData class]) ) {
                            NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
                            formatter.dateFormat       = @"yyyyMMddHHmmss";
                            NSString *str              = [formatter stringFromDate:[NSDate date]];
                            NSString *fileName         = [NSString stringWithFormat:@"%@.jpg", str];
                            
                            [formData appendPartWithFileData:obj name:key fileName:fileName mimeType:@"image/jpeg"];
                        }
                    }];
                    
                    [action.filePathAry enumerateObjectsUsingBlock:^(NSString*  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                        if (obj.length > 0) {
                            [formData appendPartWithFileURL:[NSURL fileURLWithPath:obj] name:obj.lastPathComponent fileName:obj.lastPathComponent mimeType:@"image/jpeg" error:nil];
                        }
                    }];
                    
                } progress:^(NSProgress * _Nonnull uploadProgress) {
                    
                } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                    successHandler(task,responseObject);
                } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                    failureHandler(task,error);
                }];
            }else{
                requestTask = [self.manager POST:action.href parameters:action.paramsDic progress:^(NSProgress * _Nonnull uploadProgress) {
                    
                } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                    successHandler(task,responseObject);
                } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                    failureHandler(task,error);
                }];
            }
            
        }
            break;
            
        case SKWebMethod_Put:
        {
            requestTask = [self.manager PUT:action.href parameters:action.paramsDic success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                successHandler(task,responseObject);
            } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                failureHandler(task,error);
            }];
        }
            break;
            
        case SKWebMethod_Delete:
        {
            requestTask = [self.manager DELETE:action.href parameters:action.paramsDic success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                successHandler(task,responseObject);
            } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                failureHandler(task,error);
            }];
        }
            break;
            
        case SKWebMethod_None:
            break;
    }
    
    
    return requestTask;
}

- (NSURLSessionTask*)requestWithAction:(BSAction *)action success:(void (^)(NSURLSessionDataTask *, BSRes *))success failure:(void (^)(NSURLSessionDataTask *, BSRes *))failure
{
    
    NSURLSessionTask *requestTask = [self requestWithAction:action inManager:self.managerAsync success:success failure:failure];
    
    return requestTask;
}



- (NSURLSessionDownloadTask*)downloadWithUrl:(NSString *)url toFilePath:(NSString *)path progress:(void (^)(NSProgress *))downloadProgressBlock completionHandler:(void (^)(NSURLResponse *, NSURL *, NSError *))completionHandler
{
    if (url.length >0) {
        
        NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
        AFURLSessionManager *manager = [[AFURLSessionManager alloc] initWithSessionConfiguration:configuration];
        NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:url]];
        
        NSURLSessionDownloadTask *downloadTask = [manager downloadTaskWithRequest:request progress:downloadProgressBlock destination:^NSURL *(NSURL *targetPath, NSURLResponse *response) {
            //NSURL *documentsDirectoryURL = [[NSFileManager defaultManager] URLForDirectory:NSDocumentDirectory inDomain:NSUserDomainMask appropriateForURL:nil create:NO error:nil];
            return (path.length > 0) ? [NSURL fileURLWithPath:path] : nil;
        } completionHandler:^(NSURLResponse * _Nonnull response, NSURL * _Nullable filePath, NSError * _Nullable error) {
            if (completionHandler)
                completionHandler(response,filePath,error);
        }];
        
        [downloadTask resume];
        
        return downloadTask;
    }else{
        if (completionHandler)
            completionHandler(nil,nil,nil);
        return nil;
    }
    
}

- (NSURLSessionDataTask *)downloadWithUrl:(NSString *)url completionHandler:(void (^)(NSData *, NSURLResponse *, NSError *))completionHandler
{
    
    if (url.length == 0) {
        if (completionHandler)
            completionHandler(nil,nil,nil);
        return nil;
    }
    
    //    //获取session对象
    //    NSURLSession *session = [NSURLSession sharedSession];
    //
    //    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:url?:@""]];
    //    request.timeoutInterval = 15;
    //
    //    NSURLSessionDataTask *dataTask = [session dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
    //        dispatch_async(dispatch_get_main_queue(), ^{
    //            if (completionHandler)
    //                completionHandler(data,response,error);
    //        });
    //    }];
    //
    //    [dataTask resume];
    
    
    NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
    AFURLSessionManager *manager = [[AFURLSessionManager alloc] initWithSessionConfiguration:configuration];
    manager.responseSerializer = [AFHTTPResponseSerializer new];
    manager.operationQueue.maxConcurrentOperationCount = 5;
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:url?:@""]];
    request.timeoutInterval = 15;
    
    NSURLSessionDataTask *dataTask = [manager dataTaskWithRequest:request uploadProgress:nil downloadProgress:^(NSProgress * _Nonnull downloadProgress) {
        
    } completionHandler:^(NSURLResponse * _Nonnull response, id  _Nullable responseObject, NSError * _Nullable error) {
        dispatch_async(dispatch_get_main_queue(), ^{
            if (completionHandler)
                completionHandler(responseObject,response,error);
        });
    }];
    [dataTask resume];
    
    
    return dataTask;
}


#pragma mark - set & get
- (AFHTTPSessionManager *)managerAsync
{
    if (!_managerAsync) {
        _managerAsync                                         = [AFHTTPSessionManager manager];
//        _managerAsync.securityPolicy.allowInvalidCertificates = YES;
//        _managerAsync.securityPolicy.validatesDomainName      = NO;
    }
    return _managerAsync;
}

- (AFHTTPSessionManager *)managerSync
{
    if (!_managerSync) {
        _managerSync                                         = [AFHTTPSessionManager manager];
        _managerSync.securityPolicy.allowInvalidCertificates = YES;
        _managerSync.securityPolicy.validatesDomainName      = NO;
    }
    return _managerSync;
}

- (AFHTTPRequestSerializer*)sk_requestSerializer
{
    AFHTTPRequestSerializer *serializer = nil;
    
    serializer = [AFJSONRequestSerializer serializer]; // Content-Type:    application/json
    //serializer = [AFHTTPRequestSerializer serializer]; // Content-Type: application/x-www-form-urlencoded
    //serializer.HTTPMethodsEncodingParametersInURI = [NSSet setWithArray:@[@"POST", @"GET", @"PUT",@"DELETE"]];
    
    serializer.timeoutInterval = 15;
    
    return serializer;
}

- (AFHTTPResponseSerializer*)sk_responseSerializer
{
    AFHTTPResponseSerializer *serializer = nil;
    serializer = [AFJSONResponseSerializer serializer]; // 返回json解析后的数据
    //serializer = [AFHTTPResponseSerializer serializer]; // 不会解析,直接返回 data数据
    //serializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", nil];
    
    return serializer;
}

#pragma mark *** 网络监听 ***
-(void)afNetworkStatus
{
    self.reachabilityManager = [AFNetworkReachabilityManager sharedManager];
    [self.reachabilityManager startMonitoring];
    __weak typeof(self)weakSelf = self ;
    [self.reachabilityManager setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
        switch (status) {
            case AFNetworkReachabilityStatusUnknown:
                weakSelf.netStatus = @(AFNetworkReachabilityStatusUnknown);
                
                break;
                
            case AFNetworkReachabilityStatusNotReachable:
                NSLog(@"无网络");
                weakSelf.netStatus = @(AFNetworkReachabilityStatusNotReachable);
                
                break;
                
            case AFNetworkReachabilityStatusReachableViaWWAN:
                NSLog(@"蜂窝数据网");
                weakSelf.netStatus = @(AFNetworkReachabilityStatusReachableViaWWAN);
                
                break;
                
            case AFNetworkReachabilityStatusReachableViaWiFi:
                NSLog(@"WiFi网络");
                weakSelf.netStatus = @(AFNetworkReachabilityStatusReachableViaWiFi);
                break;
            default:
                break;
        }
    }] ;
}


@end
