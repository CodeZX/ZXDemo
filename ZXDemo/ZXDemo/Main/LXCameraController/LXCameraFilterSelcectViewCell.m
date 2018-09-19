//
//  LXCameraFilterSelcectViewCell.m
//  ZXDemo
//
//  Created by 周鑫 on 2018/8/30.
//  Copyright © 2018年 ZX. All rights reserved.
//

#import "LXCameraFilterSelcectViewCell.h"
#import "LXCameraFilterModel.h"

@interface LXCameraFilterSelcectViewCell ()

@property (nonatomic,weak) UIImageView *placeholderImageView;
@property (nonatomic,weak) UILabel *titleLabel;
@property (nonatomic,strong) UIImage *placeholderImage;
@end
@implementation LXCameraFilterSelcectViewCell


- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self setupUI];
    }
    return self;
}
- (void)setupUI {
    self.contentView.backgroundColor = [UIColor clearColor];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(cellSelected) name:@"selected" object:nil];
    
    self.placeholderImage = [UIImage imageNamed:@"logo.jpg"];
    UIImageView *placeholderImageView = [[UIImageView alloc]initWithImage:self.placeholderImage];
    placeholderImageView.layer.cornerRadius = 22;
    placeholderImageView.layer.masksToBounds = YES;
    [self.contentView addSubview:placeholderImageView];
    self.placeholderImageView = placeholderImageView;
    
    [self.placeholderImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        //        make.edges.equalTo(self.contentView);
        //        make.left.equalTo(self.contentView).offset(5);
        //        make.top.equalTo(self.contentView).offset(5);
        //        make.right.equalTo(self.contentView).offset(-5);
        //        make.bottom.equalTo(self.contentView).offset(-5);
        make.centerX.equalTo(self.contentView);
        make.top.equalTo(self.contentView);
        make.size.equalTo(@(CGSizeMake(44, 44)));
    }];
    
    UILabel *titleLabel = [[UILabel alloc]init];
    titleLabel.textColor  = WhiteColor;
    titleLabel.font = [UIFont systemFontOfSize:10];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    [self.contentView addSubview:titleLabel];
    self.titleLabel = titleLabel;
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.contentView);
        make.bottom.equalTo(self.contentView);
    }];
    
    
}

- (void)cellSelected {
    
    
    
    
}



- (void)setFilterModel:(LXCameraFilterModel *)filterModel {
    
    _filterModel = filterModel;
    self.placeholderImageView.layer.borderWidth = 0;
    GPUImageFilter *filter = [[filterModel.filter alloc]init];
    [self singleImageFilter:filter];
    self.titleLabel.text = filterModel.filterName;
    if (filterModel.use) {
        self.placeholderImageView.layer.borderColor = RedColor.CGColor;
        self.placeholderImageView.layer.borderWidth = 3;
    }else {
        self.placeholderImageView.layer.borderColor = WhiteColor.CGColor;
        self.placeholderImageView.layer.borderWidth = 0;
    }
    //    [filterModel addObserver:self forKeyPath:@"use" options:NSKeyValueObservingOptionNew context:nil];
}

//- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context {
//
//    if ([keyPath isEqualToString:@"use"]) {
//
//        if ([change objectForKey:NSKeyValueChangeNewKey]) {
//            self.placeholderImageView.layer.borderColor = RedColor.CGColor;
//            self.placeholderImageView.layer.borderWidth = 3;
//        }else {
//            self.placeholderImageView.layer.borderColor = nil;
//            self.placeholderImageView.layer.borderWidth = 0;
//        }
//
//    }
//}
////这是手动操作滤镜，可以添加多个滤镜
//
//-(void)imageFilter{
//
//    UIImage *inputImage = [UIImage imageNamed:@"shensu.jpg"];
//
//
//
//    GPUImagePicture *stillImageSource = [[GPUImagePicture] initWithImage:inputImage];
//
//    GPUImageSepiaFilter *stillImageFilter = [[GPUImageSepiaFilter] init];
//
//
//
//    [stillImageSource addTarget:stillImageFilter];
//
//    [stillImageFilter useNextFrameForImageCapture];//告诉滤镜以后用它，节省内存
//
//    [stillImageSource processImage];//滤镜渲染
//
//
//
//    UIImage *currentFilteredVideoFrame = [stillImageFilterimageFromCurrentFramebuffer];//从当前滤镜缓冲区获取滤镜图片
//
//
//    UIImageView *imagev=[[UIImageViewalloc]initWithImage:currentFilteredVideoFrame];
//
//    imagev.frame=self.view.frame;
//
//    [self.viewaddSubview:imagev];
//
//}



//给图片添加单个滤镜，自动添加滤镜

- (void)singleImageFilter:(GPUImageFilter *)filter {
    
    UIImage *currentimage = [filter imageByFilteringImage:self.placeholderImage];
    self.placeholderImageView.image = currentimage;
}
//
- (void)dealloc {
    
    
}

@end
