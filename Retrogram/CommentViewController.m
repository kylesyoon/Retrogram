//
//  CommentViewController.m
//  Retrogram
//
//  Created by Kyle Yoon on 10/30/14.
//  Copyright (c) 2014 yoonapps. All rights reserved.
//

#import "CommentViewController.h"
#import "RGComment.h"
#import "RGUser.h"

@interface CommentViewController () <UITableViewDelegate, UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UITextField *commentTextField;
@property NSArray *queriedComments;
@property NSDateFormatter *dateFormatter;

@end

@implementation CommentViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    NSLog(@"For photoId:%@", self.currentPhotoId);
    [self queryCommentsForThisPhoto];
    self.dateFormatter = [[NSDateFormatter alloc] init];
    [self.dateFormatter setDateFormat:@"yyyy-MM-dd 'at' HH:mm"];
}

- (IBAction)onAddButtonTapped:(id)sender {
    RGComment *comment = [RGComment object];
    comment.text = self.commentTextField.text;
    comment.username = [RGUser currentUser].username;
    comment.photoId = self.currentPhotoId;
    [comment saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        if (error) {
            NSLog(@"%@", [error userInfo]);
        } else {
            //Need to reload the data
            [self queryCommentsForThisPhoto];
        }
    }];
}

- (void)queryCommentsForThisPhoto {
    PFQuery *queryComments = [RGComment query];
    [queryComments whereKey:@"photoId" equalTo:self.currentPhotoId];
    [queryComments orderByDescending:@"createdAt"];
    [queryComments findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        self.queriedComments = objects;
        NSLog(@"Got the comments: %@", self.queriedComments);
        [self.tableView reloadData];
    }];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.queriedComments.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CommentCell" forIndexPath:indexPath];
    RGComment *comment = [self.queriedComments objectAtIndex:indexPath.row];
    NSString *formattedDate = [self.dateFormatter stringFromDate:comment.createdAt];
    cell.textLabel.text = comment.text;
    cell.detailTextLabel.text = [NSString stringWithFormat:@"%@ on %@", comment.username, formattedDate];
    return cell;
}

@end
