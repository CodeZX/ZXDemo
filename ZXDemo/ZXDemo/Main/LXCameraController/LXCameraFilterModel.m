//
//  LXCameraFilterModel.m
//  ZXDemo
//
//  Created by 周鑫 on 2018/8/30.
//  Copyright © 2018年 ZX. All rights reserved.
//

#import "LXCameraFilterModel.h"

@implementation LXCameraFilterModel

- (instancetype)initWithFilterName:(NSString *)filterName filter:(Class)filter {
    self = [super init];
    if (self) {
        self.filterName = filterName;
        self.filter = filter;
        
    }
    return self;
}
@end
