//
//  LXCameraMaskSelectView.h
//  ZXDemo
//
//  Created by 周鑫 on 2018/9/3.
//  Copyright © 2018年 ZX. All rights reserved.
//

#import <UIKit/UIKit.h>


@class LXCameraMaskSelectView,GPUImageFilter,LXCameraMaskModel;
@protocol LXCameraMaskSelectViewDelegate <NSObject>
- (void)cameraMaskSelectView:(LXCameraMaskSelectView *)cameraMaskSelectView maskModel:(LXCameraMaskModel *)maskModel;

@end
@interface LXCameraMaskSelectView : UICollectionViewCell
@property (nonatomic,weak) id<LXCameraMaskSelectViewDelegate> delegate;
- (void)nextFilter;
- (void)lastFilter;
- (void)show;
- (void)hide;
@end
