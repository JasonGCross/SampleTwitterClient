//
//  Tweet.h
//  SampleTwitterClient
//
//  Created by Jason Cross on 2/8/15.
//  Copyright (c) 2015 Jason Cross. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
#import "JGCBaseModel.h"

@class User;

@interface Tweet : JGCBaseModel

@property (nonatomic, retain) NSDate * created_at;
@property (nonatomic, retain) NSNumber * favourite_count;
@property (nonatomic, retain) NSString * id_str;
@property (nonatomic, retain) NSString * text;
@property (nonatomic, retain) NSNumber * retweet_count;
@property (nonatomic, retain) User *user;

@end
