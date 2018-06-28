//
//  SKImagePickerManager.h
//  marketplateform
//
//  Created by Gamma.L on 17/5/16.
//  Copyright © 2017年 com.sjyt. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "TZImagePickerController.h"

@class SKImagePickerManager;

@protocol SKImagePickerManagerDelegate <NSObject>

- (void)skImagePickerDidFinishChoseImages:(NSMutableArray *)images;

@end


@interface SKImagePickerManager : NSObject

@property (nonatomic,weak)UIViewController *parentVC;

/** 所能容纳最大图片数量 最大 9 */
@property (nonatomic, assign) NSInteger maxPhotoNumber;

/**已选中的图片资源数组 */
@property (nonatomic,strong) NSMutableArray *selectedAssets;

@property (nonatomic,weak)id<SKImagePickerManagerDelegate>managerDelegate;;


//检测相册权限
- (BOOL)checkSystemPhotoStatus;
//检测相机权限
- (BOOL)checkSystemCamerStatus;

/**
 *  调用系统(裁剪后照片)用于更换头像
 *
 *  @param delegate delegate
 *
 *  @return SKImagePickerManager
 */
- (instancetype)initWithManagerDelegate:(id<SKImagePickerManagerDelegate>)delegate;

//调用系统相机(共用)
- (void)showCameraPicker;

//调用系统相册
- (void)showSystemPicker;
//****************************************
/**
 *  调用DnImagePicker
 *
 *  @param maxNum   最大选择照片数
 *  @param delegate delegate
 *
 *  @return SKImagePickerManager
 */
- (instancetype)initWithMaxPhotNum:(NSInteger)maxNum managerdelegate:(id<SKImagePickerManagerDelegate>)delegate;


//调用TZI相册
- (void)showDnImagePicker;

/**
 *  配置Tzi
 *
 *  @param animation    yes/no
 *  @param gif          允许选择GIF
 *  @param video        允许选择视频
 *  @param mutiPleVideo 允许多选 GIF/VIDEO
 */
- (void)createImagePicker:(BOOL)animation allowPickingGif:(BOOL)gif
        allowPickingVideo:(BOOL)video
allowPickingMultipleVideo:(BOOL)mutiPleVideo;

@end
