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


// 类型选择按钮
@property (nonatomic,strong) UIButton *noteButton;
@property (nonatomic,strong) UIButton *avdioButton;
@property (nonatomic,strong) UIButton *videoButton;
@end

@implementation ZXCustomTaBarController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setupUI];
    
//    DEBUG_LOG(@"%f %f %f",self.tabBar.frame.size.height,CGRectGetMinY(self.tabBar.frame),self.view.frame.size.height);
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
    
//        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"点击了中间的按钮" message:@"do something!" preferredStyle:UIAlertControllerStyleAlert];
//        UIAlertAction *action = [UIAlertAction actionWithTitle:@"知道了" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
//            [alertController dismissViewControllerAnimated:YES completion:nil];
//        }];
//        [alertController addAction:action];
//    [self presentViewController:alertController animated:YES completion:nil];
    
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    CGRect position = [self.tabBar convertRect:centreButton.frame toView:window];
    CGPoint center = CGPointMake(CGRectGetMidX(position), CGRectGetMidY(position));
    CGFloat W = 44;
    CGFloat H = 44;
    CGFloat X = center.x - W/2;
    CGFloat Y = center.y - H/2;
    
   
    self.noteButton.frame = CGRectMake(X, Y, W, H);
    [window addSubview:self.noteButton];
    self.avdioButton.frame = CGRectMake(X, Y, W, H);
    [window addSubview:self.avdioButton];
    self.videoButton.frame = CGRectMake(X, Y, W, H);
    [window addSubview:self.videoButton];
    
    
    [UIView animateWithDuration:.5 animations:^{
        self.noteButton.alpha = 1;
        self.noteButton.frame = CGRectMake(X - 100, Y - 100, W, H);
    }];
    
    
    [UIView animateWithDuration:.5 delay:.3 options:UIViewAnimationOptionCurveEaseIn animations:^{
        self.avdioButton.alpha = 1;
        self.avdioButton.frame = CGRectMake(X, Y - 100, W, H);
    } completion:^(BOOL finished) {
        
    }];
    
    
    [UIView animateWithDuration:.5 delay:.5 options:UIViewAnimationOptionCurveEaseIn animations:^{
        self.videoButton.alpha = 1;
        self.videoButton.frame = CGRectMake(X + 100, Y - 100, W, H);
    } completion:^(BOOL finished) {
        
    }];
    
    UIView animateKeyframesWithDuration:<#(NSTimeInterval)#> delay:<#(NSTimeInterval)#> options:<#(UIViewKeyframeAnimationOptions)#> animations:<#^(void)animations#> completion:<#^(BOOL finished)completion#>
    
}

#pragma mark -------------------------- lazy load ----------------------------------------
- (UIButton *)noteButton {
    
    if (!_noteButton) {
        _noteButton = [[UIButton alloc]init];
        _noteButton.backgroundColor = RandomColor;
        _avdioButton.alpha = 0;
        
    }
    return _noteButton;
}

- (UIButton *)avdioButton {
    
    if (!_avdioButton) {
        _avdioButton = [[UIButton alloc]init];
        _avdioButton.backgroundColor = RandomColor;
        _avdioButton.alpha = 0;
    }
    return _avdioButton;
}

- (UIButton *)videoButton {
    
    if (!_videoButton) {
        _videoButton = [[UIButton alloc]init];
        _videoButton.backgroundColor = RandomColor;
        _videoButton.alpha = 0;
    }
    return _videoButton;
}

@end
