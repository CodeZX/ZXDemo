//
//  LXCameraFilterSelectView.m
//  ZXDemo
//
//  Created by 周鑫 on 2018/8/30.
//  Copyright © 2018年 ZX. All rights reserved.
//

#import "LXCameraFilterSelectView.h"
#import "LXCameraFilterModel.h"
#import "LXCameraFilterSelcectViewCell.h"


static NSString  *identifier = @"LXCameraFilterSelcectViewCell";
@interface LXCameraFilterSelectView ()<UICollectionViewDelegate,UICollectionViewDataSource>

@property (nonatomic,weak) UICollectionView *collectionView;
@property (nonatomic,strong) NSArray *filterAry;

@property (nonatomic,strong) LXCameraFilterModel *currentFilterModel;
@property (nonatomic,strong) LXCameraFilterModel *lastFilterModel;


@property (nonatomic,assign) int currentIndex;
@property (nonatomic,assign) int lastIndex;
@end

@implementation LXCameraFilterSelectView


- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        [self setupData];
        [self setupUI];
    }
    return self;
}

- (void)setupData {
    
   
    self.filterAry= @[
                      [[LXCameraFilterModel alloc]initWithFilterName:@"原图" filter:[GPUImageFilter class]],
//                      [[LXCameraFilterModel alloc]initWithFilterName:@"美颜" filter:[GPUImageBeautifyFilter class]],
                      [[LXCameraFilterModel alloc]initWithFilterName:@"高斯模糊" filter:[GPUImageGaussianBlurFilter class]],
                      [[LXCameraFilterModel alloc]initWithFilterName:@"单色模糊" filter:[GPUImageSingleComponentGaussianBlurFilter class]],
                      [[LXCameraFilterModel alloc]initWithFilterName:@"iOS模糊" filter:[GPUImageiOSBlurFilter class]],
                      [[LXCameraFilterModel alloc]initWithFilterName:@"边缘检测" filter:[GPUImageSobelEdgeDetectionFilter class]],
                      [[LXCameraFilterModel alloc]initWithFilterName:@"低通滤波器" filter:[GPUImageLowPassFilter class]],
                      [[LXCameraFilterModel alloc]initWithFilterName:@"缩放模糊" filter:[GPUImageZoomBlurFilter class]],
                      [[LXCameraFilterModel alloc]initWithFilterName:@"亮度" filter:[GPUImageBrightnessFilter class]],
                      [[LXCameraFilterModel alloc]initWithFilterName:@"饱和度" filter:[GPUImageSaturationFilter class]],
                      [[LXCameraFilterModel alloc]initWithFilterName:@"白平衡" filter:[GPUImageWhiteBalanceFilter class]],
                      [[LXCameraFilterModel alloc]initWithFilterName:@"颜色反转" filter:[GPUImageColorInvertFilter class]],
                      [[LXCameraFilterModel alloc]initWithFilterName:@"单色滤光" filter:[GPUImageMonochromeFilter class]],
                      [[LXCameraFilterModel alloc]initWithFilterName:@"褐色滤光" filter:[GPUImageSepiaFilter class]],
                      [[LXCameraFilterModel alloc]initWithFilterName:@"透明度" filter:[GPUImageOpacityFilter class]],
                      [[LXCameraFilterModel alloc]initWithFilterName:@"圆点马赛克" filter:[GPUImagePolkaDotFilter class]],
                      [[LXCameraFilterModel alloc]initWithFilterName:@"马赛克" filter:[GPUImagePixellateFilter class]],
                      [[LXCameraFilterModel alloc]initWithFilterName:@"半色调" filter:[GPUImageHalftoneFilter class]],
                      [[LXCameraFilterModel alloc]initWithFilterName:@"素描" filter:[GPUImageSketchFilter class]],
                      [[LXCameraFilterModel alloc]initWithFilterName:@"浮雕" filter:[GPUImageEmbossFilter class]],
                      [[LXCameraFilterModel alloc]initWithFilterName:@"玻璃球" filter:[GPUImageGlassSphereFilter class]],
                      [[LXCameraFilterModel alloc]initWithFilterName:@"边缘阴影" filter:[GPUImageVignetteFilter class]]
                      ];
    
    self.currentIndex = 0;
}

