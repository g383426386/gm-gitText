//
//  UIImage+SKGifData.m
//  marketplateform
//
//  Created by vic_wei on 2017/8/1.
//  Copyright © 2017年 com.sjyt. All rights reserved.
//

#import "UIImage+SKGifData.h"
#import "NSObject+VVAssociate.h"

@implementation UIImage (SKGifData)

- (void)setSk_gifData:(NSData *)sk_gifData
{
    [self vv_associateValue:sk_gifData forKey:@"sk_gifData" associationPolicy:OBJC_ASSOCIATION_RETAIN_NONATOMIC];
}

- (NSData *)sk_gifData
{
    return [self vv_associateValueForKey:@"sk_gifData"];
}

@end
