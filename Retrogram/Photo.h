//
//  Photo.h
//  Retrogram
//
//  Created by Kyle Yoon on 10/27/14.
//  Copyright (c) 2014 yoonapps. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Parse/Parse.h>

@interface Photo : PFObject <PFSubclassing>

@property PFFile *imageFile;
@property PFUser *poster;

@end
