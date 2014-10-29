//
//  ProfileViewController.m
//  Retrogram
//
//  Created by Kyle Yoon on 10/27/14.
//  Copyright (c) 2014 yoonapps. All rights reserved.
//

#import "ProfileViewController.h"
#import "RGPhoto.h"
#import "ProfileCollectionViewCell.h"


@interface ProfileViewController () <UICollectionViewDataSource>

@property (weak, nonatomic) IBOutlet UILabel *myPhotoCountLabel;
@property (weak, nonatomic) IBOutlet UILabel *followersCountLabel;
@property (weak, nonatomic) IBOutlet UILabel *followingCountLabek;
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property NSArray *profilePhotos;


@end

@implementation ProfileViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    NSLog(@"Loaded Profile");

}

- (void)queryMyPhotos {
    PFQuery *queryMyPhotos = [RGPhoto query];
    [queryMyPhotos findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if (error) {
            NSLog(@"%@", error);
        } else {
            self.profilePhotos = objects;
            [self.collectionView reloadData];
        }
    }];
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.profilePhotos.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    ProfileCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"ProfileCell" forIndexPath:indexPath];
    
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


@end
