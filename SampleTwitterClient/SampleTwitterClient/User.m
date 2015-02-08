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
@dynamic profile_image;
@dynamic user_tweets;


#pragma mark - key value coding

- (void) setProfile_image_url:(NSString *)value {
    static NSString * key = @"profile_image_url";
    
    // if the url has changed, we need to remove the old image data
    NSString * oldImagePath = self.profile_image_url;
    if ((nil != oldImagePath) && [oldImagePath isEqualToString:value]) {
        NSLog(@"the user thumnail image url has not changed");
        // do nothing to the image data or the image object
    }
    else {
        self.profile_image = nil;
    }
    
    [self willChangeValueForKey:key];
    [self setPrimitiveValue:value forKey:key];
    [self didChangeValueForKey:key];
}

// expose for testing
+ (User*) matchingOrNewlyCreatedUserForSerializedUser:(NSDictionary*)serializedUser
                                 managedObjectContext:(NSManagedObjectContext*)context; {
    
    User * value = nil;
    NSEntityDescription * entity = [NSEntityDescription entityForName:@"User" inManagedObjectContext:context];
    
    NSString * userScreenName = serializedUser[@"screen_name"];
    if (nil != userScreenName) {
        NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
        [fetchRequest setEntity:entity];
        [fetchRequest setFetchLimit:1];
        NSPredicate * predicate = [NSPredicate predicateWithFormat:@"screen_name like %@", userScreenName];
        [fetchRequest setPredicate:predicate];
        NSError * fetchError = nil;
        
        NSArray * matchingUsers = [context executeFetchRequest:fetchRequest error:&fetchError];
        if (nil == fetchError) {
            value = matchingUsers.firstObject;
        }
    }
    
    if (nil == value) {
        value = [[User alloc]initWithEntity:entity insertIntoManagedObjectContext:context];
        [value setValuesForKeysWithDictionary:serializedUser];
    }
    
    return value;
}

@end
