//
//  LXCameraMaskSelectViewCell.m
//  ZXDemo
//
//  Created by 周鑫 on 2018/9/3.
//  Copyright © 2018年 ZX. All rights reserved.
//

#import "LXCameraMaskSelectViewCell.h"
#import "LXCameraMaskModel.h"

@interface LXCameraMaskSelectViewCell ()

@property (nonatomic,weak) UIImageView  *imageView;
@property (nonatomic,weak) UILabel *titlleLabel;

@end

@implementation LXCameraMaskSelectViewCell

- (instancetype)initWithFrame:(CGRect)frame {
    self  = [super initWithFrame:frame];
    if (self) {
        [self setupUI];
    }
    return self;
}

- (void)setupUI {
    
    __weak typeof(self) weakSelf = self;
    
    UIImageView *imageView = [[UIImageView alloc]init];
    [self.contentView addSubview:imageView];
    self.imageView = imageView;
    [self.imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(weakSelf.contentView);
        make.top.equalTo(weakSelf.contentView);
        make.size.equalTo(CGSizeMake(44, 44));
    }];
    
    
    UILabel *titleLabel = [[UILabel alloc]init];
//    titleLabel.backgroundColor = [UIColor redColor];
    titleLabel.textColor  = WhiteColor;
    titleLabel.font = [UIFont systemFontOfSize:10];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    [self.contentView addSubview:titleLabel];
    self.titlleLabel = titleLabel;
    [self.titlleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.contentView);
        make.bottom.equalTo(self.contentView);
    }];
    
}



- (void)setMaskModel:(LXCameraMaskModel *)maskModel {
   
    _maskModel = maskModel;
    self.titlleLabel.text = maskModel.title;
    self.imageView.image = [UIImage imageNamed:maskModel.imageName];
    if (maskModel.use) {
        self.imageView.layer.borderColor = RedColor.CGColor;
        self.imageView.layer.borderWidth = 3;
    }else {
        self.imageView.layer.borderColor = WhiteColor.CGColor;
        self.imageView.layer.borderWidth = 0;
    }
    
}

@end
