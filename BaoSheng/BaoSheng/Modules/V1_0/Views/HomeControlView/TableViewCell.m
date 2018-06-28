//
//  TableViewCell.m
//  BaoSheng
//
//  Created by GML on 2018/4/22.
//  Copyright © 2018年 haozheng. All rights reserved.
//

#import "TableViewCell.h"


@implementation TableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.imageView_.layer.cornerRadius = 5.f;
    self.imageView_.layer.masksToBounds = YES;
}


- (void)configCellWithDto:(InfoListDto *)infoDto{
    
    [self.imageView_ sd_setImageWithURL:[NSURL URLWithString:infoDto.thumbnailUrl] placeholderImage:[UIImage imageNamed:@"zhanwei_zixun"]];
    self.titlelb_.text = infoDto.title;
    self.deslb_.text = infoDto.text;
    self.timelb_.text = [GmWidget dateFromTimeIntervalWithHHmm:[infoDto.createDate doubleValue]];
    
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    self.selectionStyle = UITableViewCellSelectionStyleNone;
    // Configure the view for the selected state
}

@end
