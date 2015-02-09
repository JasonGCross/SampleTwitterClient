//
//  SampleTwitterClientConstants.h
//  SampleTwitterClient
//
//  Created by Jason Cross on 1/29/15.
//  Copyright (c) 2015 Jason Cross. All rights reserved.
//

#import <Foundation/Foundation.h>


#define kSampleTwitterClientErrorCodeLoginError 1001
#define kSampleTwitterClientErrorCodeTweetTooLong 1002
#define kMaxTwitterTextCharacterLength 140


#pragma mark - segues
extern NSString* const kLoginToMasterSegueId;
extern NSString* const kMasterToPostTweetSegueId;

#pragma mark - notifications
extern NSString* const kNotificationNameNewTweetPosted;
extern NSString* const kNotificationNameTwitterLoginSuccess;

#pragma mark - miscellaneous string constants
extern NSString* const kTwitterAPITimelinePath;


#pragma mark - class definition
@interface STCGlobals : NSObject

@end
