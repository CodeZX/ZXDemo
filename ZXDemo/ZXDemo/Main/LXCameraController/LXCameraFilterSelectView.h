//
//  LXCameraFilterSelectView.h
//  ZXDemo
//
//  Created by 周鑫 on 2018/8/30.
//  Copyright © 2018年 ZX. All rights reserved.
//

#import <UIKit/UIKit.h>

@class LXCameraFilterSelectView,GPUImageFilter;
@protocol LXCameraFilterSelectViewDelegate <NSObject>
- (void)camerafilterSelectView:(LXCameraFilterSelectView *)camerafilterSelectView filter:(GPUImageFilter *)filter;

@end


@interface LXCameraFilterSelectView : UIView
@property (nonatomic,weak) id<LXCameraFilterSelectViewDelegate> delegate;
- (void)nextFilter;
- (void)lastFilter;
- (void)show;
- (void)hide;
@end
