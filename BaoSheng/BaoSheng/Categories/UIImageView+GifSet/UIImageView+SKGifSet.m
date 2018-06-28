//
//  UIImageView+SKGifSet.m
//  marketplateform
//
//  Created by vic_wei on 2017/8/1.
//  Copyright © 2017年 com.sjyt. All rights reserved.
//

#import "UIImageView+SKGifSet.h"

#import "AnimatedGIFImageSerialization.h"

#import "UIImage+GIF.h"
#import "Masonry.h"


@implementation UIImageView (SKGifSet)

+ (void)load
{
    NSString *className = NSStringFromClass(self.class);
    NSLog(@"classname %@", className);
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        
        { // aspect swizzling aop : setImage
            SEL originalSelector = @selector(setImage:);
            SEL swizzledSelector = @selector(skgs_setImage:);
            
            // When swizzling a class method, use the following:
            // Class class = object_getClass((id)self);
            // Method originalMethod = class_getClassMethod(class, originalSelector);
            // Method swizzledMethod = class_getClassMethod(class, swizzledSelector);
            
            Class class = [self class];
            Method originalMethod = class_getInstanceMethod(class, originalSelector);
            Method swizzledMethod = class_getInstanceMethod(class, swizzledSelector);
            
            BOOL didAddMethod =
            class_addMethod(class,
                            originalSelector,
                            method_getImplementation(swizzledMethod),
                            method_getTypeEncoding(swizzledMethod));
            
            if (didAddMethod) {
                class_replaceMethod(class,
                                    swizzledSelector,
                                    method_getImplementation(originalMethod),
                                    method_getTypeEncoding(originalMethod));
            } else {
                method_exchangeImplementations(originalMethod, swizzledMethod);
            }
        }
        
        { // aspect swizzling aop : sd_setImageWithURL
            SEL originalSelector = @selector(sd_setImageWithURL:placeholderImage:options:progress:completed:);
            SEL swizzledSelector = @selector(skgs_setImageWithURL:placeholderImage:options:progress:completed:);
            
            // When swizzling a class method, use the following:
            // Class class = object_getClass((id)self);
            // Method originalMethod = class_getClassMethod(class, originalSelector);
            // Method swizzledMethod = class_getClassMethod(class, swizzledSelector);
            
            Class class = [self class];
            Method originalMethod = class_getInstanceMethod(class, originalSelector);
            Method swizzledMethod = class_getInstanceMethod(class, swizzledSelector);
            
            BOOL didAddMethod =
            class_addMethod(class,
                            originalSelector,
                            method_getImplementation(swizzledMethod),
                            method_getTypeEncoding(swizzledMethod));
            
            if (didAddMethod) {
                class_replaceMethod(class,
                                    swizzledSelector,
                                    method_getImplementation(originalMethod),
                                    method_getTypeEncoding(originalMethod));
            } else {
                method_exchangeImplementations(originalMethod, swizzledMethod);
            }
        }
        
    });
}

- (void)skgs_setImage:(UIImage *)image{
    
    if (image.images > 0) {
        UIImage *firstImage = image.images[0];
        [self skgs_setImage:firstImage]; // 先根据 第一帧渲染一次, 避免手势返回时，动图会消失
        [self skgs_setImage:image]; // 再通过gif 渲染动图
    }else{
        [self skgs_setImage:image];
    }
}

- (void)skgs_setImageWithURL:(NSURL *)url placeholderImage:(UIImage *)placeholder options:(SDWebImageOptions)options progress:(SDWebImageDownloaderProgressBlock)progressBlock completed:(SDWebImageCompletionBlock)completedBlock
{
    
    if ([url.pathExtension.lowercaseString isEqualToString:@"gif"] && [url.absoluteString containsString:@"?x-oss-process=image"]) { // 外部 gif静态小图
        [self sk_setGifTag:YES];
    }else{
        [self sk_setGifTag:NO];
        if ([url.pathExtension.lowercaseString isEqualToString:@"gif"] && ![url.absoluteString containsString:@"?x-oss-process=image"]) { // 查看 gif 原图时
            url = [NSURL URLWithString:url.absoluteString];
        }
    }
    
    [self skgs_setImageWithURL:url placeholderImage:placeholder options:options progress:progressBlock completed:completedBlock];
    
}

