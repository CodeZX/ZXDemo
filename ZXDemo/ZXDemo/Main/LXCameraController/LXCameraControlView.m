//
//  LXCameraControlView.m
//  LiangFengYouXin
//
//  Created by 周鑫 on 2018/8/16.
//  Copyright © 2018年 LiangFengYouXin. All rights reserved.
//

#import "LXCameraControlView.h"
#import "LXCameraController.h"

@interface LXCameraControlView ()

@property (nonatomic,weak) UIButton *startCaptureBtn;  // 捕获按钮 (视频和图片)
@property (nonatomic,weak) UIPageControl *pageControl;  // 分页控制  标记当前捕获状态

@property (nonatomic,weak) UIImageView *previewImageView;
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


- (void)setupUI {
    
    self.backgroundColor = [UIColor clearColor];
    
    
    // 捕获按钮 (视频和图片)
    __weak typeof(self) weakSelf = self;
    UIButton *startCaptureBtn = [[UIButton alloc]init];
    startCaptureBtn.backgroundColor = [UIColor redColor];
    startCaptureBtn.layer.cornerRadius = 40;
    startCaptureBtn.layer.masksToBounds = YES;
    [startCaptureBtn addTarget:self action:@selector(startCaptureBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:startCaptureBtn];
    self.startCaptureBtn = startCaptureBtn;
    [self.startCaptureBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(weakSelf).offset(-40);
        make.centerX.equalTo(weakSelf);
        make.size.equalTo(CGSizeMake(80, 80));
    }];
    
    
    //分页
    UIPageControl *pageControl = [[UIPageControl alloc]init];
//    pageControl.backgroundColor = [UIColor yellowColor];
//    pageControl.enabled = NO;
    pageControl.numberOfPages = 2;
    pageControl.currentPage = 0;
    pageControl.currentPageIndicatorTintColor = [UIColor redColor];
    pageControl.pageIndicatorTintColor = [UIColor greenColor];
    [self addSubview:pageControl];
    self.pageControl = pageControl;
    [pageControl addTarget:self action:@selector(valueChangedForPageControl:) forControlEvents:(UIControlEventValueChanged)];
    [self.pageControl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(weakSelf).offset(-20);
        make.centerX.equalTo(weakSelf);
        make.height.equalTo(20);
    }];
    
    
    // 滑动手势
    UISwipeGestureRecognizer  *swipeRight = [[UISwipeGestureRecognizer alloc]initWithTarget:self action:@selector(swipeGesture:)];
    swipeRight.direction = UISwipeGestureRecognizerDirectionRight;
    [self addGestureRecognizer:swipeRight];
    UISwipeGestureRecognizer *swipeLeft =[[UISwipeGestureRecognizer alloc]initWithTarget:self action:@selector(swipeGesture:)];
    swipeLeft.direction = UISwipeGestureRecognizerDirectionLeft;
    [self addGestureRecognizer:swipeLeft];
    
    
    UIImageView *previewImageView = [[UIImageView alloc]init];
    [self addSubview:previewImageView];
    self.previewImageView = previewImageView;
    [self.previewImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf).offset(20);
        make.bottom.equalTo(weakSelf).offset(-20);
        make.size.equalTo(CGSizeMake(80, 80));
    }];
    
}

- (void)swipeGesture:(UISwipeGestureRecognizer *)swipe {
    
    if (swipe.direction == UISwipeGestureRecognizerDirectionLeft) {
        [self.pageControl setCurrentPage:1];
        [self.cameraController transformCameraType:LXCameraTypeVideoCamera];
    }
    
    if (swipe.direction == UISwipeGestureRecognizerDirectionRight) {
        [self.pageControl setCurrentPage:0];
        [self.cameraController transformCameraType:LXCameraTypeStillCamera];
    }
}

- (void)valueChangedForPageControl:(UIPageControl *)pageControl {
    
//    if (pageControl.currentPage == 0) {
//        [self.cameraController transformCameraType:LXCameraTypeStillCamera];
//    } if (pageControl.currentPage == 1) {
//        [self.cameraController transformCameraType:LXCameraTypeVideoCamera];
//    }
    
}
- (void)startCaptureBtnClicked:(UIButton *)startCaptureBtn {
    
    startCaptureBtn.selected = !startCaptureBtn.selected;
    if (startCaptureBtn.selected) {
        if([self.cameraController respondsToSelector:@selector(startCapture:completionHandler:)]) {
//            [self.cameraController startCapture:startCaptureBtn];
            [self.cameraController startCapture:startCaptureBtn completionHandler:^(BOOL success, UIImage *image, NSError *error) {
                
                self.previewImageView.image = image;
            }];
        }
    }else {
        if ([self.cameraController respondsToSelector:@selector(stopCapture:completionHandler:)]) {
//            [self.cameraController stopCapture:startCaptureBtn];
            [self.cameraController stopCapture:startCaptureBtn completionHandler:^(BOOL success, UIImage *image, NSString *path, NSError *error) {
                
            }];
        }
        
    }
    
   
}

@end
