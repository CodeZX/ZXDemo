//
//  LXCameraManager.m
//  LiangFengYouXin
//
//  Created by 周鑫 on 2018/8/15.
//  Copyright © 2018年 LiangFengYouXin. All rights reserved.
//

#import "LXCameraManager.h"
#import "LXCameraController.h"
#import <AssetsLibrary/AssetsLibrary.h>
#import <Photos/Photos.h>



@interface LXCameraManager ()

@property (nonatomic,strong) GPUImageStillCamera *stillCamera;
@property (nonatomic,strong) GPUImageVideoCamera *videoCamera;
@property (nonatomic,strong) GPUImageView *previewView;
// 默认滤镜
@property (nonatomic,retain) GPUImageFilter *defaultFilter;
//
@property (nonatomic,strong) GPUImageMovieWriter *movieWriter;
@property (nonatomic,strong) NSString  *stillFile;
@property (nonatomic,strong) NSString *videoFile;


@property (nonatomic,strong) GPUImageView *gpuImageview;
@end
@implementation LXCameraManager


//- (instancetype)initWithContainerView:(UIView *)containerView {
//    self = [super init];
//    if (self) {
//        self.containerView = containerView;
//        [self setupBegin];
//    }
//    return self;
//}


- (instancetype)init
{
    self = [super init];
    if (self) {
        self.cameraType = LXCameraTypeDefault;
        self.position = AVCaptureDevicePositionBack;
        self.flashMode = AVCaptureFlashModeAuto;
    }
    return self;
}

- (void)setContainerView:(UIView *)containerView {
    
    _containerView = containerView;
    [self setupBegin];
}



- (void)setupBegin {
    
    if ([LXCameraController authorizationStatusForAVMediaTypeVideo] == AVAuthorizationStatusNotDetermined) {
        [LXCameraController requestAccessForAVMediaTypeVideo:^(BOOL granted) {
            if (granted) {
                [self initializeGPUImage];
            }
        }];
    }else if([LXCameraController authorizationStatusForAVMediaTypeVideo] == AVAuthorizationStatusAuthorized) {
        [self initializeGPUImage];
        
    }else if([LXCameraController authorizationStatusForAVMediaTypeVideo] == AVAuthorizationStatusDenied) {
        
    }
    
    
}

- (void)initializeGPUImage {
    
   
    CGRect previewViewFrame = self.containerView.frame;
    self.previewView = [[GPUImageView alloc]initWithFrame:previewViewFrame];
    [self.stillCamera addTarget:self.defaultFilter];
    [self.defaultFilter addTarget:self.previewView];
    [self.containerView addSubview:self.previewView];
    [self.stillCamera startCameraCapture];
    
//    [self.videoCamera addTarget:self.defaultFilter];
//    [self.defaultFilter addTarget:self.previewView];
//    [self.containerView addSubview:self.previewView];
//    [self.videoCamera startCameraCapture];
    
}

#pragma mark -------------------------- 操作方法 ----------------------------------------



/**
图片捕获

 @param completionHandler 完成回调
 */

- (void)startStillCaptureWithBezierPath:(UIBezierPath *)maskPath completionHandler:(void (^)(BOOL, UIImage *, NSError *))completionHandler {
    
    __weak typeof(self) weakSelf = self;
    if (self.cameraType == LXCameraTypeStillCamera) {
        [self.stillCamera capturePhotoAsImageProcessedUpToFilter:self.defaultFilter withCompletionHandler:^(UIImage *processedImage, NSError *error) {
            
            [self.stillCamera capturePhotoAsImageProcessedUpToFilter:self.defaultFilter withCompletionHandler:^(UIImage *processedImage, NSError *error) {
                UIImage *clipImg = [UIImage clipedImageWithImage:processedImage path:maskPath];
                if ([weakSelf saveImage:clipImg]) {
                    completionHandler(YES,clipImg,nil);
                }else {
                    NSError *error = [[NSError alloc]initWithDomain:NSCocoaErrorDomain code:-101 userInfo:@{NSUnderlyingErrorKey:@"不能完成捕获!"}];
                    completionHandler(NO,nil,error);
                }
            }];
            
        }];
        
    }
    
}
- (void)startStillCaptureCompletionHandler:(void (^)(BOOL, UIImage *,UIBezierPath *, NSError *))completionHandler {
   
    
    
}


