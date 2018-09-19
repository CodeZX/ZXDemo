//
//  LXCameraMaskModel.h
//  ZXDemo
//
//  Created by 周鑫 on 2018/9/3.
//  Copyright © 2018年 ZX. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LXCameraMaskModel : NSObject
@property (nonatomic,strong) NSString *title;
@property (nonatomic,strong) NSString *imageName;
@property (nonatomic,strong) UIBezierPath *path;
@property (nonatomic,assign,getter=isUse) BOOL use;
@property (nonatomic,assign) LXCameraMaskType maskType;
- (instancetype)initWithMaskTitle:(NSString *)title maskType:(LXCameraMaskType)type;
- (instancetype)initWithMaskTitle:(NSString *)title maskType:(LXCameraMaskType)type imageName:(NSString *)imageName;
@end
