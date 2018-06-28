//
//  LoginControl.h
//  BaoSheng
//
//  Created by GML on 2018/4/23.
//  Copyright © 2018年 haozheng. All rights reserved.
//

#import "BSBaseControl.h"

typedef enum : NSUInteger {
    LoginVc_Style_Login = 0,
    LoginVc_Style_Regis,
    LoginVc_Style_ForgetPW,//忘记密码
} LoginVc_Style;

typedef enum : NSUInteger {
    TextField_EM_Phone = 100,
    TextField_EM_PassW,
    TextField_EM_CheckNum,
} TextField_EM;

@interface LoginControl : BSBaseControl

@property (nonatomic , assign)LoginVc_Style loginStle;

@end
