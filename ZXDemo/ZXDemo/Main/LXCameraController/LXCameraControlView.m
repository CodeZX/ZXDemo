//
//  LXCameraControlView.m
//  LiangFengYouXin
//
//  Created by 周鑫 on 2018/8/16.
//  Copyright © 2018年 LiangFengYouXin. All rights reserved.
//

#import "LXCameraControlView.h"
#import "LXCameraController.h"
#import "LXCameraFilterSelectView.h"
#import "LXCameraMaskView.h"
#import "LXCameraMaskModel.h"
#import "LXCameraMaskSelectView.h"
#import "LXCameraCaptureButton.h"
#import "LXCalculagraphLabel.h"

@interface LXCameraControlView ()<LXCameraFilterSelectViewDelegate,UIGestureRecognizerDelegate,LXCameraMaskSelectViewDelegate>

@property (nonatomic,weak) LXCameraCaptureButton *startCaptureBtn;  // 捕获按钮 (视频和图片)
@property (nonatomic,weak) UIView *pageView;         // 分页控制的父视图
@property (nonatomic,weak) UIPageControl *pageControl;  // 分页控制  标记当前捕获状态

@property (nonatomic,weak) LXCalculagraphLabel *timeLabel;   //计时器
@property (nonatomic,weak) UIButton *closeBtn;      // 关闭
@property (nonatomic,weak) UIImageView *previewImageView;    // 预览图
@property (nonatomic,weak) UIButton *filterBtn;           // 滤镜按钮
@property (nonatomic,weak) LXCameraFilterSelectView *filterSelectView;  // 滤镜选择View
@property (nonatomic,weak) UIButton *cameraPositionBtn;    // 相机位置（前后摄像头切换）
@property (nonatomic,weak) UIButton *flashModeBtn;       // 闪光灯模式
@property (nonatomic,weak) LXCameraMaskView *cameraMaskView;   // 相机模板
@property (nonatomic,weak) UIButton *maskSelelctBtn;     // 蒙版选择
@property (nonatomic,weak) LXCameraMaskSelectView *maskSelectView;


@property (nonatomic,assign) CGFloat effectiveScale;
@property (nonatomic,assign) CGFloat beginGestureScale;
@end
@implementation LXCameraControlView

//- (instancetype)initWithCameraController:(LXCameraController *)cameraController {
//    self = [super init];
//    if (self) {
//        self.cameraController = cameraController;
//        [self setupUI];
//    }
//    return self;
//}

- (instancetype)initWithFrame:(CGRect)frame  {
    self = [super initWithFrame:frame];
    if (self) {
        [self setupUI];
    }
    return self;
}

- (void)captureBtn:(LXCameraCaptureButton *)btn {
    
    btn.selected = !btn.selected;
    if (btn.selected) {
        [btn startCapture];
    } else {
        
        [btn finishCapture];
    }
    
}

- (void)setupUI {
    
    self.backgroundColor = [UIColor clearColor];
    __weak typeof(self) weakSelf = self;
    
//    LXCameraCaptureButton *captureBtn = [[LXCameraCaptureButton alloc]init];
//    [captureBtn setImage:[UIImage imageNamed:@"button_shot_nor"] forState:UIControlStateNormal];
//    [captureBtn addTarget:self action:@selector(captureBtn:) forControlEvents:UIControlEventTouchUpInside];
////    captureBtn.backgroundColor = [UIColor whiteColor];
//    [self addSubview:captureBtn];
//    [captureBtn mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.center.equalTo(self);
//        make.size.equalTo(CGSizeMake(70, 70));
//    }];
    
    
    LXCalculagraphLabel *timeLabel = [[LXCalculagraphLabel alloc]init];
    timeLabel.textAlignment = NSTextAlignmentCenter;
    timeLabel.textColor = [UIColor whiteColor];
    timeLabel.text = @"00:00:00";
    timeLabel.hidden = YES;
    [self addSubview:timeLabel];
    self.timeLabel = timeLabel;
    [self.timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(weakSelf);
        make.top.equalTo(weakSelf).offset(80);
        
    }];
    
    // 捕获按钮 (视频和图片)
    
    LXCameraCaptureButton *startCaptureBtn = [[LXCameraCaptureButton alloc]init];
