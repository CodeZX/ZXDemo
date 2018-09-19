//
//  LXCameraMaskView.m
//  ZXDemo
//
//  Created by 周鑫 on 2018/9/3.
//  Copyright © 2018年 ZX. All rights reserved.
//

#import "LXCameraMaskView.h"
#import "LXCameraMaskModel.h"

@interface LXCameraMaskView ()

//@property (nonatomic,strong) UIBezierPath *path;
@property (nonatomic,strong) UIColor *maskColor;
@end

@implementation LXCameraMaskView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        
        self.backgroundColor = [UIColor clearColor];
        self.maskColor = RGBACOLOR(179, 179, 179, 0.75);
    }
    
    return self;
}
- (void)setMaskModel:(LXCameraMaskModel *)maskModel {
    _maskModel = maskModel;
    [self setNeedsDisplay];
}
- (void)drawRect:(CGRect)rect {
    
    switch (self.maskModel.maskType) {
        case LXCameraMaskType1_1:
        {
            [self drawe1X1MaskInRect:rect];
            break;
            
        }
        case LXCameraMaskType4_3:
        {
            [self drawe4X3MaskInRect:rect];
            break;
            
        }
        case LXCameraMaskType16_9:
        {
            [self drawe16X9MaskInRect:rect];
            break;
            
        }
        case LXCameraMaskTypeRound:
        {
            [self drawRoundMaskInRect:rect];
            break;
            
        }
        case LXCameraMaskTypeOval:
        {
            [self drawOvalMaskInRect:rect];
            break;
            
        }
        case LXCameraMaskTypePentagon:
        {
            [self drawPentagonInRect:rect];
            break;
            
        }
        case LXCameraMaskTypeTriangle:
        {
            [self drawTriangleInRect:rect];
            break;
            
        }
            
            
        default:
            break;
    }
    
    
    
}

- (void)drawe1X1MaskInRect:(CGRect)rect {
    
    CGFloat X,Y,W,H;
    W = MIN(rect.size.width,rect.size.height);
    H = W;
    if (rect.size.width < rect.size.height) {
        Y = (rect.size.height - rect.size.width)/2;
        X = 0;
    }else{
        X = (rect.size.width - rect.size.height)/2;
        Y = 0;
    }

    self.path = [UIBezierPath bezierPathWithRect:CGRectMake(X, Y, W, H)];
    [self maskFillInRect:rect path:_path color:self.maskColor];
}


- (void)drawe4X3MaskInRect:(CGRect)rect
{
    CGFloat X,Y,W,H;
    if (rect.size.width < rect.size.height) {
             W = rect.size.width;
             H = W*4/3;
             X = 0;
             Y = (rect.size.height - H)/2;
    }else{
             H = rect.size.height;
             W = H*4/3;
             X = (rect.size.width - W)/2;
             Y = 0;
        }
    
    self.path = [UIBezierPath bezierPathWithRect:CGRectMake(X,Y,W,H)];
    [self maskFillInRect:rect path:_path color:self.maskColor];
}

- (void)drawe16X9MaskInRect:(CGRect)rect {
    
    CGFloat X,Y,W,H;
    
    Y = rect.origin.y;
    H = rect.size.height;
    X = rect.origin.x;
    W = rect.size.width;
    
    self.path = [UIBezierPath bezierPathWithRect:CGRectMake(X,Y,W,H)];
    [self maskFillInRect:rect path:_path color:self.maskColor];
    
}

- (void)drawRoundMaskInRect:(CGRect)rect {
    
    self.path = [UIBezierPath bezierPathWithArcCenter:CGPointMake(rect.size.width/2, rect.size.height/2)
                                           radius:MIN(rect.size.width/2,rect.size.height/2)
                                       startAngle:0
                                         endAngle:180
                                        clockwise:YES];
    [self maskFillInRect:rect path:_path color:self.maskColor];
}

- (void)drawOvalMaskInRect:(CGRect)rect {
    
    CGFloat X,Y,W,H;
    if (rect.size.width <= rect.size.height) {
        W = rect.size.width;
        H = W*3/4;
        Y = (rect.size.height - H)/2;
        X = 0;
    }else{
        H = rect.size.height;
        W = H*3/4;
        X = (rect.size.width - W)/2;
        Y = 0;
    }
    self.path = [UIBezierPath bezierPathWithOvalInRect:CGRectMake(X, Y, W, H)];
    [self maskFillInRect:rect path:_path color:self.maskColor];
}

- (void)drawTriangleInRect:(CGRect)rect {
    
//    _path = [UIBezierPath bezierPath];
//
//    if (rect.size.width <= rect.size.height) {
//        if (_pinchGest.state == UIGestureRecognizerStateChanged) {
//            _triangleHeight = _triangleHeight + _pinchGest.velocity*kVelocityMultiple;
//            if (_triangleHeight > rect.size.height) {
//                _triangleHeight = rect.size.height;
//            }else if (_triangleHeight < 0){
//                _triangleHeight = 0;
//            }
//        }
//
//        //设置起点
//        [_path moveToPoint:CGPointMake(0, self.center.y+_triangleHeight/2)];
//        [_path addLineToPoint:CGPointMake(self.center.x,self.center.y-_triangleHeight/2)];
//        [_path addLineToPoint:CGPointMake(self.frame.size.width, self.center.y+_triangleHeight/2)];
//    }else{
//        //设置起点
//        /*
//         [path moveToPoint:CGPointMake(, self.center.y+triangleHeight/2)];
//         [path addLineToPoint:CGPointMake(self.center.x,self.center.y-triangleHeight/2)];
//         [path addLineToPoint:CGPointMake(self.frame.size.width, self.center.y+triangleHeight/2)];
//         */
//    }
//
//
//    [_path closePath];
//    [self maskFillInRect:rect path:_path color:self.maskColor];
}

- (void)drawPentagonInRect:(CGRect)rect {
    
    
}
- (void)maskFillInRect:(CGRect)rect path:(UIBezierPath *)path color:(UIColor *)color
{
    [color setFill];
    UIRectFill(rect);
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    CGContextSetBlendMode(ctx, kCGBlendModeDestinationOut);
    [path fill];
    CGContextSetBlendMode(ctx, kCGBlendModeNormal);
}

@end
