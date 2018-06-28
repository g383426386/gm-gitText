//
//  RootTabarControl.h
//  BaoSheng
//
//  Created by GML on 2018/4/18.
//  Copyright © 2018年 haozheng. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BSRootNavigationController.h"
#import "HomeControl.h"
#import "MessageControl.h"
#import "MineInfoControl.h"
#import "BSConversationLIstControl.h"


@interface RootTabarControl : UITabBarController

@property (nonatomic,strong)HomeControl *homeControl;
@property (nonatomic,strong)MessageControl  *messageControl;
@property (nonatomic,strong)MineInfoControl *mineInfoControl;
@property (nonatomic , strong)BSConversationLIstControl *ConversationControl;

@property (nonatomic,strong)BSRootNavigationController *nc1;
@property (nonatomic,strong)BSRootNavigationController *nc2;
@property (nonatomic,strong)BSRootNavigationController *nc3;
@property (nonatomic , strong)BSRootNavigationController *nc4;

@property (nonatomic , assign)BOOL openConverSation;

- (instancetype)initWithOpenConversation:(BOOL)OpenConversation;

@end
