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

@property (nonatomic,assign) CGPoint centerButtonPoint;
@end

@implementation ZXCustomTaBarController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setupUI];
    
//    DEBUG_LOG(@"%f %f %f",self.tabBar.frame.size.height,CGRectGetMinY(self.tabBar.frame),self.view.frame.size.height);
}

- (void)setupUI {
    
    // 利用KVC来使用自定义的tabBar
    self.customTabar = [[ZXCustomTabBar alloc] init];
    self.customTabar.customDelegate = self;
    [self setValue:self.customTabar forKey:@"tabBar"];
    
    [self addAllChildViewController];
    
    
}


- (void)viewWillAppear:(BOOL)animated {
    
  
  
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
    

    if (_noteButton && _avdioButton && _videoButton) {
        
        if (centreButton.selected) {
            
            [self unfoldAllOptions];
        
        }else {
            
            [self foldAllOptions];
        }
        
    
    }else {
        
        UIWindow *window = [UIApplication sharedApplication].keyWindow;
        CGRect position = [self.customTabar convertRect:centreButton.frame toView:window];
        CGPoint center = CGPointMake(CGRectGetMidX(position), CGRectGetMidY(position));
        CGFloat W = 44;
        CGFloat H = 44;
        CGFloat X = center.x - W/2;
        CGFloat Y = center.y - H/2;
        self.centerButtonPoint = center;
        
        self.noteButton.frame = CGRectMake(X, Y, W, H);
        [window addSubview:self.noteButton];
        self.avdioButton.frame = CGRectMake(X, Y, W, H);
        [window addSubview:self.avdioButton];
        self.videoButton.frame = CGRectMake(X, Y, W, H);
        [window addSubview:self.videoButton];
        [self unfoldAllOptions];
        
    }
   
   
    

}

- (void)unfoldAllOptions {
    
    
    [self unfoldOptionWithRadius:120 Angle:45.0 Delay:.1 target:self.noteButton];
    [self unfoldOptionWithRadius:120 Angle:90.0 Delay:.2 target:self.avdioButton];
    [self unfoldOptionWithRadius:120 Angle:135.0 Delay:.3 target:self.videoButton];
}


- (void)foldAllOptions {
    
    [self foldOptionWithRadius:120 Angle:135.0 Delay:.1 target:self.videoButton];
    [self foldOptionWithRadius:120 Angle:90.0 Delay:.2 target:self.avdioButton];
    [self foldOptionWithRadius:120 Angle:45.0 Delay:.3 target:self.noteButton];
    
   
    
}

- (void)unfoldOptionWithRadius:(CGFloat)radius Angle:(CGFloat)angle Delay:(CGFloat)delay target:(UIView *)target {
    
    CGFloat centerX = target.center.x;
    CGFloat centerY = target.center.y;
    CGFloat W = target.frame.size.width;
    CGFloat H = target.frame.size.height;
    CGFloat locationX = sin(angle) * radius;
    CGFloat locationY = cos(angle) * radius;
    
    CGFloat toCenterX = 0;
    CGFloat toCenterY = 0;
    if (angle < 90.0) {
        toCenterX = centerX - locationX ;
        toCenterY = centerY - locationY ;
    }else if(angle == 90.0) {
        toCenterX = centerX;
        toCenterY = centerY - radius;
    }else if(angle > 90.0 ) {
        toCenterX = centerX + sin(angle - 90) * radius;;
        toCenterY = centerY - cos(angle - 90) * radius;
        
    }
   
    
    [UIView animateWithDuration:.6 delay:delay usingSpringWithDamping:.9 initialSpringVelocity:30 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        target.center = CGPointMake(toCenterX, toCenterY);
    } completion:^(BOOL finished) {}];
    
    [UIView animateWithDuration:.05 delay: delay options:UIViewAnimationOptionCurveEaseIn animations:^{
        target.alpha = 1;
    } completion:^(BOOL finished) {}];
    
    
    
}


- (void)foldOptionWithRadius:(CGFloat)radius Angle:(CGFloat)angle Delay:(CGFloat)delay target:(UIView *)target {
    
    CGFloat toCenterX = self.centerButtonPoint.x;
    CGFloat toCenterY = self.centerButtonPoint.y;
    
    
    
    [UIView animateWithDuration:.6 delay:delay usingSpringWithDamping:.9 initialSpringVelocity:30 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        target.center = CGPointMake(toCenterX, toCenterY);
    } completion:^(BOOL finished) {}];
    
    [UIView animateWithDuration:.03 delay: delay options:UIViewAnimationOptionCurveEaseIn animations:^{
        target.alpha = 0;
    } completion:^(BOOL finished) {}];
    
    
}


#pragma mark -------------------------- lazy load ----------------------------------------
- (UIButton *)noteButton {
    
    if (!_noteButton) {
        _noteButton = [[UIButton alloc]init];
        _noteButton.backgroundColor = RandomColor;
        _noteButton.alpha = 0;
        _noteButton.layer.cornerRadius = 22;
        _noteButton.layer.masksToBounds = YES;
        
    }
    return _noteButton;
}

- (UIButton *)avdioButton {
    
    if (!_avdioButton) {
        _avdioButton = [[UIButton alloc]init];
        _avdioButton.backgroundColor = RandomColor;
        _avdioButton.alpha = 0;
        _avdioButton.layer.cornerRadius = 22;
        _avdioButton.layer.masksToBounds = YES;
    }
    return _avdioButton;
}

- (UIButton *)videoButton {
    
    if (!_videoButton) {
        _videoButton = [[UIButton alloc]init];
        _videoButton.backgroundColor = RandomColor;
        _videoButton.alpha = 0;
        _videoButton.layer.cornerRadius = 22;
        _videoButton.layer.masksToBounds = YES;
    }
    return _videoButton;
}

@end
