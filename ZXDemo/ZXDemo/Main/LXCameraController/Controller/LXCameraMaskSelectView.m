//
//  LXCameraMaskSelectView.m
//  ZXDemo
//
//  Created by 周鑫 on 2018/9/3.
//  Copyright © 2018年 ZX. All rights reserved.
//

#import "LXCameraMaskSelectView.h"
#import "LXCameraMaskSelectViewCell.h"
#import "LXCameraMaskModel.h"


static NSString  *identifier = @"LXCameraMaskSelectViewCell";
@interface LXCameraMaskSelectView ()<UICollectionViewDelegate,UICollectionViewDataSource>

@property (nonatomic,weak) UICollectionView *collectionView;
@property (nonatomic,strong) NSArray *maskModelAry;

@property (nonatomic,strong) LXCameraMaskModel *currentMaskModel;
@property (nonatomic,strong) LXCameraMaskModel *lastMaskModel;


@property (nonatomic,assign) int currentIndex;
@property (nonatomic,assign) int lastIndex;

@end

@implementation LXCameraMaskSelectView

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
    
    
    self.maskModelAry = @[
                        [[LXCameraMaskModel alloc]initWithMaskTitle:@"1_1" maskType:LXCameraMaskType1_1 imageName:@"画幅1_1"],
                        [[LXCameraMaskModel alloc]initWithMaskTitle:@"4_3" maskType:LXCameraMaskType4_3 imageName:@"画幅1_1"],
                        [[LXCameraMaskModel alloc]initWithMaskTitle:@"16_9" maskType:LXCameraMaskType16_9 imageName:@"画幅16_9"],
                        [[LXCameraMaskModel alloc]initWithMaskTitle:@"Round" maskType:LXCameraMaskTypeRound imageName:@"圆形"],
                        [[LXCameraMaskModel alloc]initWithMaskTitle:@"Oval" maskType:LXCameraMaskTypeOval imageName:@"椭圆"],
                        [[LXCameraMaskModel alloc]initWithMaskTitle:@"pentagon" maskType:LXCameraMaskTypePentagon imageName:@"画幅1_1"],
                        [[LXCameraMaskModel alloc]initWithMaskTitle:@"triangle" maskType:LXCameraMaskTypeTriangle imageName:@"画幅1_1"],
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
    [self.collectionView registerClass:[LXCameraMaskSelectViewCell class] forCellWithReuseIdentifier:identifier];
    
}


#pragma mark -------------------------- collectionview dalegate ----------------------------------------
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    
    
    return self.maskModelAry.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    LXCameraMaskSelectViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:identifier forIndexPath:indexPath];
    //        cell.contentView.backgroundColor = RandomColor;
    LXCameraMaskModel *maskModel = self.maskModelAry[indexPath.row];
    //    cell.filter = [[filterModel.filter alloc]init];
//    cell.filterModel = filterModel;
    cell.maskModel = maskModel;
    return cell;
    
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    
    self.lastIndex = self.currentIndex;
    self.currentIndex =(int) indexPath.row;
    self.lastMaskModel = self.currentMaskModel;
    self.lastMaskModel.use = NO;
    
    LXCameraMaskModel *maskModel = self.maskModelAry[indexPath.row];
    maskModel.use = YES;
    self.currentMaskModel = maskModel;
    self.currentMaskModel.use = YES;
    [collectionView reloadData];
    
    if ([self.delegate respondsToSelector:@selector(cameraMaskSelectView:maskModel:)]) {
        [self.delegate cameraMaskSelectView:self maskModel:self.currentMaskModel];
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
    if (self.currentIndex == self.maskModelAry.count) {
        self.currentIndex = (int) self.maskModelAry.count - 1;
        return;
    }
    
    [self show];
    self.lastIndex = self.currentIndex;
    self.lastMaskModel = self.currentMaskModel;
    self.lastMaskModel.use = NO;
    self.currentMaskModel = self.maskModelAry[self.currentIndex];
    self.currentMaskModel.use = YES;
    [self.collectionView reloadData];
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:self.currentIndex inSection:0];
    //    [self.collectionView reloadItemsAtIndexPaths:@[indexPath]];
    [self.collectionView scrollToItemAtIndexPath:indexPath atScrollPosition:UICollectionViewScrollPositionCenteredHorizontally animated:YES];
    if ([self.delegate respondsToSelector:@selector(cameraMaskSelectView:maskModel:)]) {
        LXCameraMaskModel *maskModel = self.maskModelAry[self.currentIndex];
        [self.delegate cameraMaskSelectView:self maskModel:maskModel];
        
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
    self.lastMaskModel = self.currentMaskModel;
    self.lastMaskModel.use = NO;
    self.currentMaskModel = self.maskModelAry[self.currentIndex];
    self.currentMaskModel.use = YES;
    [self.collectionView reloadData];
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:self.currentIndex inSection:0];
    //    [self.collectionView reloadItemsAtIndexPaths:@[indexPath]];
    [self.collectionView scrollToItemAtIndexPath:indexPath atScrollPosition:UICollectionViewScrollPositionCenteredHorizontally animated:YES];
    if ([self.delegate respondsToSelector:@selector(cameraMaskSelectView:maskModel:)]) {
        LXCameraMaskModel *maskModel = self.maskModelAry[self.currentIndex];
        [self.delegate cameraMaskSelectView:self maskModel:maskModel];
    }
}

- (void)show {
    self.hidden  = NO;
    
}

- (void)hide {
    self.hidden = YES;
    
}

@end
