//
//  User.h
//  Retrogram
//
//  Created by Kyle Yoon on 10/27/14.
//  Copyright (c) 2014 yoonapps. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface User : NSObject

@property NSString *username;
//@property NSString *password;
@property NSString *email;
@property NSArray *myPhotos;
@property NSArray *likedPhotos;
@property NSArray *myFollowers;
@property NSArray *usersIFollow;

- (instancetype)initWithUsername:(NSString *)username;

@end
