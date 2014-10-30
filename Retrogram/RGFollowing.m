//
//  RGFollowing.m
//  Retrogram
//
//  Created by Kyle Yoon on 10/29/14.
//  Copyright (c) 2014 yoonapps. All rights reserved.
//

#import "RGFollowing.h"


@implementation RGFollowing
@dynamic followedUser;
@dynamic followingUser;

+ (NSString *)parseClassName {
    return @"RGFollowing";
}

+ (void)load {
    [self registerSubclass];
}


@end
