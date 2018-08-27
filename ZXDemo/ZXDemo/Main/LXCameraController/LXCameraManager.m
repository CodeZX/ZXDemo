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


- (void)startCapture {
    
    __weak typeof(self) weakSelf = self;
    if (self.cameraType == LXCameraTypeStillCamera) {
            [self.stillCamera capturePhotoAsImageProcessedUpToFilter:self.defaultFilter withCompletionHandler:^(UIImage *processedImage, NSError *error) {
        
//                UIImageWriteToSavedPhotosAlbum(processedImage, self, @selector(image:didFinishSavingWithError:contextInfo:),(__bridge void *)self);
                [weakSelf saveImage:processedImage];
        
            }];
        
    } else if(self.cameraType == LXCameraTypeVideoCamera) {
        
         [self.movieWriter startRecording];
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
        NSError *error = [[NSError alloc]initWithDomain:NSCocoaErrorDomain code:-101 userInfo:@{NSUnderlyingErrorKey:@"不能完成捕获!"}];
        completionHandler(NO,nil,error);
    }
}

- (void)stopCaptureCompletionHandler:(void (^)(BOOL, UIImage *, NSString *, NSError *))completionHandler {
    
    if (self.cameraType == LXCameraTypeStillCamera) {
        NSError *error = [[NSError alloc]initWithDomain:NSCocoaErrorDomain code:-101 userInfo:@{NSUnderlyingErrorKey:@"拍照模式下，不需要结束捕获"}];
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
// 转换成图片拍摄
- (void)transformStillCamera {
    
//    [self.videoCamera stopCameraCapture];
//    [self.videoCamera removeAllTargets];
//    [self.defaultFilter removeAllTargets];
//    [self.stillCamera addTarget:self.defaultFilter];
//    [self.defaultFilter addTarget:self.previewView];
//    [self.stillCamera startCameraCapture];
    self.cameraType = LXCameraTypeStillCamera;
}

// 转换成录像拍摄
- (void)transformVideoCamera {
    
//    [self.stillCamera stopCameraCapture];
//    [self.stillCamera removeAllTargets];
//    [self.defaultFilter removeAllTargets];
//    [self.videoCamera addTarget:self.defaultFilter];
//    [self.defaultFilter addTarget:self.previewView];
//    [self.videoCamera startCameraCapture];
    self.cameraType = LXCameraTypeVideoCamera;
    
    
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
