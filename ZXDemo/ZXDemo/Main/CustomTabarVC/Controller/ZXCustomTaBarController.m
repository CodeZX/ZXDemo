//
//  ZXCustomTabBarController.m
//  ZXDemo
//
//  Created by 周鑫 on 2018/7/11.
//  Copyright © 2018年 ZX. All rights reserved.
//

#import "ZXCustomTaBarController.h"
#import "ZXOneViewController.h"
#import "ZXTwoViewController.h"
#import "ZXCustomTabBar.h"

@interface ZXCustomTaBarController ()<ZXCustomTabBarDelegate>

@property (nonatomic,strong) ZXCustomTabBar *customTabar;
@end

@implementation ZXCustomTaBarController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setupUI];
}

- (void)setupUI {
    
    // 利用KVO来使用自定义的tabBar
    self.customTabar = [[ZXCustomTabBar alloc] init];
    self.customTabar.customDelegate = self;
    [self setValue:self.customTabar forKey:@"tabBar"];
    
    [self addAllChildViewController];
}


- (void)addAllChildViewController {
    
    ZXOneViewController *VC1 = [[ZXOneViewController alloc]init];
    [self addController:VC1 withTitle:@"One" imageName:@"" selectedImageName:@""];
    
    ZXTwoViewController *VC2 = [[ZXTwoViewController  alloc]init];
    [self addController:VC2 withTitle:@"Two" imageName:@"" selectedImageName:@""];
    
}




#pragma mark - 添加子视图控制器
- (void)addController:(UIViewController *)controller withTitle:(NSString *)title imageName:(NSString *)imageName selectedImageName:(NSString *)selectedImageName {
    
    // 设置tabBarItem的子视图
    controller.tabBarItem.title = title;
    controller.tabBarItem.image = [[UIImage imageNamed:imageName] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    controller.tabBarItem.selectedImage = [[UIImage imageNamed:selectedImageName] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    
    // 将视图控制器添加到标签栏控制器中
    [self addChildViewController:controller];
    

}

#pragma mark -------------------------- zxCustomTaBarDelegate ----------------------------------------

- (void)customTabBar:(ZXCustomTabBar *)customTabBar didClickForCentreButton:(UIButton *)centreButton {
    
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"点击了中间的按钮" message:@"do something!" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *action = [UIAlertAction actionWithTitle:@"知道了" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            [alertController dismissViewControllerAnimated:YES completion:nil];
        }];
        [alertController addAction:action];
    [self presentViewController:alertController animated:YES completion:nil];
}

#pragma mark -------------------------- lazy load ----------------------------------------



@end
