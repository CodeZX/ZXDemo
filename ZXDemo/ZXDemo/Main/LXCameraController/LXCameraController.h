//
//  LXCameraController.h
//  LiangFengYouXin
//
//  Created by 周鑫 on 2018/8/14.
//  Copyright © 2018年 LiangFengYouXin. All rights reserved.
//  相机控制类    对相机的预览、捕获、参数、控制层做管理和控制

#import <Foundation/Foundation.h>
#import <Photos/Photos.h>
#import "LXCameraConfig.h"



@class LXCameraManager,LXCameraControlView,LXCameraController;
@protocol  LXCameraControllerDelegate <NSObject>
@optional
- (void)cameraController:(LXCameraController *)cameraController didClose:(UIButton *)closeBtn;
- (void)cameraController:(LXCameraController *)cameraController didSetting:(UIButton *)SettingBtn;
- (void)cameraController:(LXCameraController *)cameraController didTapPreviewImageV:(UIImageView *)PreviewImageV;
@required
@end
@interface LXCameraController : NSObject

@property (nonatomic,weak) id<LXCameraControllerDelegate> delegate;



+ (instancetype)cameraWithCameraManager:(LXCameraManager *)cameraManager cameraControlView:(LXCameraControlView *)cameraControlView containerView:(UIView *)containerView;
- (instancetype)initWtihCameraManager:(LXCameraManager *)camearManager cameraControlView:(LXCameraControlView *)cameraControlView containerView:(UIView *)containerView;
@end


// 控制方法
@interface LXCameraController (control)

/**
 关闭

 @param closeBtn 关闭按钮
 */
- (void)closeCamera:(UIButton *)closeBtn;

- (void)tapSetting:(UIButton *)settingBtn;

- (void)tapPreview:(UIImageView *)previewImageV;
/**
 开始捕获

 @param
 */
- (void)startCapture;


/**
 结束捕获
 */
- (void)stopCapture;



/**
 转换拍摄模式

 @param cameraType <#cameraType description#>
 */
- (void)transformCameraType:(LXCameraType)cameraType;


/**
 设置滤镜

 @param filter <#filter description#>
 */
- (void)setFilter:(GPUImageFilter *)filter;


/**
 转换前后摄像头
 */
- (void)turnCameraPositionc;



/**
 转换闪光灯模式
 */
- (void)turnFlashMode;


/**
 设置焦距

 @param scale <#scale description#>
 */
- (void)setFocalDistancesScale:(CGFloat )scale;



@end






// 应用授权   相机  相册  麦克风
@interface LXCameraController (authorization)
+ (AVAuthorizationStatus)authorizationStatusForAVMediaTypeVideo;
+ (AVAuthorizationStatus)authorizationStatusForAVMediaTypeAudio;
+ (PHAuthorizationStatus)authorizationStatusForPhotoLibrary;

+ (void)requestAccessForAVMediaTypeVideo:(void (^)(BOOL granted))completionHandler;
+ (void)requestAccessForAVMediaTypeAudio:(void (^)(BOOL granted))completionHandler;
+ (void)requestAccessForPhotoLibrary:(void (^)(PHAuthorizationStatus status))completionHandler;

@end

// 资源保存路径
@interface LXCameraController (path)
+ (NSString *)folderPathForStillCamera;
+ (NSString *)folderPathForVideoCamera;
+ (NSString *)filePathForStillCamera;
+ (NSString *)filePathForStillCameraByAppendingFileName:(NSString *)fileName;
+ (NSString *)filePathForVideoCamera;
+ (NSString *)filePathForVideoCameraByAppendingFileName:(NSString *)fileName;
@end

