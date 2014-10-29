//
//  Photo.m
//  Retrogram
//
//  Created by Kyle Yoon on 10/27/14.
//  Copyright (c) 2014 yoonapps. All rights reserved.
//

#import "Photo.h"
#import <Parse/PFObject+Subclass.h>

@implementation Photo

@dynamic imageFile;
@dynamic poster;

+ (NSString *)parseClassName {
    return @"Photo";
}

+ (void)load {
    [self registerSubclass];
}

@end
