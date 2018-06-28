//
//  UIImage+ECCrop.h
//  Education
//
//  Created by Leo Song on 15/3/9.
//  Copyright (c) 2015年 Leo Song. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (ECCrop)

- (UIImage *)sizeToFitRectSize:(CGSize )imageSize;
- (UIImage *)sizeToFitLimitValue:(CGFloat )value scale:(CGFloat)scale;
+ (UIImage *)assetGetThumImage:(CGFloat)second movieUrl:(NSURL *)videoURL;
@end
