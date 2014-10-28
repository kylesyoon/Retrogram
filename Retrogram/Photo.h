//
//  Photo.h
//  Retrogram
//
//  Created by Kyle Yoon on 10/27/14.
//  Copyright (c) 2014 yoonapps. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "User.h"
#import <Parse/Parse.h>


@interface Photo : NSObject

@property NSString *photoID;
@property UIImage *image;
@property NSDate *postDate;
//@property User *poster;
//@property NSArray *usersWhoLiked;

- (instancetype)initWithPhoto:(UIImage *)image photoID:(NSString *)photoID date:(NSDate *)postDate;
+ (void)retrieveNewsFeedPhotosWithCurrentUser:(User *)user completion:(void(^)(NSArray *))completion;
+ (void)retrieveUserPhotosWithCompletion:(void(^)(NSArray *))completion;
- (void)savePhoto;

@end
