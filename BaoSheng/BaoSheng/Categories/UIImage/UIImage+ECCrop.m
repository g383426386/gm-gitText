//
//  UIImage+ECCrop.m
//  Education
//
//  Created by Leo Song on 15/3/9.
//  Copyright (c) 2015年 Leo Song. All rights reserved.
//

#import "UIImage+ECCrop.h"

@implementation UIImage (ECCrop)

- (UIImage *)sizeToFitRectSize:(CGSize )imageSize{
    __autoreleasing UIImage *originalImage = self;
    NSLog(@"%@",NSStringFromCGSize(originalImage.size));
    if (originalImage.size.width > imageSize.width || originalImage.size.height > imageSize.height) {
        float wScale = originalImage.size.width/imageSize.width;
        float hScale = originalImage.size.height/imageSize.height;
        
        CGRect imageFrame;
        if (wScale > hScale)
            imageFrame = CGRectMake(0, 0, imageSize.width, originalImage.size.height/wScale);
        else
            imageFrame = CGRectMake(0, 0, originalImage.size.width/hScale, imageSize.height);
        
        CGSize itemSize = imageFrame.size;
        UIGraphicsBeginImageContextWithOptions(itemSize,1.0,1.0);
        CGContextRef ctx = UIGraphicsGetCurrentContext();
        CGContextSetRGBFillColor(ctx,0, 0, 0, 1.0);
        [originalImage drawInRect:imageFrame];
        originalImage = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
    }
    return originalImage;
}

//- (UIImage *)sizeToFitLimitValue:(CGFloat )value scale:(CGFloat)scale {
//    __autoreleasing UIImage *originalImage = self;
//    CGFloat imageScale = originalImage.size.width / originalImage.size.height;
//    if ((imageScale < 1.00 / scale || imageScale > scale)) {
//        CGRect imageFrame = CGRectZero;
//        if (originalImage.size.width < originalImage.size.height && originalImage.size.width > value) {
//            imageFrame = CGRectMake(0, 0, value, value/imageScale);
//        }else if (originalImage.size.width > originalImage.size.height && originalImage.size.height > value) {
//            imageFrame = CGRectMake(0, 0, value * imageScale, value);
//        }
//        
//        if (!CGRectEqualToRect(imageFrame, CGRectZero)) {
//            CGSize itemSize = imageFrame.size;
//            UIGraphicsBeginImageContextWithOptions(itemSize,1.0,1.0);
//            CGContextRef ctx = UIGraphicsGetCurrentContext();
//            CGContextSetRGBFillColor(ctx,0, 0, 0, 1.0);
//            [originalImage drawInRect:imageFrame];
//            originalImage = UIGraphicsGetImageFromCurrentImageContext();
//            UIGraphicsEndImageContext();
//        }
//    }
//    
//    return originalImage;
//}


/* 压缩规则
 a，图片宽或者高均小于或等于1280时图片尺寸保持不变，但仍然经过图片压缩处理，得到小文件的同尺寸图片
 b，宽或者高大于1280，但是图片宽度高度比小于或等于2，则将图片宽或者高取大的等比压缩至1280
 c，宽或者高大于1280，但是图片宽高比大于2时，并且宽以及高均大于1280，则宽或者高取小的等比压缩至1280
 d，宽或者高大于1280，但是图片宽高比大于2时，并且宽或者高其中一个小于1280，则压缩至同尺寸的小文件图片
 */
- (UIImage *)sizeToFitLimitValue:(CGFloat )value scale:(CGFloat)scale {
    __autoreleasing UIImage *originalImage = self;
    CGFloat imageWidth = originalImage.size.width;
    CGFloat imageHeight = originalImage.size.height;
    CGFloat imageScale = imageWidth / imageHeight;
    if (imageWidth <= value && imageHeight <= value) {
        //a
        return originalImage;
    }else {
        CGRect imageFrame = CGRectZero;
        if (imageScale <= scale && imageScale >= 1.0 / scale) {
            //b
            if (imageWidth > imageHeight) {
                imageFrame = CGRectMake(0, 0, value, value/imageScale);
            }else {
                imageFrame = CGRectMake(0, 0, value * imageScale, value);
            }
        }
        
        if ((imageScale >= scale || imageScale <= 1.0 / scale) && imageWidth > value && imageHeight > value) {
            //c
            if (imageWidth > imageHeight) {
                imageFrame = CGRectMake(0, 0, value * imageScale, value);
            }else {
                imageFrame = CGRectMake(0, 0, value, value/imageScale);
            }
        }
        
        if ((imageScale >= scale || imageScale <= 1.0 / scale) && (imageWidth < value || imageHeight < value)) {
            //d
            return originalImage;
        }
        
        if (!CGRectEqualToRect(imageFrame, CGRectZero)) {
            CGSize itemSize = imageFrame.size;
            UIGraphicsBeginImageContextWithOptions(itemSize,1.0,1.0);
            CGContextRef ctx = UIGraphicsGetCurrentContext();
            CGContextSetRGBFillColor(ctx,0, 0, 0, 1.0);
            [originalImage drawInRect:imageFrame];
            originalImage = UIGraphicsGetImageFromCurrentImageContext();
            UIGraphicsEndImageContext();
        }
    }
    return originalImage;
    
}

+ (UIImage *)assetGetThumImage:(CGFloat)second movieUrl:(NSURL *)videoURL {
//    AVURLAsset *urlSet = [AVURLAsset assetWithURL:videoURL];
//    AVAssetImageGenerator *imageGenerator = [AVAssetImageGenerator assetImageGeneratorWithAsset:urlSet];
//    NSError *error = nil;
//    CMTime time = CMTimeMake(second,1);
//    CMTime actucalTime; //缩略图实际生成的时间
//    CGImageRef cgImage = [imageGenerator copyCGImageAtTime:time actualTime:&actucalTime error:&error];
//    if (error) {
//        NSLog(@"截取视频图片失败:%@",error.localizedDescription);
//        return nil;
//    }
//    CMTimeShow(actucalTime);
//    UIImage *image = [UIImage imageWithCGImage:cgImage];
//    CGImageRelease(cgImage);
//    NSLog(@"视频截取成功");
    return nil;
}

@end
