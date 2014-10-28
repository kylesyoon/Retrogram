//
//  ProfileViewController.m
//  Retrogram
//
//  Created by Kyle Yoon on 10/27/14.
//  Copyright (c) 2014 yoonapps. All rights reserved.
//

#import "ProfileViewController.h"
#import "Photo.h"
#import "ProfileCollectionViewCell.h"


@interface ProfileViewController () <UICollectionViewDataSource>

@property (weak, nonatomic) IBOutlet UILabel *myPhotoCountLabel;
@property (weak, nonatomic) IBOutlet UILabel *followersCountLabel;
@property (weak, nonatomic) IBOutlet UILabel *followingCountLabek;
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property NSArray *myPhotos;


@end

@implementation ProfileViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    NSLog(@"Loaded Profile");
    
    [Photo retrieveUserPhotosWithCompletion:^(NSArray *photoArray) {
        self.myPhotos = photoArray;
        [self.collectionView reloadData];
    }];
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return 0;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    ProfileCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"ProfileCell" forIndexPath:indexPath];
    Photo *myPhoto = [self.myPhotos objectAtIndex:indexPath.row];
    
    cell.imageView.image = myPhoto.image;
    
    return cell;
}


@end
