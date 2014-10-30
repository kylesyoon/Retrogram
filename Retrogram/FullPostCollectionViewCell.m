//
//  FullPostCollectionViewCell.m
//  Retrogram
//
//  Created by Kyle Yoon on 10/28/14.
//  Copyright (c) 2014 yoonapps. All rights reserved.
//

#import "FullPostCollectionViewCell.h"

@implementation FullPostCollectionViewCell

- (void)layoutSubviews {
    [super layoutSubviews];
    self.imageView.frame = CGRectMake(0, 0, 310, 310);
    [self.imageView setContentMode:UIViewContentModeScaleAspectFill];
    [self.imageView setClipsToBounds:YES];
    [self.usernameLabel setFrame:CGRectMake(5, 315, 310, 20)];
    [self.timestampLabel setFrame:CGRectMake(5, 335, 310, 20)];
}

@end
