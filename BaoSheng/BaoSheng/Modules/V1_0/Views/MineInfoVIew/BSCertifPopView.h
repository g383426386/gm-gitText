//
//  BSCertifPopView.h
//  BaoSheng
//
//  Created by GML on 2018/4/25.
//  Copyright © 2018年 haozheng. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum : NSUInteger {
    CertifPop_style_Suc,
    CertifPop_style_Fail,
} CertifPop_style;

@interface BSCertifPopView : UIView

- (instancetype)initWithStyle:(CertifPop_style)Style;

- (void)show;

@end
