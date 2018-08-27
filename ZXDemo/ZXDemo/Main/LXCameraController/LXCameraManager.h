//
//  LXCameraManager.h
//  LiangFengYouXin
//
//  Created by 周鑫 on 2018/8/15.
//  Copyright © 2018年 LiangFengYouXin. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LXCameraConfig.h"





@interface LXCameraManager : NSObject
// 容器视图
@property (nonatomic,strong) UIView *containerView;

@property (nonatomic,assign) LXCameraType cameraType;




//- (instancetype)initWithContainerView:(UIView *)containerView;


- (void)startCapture;
- (void)stopCapture;
- (void)startCaptureCompletionHandler:(void(^)(BOOL success,UIImage *image, NSError * error))completionHandler;
- (void)stopCaptureCompletionHandler:(void(^)(BOOL success, UIImage *image,NSString *path, NSError *  error))completionHandler;
- (void)transformStillCamera;
- (void)transformVideoCamera;
@end