/**
 开始视频捕获

 @param completionHandler <#completionHandler description#>
 */
- (void)startVideoCaptureCompletionHandler:(void (^)(BOOL, NSError *))completionHandler {
   
    if(self.cameraType == LXCameraTypeVideoCamera) {
        self.movieWriter = nil;
        [self.movieWriter startRecording];
        self.captureing = YES;
        NSError *error = [[NSError alloc]initWithDomain:NSCocoaErrorDomain code:-101 userInfo:@{NSUnderlyingErrorKey:@"摄像模式，开始捕获..."}];
        completionHandler(YES,error);
        DEBUG_LOG(@"开始捕获视频");
    }
    
}


/**
 结束视频捕获

 @param completionHandler <#completionHandler description#>
 */
- (void)stopVideoCaptureCompletionHandler:(void (^)(BOOL, UIImage *, NSError *))completionHandler {
    
    if (self.cameraType == LXCameraTypeVideoCamera) {
        [self.defaultFilter removeTarget:self.movieWriter];
        self.videoCamera.audioEncodingTarget = nil;
        [self.movieWriter finishRecording];
        self.captureing  = NO;
        if (UIVideoAtPathIsCompatibleWithSavedPhotosAlbum(self.videoFile)) {
            if ([self saveVideoWithPath:self.videoFile]) {
                
                completionHandler(YES,[self getThumbnailImage:self.videoFile],nil);
                DEBUG_LOG(@"完成视频捕获");
            } else {
                NSError *error = [[NSError alloc]initWithDomain:NSCocoaErrorDomain code:-101 userInfo:@{NSUnderlyingErrorKey:@"不能完成捕获!"}];
                completionHandler(NO,nil,error);
                DEBUG_LOG(@"视频捕获完成失败");
            }
            
        }
    }
   
    
}

- (void)stopCapture {
    
    if (self.cameraType == LXCameraTypeStillCamera) {
        return;
    }
    
    [self.defaultFilter removeTarget:self.movieWriter];
    self.videoCamera.audioEncodingTarget = nil;
    [self.movieWriter finishRecording];
    
    if (UIVideoAtPathIsCompatibleWithSavedPhotosAlbum(self.videoFile))
    {
        [self saveVideoWithPath:self.videoFile];
    }
}


- (void)startCaptureCompletionHandler:(void (^)(BOOL, UIImage *, NSError *))completionHandler {
    
    __weak typeof(self) weakSelf = self;
    if (self.cameraType == LXCameraTypeStillCamera) {
        [self.stillCamera capturePhotoAsImageProcessedUpToFilter:self.defaultFilter withCompletionHandler:^(UIImage *processedImage, NSError *error) {
            if ([weakSelf saveImage:processedImage]) {
                completionHandler(YES,processedImage,nil);
            }else {
                NSError *error = [[NSError alloc]initWithDomain:NSCocoaErrorDomain code:-101 userInfo:@{NSUnderlyingErrorKey:@"不能完成捕获!"}];
                completionHandler(NO,nil,error);
            }
        }];
        
    } else if(self.cameraType == LXCameraTypeVideoCamera) {
        self.movieWriter = nil;
        [self.movieWriter startRecording];
        NSError *error = [[NSError alloc]initWithDomain:NSCocoaErrorDomain code:-101 userInfo:@{NSUnderlyingErrorKey:@"摄像模式，开始捕获..."}];
        completionHandler(NO,nil,error);
    }
}

- (void)stopCaptureCompletionHandler:(void (^)(BOOL, UIImage *, NSString *, NSError *))completionHandler {
    
    if (self.cameraType == LXCameraTypeStillCamera) {
        NSError *error = [[NSError alloc]initWithDomain:NSCocoaErrorDomain code:-101 userInfo:@{NSUnderlyingErrorKey:@"拍照模式下，结束捕获无效"}];
        completionHandler(NO,nil,nil,error);
        return;
    }
    
    [self.defaultFilter removeTarget:self.movieWriter];
    self.videoCamera.audioEncodingTarget = nil;
    [self.movieWriter finishRecording];
    if (UIVideoAtPathIsCompatibleWithSavedPhotosAlbum(self.videoFile)) {
        if ([self saveVideoWithPath:self.videoFile]) {
            completionHandler(YES,nil,nil,nil);
        } else {
            NSError *error = [[NSError alloc]initWithDomain:NSCocoaErrorDomain code:-101 userInfo:@{NSUnderlyingErrorKey:@"不能完成捕获!"}];
            completionHandler(NO,nil,nil,error);
        }
       
    }
    
    
}