//    startCaptureBtn.backgroundColor = [UIColor whiteColor];
//    startCaptureBtn.layer.cornerRadius = 40;
//    startCaptureBtn.layer.masksToBounds = YES;
    [startCaptureBtn setImage:[UIImage imageNamed:@"button_shot_nor"] forState:UIControlStateNormal];
    [startCaptureBtn addTarget:self action:@selector(startCaptureBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:startCaptureBtn];
    self.startCaptureBtn = startCaptureBtn;
    [self.startCaptureBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(weakSelf).offset(-40);
        make.centerX.equalTo(weakSelf);
        make.size.equalTo(CGSizeMake(70, 70));
    }];
    
    
    // 预览
    UIImageView *previewImageView = [[UIImageView alloc]init];
//    previewImageView.alpha = 0;
    [self addSubview:previewImageView];
    self.previewImageView = previewImageView;
    [self.previewImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf).offset(20);
        make.bottom.equalTo(weakSelf).offset(-40);
        make.size.equalTo(CGSizeMake(60, 60));
    }];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapPreviewImageV:)];
    [self.previewImageView addGestureRecognizer:tap];
    
    
    
    
    // 摄像头切换
    UIButton *cameraPositionBtn = [[UIButton alloc]init];
//    cameraPositionBtn.backgroundColor = [UIColor whiteColor];
    [cameraPositionBtn setImage:[UIImage imageNamed:@"icon_convert"] forState:UIControlStateNormal];
    [cameraPositionBtn addTarget:self action:@selector(cameraPositionBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:cameraPositionBtn];
    self.cameraPositionBtn = cameraPositionBtn;
    [self.cameraPositionBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf).offset(80);
        make.right.equalTo(weakSelf).offset(-20);
        make.size.equalTo(CGSizeMake(20, 20));
    }];
    
    
    // 闪光灯模式
    UIButton *flashModeBtn = [[UIButton alloc]init];
//    flashModeBtn.backgroundColor = [UIColor whiteColor];
    [flashModeBtn setImage:[UIImage imageNamed:@"icon_flashlight_auto"] forState:UIControlStateNormal];
    [flashModeBtn addTarget:self action:@selector(flashModeBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:flashModeBtn];
    self.flashModeBtn = flashModeBtn;
    [self.flashModeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf.cameraPositionBtn.mas_bottom).offset(20);
        make.right.equalTo(weakSelf.cameraPositionBtn.mas_right);
        make.size.equalTo(CGSizeMake(20, 20));
    }];
    
    
    
    // 关闭
    UIButton *closeBtn = [[UIButton alloc]init];
    //    flashModeBtn.backgroundColor = [UIColor whiteColor];
    [closeBtn setImage:[UIImage imageNamed:@"icon_close"] forState:UIControlStateNormal];
    [closeBtn addTarget:self action:@selector(closeBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:closeBtn];
    self.closeBtn = closeBtn;
    [self.closeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf).offset(80);
        make.left.equalTo(weakSelf).offset(20);
        make.size.equalTo(CGSizeMake(20, 20));
    }];
    
    
    [self setupPageView];
    [self setupFilterSelectView];
    [self setupFocalDistance];
    [self setupMaskView];
    
    
    
    
    
}


- (void)tapPreviewImageV:(UITapGestureRecognizer *)tap {
    
    if ([self.cameraController respondsToSelector:@selector(tapPreview:)]) {
        [self.cameraController tapPreview:self.previewImageView];
    }
}

- (void)closeBtnClicked:(UIButton *)btn  {
    
    if ([self.cameraController respondsToSelector:@selector(closeCamera:)]) {
        [self.cameraController closeCamera:btn];
    }
    
}

- (void)setupMaskView {
    
    __weak typeof(self) weakSelf = self;
    LXCameraMaskView *cameraMaskView = [[LXCameraMaskView alloc]init];
    cameraMaskView.MaskModel = [[LXCameraMaskModel alloc]initWithMaskTitle:@"16/9" maskType:LXCameraMaskType16_9];
    [cameraMaskView setNeedsDisplay];
    [self insertSubview:cameraMaskView atIndex:0];
    self.cameraMaskView = cameraMaskView;
    [self.cameraMaskView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(weakSelf);
    }];

    
    
    UIButton *maskSelelctBtn = [[UIButton alloc]init];
