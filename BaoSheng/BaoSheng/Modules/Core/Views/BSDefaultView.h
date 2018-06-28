//
//  BSDefaultView.h
//  BaoSheng
//
//  Created by GML on 2018/5/2.
//  Copyright © 2018年 haozheng. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum : NSUInteger {
    DefaultView_Style_None,
    DefaultView_Style_Pic_Btn,
} DefaultView_Style;

typedef void(^BtnBlock)(void);

@interface BSDefaultView : UIView

@property (nonatomic , strong)UIImageView *ImageView;
@property (nonatomic , strong)UILabel *deslb;
@property (nonatomic , strong)BSGlobalButton *defaultBtn;

- (instancetype)initWithImage:(UIImage *)image Des:(NSString *)Des BtnTitle:(NSString *)btnTitle BtnClick:(BtnBlock)BtnClick orginframe:(CGRect)frame;

@end