- (void)setFilter:(GPUImageFilter *)filter completionHandler:(void (^)(BOOL, GPUImageFilter *, NSError *))completionHandler {
    
    if (!filter) {
        NSError *error = [NSError errorWithDomain:NSCocoaErrorDomain code:-101 userInfo:@{NSUnderlyingErrorKey:@"filter为空"}];
        completionHandler(NO,nil,error);
        return;
    }
    [self.stillCamera removeAllTargets];
    [self.defaultFilter removeAllTargets];
    [self.stillCamera addTarget:filter];
    [filter addTarget:self.previewView];
    completionHandler(YES,filter,nil);
}

- (void)turnCameraPosition:(AVCaptureDevicePosition)position completionHandler:(void (^)(BOOL, AVCaptureDevicePosition, NSError *))completionHandler {
    if (position == AVCaptureDevicePositionUnspecified) {
         NSError *error = [[NSError alloc]initWithDomain:NSCocoaErrorDomain code:-101 userInfo:@{NSUnderlyingErrorKey:@"position参数没有声明具体方向！"}];
        completionHandler(NO,AVCaptureDevicePositionUnspecified,error);
        return;
    }
    
    [self.stillCamera stopCameraCapture];
    if ([self.stillCamera initWithSessionPreset:AVCaptureSessionPresetHigh cameraPosition:position]) {
        self.position = position;
        self.stillCamera.outputImageOrientation = UIInterfaceOrientationPortrait;
        self.stillCamera.horizontallyMirrorFrontFacingCamera = YES;
        self.stillCamera.horizontallyMirrorRearFacingCamera = NO;
        
        [self.stillCamera removeAllTargets];
        [self.stillCamera addTarget:self.defaultFilter];
        //    _filterView = (GPUImageView *)self.preview;
        //        [self.defaultFilter addTarget:self.previewView];
        [self.stillCamera startCameraCapture];
        completionHandler(YES,position,nil);
        
    } else {
        NSError *error = [NSError errorWithDomain:NSCocoaErrorDomain code:-101 userInfo:@{NSUnderlyingErrorKey:@"方向未知为空"}];
        completionHandler(NO,AVCaptureDevicePositionUnspecified,error);
        
    }
    
}




- (void)turnFlashMode:(AVCaptureFlashMode)flashMode completionHandler:(void (^)(BOOL, AVCaptureFlashMode, NSError *))completionHandler {
    
  
    [self.stillCamera.inputCamera lockForConfiguration:nil];
    if ([self.stillCamera.inputCamera isFlashModeSupported:flashMode]) {
        [self.stillCamera.inputCamera setFlashMode:AVCaptureFlashModeOn];
        self.flashMode = flashMode;
        completionHandler(YES,self.flashMode,nil);
        
    }else {
        NSError *error = [NSError errorWithDomain:NSCocoaErrorDomain code:-101 userInfo:@{NSUnderlyingErrorKey:@"flashMode为不支持的闪光灯模式"}];
        completionHandler(NO,flashMode,error);
    }
    [self.stillCamera.inputCamera unlockForConfiguration];
}

- (void)focalDistancesScale:(CGFloat)scale completionHandler:(void (^)(BOOL, CGFloat, NSError *))completionHandler {
    
    [CATransaction begin];
    [CATransaction setAnimationDuration:.025];
    NSError *error;
    if([self.stillCamera.inputCamera lockForConfiguration:&error]){
        [self.stillCamera.inputCamera setVideoZoomFactor:scale];
        [self.stillCamera.inputCamera unlockForConfiguration];
        completionHandler(YES,scale,nil);
    }
    else {
         NSError *error = [NSError errorWithDomain:NSCocoaErrorDomain code:-101 userInfo:@{NSUnderlyingErrorKey:@"变焦失败"}];
        completionHandler(NO,scale,error);
    }
    
    [CATransaction commit];
}



