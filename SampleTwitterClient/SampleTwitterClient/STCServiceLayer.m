//
//  MockWebService.m
//  SampleTwitterClient
//
//  Created by Jason Cross on 1/29/15.
//  Copyright (c) 2015 Jason Cross. All rights reserved.
//


#import "STCServiceLayer.h"
#import "STCGlobals.h"
#import "STCDataManager.h"
#import "Tweet.h"
#import <Social/Social.h>
#import <Accounts/Accounts.h>
#import "STSSettingsManager.h"
#import "NSError+JGCErrorDictionaryForDescriptionAndReason.h"


static ACAccount * twitterAcAccount;
static NSOperationQueue * requestOperationQueue;


@implementation STCServiceLayer

+(void)initialize {
    requestOperationQueue = [[NSOperationQueue alloc]init];
}

/**
 used to simulate delay in web service
 */
+ (void)waitForCompletion:(NSTimeInterval)timeoutSecs {
    NSDate *timeoutDate = [NSDate dateWithTimeIntervalSinceNow:timeoutSecs];
    BOOL done = NO;
    do {
        [[NSRunLoop currentRunLoop] runMode:NSDefaultRunLoopMode beforeDate:timeoutDate];
        if ([timeoutDate timeIntervalSinceNow] < 0.0) {
            break;
        }
    } while (!done);
    
    return;
}

+ (void) loginWithUsername:(NSString*)username password:(NSString*)password responseBlock:(WebServiceLoginResponseBlock)responseBlock; {
    
    BOOL result = NO;
    NSError * err = nil;
    
    // simulate network delay
    [self waitForCompletion:1.0];
    
    if ([[username lowercaseString] isEqualToString:@"tester"] && [password isEqualToString:@"abc123"]) {
        result = YES;
    }
    if (!result) {
        NSDictionary * info = [NSError jgc_errorDictionaryForDescription:@"The username / password combination is invalid"
                                                                  reason:@"Ensure you have entered the username and password correctly."
                                                         underlyingError:nil];

        err = [NSError errorWithDomain:@"ca.jasoncross.login"
                                  code:kSampleTwitterClientErrorCodeLoginError
                              userInfo:info];
    }
    
    responseBlock(result, err);
}

#pragma mark - user authentication

+ (void) loginDeveloperAccountUsingResponseBlock:(WebServiceLoginResponseBlock)responseBlock; {
    ACAccountStore * accountStore = [[ACAccountStore alloc]init];
    ACAccountType * twitterAccountType = [accountStore accountTypeWithAccountTypeIdentifier:ACAccountTypeIdentifierTwitter];

    [accountStore requestAccessToAccountsWithType:twitterAccountType options:nil completion:^(BOOL granted, NSError *error) {

        if (NO == granted) {
            NSLog(@"permission denied to twitter account store");
            responseBlock(NO, error);
        }
        else {
            // log in to a single user's account, for development and testing only
            // https://dev.twitter.com/oauth/overview/application-owner-access-tokens
            
            ACAccount * twitterAccount = nil;
            NSArray * matchingAccounts = [accountStore accountsWithAccountType:twitterAccountType];
            if (matchingAccounts.count > 0) {
                twitterAccount = matchingAccounts.lastObject;
            }
            else {
                twitterAccount = [[ACAccount alloc]initWithAccountType:twitterAccountType];
                ACAccountCredential * accountCredential = [[ACAccountCredential alloc]initWithOAuthToken:@"1499396000-y8GRiXrI9N2xX4hhLkc8wy7nynyh0FK2CjkKyN7"
                                                                                             tokenSecret:@"ZniBNmt7ZY4lT83SGBeDVIrsoSquz00k821DMBfjxEsVO"];
                twitterAccount.credential = accountCredential;
            }
            twitterAcAccount = twitterAccount;
            
            [accountStore saveAccount:twitterAcAccount withCompletionHandler:^(BOOL success, NSError *error) {
                if (NO == success) {
                    NSLog(@"Save of twitter account failed");
                    responseBlock(NO, error);
                }
                else {
                    [[NSNotificationCenter defaultCenter] postNotificationName:kNotificationNameTwitterLoginSuccess object:nil];
                    responseBlock(YES, error);
                }
            }];

        }
    }];

}

