//
//  TZImageManager+SKSyncGetImageData.h
//  marketplateform
//
//  Created by vic_wei on 2017/8/24.
//  Copyright © 2017年 com.sjyt. All rights reserved.
//

#import "TZImageManager.h"

@interface TZImageManager (SKSyncGetImageData)

- (void)syncGetOriginalPhotoDataWithAsset:(id)asset completion:(void (^)(NSData *data,NSDictionary *info,BOOL isDegraded))completion;

@end
