//
//  LoginViewController.m
//  Retrogram
//
//  Created by Kyle Yoon on 10/28/14.
//  Copyright (c) 2014 yoonapps. All rights reserved.
//

#import "LoginViewController.h"

@interface LoginViewController ()
@property (weak, nonatomic) IBOutlet UITextField *usernameTextField;
@property (weak, nonatomic) IBOutlet UITextField *passwordTextField;

@end

@implementation LoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (IBAction)onLoginButtonPressed:(id)sender {
    [PFUser logInWithUsernameInBackground:self.usernameTextField.text password:self.passwordTextField.text block:^(PFUser *user, NSError *error) {
        if (error) {
            NSLog(@"%@", error);
            //Alert user log in was not successful.
        } else {
            NSLog(@"Successful login");
            [self dismissViewControllerAnimated:YES completion:nil];
        }
    }];
}

@end
