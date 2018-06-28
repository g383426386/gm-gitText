//
//  SYTagItem.h
//  SY_Doctor
//
//  Created by vic_wei on 16/1/26.
//  Copyright © 2016年 SY. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SYTagItem : UICollectionViewCell

@property (nonatomic , assign) UIEdgeInsets titleInset;

@property (strong, nonatomic) IBOutlet UILabel *defaultTitleLab_;
@property (weak, nonatomic) IBOutlet UIButton *defaultBtn_;

@end
