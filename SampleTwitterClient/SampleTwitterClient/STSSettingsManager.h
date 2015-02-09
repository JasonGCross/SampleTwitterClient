//
//  STSSettingsManager.h
//  SampleTwitterClient
//
//  Created by Jason Cross on 2/6/15.
//  Copyright (c) 2015 Jason Cross. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface STSSettingsManager : NSObject

/*!
 The global singleton for accessing application settings which persist to disk.
 */
+ (STSSettingsManager*) sharedInstance; 

/*!
 The saved identifier of the last tweet fetched during a previous call to the Twitter API.
 @discussion this is needed to optimize API calls by not requesting previously-fetched tweets
 */
@property (nonatomic, strong) NSString * maximumTweetIdFromPreviousFetch;

@end
