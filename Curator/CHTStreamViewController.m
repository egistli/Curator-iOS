//
//  CHTStreamViewController.m
//  Curator
//
//  Created by Nelson on 2014/1/30.
//  Copyright (c) 2014年 Nelson. All rights reserved.
//

#import "CHTStreamViewController.h"
#import "CHTLargeImageViewController.h"
#import "CHTHTTPSessionManager.h"
#import <CHTCollectionViewWaterfallLayout/CHTCollectionViewWaterfallLayout.h>

@interface CHTStreamViewController () <CHTCollectionViewDelegateWaterfallLayout>
@end

@implementation CHTStreamViewController

CGFloat itemWidth;

#pragma mark - UIViewController

- (void)viewWillAppear:(BOOL)animated {
  [super viewWillAppear:animated];

  UIInterfaceOrientation orientation = [UIApplication sharedApplication].statusBarOrientation;
  [self setupCollectionViewLayoutForOrientation:orientation];
}

- (void)willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration {
  [super willRotateToInterfaceOrientation:toInterfaceOrientation duration:duration];
  [self setupCollectionViewLayoutForOrientation:toInterfaceOrientation];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
  CHTBeautyCell *cell = (CHTBeautyCell *)sender;
  NSIndexPath *indexPath = [self.collectionView indexPathForCell:cell];
  CHTLargeImageViewController *vc = segue.destinationViewController;
  vc.beauties = self.beauties;
  vc.selectedIndex = indexPath.item;
}

#pragma mark - CHTCollectionViewDelegateWaterfallLayout

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout heightForItemAtIndexPath:(NSIndexPath *)indexPath {
  CHTBeauty *beauty = self.beauties[indexPath.item];
  return floorf(beauty.thumbnailHeight * itemWidth / beauty.thumbnailWidth);
}

#pragma mark - Public Methods

- (void)fetchBeauties {
  [super fetchBeauties];

  [[CHTHTTPSessionManager sharedManager] fetchStreamAtPage:self.fetchPage success:self.fetchSuccessfulBlock failure:self.fetchFailedBlock];
}

#pragma mark - Private Methods

- (void)setupCollectionViewLayoutForOrientation:(UIInterfaceOrientation)orientation {
  CHTCollectionViewWaterfallLayout *layout = (CHTCollectionViewWaterfallLayout *)self.collectionViewLayout;
  CGFloat spacing;

  if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad) {
    spacing = 15;
    itemWidth = 236;
  } else {
    spacing = 5;
    itemWidth = 100;
  }
  layout.sectionInset = UIEdgeInsetsMake(0, spacing, 0, spacing);
  layout.itemWidth = itemWidth;

  if (UIInterfaceOrientationIsPortrait(orientation)) {
    layout.columnCount = 3;
  } else {
    layout.columnCount = 4;
  }
}

@end
