//
//  SecondViewController.m
//  Retrogram
//
//  Created by Kyle Yoon on 10/27/14.
//  Copyright (c) 2014 yoonapps. All rights reserved.
//

#import "ExploreViewController.h"
#import "ExploreCollectionViewCell.h"
#import "IndividualPhotoViewController.h"


@interface ExploreViewController () <UICollectionViewDataSource, UICollectionViewDelegate>

@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property NSArray *allPhotos; //Show all photos for now.

@end

@implementation ExploreViewController

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:YES];
    NSLog(@"Loaded Explore");
    
    [self queryForAllPhotos];
}

- (void)queryForAllPhotos {
    //All photos are queried except one posted by user.
    NSLog(@"Query method called");
    PFQuery *queryAllPhotos = [RGPhoto query];
    [queryAllPhotos whereKey:@"poster" notEqualTo:[RGUser currentUser]];
    [queryAllPhotos includeKey:@"poster"];
    [queryAllPhotos orderByDescending:@"createdAt"];
    [queryAllPhotos findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if (error) {
            NSLog(@"%@", error);
        } else {
            self.allPhotos = objects;
            [self.collectionView reloadData];
            NSLog(@"Got the photos: %@", objects);
        }
    }];
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.allPhotos.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    ExploreCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"ExploreCell" forIndexPath:indexPath];
    RGPhoto *photo = [self.allPhotos objectAtIndex:indexPath.row];
    [photo.imageFile getDataInBackgroundWithBlock:^(NSData *data, NSError *error) {
        cell.imageView.image = [UIImage imageWithData:data];
    }];
    NSLog(@"The cell has: %@", cell);
    return cell;
}

//- (void)collectionView:(UICollectionView *)collectionView didHighlightItemAtIndexPath:(NSIndexPath *)indexPath {
//    RGPhoto *photo = [self.allPhotos objectAtIndex:indexPath.row];
//    RGUser *user = photo.poster;
//    RGUser *currentUser = [RGUser currentUser];
//    currentUser.following = [NSArray arrayWithObject:user];
//    [currentUser saveInBackground];
//}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"photoSegue"]) {
        IndividualPhotoViewController *individualPhotoViewController = segue.destinationViewController;
        NSIndexPath *indexPath = [self.collectionView.indexPathsForSelectedItems firstObject];
        individualPhotoViewController.photo = [self.allPhotos objectAtIndex:indexPath.row];
    }
}

@end
