//
//  NSObject+SKRequest.h
//  marketplateform
//
//  Created by vic_wei on 2017/5/5.
//  Copyright © 2017年 com.sjyt. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BSWebApiHelper.h"

@interface NSObject (SKRequest)

- (void)sk_requestWithAction:(BSAction*)action success:(void(^)(BSRes *res))success failure:(void(^)(BSRes *res))failure;

@end
