//
//  CameraViewController.m
//  Retrogram
//
//  Created by Kyle Yoon on 10/27/14.
//  Copyright (c) 2014 yoonapps. All rights reserved.
//

#import "CameraViewController.h"
#import <Parse/Parse.h>
#import "RGPhoto.h"
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
    RGPhoto *photo = [RGPhoto object];
    photo.imageFile = imageFile;
    photo.poster = [RGUser currentUser];
    [photo saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        if (error) {
            NSLog(@"%@", error);
        } else {
            NSLog(@"Saved");
            NewsFeedViewController *newsFeedViewController = [[(UINavigationController *)[[self.tabBarController viewControllers] objectAtIndex:0] viewControllers] objectAtIndex:0];
            [newsFeedViewController queryMyPhotosAndFollowedUsersPhotos];
        }
    }];
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    UIImage *chosenImage = info[UIImagePickerControllerOriginalImage];
    UIImage *newImage = [self convertImageToGrayScale:chosenImage];
    [self savePickedImage:newImage];
    [picker dismissViewControllerAnimated:YES completion:^{
        self.tabBarController.selectedViewController = (UINavigationController *)[[self.tabBarController viewControllers] objectAtIndex:0];
    }];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    [picker dismissViewControllerAnimated:YES completion:^{
        self.tabBarController.selectedViewController = (UINavigationController *)[[self.tabBarController viewControllers] objectAtIndex:0];
    }];
}

- (UIImage *)convertImageToGrayScale:(UIImage *)image {
    CGRect imageRect = CGRectMake(0, 0, image.size.width, image.size.height);
    
    //Grayscale colorspace
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceGray();
    //Create bitmap content with current image size and grayscale colorspace
    CGContextRef context = CGBitmapContextCreate(nil, image.size.width, image.size.height, 8, 0, colorSpace, (CGBitmapInfo)kCGImageAlphaNone);
    //Draw image into current context with specified rectangle using previously defined context (with grayscale colorspace)
    CGContextDrawImage(context, imageRect, [image CGImage]);
    
    //Create bitmap image info from pixel data in current context
    CGImageRef imageRef = CGBitmapContextCreateImage(context);
    
    //Create a new UIImage object
    UIImage *newImage = [UIImage imageWithCGImage:imageRef];
    
    //Release colorspace, context and bitmap info
    CGColorSpaceRelease(colorSpace);
    CGContextRelease(context);
    CFRelease(imageRef);
    
    return newImage;
}

@end
