//
//  SignUpViewController.m
//  Retrogram
//
//  Created by Kyle Yoon on 10/28/14.
//  Copyright (c) 2014 yoonapps. All rights reserved.
//

#import "SignUpViewController.h"

@interface SignUpViewController ()
@property (weak, nonatomic) IBOutlet UITextField *usernameTextField;
@property (weak, nonatomic) IBOutlet UITextField *passwordTextField;
@property (weak, nonatomic) IBOutlet UITextField *emailTextField;

@end

@implementation SignUpViewController

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (IBAction)onSignUpButtonPressed:(id)sender {
    if (![self.usernameTextField.text isEqualToString:@""] && ![self.passwordTextField.text isEqualToString:@""] && ![self.emailTextField.text isEqualToString:@""]) {
        PFUser *user = [PFUser user];
        user.username = self.usernameTextField.text;
        user.password = self.passwordTextField.text;
        user.email = self.emailTextField.text;
        
        [user signUpInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
            if (error) {
                NSLog(@"%@", error);
                //Alert user sign up was not successful.
            } else {
                //Alert user sign up was successful.
                NSLog(@"Sign up successful");
                [PFUser logInWithUsernameInBackground:self.usernameTextField.text password:self.passwordTextField.text block:^(PFUser *user, NSError *error) {
                    if (error) {
                        NSLog(@"%@", error);
                        //Alert user log in was not successful.
                    } else {
                        NSLog(@"Successful login");
                        self.loggedInUser = user;
                        [self dismissViewControllerAnimated:YES completion:nil];
                    }
                }];
            }
        }];
    } else {
        //Create alertview telling user they need to fill out fields.
    }
}



@end
