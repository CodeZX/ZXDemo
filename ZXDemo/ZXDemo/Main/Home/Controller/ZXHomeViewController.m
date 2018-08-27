//
//  HomeViewController.m
//  ZXDemo
//
//  Created by 周鑫 on 2018/7/10.
//  Copyright © 2018年 ZX. All rights reserved.
//

#import "ZXHomeViewController.h"
#import "ZXHomeCollectionViewCell.h"
#import "ZXSectionModel.h"
#import "ZXItemModel.h"

static NSString  * const cellIdentifier = @"HomeCollectionViewCell";

@interface ZXHomeViewController ()<UICollectionViewDelegate,UICollectionViewDataSource>
@property (nonatomic,weak) UICollectionView *collectionView;
@property (nonatomic,strong) NSArray *sectionArray;
@end

@implementation ZXHomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupUI];
}

- (void)setupUI {
    
    self.title = @"主页";
    self.view.backgroundColor = [UIColor whiteColor];
    
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc]init];
    layout.itemSize = CGSizeMake(100, 100);
    UICollectionView *collectionView = [[UICollectionView alloc]initWithFrame:self.view.bounds collectionViewLayout:layout];
    collectionView.backgroundColor = [UIColor whiteColor];
    collectionView.delegate = self;
    collectionView.dataSource = self;
    [self.view addSubview:collectionView];
    self.collectionView = collectionView;
    
    [self.collectionView registerClass:[ZXHomeCollectionViewCell class] forCellWithReuseIdentifier:cellIdentifier];
    
}

#pragma mark -------------------------- collectionViewDelegate ----------------------------------------
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    
    ZXSectionModel *sectionModel = self.sectionArray[section];
    return sectionModel.itemArray.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    ZXHomeCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:cellIdentifier forIndexPath:indexPath];
    ZXSectionModel *sectionModel = self.sectionArray[indexPath.section];
    ZXItemModel *itemModel = sectionModel.itemArray[indexPath.row];
    cell.itemModel = itemModel;
    cell.contentView.backgroundColor = [UIColor lightGrayColor];
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    
    ZXSectionModel *sectionModel = self.sectionArray[indexPath.section];
    ZXItemModel *itemModel = sectionModel.itemArray[indexPath.row];
    Class VCClass = NSClassFromString(itemModel.className);
    UIViewController *VC = [[VCClass alloc]init];
    [self.navigationController pushViewController:VC animated:YES];
    
}

#pragma mark -------------------------- lazy load ----------------------------------------
- (NSArray *)sectionArray {
    if (!_sectionArray) {
       
        ZXSectionModel *sectionModel1 = [[ZXSectionModel alloc]initWithTitle:@"UI" ItemArray:@[
                                                                                            
        [[ZXItemModel alloc]initWithTitle:@"自定义TabarVC" TargetClase:@"ZXCustomTaBarController"],
        
        [[ZXItemModel alloc]initWithTitle:@"ZFPlayer" TargetClase:@"PlayerViewController"],
        [[ZXItemModel alloc]initWithTitle:@"CameraController" TargetClase:@"ZXCameraViewController"]
                                                                                                      
      ]];
        
        _sectionArray = @[sectionModel1];
    }
    return _sectionArray;
}


@end
