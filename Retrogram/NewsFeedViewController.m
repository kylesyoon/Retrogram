//
//  FirstViewController.m
//  Retrogram
//
//  Created by Kyle Yoon on 10/27/14.
//  Copyright (c) 2014 yoonapps. All rights reserved.
//

#import "NewsFeedViewController.h"
#import "User.h"


@interface NewsFeedViewController () <UICollectionViewDataSource, UICollectionViewDelegate>

@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property NSArray *newsFeedPhotos;

@end

@implementation NewsFeedViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    NSLog(@"Loaded News Feed");
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return 0;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"NewsCell" forIndexPath:indexPath];
    
    return cell;
}


@end