// 转换拍摄模式 （录像和拍照）
- (void)transformCameraType:(LXCameraType)cameraType completionHandler:(void (^)(BOOL, LXCameraType, NSError *))completionHandler {
    
    if (cameraType == LXCameraTypeUnknown) {
         NSError *error = [[NSError alloc]initWithDomain:NSCocoaErrorDomain code:-101 userInfo:@{NSUnderlyingErrorKey:@"cameraType参数不能为LXCameraTypeUnknown，请重试！"}];
        completionHandler(NO,LXCameraTypeUnknown,error);
        return;
    }
    
    self.cameraType = cameraType;
    completionHandler(YES,self.cameraType,nil);
    
    
}
#pragma mark -------------------------- Save ImageAndvideo Means ----------------------------------------

- (BOOL)saveImage:(UIImage *)image {
   
    if (!image) {
        return NO;
    }
    NSString *assetCollectionTitle = @"凉风有信";
   return   [self saveImage:image toAssetCollectionWithTitle:assetCollectionTitle];
    

}

- (BOOL)saveImage:(UIImage *)image toAssetCollectionWithTitle:(NSString *)title {
    
    if (!image || !title) {
        return NO;
    }
    
    // 1. 获取相片库对象
    PHPhotoLibrary *library = [PHPhotoLibrary sharedPhotoLibrary];
    
    // 2. 调用changeBlock
    [library performChanges:^{
        
        // 2.1 创建一个相册变动请求
        PHAssetCollectionChangeRequest *collectionRequest;
        
        // 2.2 取出指定名称的相册
        PHAssetCollection *assetCollection = [self getCurrentPhotoCollectionWithTitle:title];
        
        // 2.3 判断相册是否存在
        if (assetCollection) { // 如果存在就使用当前的相册创建相册请求
            collectionRequest = [PHAssetCollectionChangeRequest changeRequestForAssetCollection:assetCollection];
        } else { // 如果不存在, 就创建一个新的相册请求
            collectionRequest = [PHAssetCollectionChangeRequest creationRequestForAssetCollectionWithTitle:title];
        }
        
        // 2.4 根据传入的相片, 创建相片变动请求
        PHAssetChangeRequest *assetRequest = [PHAssetChangeRequest creationRequestForAssetFromImage:image];
        
        // 2.4 创建一个占位对象
        PHObjectPlaceholder *placeholder = [assetRequest placeholderForCreatedAsset];
        
        // 2.5 将占位对象添加到相册请求中
        [collectionRequest addAssets:@[placeholder]];
        
    } completionHandler:^(BOOL success, NSError * _Nullable error) {
        
        // 3. 判断是否出错, 如果报错, 声明保存不成功
        if (error) {
//            [SVProgressHUD showErrorWithStatus:@"保存失败"];
            DEBUG_LOG(@"保存失败");
        } else {
            DEBUG_LOG(@"保存成功");
//            [SVProgressHUD showSuccessWithStatus:@"保存成功"];
        }
    }];
    
    
    return YES;
}

- (BOOL)saveVideoWithPath:(NSString *)path {
    
    if ((!path)) {
        return NO;
    }
    
    NSString *assetCollectionTitle = @"凉风有信";
   return  [self saveVideoWithPath:path toAssetCollectionWithTitle:assetCollectionTitle];
}

- (BOOL)saveVideoWithPath:(NSString *)path toAssetCollectionWithTitle:(NSString *)title {
    
    if (!(path && title)) {
        return  NO;
    }
    // 1. 获取相片库对象
    PHPhotoLibrary *library = [PHPhotoLibrary sharedPhotoLibrary];
    
    // 2. 调用changeBlock
    [library performChanges:^{
        
        // 2.1 创建一个相册变动请求
        PHAssetCollectionChangeRequest *collectionRequest;
        
        // 2.2 取出指定名称的相册
        PHAssetCollection *assetCollection = [self getCurrentPhotoCollectionWithTitle:title];
        
        // 2.3 判断相册是否存在
        if (assetCollection) { // 如果存在就使用当前的相册创建相册请求
            collectionRequest = [PHAssetCollectionChangeRequest changeRequestForAssetCollection:assetCollection];
        } else { // 如果不存在, 就创建一个新的相册请求
            collectionRequest = [PHAssetCollectionChangeRequest creationRequestForAssetCollectionWithTitle:title];
        }
        
        // 2.4 根据传入的相片, 创建相片变动请求
        PHAssetChangeRequest *assetRequest = [PHAssetChangeRequest creationRequestForAssetFromVideoAtFileURL:[NSURL fileURLWithPath:path]];
        
        // 2.4 创建一个占位对象
        PHObjectPlaceholder *placeholder = [assetRequest placeholderForCreatedAsset];
        
        // 2.5 将占位对象添加到相册请求中
        [collectionRequest addAssets:@[placeholder]];
        
    } completionHandler:^(BOOL success, NSError * _Nullable error) {
        
        // 3. 判断是否出错, 如果报错, 声明保存不成功
        if (error) {
            //            [SVProgressHUD showErrorWithStatus:@"保存失败"];
            DEBUG_LOG(@"保存失败");
        } else {
            DEBUG_LOG(@"保存成功");
            //            [SVProgressHUD showSuccessWithStatus:@"保存成功"];
        }
    }];
    
    
    return YES;
    
}
- (PHAssetCollection *)getCurrentPhotoCollectionWithTitle:(NSString *)collectionName {
    
    // 1. 创建搜索集合
    PHFetchResult *result = [PHAssetCollection fetchAssetCollectionsWithType:PHAssetCollectionTypeAlbum subtype:PHAssetCollectionSubtypeAlbumRegular options:nil];
    
    // 2. 遍历搜索集合并取出对应的相册
    for (PHAssetCollection *assetCollection in result) {
        
        if ([assetCollection.localizedTitle containsString:collectionName]) {
            return assetCollection;
        }
    }
    
    return nil;
}

