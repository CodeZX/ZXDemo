//
//  ZXSectionModel.m
//  ZXDemo
//
//  Created by 周鑫 on 2018/7/10.
//  Copyright © 2018年 ZX. All rights reserved.
//

#import "ZXSectionModel.h"

@implementation ZXSectionModel
- (instancetype)initWithTitle:(NSString *)title ItemArray:(NSArray<ZXItemModel *> *)itemArray {
    
    self = [super init];
    if (self) {
        self.title  = title;
        self.itemArray = itemArray;
    }
    return self;
}
@end
