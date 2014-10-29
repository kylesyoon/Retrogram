//
//  UserViewController.m
//  Retrogram
//
//  Created by Kyle Yoon on 10/29/14.
//  Copyright (c) 2014 yoonapps. All rights reserved.
//

#import "UserViewController.h"
#import <Parse/Parse.h>
#import "RGUser.h"
#import "RGPhoto.h"
#import "ProfileCollectionViewCell.h"


@interface UserViewController () <UICollectionViewDelegate, UICollectionViewDataSource>
@property (weak, nonatomic) IBOutlet UILabel *photoCountLabel;
@property (weak, nonatomic) IBOutlet UILabel *followersCountLabel;
@property (weak, nonatomic) IBOutlet UILabel *followingCountLabel;
@property (weak, nonatomic) IBOutlet UIButton *followButton;
@property (weak, nonatomic) IBOutlet UIImageView *profilePictureView;
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property RGUser *selectedUser;
@property NSArray *selectedUserPhotos;

@end

@implementation UserViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    NSLog(@"Passed string is: %@", self.username);
    [self queryUserWithUsername];
}

- (void)queryUserWithUsername {
    PFQuery *query = [RGUser query];
    [query whereKey:@"username" equalTo:self.username];
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        self.selectedUser = [objects firstObject];
        NSLog(@"Selected user is: %@", self.selectedUser.username);
        PFQuery *queryPhotos = [RGPhoto query];
        [queryPhotos whereKey:@"poster" equalTo:self.selectedUser];
        [queryPhotos orderByDescending:@"createdAt"];
        [queryPhotos findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
            self.selectedUserPhotos = objects;
            [self.collectionView reloadData];
            [self setUpUserDetails];
        }];
    }];
}

- (void)setUpUserDetails {
    self.navigationItem.title = self.selectedUser.username;
    self.photoCountLabel.text = [NSString stringWithFormat:@"%li", self.selectedUserPhotos.count];
    self.followersCountLabel.text = [NSString stringWithFormat:@"%li", self.selectedUser.followers.count];
    self.followingCountLabel.text = [NSString stringWithFormat:@"%li", self.selectedUser.followers.count];
    [self.followButton setBackgroundColor:[UIColor whiteColor]];
    [self.followButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [self.followButton setTitle:@"Follow" forState:UIControlStateNormal];
    [self.followButton setTintColor:[UIColor whiteColor]];
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.selectedUserPhotos.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    ProfileCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"UserCell" forIndexPath:indexPath];
    RGPhoto *photo = [self.selectedUserPhotos objectAtIndex:indexPath.row];
    [photo.imageFile getDataInBackgroundWithBlock:^(NSData *data, NSError *error) {
        cell.imageView.image = [UIImage imageWithData:data];
    }];
    return cell;
}

- (IBAction)onFollowButtonWasTapped:(id)sender {
    [self.followButton setBackgroundColor:[UIColor greenColor]];
    [self.followButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.followButton setTitle:@"Following!" forState:UIControlStateNormal];
}



@end
