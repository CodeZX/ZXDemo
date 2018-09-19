//
//  LXCameraController.m
//  LiangFengYouXin
//
//  Created by 周鑫 on 2018/8/14.
//  Copyright © 2018年 LiangFengYouXin. All rights reserved.
//  CameraController:做操作事件的中转和管理
//  CameraControllView:  相机的操作控制层（操作控件和手势）
//  CameraManager:   相机管理者（封装了GPUImage的操作，封装了操作细节）
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
- (void)closeCamera:(UIButton *)closeBtn {
    
    if ([self.delegate respondsToSelector:@selector(cameraController:didClose:)]) {
        [self.delegate cameraController:self didClose:closeBtn];
    }
}

- (void)tapPreview:(UIImageView *)previewImageV {
    
    if ([self.delegate respondsToSelector:@selector(cameraController:didTapPreviewImageV:)]) {
        [self.delegate cameraController:self didTapPreviewImageV:previewImageV];
    }
}

- (void)startCapture {
    
    if (self.cameraManager.cameraType == LXCameraTypeStillCamera) {
        if ([self.cameraManager respondsToSelector:@selector(startStillCaptureWithBezierPath:completionHandler:)]) {
            [self.cameraManager startStillCaptureWithBezierPath:self.cameraControlView.maskPath completionHandler:^(BOOL success, UIImage *previewImage, NSError *error) {
                [self.cameraControlView setPreviewImage:previewImage];
            }];
        }
    }else if (self.cameraManager.cameraType == LXCameraTypeVideoCamera) {
            if (!self.cameraManager.captureing) {
                if ([self.cameraManager respondsToSelector:@selector(startVideoCaptureCompletionHandler:)]) {
                    [self.cameraManager startVideoCaptureCompletionHandler:^(BOOL success, NSError *error) {
                        if (success) {
                            DEBUG_LOG(@"视频开始捕获....");
                            [self.cameraControlView startVideoCapture];
                        }
                    }];
                }
        }else if ([self.cameraManager respondsToSelector:@selector(stopVideoCaptureCompletionHandler:)]) {
                [self.cameraManager stopVideoCaptureCompletionHandler:^(BOOL success, UIImage *previewImage, NSError *error) {
                     [self.cameraControlView setPreviewImage:previewImage];
                     DEBUG_LOG(@"视频结束捕获....");
                    [self.cameraControlView finishVideoCapture];
                }];
               }
    }
        
}


- (void)transformCameraType:(LXCameraType)cameraType {
    
    if (cameraType == LXCameraTypeUnknown) {
        return;
    }
    
    if ([self.cameraManager respondsToSelector:@selector(transformCameraType:completionHandler:)]) {
        [self.cameraManager transformCameraType:cameraType completionHandler:^(BOOL success, LXCameraType cameraType, NSError *error) {
            if (success) {
                [self.cameraControlView setCameraType:cameraType];
                DEBUG_LOG(@"当前模式为%lu",(unsigned long)cameraType);
            }
        }];
    }
}

- (void)setFilter:(GPUImageFilter *)filter {
    
    if (!filter) {
        return;
    }
    
    if ([self.cameraManager respondsToSelector:@selector(setFilter:completionHandler:)]) {
        [self.cameraManager setFilter:filter completionHandler:^(BOOL success, GPUImageFilter *filter, NSError *error) {
            if (success) {
                DEBUG_LOG(@"设置%@滤镜",NSStringFromClass([filter class]));
            }
            
        }];
    }
}


- (void)turnCameraPositionc {
    
    
    if ([self.cameraManager respondsToSelector:@selector(turnCameraPosition:completionHandler:)]) {
        AVCaptureDevicePosition position = AVCaptureDevicePositionUnspecified;
        if (self.cameraManager.position == AVCaptureDevicePositionBack) {
            position = AVCaptureDevicePositionFront;
        }else if(self.cameraManager.position == AVCaptureDevicePositionFront ||self.cameraManager.position == AVCaptureDevicePositionUnspecified) {
            position = AVCaptureDevicePositionBack;
        }
        [self.cameraManager turnCameraPosition:position completionHandler:^(BOOL success, AVCaptureDevicePosition position, NSError *error) {
            if (success) {
                [self.cameraControlView setCameraPosition:position];
            }
        }];
    }
}



- (void)turnFlashMode {
    
    if ([self.cameraManager respondsToSelector:@selector(turnFlashMode:completionHandler:)]) {
        AVCaptureFlashMode flashMode = AVCaptureFlashModeAuto;
        if (self.cameraManager.flashMode == AVCaptureFlashModeAuto) {
            flashMode = AVCaptureFlashModeOff;
        }else if (self.cameraManager.flashMode == AVCaptureFlashModeOff) {
            flashMode = AVCaptureFlashModeOn;
        }else if(self.cameraManager.flashMode == AVCaptureFlashModeOn) {
            flashMode = AVCaptureFlashModeAuto;
        }
        
        [self.cameraManager turnFlashMode:flashMode completionHandler:^(BOOL success, AVCaptureFlashMode flashMode, NSError *error) {
            if (success) {
                [self.cameraControlView setFlashMode:flashMode];
                DEBUG_LOG(@"设置%ld闪光模式成功",flashMode);
            }
        }];
    }
    
}


- (void)setFocalDistancesScale:(CGFloat)scale {
    
    if ([self.cameraManager respondsToSelector:@selector(focalDistancesScale:completionHandler:)]) {
        [self.cameraManager focalDistancesScale:scale completionHandler:^(BOOL success, CGFloat scale, NSError *error) {
            if (success) {
                DEBUG_LOG(@"焦距为%f",scale);
            }
        }];
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



/**
 *  获取视频的缩略图方法
 *
 *  @param filePath 视频的本地路径
 *
 *  @return 视频截图
 */
- (UIImage *)getScreenShotImageFromVideoPath:(NSString *)filePath{
    
    UIImage *shotImage;
    //视频路径URL
    NSURL *fileURL = [NSURL fileURLWithPath:filePath];
    
    AVURLAsset *asset = [[AVURLAsset alloc] initWithURL:fileURL options:nil];
    
    AVAssetImageGenerator *gen = [[AVAssetImageGenerator alloc] initWithAsset:asset];
    
    gen.appliesPreferredTrackTransform = YES;
    
    CMTime time = CMTimeMakeWithSeconds(0.0, 600);
    
    NSError *error = nil;
    
    CMTime actualTime;
    
    CGImageRef image = [gen copyCGImageAtTime:time actualTime:&actualTime error:&error];
    
    shotImage = [[UIImage alloc] initWithCGImage:image];
    
    CGImageRelease(image);
    
    return shotImage;
    
}



@end