#pragma mark - data calls


+ (NSFetchRequest *)fetchRequestForLastFetchedTweet:(NSEntityDescription *)entity {
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    [fetchRequest setEntity:entity];
    [fetchRequest setFetchLimit:1];
    
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"id_str" ascending:NO];
    NSArray *sortDescriptors = @[sortDescriptor];
    [fetchRequest setSortDescriptors:sortDescriptors];
    return fetchRequest;
}

+ (SLRequest *)twitterRequestSinceLatestTweet:(Tweet *)latestTweet {
    SLRequest *twitterRequest;

    NSURL * url = [NSURL URLWithString:kTwitterAPIBasePath];
    NSDictionary * parameters = nil;
    NSMutableDictionary * mutableParameters = [[NSMutableDictionary alloc]initWithCapacity:2];
    
    // do not fetch all new tweets from Twitter
    // see https://dev.twitter.com/rest/public/timelines
    // Twitter advises using two parameters for maximum efficiency:
    //   1 - max_id (remember from last call)
    //   2 - since_id (the smallest identifier amongst all tweets previously fetched)
    if (latestTweet.id_str.length > 0) {
        mutableParameters[@"since_id"] = latestTweet.id_str;
    }
    
    STSSettingsManager * settingsManager = [STSSettingsManager sharedInstance];
    NSString * maxIdString = [settingsManager maximumTweetIdFromPreviousFetch];
    if (maxIdString.length > 0) {
        NSInteger maxIdInt = [maxIdString integerValue];
        mutableParameters[@"max_id"] =  @(maxIdInt - 1);
    }

    if (mutableParameters.count > 0) {
        parameters = [NSDictionary dictionaryWithDictionary:mutableParameters];
    }
    
    twitterRequest = [SLRequest requestForServiceType:SLServiceTypeTwitter
                                        requestMethod:SLRequestMethodGET
                                                  URL:url
                                           parameters:parameters];
    twitterRequest.account = twitterAcAccount;
    return twitterRequest;
}

+ (void) fetchTweetsSinceDate:(NSDate*)date responseBlock:(TweetsResponseBlock)responseBlock; {

    __block NSError * err = nil;
    
    NSManagedObjectContext * context = [[STCDataManager sharedManager] managedObjectContext];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Tweet" inManagedObjectContext:context];
    NSFetchRequest *fetchRequest = [self fetchRequestForLastFetchedTweet:entity];
    
    // do we have any tweets yet?
    NSError * fetchError = nil;
    NSArray * previousTweets = [context executeFetchRequest:fetchRequest error:&fetchError];

    if (nil != fetchError) {
        NSDictionary * info = [NSError jgc_errorDictionaryForDescription:@""
                                                                  reason:@""
                                                         underlyingError:fetchError];
        err = [NSError errorWithDomain:fetchError.domain
                                  code:fetchError.code
                              userInfo:info];
        responseBlock(err);
    }
    else {
        Tweet * latestTweet = previousTweets.firstObject;  // safe: if the array is empty, returns nil
        SLRequest * twitterRequest = nil;
        
        twitterRequest = [self twitterRequestSinceLatestTweet:latestTweet];
        
        [twitterRequest performRequestWithHandler:^(NSData *responseData, NSHTTPURLResponse *urlResponse, NSError *connectionError) {
            if ((nil != urlResponse) && (nil == connectionError)) {
                if (nil != responseData) {
                    NSError * jsonDeserializationError = nil;
                    id obj = [NSJSONSerialization JSONObjectWithData:responseData options:0 error:&jsonDeserializationError];
                    if (nil == jsonDeserializationError) {
                        if ([obj isKindOfClass:[NSArray class]]) {
                            NSArray * jsonArray = (NSArray*)obj;
                            [jsonArray enumerateObjectsUsingBlock:^(id value, NSUInteger idx, BOOL *stop) {
                                if ([value isKindOfClass:[NSDictionary class]]) {
                                    NSDictionary * dictionary = (NSDictionary*)value;
                                    Tweet * tweet = [[Tweet alloc]initWithEntity:entity insertIntoManagedObjectContext:context];
                                    [tweet setValuesForKeysWithDictionary:dictionary];
                                    
                                    // remember the maxId for the next call
                                    if ((idx == jsonArray.count - 1) && (tweet.id_str.length > 1)) {
                                        STSSettingsManager * settingsManager = [STSSettingsManager sharedInstance];
                                        [settingsManager setMaximumTweetIdFromPreviousFetch:tweet.id_str];
                                    }
                                }
                            }];
                            [[STCDataManager sharedManager] saveContext];
                        }
                    }
                    else  {
                        NSDictionary * info = [NSError jgc_errorDictionaryForDescription:@"JSON Error"
                                                                                  reason:@"The data received from the server was not in the expected format."
                                                                         underlyingError:jsonDeserializationError];
                        err = [NSError errorWithDomain:jsonDeserializationError.domain
                                                  code:jsonDeserializationError.code
                                              userInfo:info];
                    }
                }
            }
            else {
                NSDictionary * info = [NSError jgc_errorDictionaryForDescription:@"Connection Error"
                                                                          reason:@"Check your network connections or try again later."
                                                                 underlyingError:connectionError];
                err = [NSError errorWithDomain:connectionError.domain
                                          code:connectionError.code
                                      userInfo:info];
            }
            
            responseBlock(err);
        }];
    }
}

