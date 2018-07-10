//
//  ZXItemModel.h
//  ZXDemo
//
//  Created by 周鑫 on 2018/7/10.
//  Copyright © 2018年 ZX. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ZXItemModel : NSObject
@property (nonatomic,strong) NSString *title;
@property (nonatomic,strong) NSString *className;
- (instancetype)initWithTitle:(NSString *)title TargetClase:(NSString *)className;
@end
