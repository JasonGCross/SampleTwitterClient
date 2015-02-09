//
//  MockWebService.h
//  SampleTwitterClient
//
//  Created by Jason Cross on 1/29/15.
//  Copyright (c) 2015 Jason Cross. All rights reserved.
//
//  Purpose: This class takes the place of a ServiceLayer, which would act as
//    an adapter for a real web service. The client does not need to know
//    how to access the Web Service; the client simply makes requests to the
//    ServiceLayer, and receives a response.

#import <Foundation/Foundation.h>

typedef void (^WebServiceLoginResponseBlock) (BOOL success, NSError * error);
typedef void (^TweetsResponseBlock) (NSError* error);

@interface STCServiceLayer : NSObject

/*!
 Performs a single-user login against the Twitter API using developer's credentials as stored in code
 @param responseBlock the block of code which will be executed when the login attempt finishes
 */
+ (void) loginDeveloperAccountUsingResponseBlock:(WebServiceLoginResponseBlock)responseBlock;

/*!
 Performs a mock login against a in-code stored username / password. Does not hit an external API
 @discussion simulates a network call by making the user wait a small time interval
 @param responseBlock the block of code which will be executed when the login attempt finishes
 */
+ (void) loginWithUsername:(NSString*)username password:(NSString*)password responseBlock:(WebServiceLoginResponseBlock)responseBlock;

/*!
 Performs a request to the Twitter API for tweets which have not previously been fetched
 from the logged in user's home timeline
 @param responseBlock the block of code which will be executed when the fetch finishes with success or failure
 */
+ (void) fetchNewTweetsWithResponseBlock:(TweetsResponseBlock)responseBlock;

/*!
 Simulates a tweet post by performing a small time interval delay. Currently does neither
 hit the live Twitter API or make changes to the local persisted data.
 @param responseBlock the block of code which will be executed when the post finishes with success or failure
 */
+ (void) postTweetText:(NSString*)tweetText responseBlock:(WebServiceLoginResponseBlock)responseBlock;

/*!
 Determines if the first date is greater than the second date by more than the specified minutes.
 @discussion this method is useful when the twitter API is not hit, but instead we decide locally if we should
 create more fake tweets or just return the existing data set.
 @param firstDate the first date to be compared, normally the date of the last tweet received
 @param secondDate the second date to be compared, normally now
 @parm minutes the threshold between dates. For example if the first date is one hour ago from now (the second date), and the minutes parameter is 70 minutes, will return false.
 */
+ (BOOL) firstDate:(NSDate*)firstDate isGreaterThanSecondDate:(NSDate*)secondDate byMoreThanXMinutes:(NSUInteger)minutes;

@end
