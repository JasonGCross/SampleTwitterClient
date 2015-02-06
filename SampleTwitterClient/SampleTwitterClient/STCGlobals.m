//
//  SampleTwitterClientConstants.m
//  SampleTwitterClient
//
//  Created by Jason Cross on 1/29/15.
//  Copyright (c) 2015 Jason Cross. All rights reserved.
//

#import "STCGlobals.h"

#pragma mark - segues
NSString* const kLoginToMasterSegueId = @"LoginToMasterSegue";
NSString* const kMasterToPostTweetSegueId = @"MasterToPostTweetSegue";

#pragma mark - notifications
NSString* const kNotificationNameNewTweetPosted = @"NotificationNewTweetPosted";
NSString* const kNotificationNameTwitterLoginSuccess = @"kNotificationNameTwitterLoginSuccess";

#pragma mark - miscellaneous string constants
NSString* const kTwitterCellReuseIdentifier = @"TwitterCustomCell";
NSString* const kTwitterAPIBasePath = @"https://api.twitter.com/1.1";


#pragma mark - class implementation
@implementation STCGlobals

@end
