//
//  ZXCustomTabBar.h
//  ZXDemo
//
//  Created by 周鑫 on 2018/7/11.
//  Copyright © 2018年 ZX. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ZXCustomTabBar;
@protocol  ZXCustomTabBarDelegate <NSObject>
@optional
- (void)customTabBar:(ZXCustomTabBar *)customTabBar didClickForCentreButton:(UIButton *)centreButton;
@required
@end
@interface ZXCustomTabBar : UITabBar
@property (nonatomic, strong) UIButton *centerBtn;
@property (nonatomic,weak) id<ZXCustomTabBarDelegate> customDelegate;
@end
