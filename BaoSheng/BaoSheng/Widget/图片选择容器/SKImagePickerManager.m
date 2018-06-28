//
//  SKImagePickerManager.m
//  marketplateform
//
//  Created by Gamma.L on 17/5/16.
//  Copyright © 2017年 com.sjyt. All rights reserved.
//

#import "SKImagePickerManager.h"
#import <Photos/Photos.h>
#import<AVFoundation/AVCaptureDevice.h>
#import<AVFoundation/AVMediaFormat.h>

#import <AssetsLibrary/AssetsLibrary.h>
#import "UIImage+ECCrop.h"
//#import "DNImagePickerController.h"//三方Picker
//#import "DNAsset.h"
#import "WQPermissionRequest.h"
#import "TZImageManager.h"
#import "TZImageCropManager.h"
#import "TZImageManager+SKSyncGetImageData.h"
#import "AppDelegate.h"

#import <CoreLocation/CLLocationManager.h>

@interface SKImagePickerManager()<UIImagePickerControllerDelegate,UINavigationControllerDelegate,TZImagePickerControllerDelegate>
{
    UIImagePickerController *_ipc;

    TZImagePickerController *_imagePicker;
}

@property (nonatomic,strong)NSMutableArray *choseImages;



@property (nonatomic, assign) BOOL isOriginalImage;
/** 裁剪*/
@property (nonatomic ,assign) BOOL cropFrameImage;

@end

@implementation SKImagePickerManager

- (instancetype)init
{
    self = [super init];
    if (self) {
        _choseImages =[@[]mutableCopy];
        _isOriginalImage = YES;
        _cropFrameImage = NO;
        _maxPhotoNumber = 1;
        self.parentVC = [self _getParentVC];
    }
    return self;
}

- (instancetype)initWithManagerDelegate:(id<SKImagePickerManagerDelegate>)delegate
{
    self = [super init];
    if (self) {
        _choseImages =[@[]mutableCopy];
        _isOriginalImage = NO;
        _cropFrameImage = YES;
        _maxPhotoNumber = 1;
        self.managerDelegate =delegate;
        self.parentVC = [self _getParentVC];
    }
    return self;
}

- (instancetype)initWithMaxPhotNum:(NSInteger)maxNum managerdelegate:(id<SKImagePickerManagerDelegate>)delegate
{
    self = [super init];
    if (self) {
        _choseImages = [@[]mutableCopy];
        _isOriginalImage = YES;
        _cropFrameImage = NO;
        _maxPhotoNumber = maxNum;
        self.managerDelegate = delegate;
        self.parentVC = [self _getParentVC];
    }
    return self;
}

- (void)dealloc{
    NSLog(@"%@ ---- %s",NSStringFromClass([self class]),__func__);
}
#pragma mark - Check systemStatus
- (BOOL)checkSystemPhotoStatus{

    if ([[[UIDevice currentDevice] systemVersion] floatValue] < 8.0) {
        ALAuthorizationStatus author =[ALAssetsLibrary authorizationStatus];
        if (author == kCLAuthorizationStatusRestricted || author == kCLAuthorizationStatusDenied) {
            //无权限
            return NO;
        }
    }
    else {
        PHAuthorizationStatus status = [PHPhotoLibrary authorizationStatus];
        if (status == PHAuthorizationStatusRestricted ||
            status == PHAuthorizationStatusDenied) {
            //无权限
            return NO;
        }
    }
    return YES;
}

- (BOOL)checkSystemCamerStatus{
    AVAuthorizationStatus authStatus =  [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo];
    if (authStatus == AVAuthorizationStatusRestricted || authStatus ==AVAuthorizationStatusDenied)
    {
        return NO;
    }
    return YES;
}
#pragma mark - 调用相机
//调用系统相机
- (void)showCameraPicker{
    
    if (![[WQPermissionRequest shareWQPermissionRequest]determinePermission:WQCamera]) {
        [[WQPermissionRequest shareWQPermissionRequest]requestPermission:WQCamera title:@"温馨提示" description:@"您还没有开启照相机权限，现在去设置" requestResult:^(BOOL granted, NSError *error) {
            
        }];
        return;
    }

    if (!_ipc) {
       _ipc = [[UIImagePickerController alloc] init];
    }
   
    _ipc.sourceType                = UIImagePickerControllerSourceTypeCamera;
    _ipc.delegate                  = self;
    if (self.cropFrameImage) {
         _ipc.allowsEditing             = YES;
    }else{
         _ipc.allowsEditing             = NO;
    }
    [self.parentVC presentViewController:_ipc animated:YES completion:^{
                    }];
}
//调用系统相册
- (void)showSystemPicker{
    
    if (![[WQPermissionRequest shareWQPermissionRequest]determinePermission:WQPhotoLibrary]) {
        [[WQPermissionRequest shareWQPermissionRequest]requestPermission:WQPhotoLibrary title:@"温馨提示" description:@"您还没有开启相册访问权限，现在去设置" requestResult:^(BOOL granted, NSError *error) {
            
        }];
        return;
    }
    if (!_ipc) {
        _ipc = [[UIImagePickerController alloc] init];
    }
    
    _ipc.sourceType     = UIImagePickerControllerSourceTypePhotoLibrary;
    _ipc.delegate                  = self;
    if (self.cropFrameImage) {
        _ipc.allowsEditing             = YES;
    }else{
        _ipc.allowsEditing             = NO;
    }
    
    [self.parentVC presentViewController:_ipc animated:YES completion:^{
    }];
}


