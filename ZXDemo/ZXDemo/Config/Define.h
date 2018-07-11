//
//  Define.h
//  ZXDemo
//
//  Created by 周鑫 on 2018/7/11.
//  Copyright © 2018年 ZX. All rights reserved.
//

#ifndef Define_h
#define Define_h


#pragma mark -------------------------- Application ----------------------------------------

#define  SYSTEM_VERSION_VALUE   [UIDevice currentDevice].systemVersion

#define SYSTEM_VERSION_EQUAL_TO(v)                  ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedSame)
#define SYSTEM_VERSION_GREATER_THAN(v)              ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedDescending)
#define SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(v)  ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] != NSOrderedAscending)
#define SYSTEM_VERSION_LESS_THAN(v)                 ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedAscending)
#define SYSTEM_VERSION_LESS_THAN_OR_EQUAL_TO(v)     ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] != NSOrderedDescending)




#pragma mark -------------------------- Device ----------------------------------------

#define iPhone4 ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(640, 960), [[UIScreen mainScreen] currentMode].size) : NO)

#define iPhone6 ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(750, 1334), [[UIScreen mainScreen] currentMode].size) : NO)

#define iPhone5 ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(640, 1136), [[UIScreen mainScreen] currentMode].size) : NO)

#define iPhone6plus ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? (CGSizeEqualToSize(CGSizeMake(1125, 2001), [[UIScreen mainScreen] currentMode].size) || CGSizeEqualToSize(CGSizeMake(1242, 2208), [[UIScreen mainScreen] currentMode].size)) : NO)

#define iPhoneX ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(1125, 2436), [[UIScreen mainScreen] currentMode].size) : NO)




#pragma mark -------------------------- Colour ----------------------------------------

/**主题颜色*/
#define MotifColor UIColorFromRGB(0xfdf3d1)

/** 透明度为 1 的 RGB */
#define RGBCOLOR(r,g,b) [UIColor colorWithRed:(r)/255.0f green:(g)/255.0f blue:(b)/255.0f alpha:1]
/** RGBA */
#define RGBACOLOR(r,g,b,a) [UIColor colorWithRed:(r)/255.0f green:(g)/255.0f blue:(b)/255.0f alpha:(a)]
/** 使用十六进制的颜色*/
#define UIColorFromRGB(rgbValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]
/** 随机色 */
#define RandomColor [UIColor colorWithRed:arc4random_uniform(256)/255.0 green:arc4random_uniform(256)/255.0 blue:arc4random_uniform(256)/255.0 alpha:1.0]

/** 常用颜色*/
#define WhiteColor [UIColor whiteColor]
#define BlackColor [UIColor blackColor] //黑色
#define ClearColor [UIColor clearColor] //无色
#define GlobalBg  RGBCOLOR(243,243,243)



//---便捷颜色---color for test---用来 Debug 的颜色
#define PurpleColor    [UIColor purpleColor]   //紫色
#define RedColor       [UIColor redColor]
#define GrayColor      [UIColor grayColor]
#define YellowColor    [UIColor yellowColor]
#define GreenColor     [UIColor greenColor]
#define MagentaColor   [UIColor magentaColor] //品红,洋红 /mə'dʒentə/
#define BlueColor      [UIColor blueColor]
#define BrownColor     [UIColor brownColor]
#define AppColor       [UIColor colorWithRed:(113)/255.0f green:(205)/255.0f blue:(207)/255.0f alpha:1]




#pragma mark -------------------------- Path ----------------------------------------

#define PATH_OF_APP_HOME    NSHomeDirectory()
#define PATH_OF_TEMP        NSTemporaryDirectory()
#define PATH_OF_DOCUMENT    [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0]


#pragma mark -------------------------- size ----------------------------------------


#define SCREEN_WIDTH [UIScreen mainScreen].bounds.size.width
#define SCREEN_HEIGHT [UIScreen mainScreen].bounds.size.height

/** 状态条高度*/
#define SIZE_STATUSBAR_HEIGHT 20
/**导航条高度*/
#define SIZE_NAVBAR_HEIGHT 44
/** tabBar高度*/
#define SIZE_TABBAR_HEIGHT   49
/** 导航条整体高度 */
#define NavgationBar_Height 64

//适配iPhone x 底栏高度
//#define Tabbar_Height     ([[UIApplication sharedApplication] statusBarFrame].size.height>20?83:49)
#define VoiceSearchHeight 150


#define D_INTERVAL_LEFT  15
#define D_INTERVAL_RIGTH 15
#define D_INTERVAL       10
#define D_FONT_SIZE 17

#define FONT_SIZE_LITTLE 12
#define FONT_SIZE_BIG 25

#define getRectNavAndStatusHight  self.navigationController.navigationBar.frame.size.height+[[UIApplication sharedApplication] statusBarFrame].size.height




#pragma mark -------------------------- debug ----------------------------------------

//5.自定义高效率的 NSLog
#ifdef DEBUG
#define DEBUG_LOG(...) NSLog(@"%s 第%d行\n  %@\n\n",__func__,__LINE__,[NSString stringWithFormat:__VA_ARGS__])
#else
#define DEBUG_LOG(...)
#endif

#endif /* Define_h */
