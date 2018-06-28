//
//  NSObject+SKRequest.m
//  marketplateform
//
//  Created by vic_wei on 2017/5/5.
//  Copyright © 2017年 com.sjyt. All rights reserved.
//

#import "NSObject+SKRequest.h"

@interface NSObject ()
@property (nonatomic , strong) NSMutableArray *aryRquestTask;
@end

@implementation NSObject (SKRequest)

+ (void)load {
    NSString *className = NSStringFromClass(self.class);
    NSLog(@"classname %@", className);
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        
        SEL originalSelector = NSSelectorFromString(@"dealloc");
        SEL swizzledSelector = @selector(skrequest_dealloc);
        
        // When swizzling a class method, use the following:
        // Class class = object_getClass((id)self);
        // Method originalMethod = class_getClassMethod(class, originalSelector);
        // Method swizzledMethod = class_getClassMethod(class, swizzledSelector);
        
        Class class = [self class];
        Method originalMethod = class_getInstanceMethod(class, originalSelector);
        Method swizzledMethod = class_getInstanceMethod(class, swizzledSelector);
        
        BOOL didAddMethod =
        class_addMethod(class,
                        originalSelector,
                        method_getImplementation(swizzledMethod),
                        method_getTypeEncoding(swizzledMethod));
        
        if (didAddMethod) {
            class_replaceMethod(class,
                                swizzledSelector,
                                method_getImplementation(originalMethod),
                                method_getTypeEncoding(originalMethod));
        } else {
            method_exchangeImplementations(originalMethod, swizzledMethod);
        }
    });
}

- (void)sk_requestWithAction:(BSAction *)action success:(void (^)(BSRes *))success failure:(void (^)(BSRes *))failure
{
    if (!self.aryRquestTask) {
        self.aryRquestTask = [NSMutableArray new];
    }
    
//    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
    
        
        WeakSelf
        NSURLSessionTask *task = [[BSWebApiHelper shareInstanse] requestWithAction:action success:^(NSURLSessionDataTask *task, BSRes *res) {
            StrongSelf
            
//            dispatch_async(dispatch_get_main_queue(), ^{
            
                if (success)
                    success(res);
                
                if ([self.aryRquestTask containsObject:task]) {
                    [self.aryRquestTask removeObject:task];
                }
                
//            });
            
            
        } failure:^(NSURLSessionDataTask *task, BSRes *res) {
            StrongSelf
            
//            dispatch_async(dispatch_get_main_queue(), ^{
            
                if (failure)
                    failure(res);
                
                if ([self.aryRquestTask containsObject:task]) {
                    [self.aryRquestTask removeObject:task];
                }
                
//            });
            
        }];
        
        if (task)
            [self.aryRquestTask addObject:task];
        
//    });
}

- (void)skrequest_dealloc
{
    if (self.aryRquestTask) {
        [self.aryRquestTask enumerateObjectsUsingBlock:^(NSURLSessionTask*  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            if (NSURLSessionTaskStateCompleted != obj.state || NSURLSessionTaskStateCanceling != obj.state) {
                [obj cancel];
            }
        }];
        [self.aryRquestTask removeAllObjects];
        self.aryRquestTask = nil;
    }
    
    [self skrequest_dealloc];
}

#pragma mark - seeter getter
static void *aryRquestTask_key = &aryRquestTask_key;
- (void)setAryRquestTask:(NSMutableArray *)aryRquestTask
{
    objc_setAssociatedObject(self, &aryRquestTask_key, aryRquestTask, OBJC_ASSOCIATION_RETAIN);
}

- (NSMutableArray *)aryRquestTask
{
    return objc_getAssociatedObject(self, &aryRquestTask_key);
}

@end
