//
//  BSGlobalButton.m
//  BaoSheng
//
//  Created by GML on 2018/4/23.
//  Copyright © 2018年 haozheng. All rights reserved.
//

#import "BSGlobalButton.h"

@interface BSGlobalButton()

@property (nonatomic , assign)GlobalButtonStyle style;
@end

@implementation BSGlobalButton

+ (BSGlobalButton *)buttonWithTitle:(NSString *)title size:(CGSize)size globalStyle:(GlobalButtonStyle)style{
    
    BSGlobalButton *button = [self buttonWithButtonSize:size coner:size.height/2 title:title titleFont:18 backgroundColor:kappButtonBackgroundColor globalButtonStyle:GlobalButtonStyle_Conerhaf];
    return button;
}


+ (BSGlobalButton *)buttonWithButtonSize:(CGSize)size
                                   coner:(CGFloat)coner
                                   title:(NSString *)title
                               titleFont:(CGFloat)font
                         backgroundColor:(UIColor *)backgroundColor
                       globalButtonStyle:(GlobalButtonStyle)style{
    
    BSGlobalButton *button = [BSGlobalButton buttonWithType:UIButtonTypeCustom];
    [button setTitle:title forState:UIControlStateNormal];
    button.titleLabel.font = FONTSize(font);
    button.size = size;
    button.layer.cornerRadius = coner;
    button.style = style;
    button.backgroundColor = backgroundColor;
    
    if (style == GlobalButtonStyle_Conerhaf) {
        [button setTitleColor:kWhiteColor forState:UIControlStateNormal];
        button.layer.cornerRadius = size.height/2;
        button.layer.masksToBounds = YES;
        
    }else if (style == GlobalButtonStyle_Empty_RedLayer){
        [button setTitleColor:kappButtonBackgroundColor forState:UIControlStateNormal];
       
        button.backgroundColor = [UIColor clearColor];
        button.layer.borderWidth = 1.f;
        button.layer.borderColor = kappButtonBackgroundColor.CGColor;
        button.layer.cornerRadius = size.height/2;
        button.layer.masksToBounds = YES;
    }else if (style == GlobalButtonStyle_RedBK){
        [button setTitleColor:kWhiteColor forState:UIControlStateNormal];
        
    }
    
    return button;
}
- (void)setHighlighted:(BOOL)highlighted{
    if (highlighted) {
        switch (self.style) {
            case GlobalButtonStyle_Conerhaf:
                self.backgroundColor = RGB(250, 0, 0);
                break;
            case GlobalButtonStyle_Empty_RedLayer:
                self.backgroundColor = RGB(220, 0, 0);
                 [self setTitleColor:kWhiteColor forState:UIControlStateNormal];
                break;
            case GlobalButtonStyle_RedBK:
                self.backgroundColor = RGB(220, 0, 0);
                break;
          
            default:
                break;
        }
    }else{
        switch (self.style) {
            case GlobalButtonStyle_Conerhaf:
                self.backgroundColor = kappButtonBackgroundColor;
                break;
            case GlobalButtonStyle_Empty_RedLayer:
                self.backgroundColor = [UIColor clearColor];
                [self setTitleColor:kappButtonBackgroundColor forState:UIControlStateNormal];
                break;
            case GlobalButtonStyle_RedBK:
                self.backgroundColor = kappButtonBackgroundColor;
                break;
            default:
                break;
        }
    }
    
}
@end
