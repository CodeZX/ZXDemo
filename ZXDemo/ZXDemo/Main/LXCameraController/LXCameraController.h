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
- (void)cameraController:(LXCameraController *)cameraController didCancel:(UIButton *)cancelBtn;
- (void)cameraController:(LXCameraController *)cameraController didSetting:(UIButton *)SettingBtn;
@required
@end
@interface LXCameraController : NSObject

@property (nonatomic,weak) id<LXCameraControllerDelegate> delegate;



+ (instancetype)cameraWithCameraManager:(LXCameraManager *)cameraManager cameraControlView:(LXCameraControlView *)cameraControlView containerView:(UIView *)containerView;
- (instancetype)initWtihCameraManager:(LXCameraManager *)camearManager cameraControlView:(LXCameraControlView *)cameraControlView containerView:(UIView *)containerView;
@end


// 控制方法
@interface LXCameraController (control)
- (void)startCapture:(UIButton *)startCaptureBtn;
- (void)stopCapture:(UIButton *)stopCaptureBtn;
- (void)startCapture:(UIButton *)startCaptureBtn completionHandler:(void(^)(BOOL success,UIImage *image, NSError * error))completionHandler;
- (void)stopCapture:(UIButton *)stopCaptureBtn completionHandler:(void(^)(BOOL success, UIImage *image,NSString *path, NSError *  error))completionHandler;
- (void)transformCameraType:(LXCameraType)cameraType;
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

