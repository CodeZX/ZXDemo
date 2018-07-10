//
//  ZXSectionModel.h
//  ZXDemo
//
//  Created by 周鑫 on 2018/7/10.
//  Copyright © 2018年 ZX. All rights reserved.
//

#import <Foundation/Foundation.h>

@class ZXItemModel;

@interface ZXSectionModel : NSObject
@property (nonatomic,strong) NSString *title;
@property (nonatomic,strong) NSArray<ZXItemModel *> *itemArray;
- (instancetype)initWithTitle:(NSString *)title ItemArray:(NSArray<ZXItemModel *> *)itemArray;

@end