//    maskSelelctBtn.backgroundColor = [UIColor redColor];
    [maskSelelctBtn setImage:[UIImage imageNamed:@"绘制矩形"] forState:UIControlStateNormal];
    [maskSelelctBtn addTarget:self action:@selector(maskSelectBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:maskSelelctBtn];
    self.maskSelelctBtn = maskSelelctBtn;
    [self.maskSelelctBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(weakSelf.filterBtn.mas_left).offset(-20);
        make.bottom.equalTo(weakSelf.filterBtn);
        make.size.equalTo(CGSizeMake(44, 44));
    }];
    
    

    
    LXCameraMaskSelectView *maskSelectView = [[LXCameraMaskSelectView alloc]init];
    maskSelectView.delegate = self;
//    maskSelectView.backgroundColor = [UIColor redColor];
    [maskSelectView hide];
    [self addSubview:maskSelectView];
    self.maskSelectView = maskSelectView;
    [self.maskSelectView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf);
        make.right.equalTo(weakSelf);
        make.height.equalTo(66);
        make.bottom.equalTo(weakSelf).offset(-110);
    }];
    
    
    
}

- (void)maskSelectBtnClicked:(UIButton *)btn {
    
     [self.filterSelectView hide];
    if (self.maskSelectView.hidden) {
        [self.maskSelectView show];
    }else  {
        [self.maskSelectView hide];
    }
    
}
- (void)setupFilterSelectView {
    
    __weak typeof(self) weakSelf = self;
    // 滤镜
    UIButton *filterBtn = [[UIButton alloc]init];
//    filterBtn.backgroundColor = [UIColor redColor];
    [filterBtn setImage:[UIImage imageNamed:@"滤镜"] forState:UIControlStateNormal];
    [filterBtn addTarget:self action:@selector(filterBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:filterBtn];
    self.filterBtn = filterBtn;
    [self.filterBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(weakSelf).offset(-60);
        make.right.equalTo(weakSelf).offset(-20);
        make.size.equalTo(CGSizeMake(44, 44));
    }];
    
    
    LXCameraFilterSelectView *filterSelectView  = [[LXCameraFilterSelectView alloc]init];
    [filterSelectView hide];
    filterSelectView.delegate = self;
    [self addSubview:filterSelectView];
    self.filterSelectView = filterSelectView;
    [self.filterSelectView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf);
        make.right.equalTo(weakSelf);
        make.height.equalTo(66);
        make.bottom.equalTo(weakSelf).offset(-110);
        
    }];
    
    // 滑动手势 (切换滤镜)
    UISwipeGestureRecognizer  *swipeRightForFilter = [[UISwipeGestureRecognizer alloc]initWithTarget:self action:@selector(swipeGestureForFilter:)];
    swipeRightForFilter.direction = UISwipeGestureRecognizerDirectionRight;
    [self addGestureRecognizer:swipeRightForFilter];
    UISwipeGestureRecognizer *swipeLeftForFilter =[[UISwipeGestureRecognizer alloc]initWithTarget:self action:@selector(swipeGestureForFilter:)];
    swipeLeftForFilter.direction = UISwipeGestureRecognizerDirectionLeft;
    [self addGestureRecognizer:swipeLeftForFilter];
    
    
}
// 设置page分页控件和手势
- (void)setupPageView {
    
    __weak typeof(self) weakSelf = self;
    UIView *pageView = [[UIView alloc]init];
//    pageView.backgroundColor = [UIColor redColor];
    [self addSubview:pageView];
    self.pageView = pageView;
    [pageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(weakSelf);
        make.height.equalTo(40);
        make.bottom.equalTo(weakSelf);
    }];
    
    //分页
    UIPageControl *pageControl = [[UIPageControl alloc]init];
    //    pageControl.backgroundColor = [UIColor yellowColor];
    //    pageControl.enabled = NO;
    pageControl.numberOfPages = 2;
    pageControl.currentPage = 0;
    pageControl.currentPageIndicatorTintColor = [UIColor redColor];
    pageControl.pageIndicatorTintColor = [UIColor greenColor];
    [self.pageView addSubview:pageControl];
    self.pageControl = pageControl;
    [pageControl addTarget:self action:@selector(valueChangedForPageControl:) forControlEvents:(UIControlEventValueChanged)];
    [self.pageControl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(weakSelf.pageView);
        make.height.equalTo(20);
    }];
    
    
    // 滑动手势 (切换捕获模式)
    UISwipeGestureRecognizer  *swipeRightForPageView = [[UISwipeGestureRecognizer alloc]initWithTarget:self action:@selector(swipeGestureForPageView:)];
    swipeRightForPageView.direction = UISwipeGestureRecognizerDirectionRight;
    [self.pageView addGestureRecognizer:swipeRightForPageView];
    UISwipeGestureRecognizer *swipeLeftForPageView =[[UISwipeGestureRecognizer alloc]initWithTarget:self action:@selector(swipeGestureForPageView:)];
    swipeLeftForPageView.direction = UISwipeGestureRecognizerDirectionLeft;
    [self.pageView addGestureRecognizer:swipeLeftForPageView];
}

