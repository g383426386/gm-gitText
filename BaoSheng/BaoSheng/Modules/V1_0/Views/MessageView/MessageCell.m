//
//  MessageCell.m
//  BaoSheng
//
//  Created by GML on 2018/4/26.
//  Copyright © 2018年 haozheng. All rights reserved.
//

#import "MessageCell.h"

@implementation MessageCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.backgroundColor = kappBackgroundColor;
    [self.checkDetailBtn_ addTarget:self action:@selector(checkDetailBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    
}

- (void)configCellWithDto:(BSMessageDto *)dto{
    
    self.titlelb_.text = dto.title;
    self.deslb_.text = dto.synopsis;
    self.timelb_.text = [GmWidget dateFromTimeInterval:[dto.publishTime doubleValue]];
    if (dto.informFor == 1) {
        self.partyMenberlb_.hidden = NO;
        
    }else{
         self.partyMenberlb_.hidden = YES;
        self.timelbConstraint_.constant = - 30;
    }
}
- (void)checkDetailBtnClick:(UIButton *)sender{
    
    if (self.checkBtnBlock) {
        self.checkBtnBlock(sender.tag);
    }
    
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
