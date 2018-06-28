//
//  STSCustomCell.h
//  STS_Master
//
//  Created by GML on 2017/9/26.
//  Copyright © 2017年 Jiujian. All rights reserved.
//

#import <UIKit/UIKit.h>




@class STSCustomCell;
@protocol CustomcellDelegate <NSObject>

- (void)customCell:(STSCustomCell *)cell didClickAtIndex:(NSInteger)index;

@end


@interface STSCustomCell : UIView

@property (nonatomic , strong)UILabel *titlelb;
@property (nonatomic , strong)UITextField *deslb;
@property (nonatomic , strong)UIImageView *arrowdImg;



@property (nonatomic , assign)NSInteger index;

@property (nonatomic , weak)id<CustomcellDelegate> delegate;

- (instancetype)initWithFrame:(CGRect)frame
                        index:(NSInteger)index
                     delegate:(id<CustomcellDelegate>)delegate;


- (void)changeSubViews;


@end
