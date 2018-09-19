//
//  LXCameraManager.h
//  LiangFengYouXin
//
//  Created by 周鑫 on 2018/8/15.
//  Copyright © 2018年 LiangFengYouXin. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>
#import "LXCameraConfig.h"





@interface LXCameraManager : NSObject
// 容器视图
@property (nonatomic,strong) UIView *containerView;

@property (nonatomic,assign) LXCameraType cameraType;
@property (nonatomic,assign) AVCaptureDevicePosition position;
@property (nonatomic,assign) AVCaptureFlashMode flashMode;
@property (nonatomic,assign,getter=isCaptureing) BOOL captureing;




//- (instancetype)initWithContainerView:(UIView *)containerView;


- (void)startCapture;
- (void)stopCapture;


/**
 开始图片捕获

 @param completionHandler 捕获完成的的回调
 */
- (void)startStillCaptureWithBezierPath:(UIBezierPath *)maskPath completionHandler:(void(^)(BOOL success,UIImage *previewImage,NSError * error))completionHandler;

/**
 开始视频捕获

 @param completionHandler 开始视频捕获的回调
 */
- (void)startVideoCaptureCompletionHandler:(void(^)(BOOL success, NSError * error))completionHandler;


/**
 结束视频捕获

 @param completionHandler 视频捕获完成的回调
 */
- (void)stopVideoCaptureCompletionHandler:(void(^)(BOOL success,UIImage *previewImage, NSError * error))completionHandler;


/**
 切换拍摄模式

 @param cameraType <#cameraType description#>
 @param completionHandler <#completionHandler description#>
 */
- (void)transformCameraType:(LXCameraType)cameraType completionHandler:(void(^)(BOOL success,LXCameraType cameraType, NSError *  error))completionHandler;


- (void)startCaptureCompletionHandler:(void(^)(BOOL success,UIImage *image, NSError * error))completionHandler;
- (void)stopCaptureCompletionHandler:(void(^)(BOOL success, UIImage *image,NSString *path, NSError *  error))completionHandler;

- (void)setFilter:(GPUImageFilter *)filter completionHandler:(void(^)(BOOL success,GPUImageFilter *filter, NSError *  error))completionHandler;
- (void)turnCameraPosition:(AVCaptureDevicePosition)position completionHandler:(void(^)(BOOL success,AVCaptureDevicePosition position, NSError *  error))completionHandler;
- (void)turnFlashMode:(AVCaptureFlashMode)flashMode completionHandler:(void(^)(BOOL success,AVCaptureFlashMode flashMode, NSError *  error))completionHandler;
- (void)focalDistancesScale:(CGFloat )scale completionHandler:(void(^)(BOOL success,CGFloat scale, NSError *  error))completionHandler;

@end
