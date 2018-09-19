//
//  ZXCameraViewController.m
//  ZXDemo
//
//  Created by 周鑫 on 2018/8/20.
//  Copyright © 2018年 ZX. All rights reserved.
//

#import "ZXCameraViewController.h"
#import "LXCameraController.h"
#import "LXCameraManager.h"
#import "LXCameraControlView.h"

@interface ZXCameraViewController ()<LXCameraControllerDelegate>

// 相机管理
@property (nonatomic,strong) LXCameraManager *cameraManage;
// 相机管理
@property (nonatomic,strong) LXCameraController *cameraConttroller;
@end

@implementation ZXCameraViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupUI];
}


- (void)setupUI {
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    LXCameraManager *cameraManage = [[LXCameraManager alloc]init];
    LXCameraControlView *cameraControlView = [[LXCameraControlView alloc]initWithFrame:self.view.frame];
    
    self.cameraConttroller = [LXCameraController cameraWithCameraManager:cameraManage  cameraControlView:cameraControlView containerView:self.view];
    self.cameraConttroller.delegate = self;
   
    
}

#pragma mark -------------------------- Delegate ----------------------------------------
#pragma mark LXCameraControllerDelegate

- (void)cameraController:(LXCameraController *)cameraController didClose:(UIButton *)closeBtn {
    
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)cameraController:(LXCameraController *)cameraController didSetting:(UIButton *)SettingBtn {
    
    UIViewController *VC = [[UIViewController alloc]init];
    [self.navigationController pushViewController:VC animated:YES];
    
}

- (void)cameraController:(LXCameraController *)cameraController didTapPreviewImageV:(UIImageView *)PreviewImageV {
    
    UIViewController *VC = [[UIViewController alloc]init];
    [self.navigationController pushViewController:VC animated:YES];
}

@end
