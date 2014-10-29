//
//  CameraViewController.m
//  Retrogram
//
//  Created by Kyle Yoon on 10/27/14.
//  Copyright (c) 2014 yoonapps. All rights reserved.
//

#import "CameraViewController.h"
#import <Parse/Parse.h>
#import "Photo.h"
#import "NewsFeedViewController.h"

@interface CameraViewController () <UIImagePickerControllerDelegate, UINavigationControllerDelegate>
@property UIImagePickerController *imagePicker;

@end

@implementation CameraViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.imagePicker = [[UIImagePickerController alloc] init];
    self.imagePicker.delegate = self;
}

- (IBAction)takePhotoButton:(id)sender {
    if (![UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        UIAlertView *alertView = [[UIAlertView alloc] init];
        alertView.title = @"No camera available!";
        alertView.message = @"You can only choose this option with a device that has a camera.";
        [alertView addButtonWithTitle:@"Okay"];
        [alertView show];
    } else {
        self.imagePicker.sourceType = UIImagePickerControllerSourceTypeCamera;
        [self presentViewController:self.imagePicker animated:YES completion:nil];
    }
}

- (IBAction)choosePhotoLibraryButton:(id)sender {
    self.imagePicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    [self presentViewController:self.imagePicker animated:YES completion:nil];
}

- (void)savePickedImage:(UIImage *)image {
    NSData *imageData = UIImageJPEGRepresentation(image, 0.1f);
    PFFile *imageFile = [PFFile fileWithName:@"testing.jpg" data:imageData];
    Photo *photo = [Photo object];
    photo.imageFile = imageFile;
    photo.poster = [PFUser currentUser];
    [photo saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        if (error) {
            NSLog(@"%@", error);
        } else {
            NSLog(@"Saved");
            NewsFeedViewController *newsFeedViewController = [[(UINavigationController *)[[self.tabBarController viewControllers] objectAtIndex:0] viewControllers] objectAtIndex:0];
            [newsFeedViewController queryForPhotos];
        }
    }];
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    UIImage *chosenImage = info[UIImagePickerControllerOriginalImage];
    [self savePickedImage:chosenImage];
    [picker dismissViewControllerAnimated:YES completion:^{
        self.tabBarController.selectedViewController = (UINavigationController *)[[self.tabBarController viewControllers] objectAtIndex:0];
    }];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    [picker dismissViewControllerAnimated:YES completion:^{
        self.tabBarController.selectedViewController = (UINavigationController *)[[self.tabBarController viewControllers] objectAtIndex:0];
    }];
}

@end
