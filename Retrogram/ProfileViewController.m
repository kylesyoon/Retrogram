//
//  ProfileViewController.m
//  Retrogram
//
//  Created by Kyle Yoon on 10/27/14.
//  Copyright (c) 2014 yoonapps. All rights reserved.
//

#import "ProfileViewController.h"
#import "RGPhoto.h"
#import "RGFollowing.h"
#import "ProfileCollectionViewCell.h"
#import "IndividualPhotoViewController.h"

@interface ProfileViewController () <UICollectionViewDataSource, UICollectionViewDelegate>

@property (weak, nonatomic) IBOutlet UILabel *myPhotoCountLabel;
@property (weak, nonatomic) IBOutlet UILabel *followersCountLabel;
@property (weak, nonatomic) IBOutlet UILabel *followingCountLabek;
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property NSArray *profilePhotos;

@end

@implementation ProfileViewController

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:YES];
    self.navigationItem.title = [RGUser currentUser].username;
    [self queryMyPhotos];
    [self queryFollowersAndFollowingCount];
    NSLog(@"Loaded Profile");
}

- (void)queryMyPhotos {
    PFQuery *queryMyPhotos = [RGPhoto query];
    [queryMyPhotos whereKey:@"poster" equalTo:[RGUser currentUser]];
    [queryMyPhotos findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if (error) {
            NSLog(@"%@", error);
        } else {
            self.profilePhotos = objects;
            NSLog(@"Got my photos: %@", self.profilePhotos);
            self.myPhotoCountLabel.text = [NSString stringWithFormat:@"%lu", (unsigned long)self.profilePhotos.count];
            [self.collectionView reloadData];
        }
    }];
}

- (void)queryFollowersAndFollowingCount {
    PFQuery *queryCountFollowing = [RGFollowing query];
    [queryCountFollowing whereKey:@"followingUser" equalTo:[RGUser currentUser]];
    [queryCountFollowing countObjectsInBackgroundWithBlock:^(int number, NSError *error) {
        if (error) {
            NSLog(@"%@", [error userInfo]);
        } else {
            self.followingCountLabek.text = [NSString stringWithFormat:@"%d", number];
        }
    }];
    PFQuery *queryCountFollowed = [RGFollowing query];
    [queryCountFollowed whereKey:@"followedUser" equalTo:[RGUser currentUser]];
    [queryCountFollowed countObjectsInBackgroundWithBlock:^(int number, NSError *error) {
        if (error) {
            NSLog(@"%@", [error userInfo]);
        } else {
            self.followersCountLabel.text = [NSString stringWithFormat:@"%d", number];
        }
    }];
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.profilePhotos.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    ProfileCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"ProfileCell" forIndexPath:indexPath];
    RGPhoto *photo = [self.profilePhotos objectAtIndex:indexPath.row];
    [photo.imageFile getDataInBackgroundWithBlock:^(NSData *data, NSError *error) {
        cell.imageView.image = [UIImage imageWithData:data];
        NSLog(@"cell.imageview.iamge: %@", cell.imageView.image);
        NSLog(@"UIImage: %@",[UIImage imageWithData:data]);
    }];
    return cell;
}

- (IBAction)logOutButtonPressed:(id)sender {
    [PFUser logOut];
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]];
    UINavigationController *loginNavigationController = [storyboard instantiateViewControllerWithIdentifier:@"LoginNavIdentifier"];
    [self presentViewController:loginNavigationController animated:YES completion:^{
        NSLog(@"Successful log out of user: %@", [PFUser currentUser]);
    }];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"seePhotoSegue"]) {
        IndividualPhotoViewController *individualPhotoViewController = segue.destinationViewController;
        NSIndexPath *indexPath = [self.collectionView.indexPathsForSelectedItems firstObject];
        //Passing the photo.
        individualPhotoViewController.photo = [self.profilePhotos objectAtIndex:indexPath.row];
    }
}


@end
