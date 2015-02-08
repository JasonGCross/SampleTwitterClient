//
//  User.m
//  SampleTwitterClient
//
//  Created by Jason Cross on 2/8/15.
//  Copyright (c) 2015 Jason Cross. All rights reserved.
//

#import "User.h"
#import "Tweet.h"


@implementation User

@dynamic name;
@dynamic profile_image_url;
@dynamic screen_name;
@dynamic profile_image_data;
@dynamic profile_image_object;
@dynamic user_tweet;


- (void)willSave {
    UIImage * image = [self profile_image_object];
    if (nil != image) {
        NSData * imageData = UIImagePNGRepresentation(image);
        [self setProfile_image_data:imageData];
    }
}

- (UIImage *) profile_image_object {
    static NSString * key = @"profile_image_object";
    [self willAccessValueForKey:key];
    UIImage * value = [self primitiveValueForKey:key];
    [self didAccessValueForKey:key];
    if (nil == value) {
        if (nil != self.profile_image_data) {
            value = [UIImage imageWithData:self.profile_image_data];
            [self setPrimitiveValue:value forKey:key];
        }
    }
    return value;
}

@end