// 设置焦距
- (void)setupFocalDistance {
    
    UIPinchGestureRecognizer *pinch = [[UIPinchGestureRecognizer alloc] initWithTarget:self action:@selector(focalDistance:)];
    [self addGestureRecognizer:pinch];
    pinch.delegate = self;
}

- (void)filterBtnClick:(UIButton *)btn {
    
    [self.maskSelectView hide];
    if (self.filterSelectView.hidden) {
        [self.filterSelectView show];
    }else  {
        
         [self.filterSelectView hide];
    }
   
}
- (void)cameraPositionBtnClicked:(UIButton *)btn {
    
    if ([self.cameraController respondsToSelector:@selector(turnCameraPositionc)]) {
        [self.cameraController turnCameraPositionc];
    }
}

- (void)flashModeBtnClicked:(UIButton *)btn {
    
    if ([self.cameraController respondsToSelector:@selector(turnFlashMode)]) {
        [self.cameraController turnFlashMode];
    }
   
   
}




- (void)swipeGestureForPageView:(UISwipeGestureRecognizer *)swipe {
    
    LXCameraType cameraType = LXCameraTypeDefault;
    if (swipe.direction == UISwipeGestureRecognizerDirectionLeft) {
        cameraType = LXCameraTypeVideoCamera;
    }else if (swipe.direction == UISwipeGestureRecognizerDirectionRight) {
        cameraType = LXCameraTypeStillCamera;
    }
    
    if ([self.cameraController respondsToSelector:@selector(transformCameraType:)]) {
        [self.cameraController transformCameraType:cameraType];
    }
    
}

- (void)swipeGestureForFilter:(UISwipeGestureRecognizer *)swipe {
    
    if (swipe.direction == UISwipeGestureRecognizerDirectionLeft) {
       
        [self.filterSelectView nextFilter];
        
    }
    
    if (swipe.direction == UISwipeGestureRecognizerDirectionRight) {
         [self.filterSelectView lastFilter];
    }
}

//调整焦距方法
-(void)focalDistance:(UIPinchGestureRecognizer*)pinch {

    self.effectiveScale = self.beginGestureScale * pinch.scale;
    if (self.effectiveScale < 1.0f) {
        self.effectiveScale = 1.0f;
    }
    CGFloat maxScaleAndCropFactor = 3.0f;//设置最大放大倍数为3倍
    if (self.effectiveScale > maxScaleAndCropFactor)
        self.effectiveScale = maxScaleAndCropFactor;
    
    if ([self.cameraController respondsToSelector:@selector(setFocalDistancesScale:)]) {
        [self.cameraController setFocalDistancesScale:self.effectiveScale];
    }
}
- (void)valueChangedForPageControl:(UIPageControl *)pageControl {
    
//    if (pageControl.currentPage == 0) {
//        [self.cameraController transformCameraType:LXCameraTypeStillCamera];
//    } if (pageControl.currentPage == 1) {
//        [self.cameraController transformCameraType:LXCameraTypeVideoCamera];
//    }
    
}
- (void)startCaptureBtnClicked:(LXCameraCaptureButton *)startCaptureBtn {
    
    if ([self.cameraController respondsToSelector:@selector(startCapture)]) {
        [self.cameraController startCapture];
    }

   
}


#pragma mark -------------------------- setControView appearance ----------------------------------------


/**
 设置预览图

 @param PreviewImage <#PreviewImage description#>
 */