- (void)sk_setGifTag:(BOOL)isGif
{
    
    NSInteger tag = 90900 + 1;
    UILabel *lab = [self viewWithTag:tag];
    
    if (isGif) {
        
        if (!lab) {
            lab = [[UILabel alloc] init];
            lab.tag = tag;
            lab.backgroundColor = [UIColor colorWithRed:0.133 green:0.133 blue:0.192 alpha:1.000];
            lab.textColor = [UIColor whiteColor];
            lab.font = [UIFont systemFontOfSize:9.f];
            lab.textAlignment = NSTextAlignmentCenter;
            lab.text = @"GIF";
            
            [self addSubview:lab];
            WeakSelf
            [lab mas_updateConstraints:^(MASConstraintMaker *make) {
                StrongSelf
                make.top.equalTo(self.mas_top);
                make.right.equalTo(self.mas_right);
                make.width.offset(19.f);
                make.height.offset(13.f);
            }];
        }
        
        lab.hidden = NO;
        
    }else{
        lab.hidden = YES;
    }
    
}


@end


@interface UIImage ()
+ (float)sd_frameDurationAtIndex:(NSUInteger)index source:(CGImageSourceRef)source;
@end

@implementation UIImage (SKGifSet)

+ (BOOL)sk_isGIF:(ALAsset *)asset
{
    ALAssetRepresentation *re = [asset representationForUTI: (__bridge NSString *)kUTTypeGIF];
    if (re) {
        return YES;
    }
    return NO;
}

+ (NSData *)sk_gifData:(ALAsset *)asset
{
    ALAssetRepresentation *re = [asset representationForUTI:(__bridge NSString *)kUTTypeGIF];;
    long long size = re.size;
    uint8_t *buffer = malloc(size);
    NSError *error;
    NSUInteger bytes = [re getBytes:buffer fromOffset:0 length:size error:&error];
    NSData *data = [NSData dataWithBytes:buffer length:bytes];
    free(buffer);
    return data;
}

- (NSData *)sk_gifTranslateToData
{
    return [AnimatedGIFImageSerialization animatedGIFDataWithImage:self error:NULL];
}

+ (UIImage *)sk_animatedGIFWithData:(NSData *)data {
    if (!data) {
        return nil;
    }
    
    CGImageSourceRef source = CGImageSourceCreateWithData((__bridge CFDataRef)data, NULL);
    
    size_t count = CGImageSourceGetCount(source);
    
    UIImage *animatedImage;
    
    if (count <= 1) {
        animatedImage = [[UIImage alloc] initWithData:data];
    }
    else {
        NSMutableArray *images = [NSMutableArray array];
        
        NSTimeInterval duration = 0.0f;
        
        for (size_t i = 0; i < count; i++) {
            CGImageRef image = CGImageSourceCreateImageAtIndex(source, i, NULL);
            if (!image) {
                continue;
            }
            
            duration += [self sd_frameDurationAtIndex:i source:source];
            
            
            UIImage *imageFrame = [UIImage imageWithCGImage:image scale:[UIScreen mainScreen].scale orientation:UIImageOrientationUp];
            
//            @autoreleasepool { // 读取的时候 就压缩每一帧的图片大小
//                NSData *dataFrame = [self imageData:imageFrame];
//                imageFrame = [UIImage imageWithData:dataFrame];
//                dataFrame = nil;
//            }
            
            [images addObject:imageFrame];
            
            CGImageRelease(image);
        }
        
        if (!duration) {
            duration = (1.0f / 10.0f) * count;
        }
        
        animatedImage = [UIImage animatedImageWithImages:images duration:duration];
    }
    
    CFRelease(source);
    
//    CGFloat scale = animatedImage.size.width/(414.f * 1);
//    CGFloat scale = 2;
//    if (scale > 1) {
//        CGSize newSize = CGSizeMake(animatedImage.size.width/scale, animatedImage.size.height/scale);
//        animatedImage = [animatedImage sd_animatedImageByScalingAndCroppingToSize:newSize];
//    }
    
    return animatedImage;
}

+ (NSData *)imageData:(UIImage *)image
{
    UIImage *newImage = [self cropImage:image];
    NSData *data = UIImageJPEGRepresentation(newImage, 1.f);
    if (data.length > 100 * 1024) { // 0.1 M 以上
        if (data.length > 512 * 1024) { // 500kb 以及以上
            data = UIImageJPEGRepresentation(newImage, 0.1);
        }else if (data.length > 200 * 1024) {
            data = UIImageJPEGRepresentation(newImage, 0.1);
        }else if (data.length > 100 * 1024) {
            data = UIImageJPEGRepresentation(newImage, 0.1);
        }
    }
    
    return data;
}

