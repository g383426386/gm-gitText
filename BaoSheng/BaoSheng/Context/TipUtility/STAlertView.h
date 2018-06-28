//
//  STAlertView.h
//  STS_Master
//
//  Created by GML on 2017/10/24.
//  Copyright © 2017年 Jiujian. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum : NSUInteger {
    AlertVIewStyle_Nomarl,
    AlertVIewStyle_Single,
    AlertVIewStyle_TextInput,
} AlertVIewStyle;

@interface STAlertView : UIView

@property (nonatomic , strong)UILabel *deslb;

@property (nonatomic , copy)void(^alertBtnClickBlock)(BOOL yesOrNo,UIButton *Btn);


- (instancetype)initWithNomalstyleByDes:(NSString *)des;


- (instancetype)initWithDes:(NSString *)des title:(NSString *)title style:(AlertVIewStyle)style
                     btnArr:(NSArray <NSString *>*)BtnArr
                  bodyColor:(UIColor *)bodyColor;

- (void)alertRsponse:(void(^)(BOOL yesOrNO,UIButton *Btn))responseBlock;

//*************
- (instancetype)initWithTextInputTitle:(NSString *)title des:(NSString *)des keybroadtype:(UIKeyboardType)keybroad sureBtnClick:(void(^)(NSString *text))sureBtnblock cancelBtnClik:(void(^)(void))cancelBlock;

- (void)showAlert;




@end