//调用DN系统相册
- (void)showDnImagePicker{
         [self showImagePickerAnimation:YES];
}

- (void)showImagePickerAnimation:(BOOL)animation{

    [self.parentVC.view endEditing:YES];
    
    [self createImagePicker:animation allowPickingGif:NO allowPickingVideo:NO allowPickingMultipleVideo:NO];
    
}

- (void)createImagePicker:(BOOL)animation allowPickingGif:(BOOL)gif
        allowPickingVideo:(BOOL)video
allowPickingMultipleVideo:(BOOL)mutiPleVideo
{
    
    
    if (![[WQPermissionRequest shareWQPermissionRequest]determinePermission:WQPhotoLibrary]) {
        [[WQPermissionRequest shareWQPermissionRequest]requestPermission:WQPhotoLibrary title:@"温馨提示" description:@"您还没有开启相册访问权限，现在去设置" requestResult:^(BOOL granted, NSError *error) {
            if (granted == YES) {
                [self createImagePicker:animation allowPickingGif:gif allowPickingVideo:video allowPickingMultipleVideo:mutiPleVideo];
            }
        }];
        return;
    }
    
    _imagePicker = [[TZImagePickerController alloc] initWithMaxImagesCount:_maxPhotoNumber columnNumber:4 delegate:self pushPhotoPickerVc:YES];
    if (self.selectedAssets.count > 1) {
        _imagePicker.selectedAssets = self.selectedAssets;

    }
    
    _imagePicker.allowTakePicture = NO; // 在内部显示拍照按钮
    
    // 3. 设置是否可以选择视频/图片/原图
    _imagePicker.allowPickingVideo = video;
    _imagePicker.allowPickingImage = YES;
    _imagePicker.allowPickingOriginalPhoto = YES;
    _imagePicker.allowPickingGif = gif;
    _imagePicker.allowPickingMultipleVideo = mutiPleVideo; // 是否可以多选视频
    _imagePicker.allowTakePicture = NO;
    
    _imagePicker.allowPreview = NO;
    _imagePicker.allowPickingOriginalPhoto = NO;
    _imagePicker.oKButtonTitleColorNormal = UIColorFromHex(0xe84286);
    _imagePicker.oKButtonTitleColorDisabled = UIColorFromHex(0xe84286);
    
    // 4. 照片排列按修改时间升序
    _imagePicker.sortAscendingByModificationDate = YES;
    
    if (self.parentVC) {
        [self.parentVC presentViewController:_imagePicker animated:animation completion:nil];
    }else{
        [[AppDelegate sharedAppDelegate].navigationViewController pushViewController:_imagePicker animated:YES];
    }
    


}


#pragma mark - imagepicker_delegate
-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    
    UIImage *editImage = nil;
    if (picker.sourceType == UIImagePickerControllerSourceTypeCamera) {
        if (self.cropFrameImage) {
             editImage = [info objectForKey:UIImagePickerControllerEditedImage];
        }else{
            editImage = [info objectForKey:UIImagePickerControllerOriginalImage];
        }
        UIImageWriteToSavedPhotosAlbum(editImage, nil, nil, nil);//图片存入相册
        [_choseImages addObject:editImage];
    }else if (picker.sourceType == UIImagePickerControllerSourceTypePhotoLibrary){
        if (self.cropFrameImage) {
            editImage = [info objectForKey:UIImagePickerControllerEditedImage];
        }else{
            editImage = [info objectForKey:UIImagePickerControllerOriginalImage];
        }
        [_choseImages addObject:editImage];
        
    }else if (_isOriginalImage) {
        editImage = [info objectForKey:UIImagePickerControllerOriginalImage];
        [_choseImages addObject:editImage];
    }else {
        if (_cropFrameImage) {
            editImage = [info objectForKey:UIImagePickerControllerEditedImage];
        }else{
            editImage = [[info objectForKey:UIImagePickerControllerOriginalImage] sizeToFitRectSize:CGSizeMake(2000, 2000)];
        }
        [_choseImages addObject:[UIImage imageWithData:UIImageJPEGRepresentation(editImage, 0.5)] ];
    }
    [self dealImagesChangeAndDelegate];
    
    [picker dismissViewControllerAnimated:YES completion:^{
      
    }];
}

-(void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    [picker dismissViewControllerAnimated:YES completion:nil];
}


#pragma mark - TZImagePickerControllerDelegate
/// 用户点击了取消
- (void)tz_imagePickerControllerDidCancel:(TZImagePickerController *)picker {
    // NSLog(@"cancel");
}

