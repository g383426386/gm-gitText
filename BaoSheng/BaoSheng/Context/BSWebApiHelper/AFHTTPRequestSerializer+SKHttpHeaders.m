//
//  AFJSONRequestSerializer+HttpHeaders.m
//  marketplateform
//
//  Created by vic_wei on 2017/3/13.
//  Copyright © 2017年 com.sjyt. All rights reserved.
//

#import "AFHTTPRequestSerializer+SKHttpHeaders.h"
//#import "SvUDIDTools.h"
#import "NSObject+MTJSONUtils.h"
#import "NSObject+VVAssociate.h"

@implementation AFHTTPRequestSerializer (HttpHeaders)

+ (void)load {
    NSString *className = NSStringFromClass(self.class);
    NSLog(@"classname %@", className);
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        
        SEL originalSelector = @selector(HTTPRequestHeaders);
        SEL swizzledSelector = @selector(afsk_HTTPRequestHeaders);
        
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

- (NSDictionary *)afsk_HTTPRequestHeaders {
    
    NSMutableDictionary *result_header = [[self afsk_HTTPRequestHeaders] mutableCopy];
    
    if (!result_header)
        result_header = [NSMutableDictionary new];
    
//    NSString *cusInfo = [SKWidget_shareInstance skheader_cusInfoWithRequestUrlStr:self.sk_action.href];
//
//    result_header[@"Cus-Info"] = cusInfo;
    
    return result_header;
}

static void *bs_action_key = &bs_action_key;
- (void)setSk_action:(BSAction *)sk_action
{
    objc_setAssociatedObject(self, &bs_action_key, sk_action, OBJC_ASSOCIATION_RETAIN);
}

- (BSAction *)sk_action
{
    return objc_getAssociatedObject(self, &bs_action_key);
}

- (void)dealloc
{
    
}

@end
