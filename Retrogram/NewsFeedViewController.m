//
//  FirstViewController.m
//  Retrogram
//
//  Created by Kyle Yoon on 10/27/14.
//  Copyright (c) 2014 yoonapps. All rights reserved.
//

#import "NewsFeedViewController.h"
#import "RGPhoto.h"
#import "FullPostCollectionViewCell.h"
#import "UserViewController.h"

@interface NewsFeedViewController () <UICollectionViewDataSource, UICollectionViewDelegate>

@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property NSArray *newsFeedPhotos;
@property NSMutableArray *usernames;
@property NSDateFormatter *dateFormatter;

@end

@implementation NewsFeedViewController

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:YES];
    NSLog(@"NewsFeed viewDidAppear");
    
    if ([RGUser currentUser]) {
        [self queryForPhotos];
    }
    
    self.dateFormatter = [[NSDateFormatter alloc] init];
    [self.dateFormatter setDateStyle:NSDateFormatterShortStyle];
}

- (void)queryForPhotos {
    PFQuery *queryPhotos = [RGPhoto query];
    [queryPhotos whereKey:@"poster" equalTo:[RGUser currentUser]];
    [queryPhotos includeKey:@"poster"];
    [queryPhotos orderByDescending:@"createdAt"];
    [queryPhotos findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if (error) {
            NSLog(@"%@", error);
        } else {
            self.newsFeedPhotos = objects;
            [self.collectionView reloadData];
        }
    }];
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.newsFeedPhotos.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    FullPostCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"NewsCell" forIndexPath:indexPath];
    RGPhoto *photo = [self.newsFeedPhotos objectAtIndex:indexPath.row];
    [cell.usernameButton setTitle:photo.poster.username forState:UIControlStateNormal];
    cell.timestampLabel.text = [self.dateFormatter stringFromDate:photo.createdAt];
    [photo.imageFile getDataInBackgroundWithBlock:^(NSData *data, NSError *error) {
        cell.imageView.image = [UIImage imageWithData:data];
    }];
    return cell;
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"seeUserSegue"]) {
        NSLog(@"Prepared for seeUserSegue");
        UserViewController *userViewController = segue.destinationViewController;
        NSIndexPath *selectedIndexPath = [self.collectionView.indexPathsForSelectedItems firstObject];
        userViewController.username = [[[self.newsFeedPhotos objectAtIndex:selectedIndexPath.row] poster] username];
    }
}

@end
