//
//  CollectionViewController.m
//  Gardener
//
//  Created by coder on 16/5/19.
//  Copyright © 2016年 coder. All rights reserved.
//

#import "CollectionViewController.h"
#import "CollectionViewCell.h"
#import "ViewController.h"
#import "XBPresentTransition.h"
@interface CollectionViewController () <UIViewControllerTransitioningDelegate>
@property (strong, nonatomic) NSArray  *datas;
@end

@implementation CollectionViewController

static NSString * const reuseIdentifier = @"CollectionViewCell";

- (void)viewDidLoad {
    [super viewDidLoad];
    self.datas = @[@{@"cover":@"duorou1.jpg",@"name":@"龙血树",@"date":@"昨天",@"percent":@(0.98)},
                   @{@"cover":@"duorou2.jpg",@"name":@"金钻",@"date":@"23天前",@"percent":@(0)},
                   @{@"cover":@"duorou3.jpg",@"name":@"爱之蔓藤",@"date":@"昨天",@"percent":@(0.93)},
                   @{@"cover":@"duorou4.jpg",@"name":@"黄丽",@"date":@"昨天",@"percent":@(0.95)},
                   @{@"cover":@"duorou5.jpg",@"name":@"珠芽景天",@"date":@"昨天",@"percent":@(0.85)},
                   @{@"cover":@"duorou6.jpg",@"name":@"蝴蝶綿",@"date":@"昨天",@"percent":@(1.0)},
                   @{@"cover":@"duorou7.jpg",@"name":@"绿萝",@"date":@"昨天",@"percent":@(.75)}
                   ];
    
    [self.collectionView registerNib:[UINib nibWithNibName:NSStringFromClass([CollectionViewCell class]) bundle:[NSBundle mainBundle]] forCellWithReuseIdentifier:reuseIdentifier];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark <UICollectionViewDataSource>

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}


- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.datas.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    CollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:reuseIdentifier forIndexPath:indexPath];
    NSDictionary *dic = self.datas[indexPath.row];
    cell.coverImageView.image = [UIImage imageNamed:[dic valueForKey:@"cover"]];
    cell.titleLabel.text = [dic valueForKey:@"name"];
    cell.dateLabel.text  = [dic valueForKey:@"date"];
    cell.percent = [[dic valueForKey:@"percent"] floatValue];
    return cell;
}

#pragma mark <UICollectionViewDelegate>
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    self.currentIndexPath = indexPath;
    NSDictionary *dic = self.datas[indexPath.row];
    ViewController *viewController = [self.storyboard instantiateViewControllerWithIdentifier:NSStringFromClass([ViewController class])];
    viewController.imageURL = dic[@"cover"];
    viewController.transitioningDelegate = self;
    [self presentViewController:viewController animated:YES completion:nil];
}


- (nullable id <UIViewControllerAnimatedTransitioning>)animationControllerForPresentedController:(UIViewController *)presented presentingController:(UIViewController *)presenting sourceController:(UIViewController *)source
{
    return [XBPresentTransition transtionWithTransitionType:XBPresentTransitionTypePresent];
}

- (nullable id <UIViewControllerAnimatedTransitioning>)animationControllerForDismissedController:(UIViewController *)dismissed
{
    return [XBPresentTransition transtionWithTransitionType:XBPresentTransitionTypeDismiss];
}

@end
