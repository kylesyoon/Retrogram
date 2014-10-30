//
//  IndividualPhotoViewController.m
//  Retrogram
//
//  Created by Kyle Yoon on 10/29/14.
//  Copyright (c) 2014 yoonapps. All rights reserved.
//

#import "IndividualPhotoViewController.h"
#import "RGFollowing.h"
#import "RGComment.h"
#import "CommentViewController.h"

@interface IndividualPhotoViewController () <UITableViewDataSource, UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (weak, nonatomic) IBOutlet UILabel *usernameLabel;
@property (weak, nonatomic) IBOutlet UILabel *dateLabel;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *followButton;
@property RGUser *photoUser;
@property BOOL isFollowing;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property NSDateFormatter *dateFormatter;
@property NSArray *queriedComments;

@end

@implementation IndividualPhotoViewController

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:YES];
    self.followButton.enabled = NO; //Will be enabled after checking if there is a relationship.
    [self queryForUser];
    [self queryCommentsForThisPhoto];
    //Date for photo
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateStyle:NSDateFormatterShortStyle];
    self.dateLabel.text = [dateFormatter stringFromDate:self.photo.createdAt];
    //Date for comments
    self.dateFormatter = [[NSDateFormatter alloc] init];
    [self.dateFormatter setDateFormat:@"yyyy-MM-dd 'at' HH:mm"];
    
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
    PFQuery *query = [RGFollowing query];
    [query whereKey:@"followingUser" equalTo:[RGUser currentUser]];
    [query whereKey:@"followedUser" equalTo:self.photoUser];
    [query countObjectsInBackgroundWithBlock:^(int number, NSError *error) {
        if (error) {
            NSLog(@"%@", error);
        } else {
            self.followButton.enabled = YES;
            if (number != 0) {
                self.isFollowing = YES;
                self.followButton.title = @"Following!";
                NSLog(@"Already following this user");
            } else {
                self.isFollowing = NO;
                self.followButton.title = @"Follow";
                NSLog(@"Not following this user yet");
            }
        }
    }];
}

- (IBAction)onFollowButtonWasTapped:(id)sender {
    //Need to add self.photoUser to currentUser's following array
    //Need to add currentUser to self.photoUser's followers array
    //Need to toggle back forth.
    
    //To follow
    if (self.isFollowing == NO) {
        NSLog(@"Following process started");
        self.followButton.title = @"Following!";
        self.followButton.enabled = NO;
        RGFollowing *following = [RGFollowing object];
        following.followingUser = [RGUser currentUser];
        following.followedUser = self.photoUser;
        [following saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
            if (error) {
                NSLog(@"%@", error);
            }
            self.followButton.enabled = YES;
        }];
    } else {
        NSLog(@"Unfollowing process started");
        self.followButton.title = @"Follow";
        self.followButton.enabled = NO;
        PFQuery *queryFollowing = [RGFollowing query];
        [queryFollowing whereKey:@"followingUser" equalTo:[RGUser currentUser]];
        [queryFollowing whereKey:@"followedUser" equalTo:self.photoUser];
        [queryFollowing findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
            if (error) {
                NSLog(@"%@", error);
            } else {
                NSLog(@"Found Following to delete");
                RGFollowing *following = [objects firstObject];
                [following deleteInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
                    if (error) {
                        NSLog(@"%@", error);
                    } else {
                        self.followButton.enabled = YES;
                        NSLog(@"Deleted");
                    }
                }];
            }
        }];
    }
}

- (void)queryCommentsForThisPhoto {
    PFQuery *queryComments = [RGComment query];
    [queryComments whereKey:@"photoId" equalTo:self.photo.objectId];
    [queryComments orderByDescending:@"createdAt"];
    [queryComments findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        self.queriedComments = objects;
        [self.tableView reloadData];
    }];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.queriedComments.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CommentCell"];
    RGComment *comment = [self.queriedComments objectAtIndex:indexPath.row];
    NSString *formattedDate = [self.dateFormatter stringFromDate:comment.createdAt];
    cell.textLabel.text = comment.text;
    cell.detailTextLabel.text = [NSString stringWithFormat:@"%@ on %@", comment.username, formattedDate];
    return cell;
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    CommentViewController *commentViewController = segue.destinationViewController;
    commentViewController.currentPhotoId = self.photo.objectId;
}

@end
