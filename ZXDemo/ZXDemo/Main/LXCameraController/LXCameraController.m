//
//  LXCameraController.m
//  LiangFengYouXin
//
//  Created by 周鑫 on 2018/8/14.
//  Copyright © 2018年 LiangFengYouXin. All rights reserved.
//  CameraController:做操作事件的中转和管理
//  CameraControllView:  相机的操作控制层（操作控件和手势）
//  CameraManager:   相机管理者（封装了GPUImage的操作，屏蔽了操作细节）
//   基本架构：由CameraController 做操作事件的中转和管理。 CameracontrolView 的操作动作会调用CameraControler的对应方法，CamearControler会根据相机状态和参数选择CameraManager的对应方法。

#import "LXCameraController.h"
#import "LXCameraManager.h"
#import "LXCameraControlView.h"


@interface LXCameraController ()
@property (nonatomic,strong) LXCameraManager *cameraManager;
@property (nonatomic,strong) UIView *containerView;
@property (nonatomic,strong) LXCameraControlView *cameraControlView;
@end

@implementation LXCameraController
+ (instancetype)cameraWithCameraManager:(LXCameraManager *)cameraManager  cameraControlView:(LXCameraControlView *)cameraControlView containerView:(UIView *)containerView {
   
    return  [[self alloc]initWtihCameraManager:cameraManager cameraControlView:cameraControlView containerView:containerView];
}

- (instancetype)initWtihCameraManager:(LXCameraManager *)camearManager cameraControlView:(LXCameraControlView *)cameraControlView containerView:(UIView *)containerView {
    
    self = [super init];
    if (self) {
        self.cameraManager = camearManager;
        self.cameraManager.containerView = containerView;
        self.cameraControlView = cameraControlView;
        self.cameraControlView.cameraController = self;
        self.containerView = containerView;
        [self.containerView addSubview:self.cameraControlView];
        [self.containerView bringSubviewToFront:self.cameraControlView];
        
        
    }
    return self;
}


#pragma mark -------------------------- 控制方法 ----------------------------------------
- (void)startCapture:(UIButton *)startCaptureBtn  {
    
    if (startCaptureBtn.selected) {
        if ([self.cameraManager respondsToSelector:@selector(startCapture)]) {
            [self.cameraManager startCapture];
        }
    }
}

- (void)stopCapture:(UIButton *)stopCaptureBtn {
    
    if (stopCaptureBtn.selected == NO ) {
        if ([self.cameraManager respondsToSelector:@selector(stopCapture)]) {
            [self.cameraManager stopCapture];
        }
    }
    
}

- (void)startCapture:(UIButton *)startCaptureBtn completionHandler:(void (^)(BOOL,UIImage * _Nullable image, NSError * _Nullable))completionHandler {
    
    if ([self.cameraManager respondsToSelector:@selector(startCaptureCompletionHandler:)]) {
        [self.cameraManager startCaptureCompletionHandler:completionHandler];
    }
    
}

- (void)stopCapture:(UIButton *)stopCaptureBtn completionHandler:(void (^)(BOOL, UIImage *, NSString *, NSError *))completionHandler {

    if ([self.cameraManager respondsToSelector:@selector(stopCaptureCompletionHandler:)]) {
        [self.cameraManager stopCaptureCompletionHandler:completionHandler];
    }
}





- (void)transformCameraType:(LXCameraType)cameraType {
    
    if (cameraType == LXCameraTypeStillCamera) {
        [self.cameraManager transformStillCamera];
    }else if(cameraType == LXCameraTypeVideoCamera) {
        [self.cameraManager transformVideoCamera];
    }
}

@end


// 权限
@implementation LXCameraController (authorization)
+ (AVAuthorizationStatus)authorizationStatusForAVMediaTypeAudio {
    
   return  [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeAudio];
    
}

+ (AVAuthorizationStatus)authorizationStatusForAVMediaTypeVideo {
    
    return  [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo];
}

+ (PHAuthorizationStatus)authorizationStatusForPhotoLibrary {
    
    return  [PHPhotoLibrary authorizationStatus];
}

+ (void)requestAccessForAVMediaTypeVideo:(void (^)(BOOL))completionHandler {
    
    [AVCaptureDevice requestAccessForMediaType:AVMediaTypeVideo completionHandler:^(BOOL granted) {
        completionHandler(granted);
    }];
}


+ (void)requestAccessForAVMediaTypeAudio:(void (^)(BOOL))completionHandler {
    
    [AVCaptureDevice requestAccessForMediaType:AVMediaTypeAudio completionHandler:^(BOOL granted) {
        completionHandler(granted);
    }];
    
}
+ (void)requestAccessForPhotoLibrary:(void (^)(PHAuthorizationStatus ))completionHandler {
    
    [PHPhotoLibrary requestAuthorization:^(PHAuthorizationStatus status) {
        completionHandler(status);
    }];
}

@end

// 路径
@implementation LXCameraController (path)


//图片路径//
+ (NSString *)folderPathForStillCamera {
    
    //Document目录
    NSString *documentPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) firstObject];
    NSString *LXStillPath = [documentPath stringByAppendingPathComponent:@"LXStill"];
    NSFileManager *fileManaer = [NSFileManager defaultManager];
    if (![fileManaer fileExistsAtPath:LXStillPath]) {
        [fileManaer createDirectoryAtPath:LXStillPath withIntermediateDirectories:YES attributes:nil error:nil];
    }
    return LXStillPath;
}

+ (NSString *)filePathForStillCamera  {
    
    NSString *fileName =[NSString stringWithFormat:@"%f",[[NSDate date] timeIntervalSince1970]];
    return [self filePathForStillCameraByAppendingFileName:fileName];
    
}

+ (NSString *)filePathForStillCameraByAppendingFileName:(NSString *)fileName {
    
   return  [[self folderPathForStillCamera] stringByAppendingPathComponent:fileName];
}



//视频路径方法//
+ (NSString *)folderPathForVideoCamera {
    
    //Document目录
    NSString *documentPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) firstObject];
    NSString *LXVideoPath = [documentPath stringByAppendingPathComponent:@"LXVideo"];
    NSFileManager *fileManaer = [NSFileManager defaultManager];
    if (![fileManaer fileExistsAtPath:LXVideoPath]) {
        [fileManaer createDirectoryAtPath:LXVideoPath withIntermediateDirectories:YES attributes:nil error:nil];
    }
    return LXVideoPath;
}

+ (NSString *)filePathForVideoCamera {
    
    NSString *fileName =[NSString stringWithFormat:@"%.0f.m4v",[[NSDate date] timeIntervalSince1970]];

    return [self filePathForVideoCameraByAppendingFileName:fileName];
}

+ (NSString *)filePathForVideoCameraByAppendingFileName:(NSString *)fileName {
    
    return  [[self folderPathForVideoCamera] stringByAppendingPathComponent:fileName];
}



@end






