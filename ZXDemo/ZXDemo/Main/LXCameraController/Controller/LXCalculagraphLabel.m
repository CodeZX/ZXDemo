//
//  LXCalculagraphLabel.m
//  ZXDemo
//
//  Created by 周鑫 on 2018/9/16.
//  Copyright © 2018年 ZX. All rights reserved.
//

#import "LXCalculagraphLabel.h"

@interface LXCalculagraphLabel ()

@property (nonatomic,strong) NSTimer *timer;


@end
@implementation LXCalculagraphLabel
{
    
    NSInteger _sec;
}

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        _sec = 0;
    }
    return self;
}


- (void)startTime {
    
    self.text = @"00:00:00";
    [self.timer fire];
    
}


- (void)finishTime {
    
    _sec = 0;
    [self.timer invalidate];
    self.timer = nil;
    
}

- (void)displayTimer {
    
    _sec++;
    NSInteger hour = _sec/3600;
    NSInteger minute = (_sec-hour*3600)/60;
    NSInteger second = _sec-hour*3600-minute*60;
    self.text = [NSString stringWithFormat:@"%@:%@:%@",hour<10?[NSString stringWithFormat:@"0%ld",(long)hour]:@(hour),minute<10?[NSString stringWithFormat:@"0%ld",(long)minute]:@(minute),second<10?[NSString stringWithFormat:@"0%ld", (long)second]:@(second)];
    
}




- (NSTimer *)timer {
    if (!_timer) {
        _timer = [NSTimer timerWithTimeInterval:1.0f target:self selector:@selector(displayTimer) userInfo:nil repeats:YES];
        [[NSRunLoop currentRunLoop] addTimer:_timer forMode:NSRunLoopCommonModes];
    }
    return _timer;
}
@end