+ (UIImage *)cropImage:(UIImage *)image
{
    CGFloat scale              = [UIScreen mainScreen].scale;
    scale = image.size.width/(414.f * 2);
    if (scale > 1) {
        CGSize newSize = CGSizeMake(image.size.width/scale, image.size.height/scale);
        UIGraphicsBeginImageContext(newSize);
        [image drawInRect:CGRectMake(0,0,newSize.width,newSize.height)];
        image = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
    }
    return image;
}

/**

// 保存到相册
- (void)saveGifData:(NSData *)data toGroup:(ALAssetsGroup *)group inLibrary:(ALAssetsLibrary *)library
{
    NSDictionary *metadata = @{@"UTI":(__bridge NSString *)kUTTypeGIF};
    // 开始写数据
    [library writeImageDataToSavedPhotosAlbum:data metadata:metadata completionBlock:^(NSURL *assetURL, NSError *error) {
        
        if (error) {
            NSLog(@"写数据失败：%@",error);
        }else{
            
            [library assetForURL:assetURL resultBlock:^(ALAsset *asset) {
                
                NSLog(@"成功保存到相册");
                
                if ([group isEditable]) {
                    [group addAsset:asset];
                }else{
                    NSLog(@"系统gif相册不可编辑或者为nil");
                }
                
            } failureBlock:^(NSError *error) {
                NSLog(@"gif保存到的ALAsset有问题, URL：%@，err:%@",assetURL,error);
            }];
        }
    }];
}


+ (NSData *)zipGIFWithData:(NSData *)data {
    
    if (!data) {
        return nil;
    }
    CGImageSourceRef source = CGImageSourceCreateWithData((__bridge CFDataRef)data, NULL);
    size_t count = CGImageSourceGetCount(source);
    UIImage *animatedImage = nil;
    NSMutableArray *images = [NSMutableArray array];
    NSTimeInterval duration = 0.0f;
    for (size_t i = 0; i < count; i++) {
        CGImageRef image = CGImageSourceCreateImageAtIndex(source, i, NULL);
        duration += [self sd_frameDurationAtIndex:i source:source];
        UIImage *ima = [UIImage imageWithCGImage:image scale:[UIScreen mainScreen].scale orientation:UIImageOrientationUp];
        ima = [ima sk_zip];
        [images addObject:ima];
        CGImageRelease(image);
        if (!duration) {
            duration = (1.0f / 10.0f) * count;
        }
        animatedImage = [UIImage animatedImageWithImages:images duration:duration];
    }
    CFRelease(source);
    return UIImagePNGRepresentation(animatedImage);
    
}

- (UIImage *)sk_compressToByte:(NSUInteger)maxLength {
    // Compress by quality
    CGFloat compression = 1;
    NSData *data = UIImageJPEGRepresentation(self, compression);
    if (data.length < maxLength) return self;
    
    CGFloat max = 1;
    CGFloat min = 0;
    for (int i = 0; i < 6; ++i) {
        compression = (max + min) / 2;
        data = UIImageJPEGRepresentation(self, compression);
        if (data.length < maxLength * 0.9) {
            min = compression;
        } else if (data.length > maxLength) {
            max = compression;
        } else {
            break;
        }
    }
    UIImage *resultImage = [UIImage imageWithData:data];
    if (data.length < maxLength) return resultImage;
    
    // Compress by size
    NSUInteger lastDataLength = 0;
    while (data.length > maxLength && data.length != lastDataLength) {
        lastDataLength = data.length;
        
        CGSize size = CGSizeMake(200, 200);
        UIGraphicsBeginImageContext(size);
        [resultImage drawInRect:CGRectMake(0, 0, size.width, size.height)];
        resultImage = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        data = UIImageJPEGRepresentation(resultImage, compression);
    }
    resultImage = [UIImage imageWithData:data];
    return resultImage;
}

- (UIImage *)sk_zip{
    UIImage *image = [self sk_compressToByte:2*1024*1024];
    return  [image sk_zipSize];
}

- (UIImage *)sk_zipSize{
    if (self.size.width < 200) {
        return self;
    }
    CGSize size = CGSizeMake(200, 200);
    UIGraphicsBeginImageContext(size);
    [self drawInRect:CGRectMake(0, 0, size.width, size.height)];
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return  image;
}
*/

@end
