//
//  User.h
//  SampleTwitterClient
//
//  Created by Jason Cross on 2/8/15.
//  Copyright (c) 2015 Jason Cross. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
#import "JGCBaseModel.h"
#import <UIKit/UIKit.h>

@class Tweet;
@class MKNetworkOperation;

@interface User : JGCBaseModel

@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSString * profile_image_url;
@property (nonatomic, retain) NSString * screen_name;
@property (nonatomic, retain) UIImage* profile_image;
@property (nonatomic, retain) NSSet * user_tweets;
@property (strong, nonatomic) MKNetworkOperation * networkOperation;

// expose for testing
+ (User*) matchingOrNewlyCreatedUserForSerializedUser:(NSDictionary*)serializedUser
                                 managedObjectContext:(NSManagedObjectContext*)context;
@end



@interface User (STSCoreDataGeneratedAccessors)
- (void)addUser_tweetsObject:(NSManagedObject*)value;
- (void)removeUser_tweetsObject:(NSManagedObject*)value;
- (void)addUser_tweets:(NSSet*)value;
- (void)removeUser_tweets:(NSSet*)value;
@end