- (void)imagePickerController:(TZImagePickerController *)picker didFinishPickingPhotos:(NSArray *)photos sourceAssets:(NSArray *)assets isSelectOriginalPhoto:(BOOL)isSelectOriginalPhoto {

    
    NSMutableArray *photoMuti = photos.mutableCopy;
    
    if (picker.allowPickingGif != NO) {

        for (int i = 0;i < assets.count ;i++) {
            id asset = assets[i];
            TZAssetModelMediaType type = [[TZImageManager manager]getAssetType:asset];
            if ([asset isKindOfClass:[PHAsset class]]) {
    //            PHAsset *phAsset = asset;
             
                if (type == TZAssetModelMediaTypePhotoGif) {
                    [[TZImageManager manager] syncGetOriginalPhotoDataWithAsset:asset completion:^(NSData *data, NSDictionary *info, BOOL isDegraded) {
                        if (!isDegraded) {
                            
//                            if (photoMuti.count > i) {
//                                UIImage *image = photos[i];
////                                image.sk_gifData = data;
//                            }
                            
//                            UIImage *image = [UIImage sd_tz_animatedGIFWithData:data];
//                            image.sk_gifData = data;
//                            [photoMuti replaceObjectAtIndex:i withObject:image];
    //                        [self dealImagesChangeAndDelegate];
                        }
                    }];

                }
            }else if([asset isKindOfClass:[ALAsset class]]){
                if (type == TZAssetModelMediaTypePhotoGif) {
                    
                    if (photoMuti.count > i) {
                        
//                        NSData *data = [UIImage sk_gifData:asset];
//                        UIImage *image = photos[i];
//                        image.sk_gifData = data;
                    }
                    
//                    NSData *data = [UIImage sk_gifData:asset];
//                    UIImage *image = [UIImage sd_animatedGIFWithData:data];
//                    image.sk_gifData = data;
//                    [photoMuti replaceObjectAtIndex:i withObject:image];
                }
            }
        }
    }
    _choseImages = photoMuti;
     [self dealImagesChangeAndDelegate];


  

}
// 如果用户选择了一个gif图片，下面的handle会被执行
//- (void)imagePickerController:(TZImagePickerController *)picker didFinishPickingGifImage:(UIImage *)animatedImage sourceAssets:(id)asset {
//    
//    _choseImages = [NSMutableArray arrayWithArray:@[animatedImage]];
//    [self dealImagesChangeAndDelegate];
//
//    
//}


// 如果用户选择了一个视频，下面的handle会被执行
// 如果系统版本大于iOS8，asset是PHAsset类的对象，否则是ALAsset类的对象
//- (void)imagePickerController:(TZImagePickerController *)picker didFinishPickingVideo:(UIImage *)coverImage sourceAssets:(id)asset {
//    _selectedPhotos = [NSMutableArray arrayWithArray:@[coverImage]];
//    _selectedAssets = [NSMutableArray arrayWithArray:@[asset]];
//    // open this code to send video / 打开这段代码发送视频
//    // [[TZImageManager manager] getVideoOutputPathWithAsset:asset completion:^(NSString *outputPath) {
//    // NSLog(@"视频导出到本地完成,沙盒路径为:%@",outputPath);
//    // Export completed, send video here, send by outputPath or NSData
//    // 导出完成，在这里写上传代码，通过路径或者通过NSData上传
//    
//    // }];
//    [_collectionView reloadData];
//    // _collectionView.contentSize = CGSizeMake(0, ((_selectedPhotos.count + 2) / 3 ) * (_margin + _itemWH));
//}



#pragma mark - DNImagePickerControllerDelegate

- (void)dealImagesChangeAndDelegate{
    if (self.managerDelegate && [self.managerDelegate respondsToSelector:@selector(skImagePickerDidFinishChoseImages:)]) {
        [self.managerDelegate skImagePickerDidFinishChoseImages:_choseImages];
    }
}

#pragma mark - Private
- (UIViewController *)_getParentVC{
    UIViewController* result = nil;
    UIWindow* window = [[UIApplication sharedApplication] keyWindow];
    
    if (window.windowLevel != UIWindowLevelNormal) {
        NSArray* windows = [[UIApplication sharedApplication] windows];
        for(UIWindow * tmpWin in windows) {
            if (tmpWin.windowLevel == UIWindowLevelNormal){
                window = tmpWin;
                break;
            }
        }
    }
    
    id  nextResponder = nil;
    UIViewController* appRootVC = window.rootViewController;
    if (appRootVC.presentedViewController) {
        
        nextResponder = appRootVC.presentedViewController;
        
    }else{
        
        UIView* frontView = [[window subviews] objectAtIndex:0];
        nextResponder = [frontView nextResponder];
    }
    if ([nextResponder isKindOfClass:[UITabBarController class]]){
        
        UITabBarController* tabbar = (UITabBarController *)nextResponder;
        UINavigationController* nav = (UINavigationController *)tabbar.viewControllers[tabbar.selectedIndex];
        result=nav.childViewControllers.lastObject;
        
    } else if ([nextResponder isKindOfClass:[UINavigationController class]]){
        
        UIViewController * nav = (UIViewController *)nextResponder;
        result = nav.childViewControllers.lastObject;
        
    } else {
        
        result = nextResponder;
    }
    return result;
}

@end
