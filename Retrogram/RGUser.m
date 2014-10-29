//
//  RGUser.m
//  Retrogram
//
//  Created by Kyle Yoon on 10/29/14.
//  Copyright (c) 2014 yoonapps. All rights reserved.
//

#import "RGUser.h"
#import <Parse/PFUser.h>

@implementation RGUser

@dynamic following;
@dynamic followers;

+ (void)load {
    [self registerSubclass];
}

+ (RGUser *)currentUser {
    return (RGUser *)[PFUser currentUser];
}

+ (RGUser *)user {
    return (RGUser *)[PFUser user];
}

@end
