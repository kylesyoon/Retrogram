//
//  RGFollowing.h
//  Retrogram
//
//  Created by Kyle Yoon on 10/29/14.
//  Copyright (c) 2014 yoonapps. All rights reserved.
//

#import <Parse/Parse.h>
#import "RGUser.h"


@interface RGFollowing : PFObject <PFSubclassing>

@property RGUser *followingUser;
@property RGUser *followedUser;

@end
