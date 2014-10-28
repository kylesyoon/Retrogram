//
//  Photo.m
//  Retrogram
//
//  Created by Kyle Yoon on 10/27/14.
//  Copyright (c) 2014 yoonapps. All rights reserved.
//

#import "Photo.h"

@implementation Photo

- (instancetype)initWithPhoto:(UIImage *)image photoID:(NSString *)photoID date:(NSDate *)postDate {
    self = [super init];
    self.image = image;
    self.photoID = photoID;
//    self.poster = poster;
    self.postDate = postDate;
    
    return self;
}

+ (void)retrieveNewsFeedPhotosWithCurrentUser:(User *)user completion:(void(^)(NSArray *))completion {

}

+ (void)retrieveUserPhotosWithCompletion:(void(^)(NSArray *))completion {
    PFQuery *query  =[PFQuery queryWithClassName:@"Photo"];
    [query orderByDescending:@"createdAt"];
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if (error) {
            NSLog(@"Error querying: %@", [error userInfo]);
        } else {
            NSMutableArray *myPhotos = [NSMutableArray array];
            for (PFObject *object in objects) {
                Photo *myPhoto = [[Photo alloc] initWithPhoto:[UIImage imageWithData:object[@"image"]] photoID:object.objectId date:object.createdAt];
                [myPhotos addObject:myPhoto];
                NSLog(@"%@", myPhoto.postDate);
            }
            completion(myPhotos);
        }
    }];
}

- (void)savePhoto {
    //Convert UIImage into NSData
    NSData *imageData = UIImageJPEGRepresentation(self.image, 0.3f);
    
    PFObject *savedPhoto = [PFObject objectWithClassName:@"Photo"];
    savedPhoto[@"image"] = imageData;
    [savedPhoto saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        if (error) {
            NSLog(@"Error saving: %@", [error userInfo]);
        } else {
            //reload the data in viewcontroller
            NSLog(@"Save was sucessful");
        }
    }];
}

@end
