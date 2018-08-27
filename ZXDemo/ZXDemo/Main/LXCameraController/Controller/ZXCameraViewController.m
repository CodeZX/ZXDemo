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

@interface ZXCameraViewController ()

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
   
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
