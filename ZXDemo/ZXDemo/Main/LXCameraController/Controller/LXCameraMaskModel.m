//
//  LXCameraMaskModel.m
//  ZXDemo
//
//  Created by 周鑫 on 2018/9/3.
//  Copyright © 2018年 ZX. All rights reserved.
//

#import "LXCameraMaskModel.h"


@interface LXCameraMaskModel ()


@end
@implementation LXCameraMaskModel


- (instancetype)initWithMaskTitle:(NSString *)title maskType:(LXCameraMaskType)type {
    return [self initWithMaskTitle:title maskType:type imageName:@"画幅1_1"];
}

- (instancetype)initWithMaskTitle:(NSString *)title maskType:(LXCameraMaskType)type imageName:(NSString *)imageName {
    self = [super init];
    if(self) {
        self.title = title;
        self.imageName = imageName;
        self.maskType = type;
        [self createPath:self.maskType];
    }
    return  self;
}



- (void)createPath:(LXCameraMaskType)type {
    
    
   
}
@end
