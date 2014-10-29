//
//  FirstViewController.m
//  Retrogram
//
//  Created by Kyle Yoon on 10/27/14.
//  Copyright (c) 2014 yoonapps. All rights reserved.
//

#import "NewsFeedViewController.h"
#import "Photo.h"
#import "FullPostCollectionViewCell.h"

@interface NewsFeedViewController () <UICollectionViewDataSource, UICollectionViewDelegate>

@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property NSArray *newsFeedPhotos;
@property NSMutableArray *usernames;
@property NSDateFormatter *dateFormatter;

@end

@implementation NewsFeedViewController

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:YES];
    NSLog(@"Loaded News Feed");
    [self queryForPhotos];
    
    
    self.dateFormatter = [[NSDateFormatter alloc] init];
    [self.dateFormatter setDateStyle:NSDateFormatterShortStyle];
}

- (void)queryForPhotos {
    PFQuery *queryPhotos = [Photo query];
    [queryPhotos whereKey:@"poster" equalTo:[PFUser currentUser]];
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
    Photo *photo = [self.newsFeedPhotos objectAtIndex:indexPath.row];
    cell.usernameLabel.text = photo.poster.username;
    cell.timestampLabel.text = [self.dateFormatter stringFromDate:photo.createdAt];
    [photo.imageFile getDataInBackgroundWithBlock:^(NSData *data, NSError *error) {
        cell.imageView.image = [UIImage imageWithData:data];
    }];
    return cell;
}

@end
