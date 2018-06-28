//
//  TableViewCell.h
//  BaoSheng
//
//  Created by GML on 2018/4/22.
//  Copyright © 2018年 haozheng. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BSInformationListDto.h"

@interface TableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *imageView_;
@property (weak, nonatomic) IBOutlet UILabel *titlelb_;
@property (weak, nonatomic) IBOutlet UILabel *deslb_;
@property (weak, nonatomic) IBOutlet UILabel *timelb_;


- (void)configCellWithDto:(InfoListDto *)infoDto;

@end
