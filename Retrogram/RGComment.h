//
//  RGComment.h
//  Retrogram
//
//  Created by Kyle Yoon on 10/30/14.
//  Copyright (c) 2014 yoonapps. All rights reserved.
//

#import <Parse/Parse.h>

@interface RGComment : PFObject <PFSubclassing>

@property NSString *text;
@property NSString *photoId;
@property NSString *username;

@end
