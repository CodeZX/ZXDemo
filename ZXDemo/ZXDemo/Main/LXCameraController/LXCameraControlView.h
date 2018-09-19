//
//  LXCameraControlView.h
//  LiangFengYouXin
//
//  Created by 周鑫 on 2018/8/16.
//  Copyright © 2018年 LiangFengYouXin. All rights reserved.
//

#import <UIKit/UIKit.h>


@class LXCameraController;

@protocol  LXCameraControlViewDelegate <NSObject>
@optional
@required
@end
@interface LXCameraControlView : UIView
@property (nonatomic,weak) LXCameraController *cameraController;
@property (nonatomic,strong,readonly) UIBezierPath *maskPath;  // 蒙版路径


- (void)setPreviewImage:(UIImage *)PreviewImage;
- (void)setCameraType:(LXCameraType)cameraType;
- (void)setCameraPosition:(AVCaptureDevicePosition)position;
- (void)setFlashMode:(AVCaptureFlashMode)flashMode;
- (void)startVideoCapture;
- (void)finishVideoCapture;
@end
