//
//  RGUser.h
//  Retrogram
//
//  Created by Kyle Yoon on 10/29/14.
//  Copyright (c) 2014 yoonapps. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Parse/Parse.h>

@interface RGUser : PFUser <PFSubclassing>

@property NSArray *followers;
@property NSArray *following;

+ (RGUser *)currentUser;
+ (RGUser *)user;

@end
