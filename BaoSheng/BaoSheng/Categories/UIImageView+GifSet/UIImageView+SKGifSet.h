//
//  UIImageView+SKGifSet.h
//  marketplateform
//
//  Created by vic_wei on 2017/8/1.
//  Copyright © 2017年 com.sjyt. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <ImageIO/ImageIO.h>
#import <AssetsLibrary/AssetsLibrary.h>

@interface UIImageView (SKGifSet)
- (void)sk_setGifTag:(BOOL)isGif;
@end


@interface UIImage (SKGifSet)

+ (BOOL)sk_isGIF:(ALAsset*)asset;
+ (NSData *)sk_gifData:(ALAsset*)asset;
+ (UIImage *)sk_animatedGIFWithData:(NSData *)data;

- (NSData*)sk_gifTranslateToData;

@end