+ (void) postTweetText:(NSString*)tweetText responseBlock:(WebServiceLoginResponseBlock)responseBlock; {
    BOOL result = NO;
    NSError * err = nil;
    
    if (tweetText.length > 1 && tweetText.length < kMaxTwitterTextCharacterLength) {
        result = YES;
        
        // normally, we would not save anything locally until after the API confirmed the new tweet
        BOOL apiCallSuccess = YES;
        if (apiCallSuccess) {
            NSManagedObjectContext * context = [[STCDataManager sharedManager]managedObjectContext];
            NSEntityDescription *entity = [NSEntityDescription entityForName:@"Tweet" inManagedObjectContext:context];
            
            Tweet * managedModelObject = [[Tweet alloc]initWithEntity:entity insertIntoManagedObjectContext:context];
            managedModelObject.created_at = [NSDate date];
            managedModelObject.text = tweetText;
            managedModelObject.favourite_count = @0;
            
            // Save the context.
            NSError *error = nil;
            if (![context save:&error]) {
                err = [[NSError alloc]initWithDomain:error.domain
                                                code:error.code
                                            userInfo:error.userInfo];
            }
            else {
                [[NSNotificationCenter defaultCenter]postNotificationName:kNotificationNameNewTweetPosted object:nil];
            }
        }
        
        
        

    }
    else {
        NSString * recoverySuggestion = [NSString stringWithFormat:@"Limit tweets to %i characters or less.", kMaxTwitterTextCharacterLength];
        NSDictionary * userInfo = [NSError jgc_errorDictionaryForDescription:@"The tweet is too long"
                                                                      reason:recoverySuggestion
                                                             underlyingError:nil];
  
        err = [NSError errorWithDomain:@"ca.jasoncross.posttweet"
                                  code:kSampleTwitterClientErrorCodeTweetTooLong
                              userInfo:userInfo];
    }
    
    responseBlock(result, err);
}

+ (BOOL) firstDate:(NSDate*)firstDate isGreaterThanSecondDate:(NSDate*)secondDate byMoreThanXMinutes:(NSUInteger)minutes {
    BOOL value = NO;
    
    NSTimeInterval difference = [firstDate timeIntervalSinceDate:secondDate];
    NSInteger dateDifferenceInMinutes = difference / 60.0;
    if ([@(dateDifferenceInMinutes) compare:@(minutes)] == NSOrderedDescending) {
        value = YES;
    }
    
    return value;
}

@end
