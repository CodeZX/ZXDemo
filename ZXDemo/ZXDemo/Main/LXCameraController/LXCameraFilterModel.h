//
//  LXCameraFilterModel.h
//  ZXDemo
//
//  Created by 周鑫 on 2018/8/30.
//  Copyright © 2018年 ZX. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LXCameraFilterModel : NSObject
@property (nonatomic,copy) NSString *filterName;
@property (nonatomic,copy) Class filter;
@property (nonatomic,assign,getter=isUse) BOOL use;

- (instancetype)initWithFilterName:(NSString *)filterName filter:(Class)filter;
@end
