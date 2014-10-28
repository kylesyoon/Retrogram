//
//  CameraViewController.m
//  Retrogram
//
//  Created by Kyle Yoon on 10/27/14.
//  Copyright (c) 2014 yoonapps. All rights reserved.
//

#import "CameraViewController.h"
#import "User.h"
#import "Photo.h"
#import "ProfileViewController.h"

@interface CameraViewController () <UIImagePickerControllerDelegate, UINavigationControllerDelegate>

@end

@implementation CameraViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self showCamera];
}

- (void)showCamera {
    if (![UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        UIImagePickerController *photoLib = [[UIImagePickerController alloc] init];
        photoLib.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        photoLib.delegate = self;
        [self presentViewController:photoLib animated:YES completion:nil];
    } else {
        UIImagePickerController *imagePicker = [[UIImagePickerController alloc] init];
        imagePicker.sourceType = UIImagePickerControllerSourceTypeCamera;
        imagePicker.delegate = self;
        //        imagePicker.allowsEditing = YES;
        [self presentViewController:imagePicker animated:YES completion:nil];
    }
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
//    UIImage *chosenImage = info[UIImagePickerControllerOriginalImage];
//    Photo *photo = [[Photo alloc] initWithPhoto:chosenImage photoID:[self generateRandomNumberForPhotoID] date:[NSDate date]];
    //    [photo savePhoto];
    [picker dismissViewControllerAnimated:YES completion:^{
        NSLog(@"Initializing segue");
        UIStoryboardSegue *segueToProfile = [UIStoryboardSegue segueWithIdentifier:@"segueProfile" source:self destination:(ProfileViewController *)[[(UINavigationController *)[[self.tabBarController viewControllers] objectAtIndex:4] viewControllers] objectAtIndex:0] performHandler:^{
            
        }];
        [self prepareForSegue:segueToProfile sender:self];
        [segueToProfile perform];
        //Segue is not performing!!!!
    }];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    [picker dismissViewControllerAnimated:YES completion:nil];
    
    UIView *currentView = self.tabBarController.selectedViewController.view;
    UIView *transitionProfileView = [[self.tabBarController.viewControllers objectAtIndex:0] view];
    
    [UIView transitionFromView:currentView toView:transitionProfileView duration:0.3 options:UIViewAnimationOptionTransitionFlipFromLeft completion:^(BOOL finished) {
        if (finished) {
            NSLog(@"Transition finished");
        }
    }];
}

- (NSString *)generateRandomNumberForPhotoID {
    NSString *letters = @"abcdefghijklmnopqrstuvwxyzabcdefghijklmnopqrstuvwz0987654321";
    NSMutableString *randomID = [NSMutableString stringWithCapacity:10];
    for (int i = 0; i < 10 ; i++) {
        [randomID appendFormat:@"%C", [letters characterAtIndex:arc4random_uniform((u_int32_t)[letters length])]];
    }
    return randomID;
}


@end
