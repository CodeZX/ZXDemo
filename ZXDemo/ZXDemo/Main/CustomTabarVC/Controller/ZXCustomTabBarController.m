//
//  ZXCustomTabBarController.m
//  ZXDemo
//
//  Created by 周鑫 on 2018/7/11.
//  Copyright © 2018年 ZX. All rights reserved.
//

#import "ZXCustomTabBarController.h"
#import "ZXOneViewController.h"
#import "ZXTwoViewController.h"
#import "ZXCustomTabBar.h"

@interface ZXCustomTabBarController ()

@property (nonatomic,strong) UITabBar *zxCustomTabBar;
@end

@implementation ZXCustomTabBarController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setupChildVC];
}

- (void)viewWillAppear:(BOOL)animated {
    
    // 2.删除自动创建的tabBarButton
    for (UIView *view in self.tabBar.subviews) {
        // 打印tabBar上所有控件
        NSLog(@"%@",self.tabBar.subviews);
        // 移除tabBar上所有的子控件
        [view removeFromSuperview];
    }
    // 把self.wj_tabBar添加到视图上
    [self.tabBar addSubview:self.zxCustomTabBar];
    
    
}

- (void)setupChildVC {
    
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
    
    // 可以让自己定制的tabBar去创建一个对应的按钮
//    [self.wj_tabBar addButtonWithTabBarItem:controller.tabBarItem];
    
    /* 测试的
     static int i = 0;
     if (i == 0) {
     WJTabBarButton *button = [[WJTabBarButton alloc]initWithFrame:CGRectMake(10, 0, 45, 45)];
     button.item = controller.tabBarItem;
     
     button.normalColor = [UIColor blueColor];
     button.selectedColor = [UIColor greenColor];
     [button addTarget:self action:@selector(firstClick:)];
     [self.wj_tabBar addSubview:button];
     i = 1;
     }
     */
}

#pragma mark -------------------------- lazy load ----------------------------------------

- (UITabBar *)zxCustomTabBar {
    
    if (!_zxCustomTabBar) {
        _zxCustomTabBar = [[ZXCustomTabBar alloc]init];
        _zxCustomTabBar.frame = self.tabBar.frame;
        _zxCustomTabBar.backgroundColor = [UIColor whiteColor];
    }
    return _zxCustomTabBar;;
}


@end
