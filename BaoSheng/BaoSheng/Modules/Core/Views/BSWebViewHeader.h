//
//  BSWebViewHeader.h
//  BaoSheng
//
//  Created by GML on 2018/4/27.
//  Copyright © 2018年 haozheng. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BSWebViewHeader : UIView

@property (weak, nonatomic) IBOutlet UILabel *titlelb_;
@property (weak, nonatomic) IBOutlet UILabel *partymenberlb_;
@property (weak, nonatomic) IBOutlet UILabel *leftTimelb_;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *leftTimeConstraint_;
@property (weak, nonatomic) IBOutlet UILabel *ringtTimelb_;

@end