- (UIImage *)getThumbnailImage:(NSString *)videoURL{
    AVURLAsset *asset = [[AVURLAsset alloc] initWithURL:[NSURL fileURLWithPath:videoURL] options:nil];
    
    AVAssetImageGenerator *gen = [[AVAssetImageGenerator alloc] initWithAsset:asset];
    
    gen.appliesPreferredTrackTransform = YES;//按正确方向对视频进行截图,关键点是将AVAssetImageGrnerator对象的appliesPreferredTrackTransform属性设置为YES。
    
    CMTime time = CMTimeMakeWithSeconds(5, 600);
    
    NSError *error = nil;
    
    CMTime actualTime;
    
    CGImageRef image = [gen copyCGImageAtTime:time actualTime:&actualTime error:&error];
    
    UIImage *thumb = [[UIImage alloc] initWithCGImage:image];
    
    CGImageRelease(image);
    
    return thumb;
}




#pragma mark -------------------------- lazy load ----------------------------------------

- (GPUImageStillCamera *)stillCamera {
    
    if(!_stillCamera) {
        _stillCamera = [[GPUImageStillCamera alloc] initWithSessionPreset:AVCaptureSessionPresetHigh cameraPosition:AVCaptureDevicePositionBack];
        _stillCamera.outputImageOrientation = UIInterfaceOrientationPortrait;
    }
    return _stillCamera;
}

- (GPUImageVideoCamera *)videoCamera {
    
    if(!_videoCamera) {
        _videoCamera = [[GPUImageVideoCamera alloc] initWithSessionPreset:AVCaptureSessionPresetHigh cameraPosition:AVCaptureDevicePositionBack];
        _videoCamera.outputImageOrientation = UIInterfaceOrientationPortrait;
        _videoCamera.horizontallyMirrorFrontFacingCamera = NO;
        _videoCamera.horizontallyMirrorRearFacingCamera = NO;
    }
    
    return _videoCamera;
}

- (GPUImageFilter *)defaultFilter {
    
    if (!_defaultFilter) {
        _defaultFilter = [[GPUImageFilter alloc]init];
    }
    
    return _defaultFilter;
    
}

- (GPUImageMovieWriter *)movieWriter {
   
    if (!_movieWriter) {
       
        NSURL *movieURL = [NSURL fileURLWithPath:self.videoFile];
        unlink([self.videoFile UTF8String]);
        _movieWriter = [[GPUImageMovieWriter alloc] initWithMovieURL:movieURL size:CGSizeMake(480.0, 640.0)];
        _movieWriter.encodingLiveVideo = YES;
        [self.defaultFilter addTarget:_movieWriter];
        self.videoCamera.audioEncodingTarget = _movieWriter;
       
    }
    return _movieWriter;
}

- (NSString *)stillFile {
   
    if (!_stillFile) {
        _stillFile = [LXCameraController filePathForStillCamera];
    }
    return _stillFile;
}

- (NSString *)videoFile {
   
    if (!_videoFile) {
        _videoFile = [LXCameraController filePathForVideoCamera];
    }
    return _videoFile;
}


@end
