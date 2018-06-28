//
//  BSHomeTableHeader.h
//  BaoSheng
//
//  Created by GML on 2018/4/22.
//  Copyright © 2018年 haozheng. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <SDCycleScrollView/SDCycleScrollView.h>
#import "HomeItem.h"


@interface BSHomeTableHeader : UIView

@property (nonatomic , strong)SDCycleScrollView *cycleScrolView;
@property (nonatomic , copy)void (^moreBtnClickBlock)(void);
@property (nonatomic , copy)void (^itemClickAtIndex)(NSInteger index);

@end
