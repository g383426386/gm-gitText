//
//  AFJSONRequestSerializer+HttpHeaders.h
//  marketplateform
//
//  Created by vic_wei on 2017/3/13.
//  Copyright © 2017年 com.sjyt. All rights reserved.
//

#import "AFURLRequestSerialization.h"
#import "BSWebApiHelper.h"

@interface AFHTTPRequestSerializer (HttpHeaders)

@property (nonatomic , strong) BSAction *sk_action;

@end
