//
//  RGComment.m
//  Retrogram
//
//  Created by Kyle Yoon on 10/30/14.
//  Copyright (c) 2014 yoonapps. All rights reserved.
//

#import "RGComment.h"

@implementation RGComment

@dynamic text;
@dynamic photoId;
@dynamic username;

+ (NSString *)parseClassName {
    return @"RGComment";
}

+ (void)load {
    [self registerSubclass];
}

@end
