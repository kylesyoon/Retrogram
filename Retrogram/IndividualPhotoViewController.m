//
//  IndividualPhotoViewController.m
//  Retrogram
//
//  Created by Kyle Yoon on 10/29/14.
//  Copyright (c) 2014 yoonapps. All rights reserved.
//

#import "IndividualPhotoViewController.h"

@interface IndividualPhotoViewController ()
@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (weak, nonatomic) IBOutlet UILabel *usernameLabel;
@property (weak, nonatomic) IBOutlet UILabel *dateLabel;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *followButton;
@property RGUser *photoUser;
@property BOOL isFollowing;

@end

@implementation IndividualPhotoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self queryForUser];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateStyle:NSDateFormatterShortStyle];
    self.dateLabel.text = [dateFormatter stringFromDate:self.photo.createdAt];
    
    [self.photo.imageFile getDataInBackgroundWithBlock:^(NSData *data, NSError *error) {
        self.imageView.image = [UIImage imageWithData:data];
    }];
}

- (void)queryForUser {
    PFQuery *query = [RGUser query];
    [query whereKey:@"objectId" equalTo:self.photo.poster.objectId];
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        self.photoUser = [objects firstObject];
        self.usernameLabel.text = self.photoUser.username;
        [self isFollowingPhotoUser];
    }];
}

- (void)isFollowingPhotoUser {
    for (RGUser *user in [RGUser currentUser].following) {
        if (user == self.photoUser) {
            self.isFollowing = YES;
            self.followButton.title = @"Following!";
            return;
        }
    }
    self.isFollowing = NO;
    self.followButton.title = @"Follow";
}

- (IBAction)onFollowButtonWasTapped:(id)sender {
    //Need to add self.photoUser to currentUser's following array
    //Need to add currentUser to self.photoUser's followers array
    //Need to toggle back forth.
    
    //To follow
    if (self.isFollowing == NO) {
        self.followButton.title = @"Following!";
        //Adding currentUser to photoUser's followers array
        NSMutableArray *photoUserFollowers = [NSMutableArray arrayWithArray:self.photoUser.followers];
        [photoUserFollowers addObject:[RGUser currentUser]];
        NSLog(@"Adding %@", [RGUser currentUser]);
        self.photoUser.followers = [NSArray arrayWithArray:photoUserFollowers];
        NSLog(@"self.photoUser's followers: %@", self.photoUser.followers);
        [self.photoUser saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
            NSLog(@"Block called");
            if (error) {
                NSLog(@"%@", error);
            } else {
                NSLog(@"Save succeeded");
                //Adding photoUser to currentUser's following array
                NSMutableArray *currentUserFollowing = [NSMutableArray arrayWithArray:[RGUser currentUser].following];
                [currentUserFollowing addObject:self.photoUser];
                NSLog(@"Adding %@", self.photoUser.username);
                [RGUser currentUser].following = [NSArray arrayWithArray:currentUserFollowing];
                NSLog(@"currentUser's following: %@", [RGUser currentUser].following);
                [[RGUser currentUser] saveInBackground];
            }
        }];
    } else {
        self.followButton.title = @"Follow";
        //Removing currentUser to photoUser's followers array
        NSMutableArray *photoUserFollowers = [NSMutableArray arrayWithArray:self.photoUser.followers];
        [photoUserFollowers removeObject:[RGUser currentUser]];
        NSLog(@"Removing %@", [RGUser currentUser].username);
        self.photoUser.followers = [NSArray arrayWithArray:photoUserFollowers];
        NSLog(@"self.photoUser's followers: %@", self.photoUser.followers);
        [self.photoUser saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
            if (error) {
                NSLog(@"%@", error);
            } else {
                //Removing photoUser from currentUser's following array
                NSMutableArray *currentUserFollowing = [NSMutableArray arrayWithArray:[RGUser currentUser].following];
                [currentUserFollowing removeObject:self.photoUser];
                NSLog(@"Removing %@", self.photoUser.username);
                [RGUser currentUser].following = [NSArray arrayWithArray:currentUserFollowing];
                NSLog(@"currentUser's following: %@", [RGUser currentUser].following);
                [[RGUser currentUser] saveInBackground];
            }
        }];
    }
}

@end
