//
//  FirstViewController.m
//  Retrogram
//
//  Created by Kyle Yoon on 10/27/14.
//  Copyright (c) 2014 yoonapps. All rights reserved.
//

#import "NewsFeedViewController.h"
#import "RGPhoto.h"
#import "RGFollowing.h"
#import "FullPostCollectionViewCell.h"
#import "IndividualPhotoViewController.h"

@interface NewsFeedViewController () <UICollectionViewDataSource, UICollectionViewDelegate>

@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property NSArray *newsFeedPhotos;
@property NSMutableArray *usernames;
@property NSDateFormatter *dateFormatter;
@property UITapGestureRecognizer *doubleTapGesture;

@end

@implementation NewsFeedViewController

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:YES];
    NSLog(@"NewsFeed viewDidAppear");
    self.collectionView.allowsMultipleSelection = NO;
    self.dateFormatter = [[NSDateFormatter alloc] init];
    [self.dateFormatter setDateFormat:@"yyyy-MM-dd 'at' HH:mm"];
    
    //Had issue of querying when login modal is presented, causing crash. So only query when logged in.
    if ([RGUser currentUser]) {
        [self queryMyPhotosAndFollowedUsersPhotos];
    }
}

- (void)queryMyPhotosAndFollowedUsersPhotos {
    //Querying following objects where current user is the follower.
    PFQuery *query = [RGFollowing query];
    [query includeKey:@"followedUser"];
    [query whereKey:@"followingUser" equalTo:[RGUser currentUser]];
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if (error) {
            NSLog(@"%@", error);
        } else {
            //Upon successful query, query for photos of current user and the people current user is following.
            PFQuery *queryPhotos = [RGPhoto query];
            NSMutableArray *users = [NSMutableArray arrayWithObject:[RGUser currentUser]];
            for (RGFollowing *following in objects) {
                [users addObject:following.followedUser];
                //Adding users that current user is following...
            }
            //Got the array of users I need.
            NSArray *findUsers = [NSArray arrayWithArray:users];
            //Querying the photos of these users, and then ordering by recent.
            [queryPhotos whereKey:@"poster" containedIn:findUsers];
            [queryPhotos includeKey:@"poster"]; //Need user object in order to give property username.
            [queryPhotos orderByDescending:@"createdAt"];
            [queryPhotos findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
                if (error) {
                    NSLog(@"%@", error);
                } else {
                    //Array of photos from users that current user follows as well as current user's ordered by recent.
                    self.newsFeedPhotos = objects;
                    [self.collectionView reloadData];
                }
            }];
        }
    }];
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.newsFeedPhotos.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    FullPostCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"NewsCell" forIndexPath:indexPath];
    RGPhoto *photo = [self.newsFeedPhotos objectAtIndex:indexPath.row];
    cell.usernameLabel.text = photo.poster.username;
    cell.timestampLabel.text = [self.dateFormatter stringFromDate:photo.createdAt];
    //Converting PFFile into NSData
    [photo.imageFile getDataInBackgroundWithBlock:^(NSData *data, NSError *error) {
        cell.imageView.image = [UIImage imageWithData:data]; //Converting NSData to UIImage.
    }];
    
    return cell;
}
//Segue to individual photo view controller.
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"photoSegue"]) {
        IndividualPhotoViewController *individualPhotoViewController = segue.destinationViewController;
        NSIndexPath *indexPath = [self.collectionView.indexPathsForSelectedItems firstObject];
        //Passing the photo.
        individualPhotoViewController.photo = [self.newsFeedPhotos objectAtIndex:indexPath.row];
    }
}


@end
