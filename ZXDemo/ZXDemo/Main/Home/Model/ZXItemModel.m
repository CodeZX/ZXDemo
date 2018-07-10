//
//  ZXItemModel.m
//  ZXDemo
//
//  Created by 周鑫 on 2018/7/10.
//  Copyright © 2018年 ZX. All rights reserved.
//

#import "ZXItemModel.h"

@implementation ZXItemModel
- (instancetype)initWithTitle:(NSString *)title TargetClase:(NSString *)className  {
    
    self = [super init];
    if (self) {
        self.title  = title;
        self.className = className;
    }
    return self;
}
@end