- (void)setupUI {
    
    self.hidden = YES;
    self.backgroundColor = [UIColor clearColor];
    
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc]init];
    layout.itemSize  = CGSizeMake(64, 64);
    layout.minimumLineSpacing = 20;
    layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    UICollectionView *collectionView = [[UICollectionView alloc]initWithFrame:CGRectZero collectionViewLayout:layout];
    collectionView.backgroundColor = ClearColor;
    collectionView.delegate = self;
    collectionView.dataSource = self;
    collectionView.showsHorizontalScrollIndicator = NO;
    [self addSubview:collectionView];
    self.collectionView = collectionView;
    [self.collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self);
    }];
    [self.collectionView registerClass:[LXCameraFilterSelcectViewCell class] forCellWithReuseIdentifier:identifier];
    
}


#pragma mark -------------------------- collectionview dalegate ----------------------------------------
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    
    
    return self.filterAry.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    LXCameraFilterSelcectViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:identifier forIndexPath:indexPath];
//        cell.contentView.backgroundColor = RandomColor;
    LXCameraFilterModel *filterModel = self.filterAry[indexPath.row];
    //    cell.filter = [[filterModel.filter alloc]init];
    cell.filterModel = filterModel;
    return cell;
    
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    
    self.lastIndex = self.currentIndex;
    self.currentIndex =(int) indexPath.row;
    self.lastFilterModel = self.currentFilterModel;
    self.lastFilterModel.use = NO;
    
    LXCameraFilterModel *filterModel = self.filterAry[indexPath.row];
    filterModel.use = YES;
    self.currentFilterModel = filterModel;
    self.currentFilterModel.use = YES;
    [collectionView reloadData];
    
    if ([self.delegate respondsToSelector:@selector(camerafilterSelectView:filter:)]) {
        [self.delegate camerafilterSelectView:self filter:[[filterModel.filter alloc]init]];
    }
    
}

- (void)collectionView:(UICollectionView *)collectionView willDisplayCell:(UICollectionViewCell *)cell forItemAtIndexPath:(NSIndexPath *)indexPath {
    
    
}

- (void)collectionView:(UICollectionView *)collectionView didEndDisplayingCell:(UICollectionViewCell *)cell forItemAtIndexPath:(NSIndexPath *)indexPath {
    
    //    LXFilterSelectViewCell *filterSelectViewCell = (LXFilterSelectViewCell *)cell;
    //    [filterSelectViewCell cellSelected];
    
}

- (void)nextFilter {
    
    
    self.currentIndex++;
    if (self.currentIndex == self.filterAry.count) {
        self.currentIndex = (int) self.filterAry.count - 1;
        return;
    }
    
    [self show];
    self.lastIndex = self.currentIndex;
    self.lastFilterModel = self.currentFilterModel;
    self.lastFilterModel.use = NO;
    self.currentFilterModel = self.filterAry[self.currentIndex];
    self.currentFilterModel.use = YES;
    [self.collectionView reloadData];
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:self.currentIndex inSection:0];
//    [self.collectionView reloadItemsAtIndexPaths:@[indexPath]];
    [self.collectionView scrollToItemAtIndexPath:indexPath atScrollPosition:UICollectionViewScrollPositionCenteredHorizontally animated:YES];
    if ([self.delegate respondsToSelector:@selector(camerafilterSelectView:filter:)]) {
        LXCameraFilterModel *filterModel = self.filterAry[self.currentIndex];
        [self.delegate camerafilterSelectView:self filter:[[filterModel.filter alloc]init]];
        
    }
}

- (void)lastFilter {
    
    self.currentIndex--;
    if (self.currentIndex < 0) {
        self.currentIndex = 0;
        return;
    }
    
    [self show];
    self.lastIndex = self.currentIndex;
    self.lastFilterModel = self.currentFilterModel;
    self.lastFilterModel.use = NO;
    self.currentFilterModel = self.filterAry[self.currentIndex];
    self.currentFilterModel.use = YES;
    [self.collectionView reloadData];
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:self.currentIndex inSection:0];
//    [self.collectionView reloadItemsAtIndexPaths:@[indexPath]];
   [self.collectionView scrollToItemAtIndexPath:indexPath atScrollPosition:UICollectionViewScrollPositionCenteredHorizontally animated:YES];
    if ([self.delegate respondsToSelector:@selector(camerafilterSelectView:filter:)]) {
        LXCameraFilterModel *filterModel = self.filterAry[self.currentIndex];
        [self.delegate camerafilterSelectView:self filter:[[filterModel.filter alloc]init]];
    }
}

- (void)show {
    self.hidden  = NO;
    
}

- (void)hide {
    self.hidden = YES;
    
}


@end
