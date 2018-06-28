//
//  BSConversationLIstControl.m
//  BaoSheng
//
//  Created by GML on 2018/5/3.
//  Copyright © 2018年 haozheng. All rights reserved.
//

#import "BSConversationLIstControl.h"

@interface BSConversationLIstControl ()

@end

@implementation BSConversationLIstControl

- (instancetype)init
{
    self = [super init];
    if (self) {
        if (ConnectionStatus_Unconnected == [[RCIM sharedRCIM]getConnectionStatus]) {
            
        }
    }
    return self;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setDisplayConversationTypes:@[@(ConversationType_PRIVATE),
                                        @(ConversationType_DISCUSSION),
                                        @(ConversationType_CHATROOM),
                                        @(ConversationType_GROUP),
                                        @(ConversationType_APPSERVICE),
                                        @(ConversationType_SYSTEM)]];
    
    
}



@end
