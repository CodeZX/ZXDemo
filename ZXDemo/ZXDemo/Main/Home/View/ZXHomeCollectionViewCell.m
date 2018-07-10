//
//  HomeCollectionViewCell.m
//  ZXDemo
//
//  Created by 周鑫 on 2018/7/10.
//  Copyright © 2018年 ZX. All rights reserved.
//

#import "ZXHomeCollectionViewCell.h"
#import "ZXItemModel.h"

@interface ZXHomeCollectionViewCell ()

@property (nonatomic,weak) UILabel *contentLabel;
@end
@implementation ZXHomeCollectionViewCell

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self setupUI];
    }
    return  self;
}

- (void)setupUI {
    
    self.contentView.backgroundColor = [UIColor whiteColor];\
    
    
    UILabel *label = [[UILabel alloc] init];
//    label.font = [UIFont <#font#>];
    label.text = @"cell";
    label.textColor = [UIColor blueColor];
    label.textAlignment = NSTextAlignmentCenter;
    label.backgroundColor = [UIColor clearColor];
    [self.contentView addSubview:label];
    self.contentLabel = label;
    
    [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:self.contentLabel attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:self.contentView attribute:NSLayoutAttributeCenterY multiplier:1.0 constant:0]];
    [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:self.contentLabel attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:self.contentView attribute:NSLayoutAttributeCenterX multiplier:1.0 constant:0]];
    [self.contentLabel addConstraint:[NSLayoutConstraint constraintWithItem:self.contentLabel attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0 constant:100]];
    [self.contentLabel addConstraint:[NSLayoutConstraint constraintWithItem:self.contentLabel attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0 constant:100]];
    
}

- (void)setItemModel:(ZXItemModel *)itemModel {
    _itemModel = itemModel;
    self.contentLabel.text = itemModel.title;
}
@end
