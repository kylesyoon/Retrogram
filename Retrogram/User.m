//
//  User.m
//  Retrogram
//
//  Created by Kyle Yoon on 10/27/14.
//  Copyright (c) 2014 yoonapps. All rights reserved.
//

#import "User.h"

@implementation User

- (instancetype)initWithUsername:(NSString *)username {
    self = [super init];
    self.username = username;
    
    return self;
}

@end