- (void)setPreviewImage:(UIImage *)PreviewImage {
    
    [UIView animateWithDuration:.2 animations:^{
        self.previewImageView.transform = CGAffineTransformMakeScale(0.9, 0.9);
        self.previewImageView.alpha = 0.7;
    } completion:^(BOOL finished) {
        self.previewImageView.transform = CGAffineTransformIdentity;
        self.previewImageView.alpha = 1;
        self.previewImageView.image = PreviewImage;
    }];
    
}


/**
 设置分页 和 计时器

 @param cameraType <#cameraType description#>
 */
- (void)setCameraType:(LXCameraType)cameraType {
    
    if (cameraType == LXCameraTypeStillCamera) {
         [self.pageControl setCurrentPage:0];
        self.timeLabel.hidden = YES;
        
    }else if (cameraType == LXCameraTypeVideoCamera) {
         [self.pageControl setCurrentPage:1];
        self.timeLabel.hidden = NO;
        
    }
}


/**
 设置摄像头位置

 @param position <#position description#>
 */
- (void)setCameraPosition:(AVCaptureDevicePosition)position {
    
    [UIView transitionWithView:self.cameraPositionBtn duration:.6 options:UIViewAnimationOptionTransitionFlipFromLeft|UIViewAnimationOptionCurveEaseOut animations:^{
//        self.cameraPositionBtn.backgroundColor = [UIColor yellowColor];
//        [self.cameraPositionBtn setImage:[UIImage imageNamed:@"icon_convert"] forState:UIControlStateNormal];
    } completion:^(BOOL finished) {
        
    }];
//    if (position == AVCaptureDevicePositionBack) {
//
//
//    }else if (position == AVCaptureDevicePositionFront) {
//
//
//    }
    
}


- (void)setFlashMode:(AVCaptureFlashMode)flashMode {
    
    [UIView transitionWithView:self.flashModeBtn duration:.6 options:UIViewAnimationOptionTransitionFlipFromLeft|UIViewAnimationOptionCurveEaseOut animations:^{
        UIImage *image;
        if (flashMode == AVCaptureFlashModeAuto) {
            image =  [UIImage imageNamed:@"icon_flashlight_auto"];
        }else if(flashMode == AVCaptureFlashModeOn) {
            image =  [UIImage imageNamed:@"Shape"];
        } else if (flashMode == AVCaptureFlashModeOff) {
            image =  [UIImage imageNamed:@"icon_flashlight_off"];
        }
        [self.flashModeBtn setImage:image forState:UIControlStateNormal];
        //        btn.backgroundColor = [UIColor yellowColor];
    } completion:^(BOOL finished) {
        
    }];
}

- (void)startVideoCapture {
    
    [self.startCaptureBtn startCapture];
    self.timeLabel.hidden = NO;
    [self.timeLabel startTime];
}

- (void)finishVideoCapture {
    
    [self.startCaptureBtn finishCapture];
    self.timeLabel.hidden = YES;
    [self.timeLabel finishTime];
}
#pragma mark -------------------------- Delegate ----------------------------------------
#pragma mark LXCameraMaskSelectViewDelegate
- (void)cameraMaskSelectView:(LXCameraMaskSelectView *)camerafilterSelectView maskModel:(LXCameraMaskModel *)maskModel
{
    self.cameraMaskView.maskModel = maskModel;
    
}

#pragma mark  Gesture delegate


//手势代理方法
- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer
{
    if ( [gestureRecognizer isKindOfClass:[UIPinchGestureRecognizer class]] ) {
        if (self.effectiveScale == 0) {
            self.effectiveScale = 1;
        }
        self.beginGestureScale = self.effectiveScale;
//        NSLog(@"-----beginGestureScale%f",self.beginGestureScale);
    }
    return YES;
}


#pragma mark -------------------------- LXCameraFilterSelectViewDelegate ----------------------------------------
- (void)camerafilterSelectView:(LXCameraFilterSelectView *)camerafilterSelectView filter:(GPUImageFilter *)filter {
    
    if ([self.cameraController respondsToSelector:@selector(setFilter:)]) {
        [self.cameraController setFilter:filter];
         
    }
}

#pragma mark -------------------------- lazy load  ----------------------------------------
- (UIBezierPath *)maskPath {
    return self.cameraMaskView.path;
}

@end
