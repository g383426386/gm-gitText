//
//  MessageCell.h
//  BaoSheng
//
//  Created by GML on 2018/4/26.
//  Copyright © 2018年 haozheng. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BSMessageDto.h"

@interface MessageCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *titlelb_;
@property (weak, nonatomic) IBOutlet UILabel *deslb_;
@property (weak, nonatomic) IBOutlet UILabel *partyMenberlb_;
@property (weak, nonatomic) IBOutlet UILabel *timelb_;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *timelbConstraint_;
@property (weak, nonatomic) IBOutlet UIButton *checkDetailBtn_;

@property (nonatomic , copy)void (^checkBtnBlock)(NSInteger index);

- (void)configCellWithDto:(BSMessageDto *)dto;

@end
