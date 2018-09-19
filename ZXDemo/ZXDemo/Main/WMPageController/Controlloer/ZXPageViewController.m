//
//  ZXPageViewController.m
//  ZXDemo
//
//  Created by 周鑫 on 2018/9/18.
//  Copyright © 2018年 ZX. All rights reserved.
//

#import "ZXPageViewController.h"

@interface ZXPageViewController ()

@end

@implementation ZXPageViewController

//初始化方法
- (instancetype)init
{
    if (self = [super init]) {
        //        self.menuBGColor = YGRGBColor(60 , 158, 243);
        
//        self.menuViewStyle = WMMenuViewStyleLine;
        self.menuViewLayoutMode = WMMenuViewLayoutModeCenter;
        self.menuViewStyle = WMMenuViewStyleDefault;
        self.titleSizeNormal = 14;
        self.titleSizeSelected = 16;
//        self.showOnNavigationBar = YES;
        self.titleColorSelected = [UIColor redColor];

        self.automaticallyCalculatesItemWidths = YES; //根据题目的内容自动算宽度
        self.itemMargin = 30; //题目的间距
//        self.selectIndex = 1;
        //        self.menuHeight = 44;
    }
    return self;
}

//- (NSArray<NSString *> *)titles
//{
//    return @[@"最新", @"推荐", @"分类"];
//}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
//    self.title = @"page";
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


//- (NSInteger)numbersOfTitlesInMenuView:(WMMenuView *)menu {
//    return 3;
//}
- (NSInteger)numbersOfChildControllersInPageController:(WMPageController *)pageController {
    
    return 3;
}

- (UIViewController *)pageController:(WMPageController *)pageController viewControllerAtIndex:(NSInteger)index {
    
//    if (index == 0) {
//        return [[TJHomeViewController alloc]init];
//    } else if (index == 1) {
//        return [[TJAuntExistenceViewController alloc]init];
//    }
    UIViewController *VC = [[UIViewController alloc]init];
    VC.view.backgroundColor = [UIColor redColor];
    return VC;
}

- (NSString *)pageController:(WMPageController *)pageController titleAtIndex:(NSInteger)index {
    
//    if (index == 0) {
//        return @"首页";
//    } else if (index == 1) {
//        return @"阿姨生活";
//    }
    return @"标题";
}

- (CGRect)pageController:(WMPageController *)pageController preferredFrameForMenuView:(WMMenuView *)menuView {
    
    return CGRectMake(0, 100, SCREEN_WIDTH, 44);
}

- (CGRect)pageController:(WMPageController *)pageController preferredFrameForContentView:(WMScrollView *)contentView {
    
    
    return CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT);
    
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
