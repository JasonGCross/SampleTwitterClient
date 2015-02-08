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

@interface User : JGCBaseModel

@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSString * profile_image_url;
@property (nonatomic, retain) NSString * screen_name;
@property (nonatomic, retain) NSData * profile_image_data;
@property (nonatomic, retain) UIImage* profile_image_object;
@property (nonatomic, retain) Tweet *user_tweets;

@end
