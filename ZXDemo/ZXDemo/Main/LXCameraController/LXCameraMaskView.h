//
//  LXCameraMaskView.h
//  ZXDemo
//
//  Created by 周鑫 on 2018/9/3.
//  Copyright © 2018年 ZX. All rights reserved.
//

#import <UIKit/UIKit.h>

@class LXCameraMaskModel;
@interface LXCameraMaskView : UIView
@property (nonatomic,strong) UIBezierPath *path;
@property (nonatomic,strong) LXCameraMaskModel *maskModel;

@end
