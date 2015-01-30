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


extern NSString* const kLoginToMasterSegueId;
extern NSString* const kTwitterCellReuseIdentifier;
extern NSString* const kMasterToPostTweetSegueId;
extern NSString* const kNotificationNameNewTweetPosted;

@interface STCGlobals : NSObject

@end
