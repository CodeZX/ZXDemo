//
//  LXCameraCaptureButton.m
//  ZXDemo
//
//  Created by 周鑫 on 2018/9/8.
//  Copyright © 2018年 ZX. All rights reserved.
//

#import "LXCameraCaptureButton.h"

@interface LXCameraCaptureButton ()

@property (nonatomic,strong) CAShapeLayer *circleLayer;
@end

@implementation LXCameraCaptureButton

- (void)layoutSubviews {
    [super layoutSubviews];
  
}

- (void)startCapture{
    
    
    CABasicAnimation *pathAnimation = [CABasicAnimation animationWithKeyPath:@"path"];
    pathAnimation.duration = 3.0;
//    animation.toValue = [NSValue valueWithCATransform3D:CATransform3DMakeScale(1.5, 1.5, 1.5)];
    pathAnimation.toValue = (__bridge id _Nullable)([self animationPtha].CGPath);;
//    animation.toValue = @10;
    pathAnimation.repeatCount = MAXFLOAT;
    pathAnimation.removedOnCompletion = NO;
    pathAnimation.fillMode = kCAFillModeForwards;
    [self.circleLayer addAnimation:pathAnimation forKey:@"circleLayer.path"];
    
    
    CABasicAnimation *opacityAnimation = [CABasicAnimation animationWithKeyPath:@"opacity"];
    opacityAnimation.fromValue = [NSNumber numberWithFloat:0.6];
    opacityAnimation.toValue = [NSNumber numberWithFloat:0.0];
    opacityAnimation.duration = 3.0;
    opacityAnimation.repeatCount = MAXFLOAT;
    [self.circleLayer addAnimation:opacityAnimation forKey:@"circleLayer.opacity"];
    
    CABasicAnimation *lineWidthAnimation = [CABasicAnimation animationWithKeyPath:@"lineWidth"];
//    lineWidthAnimation.fromValue = [NSNumber numberWithFloat:0.6];
    lineWidthAnimation.toValue = [NSNumber numberWithFloat:5];
    lineWidthAnimation.duration = 3.0;
    lineWidthAnimation.repeatCount = MAXFLOAT;
    [self.circleLayer addAnimation:lineWidthAnimation forKey:@"circleLayer.lineWidth"];
}

- (void)finishCapture {
    
    [self.circleLayer removeAllAnimations];
    [self.circleLayer removeFromSuperlayer];
    self.circleLayer = nil;
}

- (UIBezierPath *)animationPtha {
    
    CGFloat X,Y,W,H,offset;
    offset = -40;
    X = 0;
    Y = 0;
    W = self.frame.size.width;
    H = self.frame.size.height;
    CGRect endRect = CGRectInset(CGRectMake(X, Y, W, H),offset,offset);
    UIBezierPath *path = [UIBezierPath bezierPathWithOvalInRect:endRect];
    return path;
}

#pragma mark -------------------------- lazy load  ----------------------------------------

- (CAShapeLayer *)circleLayer {
    if (!_circleLayer) {
        _circleLayer = [[CAShapeLayer alloc]init];

        CGFloat X,Y,W,H;
        X = 0;
        Y = 0;
        W = self.frame.size.width;
        H = self.frame.size.height;
        UIBezierPath *path = [UIBezierPath bezierPathWithOvalInRect: CGRectMake(X, Y, W, H)];
        _circleLayer.path = path.CGPath;
        _circleLayer.lineWidth = 2.f;
        _circleLayer.strokeColor = [UIColor whiteColor].CGColor;
        //    circleLayer.fillColor = [UIColor clearColor].CGColor;
        //    [self.layer addSublayer:circleLayer];
        [self.layer insertSublayer:_circleLayer below:self.imageView.layer];
    }
    return _circleLayer;
}
@end
