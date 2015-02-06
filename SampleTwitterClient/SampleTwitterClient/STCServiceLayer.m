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
        NSDictionary * userInfo = @{
                                    NSLocalizedDescriptionKey : @"The username / password combination is invalid",
                                    NSLocalizedRecoverySuggestionErrorKey : @"Ensure you have entered the username and password correctly."
                                    };
        err = [NSError errorWithDomain:@"ca.jasoncross.login"
                                  code:kSampleTwitterClientErrorCodeLoginError
                              userInfo:userInfo];
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
                twitterAccount = matchingAccounts.firstObject;
            }
            else {
                twitterAccount = [[ACAccount alloc]initWithAccountType:twitterAccountType];
            }
            twitterAcAccount = twitterAccount;
            
            ACAccountCredential * accountCredential = [[ACAccountCredential alloc]initWithOAuthToken:@"1499396000-y8GRiXrI9N2xX4hhLkc8wy7nynyh0FK2CjkKyN7"
                                                                                         tokenSecret:@"ZniBNmt7ZY4lT83SGBeDVIrsoSquz00k821DMBfjxEsVO"];
            twitterAccount.credential = accountCredential;
            [accountStore saveAccount:twitterAccount withCompletionHandler:^(BOOL success, NSError *error) {
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

+ (void) fetchTweetsSinceDate:(NSDate*)date responseBlock:(TweetsResponseBlock)responseBlock; {
    NSMutableArray * resultsArray = [[NSMutableArray alloc]initWithCapacity:2];
    __block NSError * err = nil;
    
    // note: in calling a real API, we would pass in the date as a parameter and also pass in a user ID, amongst others
    // but for this proof of concept, just create two new tweets
    // note that *new* means checking the saved data, which would normally be done on the server
    
    NSManagedObjectContext * context = [[STCDataManager sharedManager] managedObjectContext];
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    // Edit the entity name as appropriate.
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Tweet" inManagedObjectContext:context];
    [fetchRequest setEntity:entity];
    
    // Set the batch size to a suitable number.
    [fetchRequest setFetchBatchSize:20];
    
    // Edit the sort key as appropriate.
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"created_at" ascending:NO];
    NSArray *sortDescriptors = @[sortDescriptor];
    
    [fetchRequest setSortDescriptors:sortDescriptors];
    NSError * fetchError = nil;
    NSArray * previousTweets = [context executeFetchRequest:fetchRequest error:&fetchError];
    if (nil != fetchError) {
        err = [[NSError alloc]initWithDomain:fetchError.domain
                                        code:fetchError.code
                                    userInfo:fetchError.userInfo];
    }

//    if (previousTweets.count < 1) {
        // fetch all new tweets from Twitter
        
        NSString * path = [kTwitterAPIBasePath stringByAppendingPathComponent:@"statuses/home_timeline.json"];
        NSURL * url = [NSURL URLWithString:@"https://api.twitter.com/1.1/statuses/home_timeline.json"];
        SLRequest * twitterRequest = [SLRequest requestForServiceType:SLServiceTypeTwitter
                                                        requestMethod:SLRequestMethodGET
                                                                  URL:url
                                                           parameters:nil];
        twitterRequest.account = twitterAcAccount;
    
        [twitterRequest performRequestWithHandler:^(NSData *responseData, NSHTTPURLResponse *urlResponse, NSError *connectionError) {
            if ((nil != urlResponse) && (nil == connectionError)) {
                if (nil != responseData) {
                    NSError * jsonDeserializationError = nil;
                    id obj = [NSJSONSerialization JSONObjectWithData:responseData options:0 error:&jsonDeserializationError];
                    if (nil == jsonDeserializationError) {
                        if ([obj isKindOfClass:[NSArray class]]) {
                            NSArray * jsonArray = (NSArray*)obj;
                            NSLog(@"%@", jsonArray);
                        }
                    }
                    else  {
                        err = [jsonDeserializationError copy];
                    }
                }
            }
            else {
                err = [connectionError copy];
            }
            responseBlock(resultsArray, err);

        }];
    
    
//        NSURLRequest * urlRequest = [twitterRequest preparedURLRequest];
    
//        [NSURLConnection sendAsynchronousRequest:urlRequest queue:requestOperationQueue completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
//            if ((nil != response) && (nil == connectionError)) {
//                if (nil != data) {
//                    NSError * jsonDeserializationError = nil;
//                    id obj = [NSJSONSerialization JSONObjectWithData:data options:0 error:&jsonDeserializationError];
//                    if (nil == jsonDeserializationError) {
//                        if ([obj isKindOfClass:[NSArray class]]) {
//                            NSArray * jsonArray = (NSArray*)obj;
//                            NSLog(@"%@", jsonArray);
//                        }
//                    }
//                    else  {
//                        err = [jsonDeserializationError copy];
//                    }
//                }
//            }
//            else {
//                err = [connectionError copy];
//            }
//            responseBlock(resultsArray, err);
//        }];
    
        return;
        
//        Tweet * firstTweet = [[Tweet alloc]initWithEntity:entity insertIntoManagedObjectContext:context];
//        firstTweet.text = @"how exciting, my very first tweet!";
//        firstTweet.id_str = @"abc123myfirsttweet";
//        firstTweet.created_at = [NSDate date];
//        firstTweet.favourites_count = @4;
//        
//        [resultsArray addObject:firstTweet];
//        
//        Tweet * secondTweet = [[Tweet alloc]initWithEntity:entity insertIntoManagedObjectContext:context];
//        secondTweet.text = @"it's still kinda fun";
//        secondTweet.id_str = @"abcxyzmysecondtweet";
//        secondTweet.created_at = [NSDate date];
//        secondTweet.favourites_count = @13;
//        
//        [resultsArray addObject:secondTweet];
//        
//        [[STCDataManager sharedManager] saveContext];
//    }
//    else {
//        // fake that the favorite count has been increased by others
//        for (Tweet * tweet in previousTweets) {
//            tweet.favourites_count = @([tweet.favourites_count integerValue] + 1);
//        }
//        
//        // what is the date of the latest tweet?
//        
//        static NSDateFormatter * dateFormatter = nil;
//        if (nil == dateFormatter) {
//            dateFormatter = [[NSDateFormatter alloc]init];
//            [dateFormatter setDateFormat:@"yyyy/MMM/d[hh.mm.ss.SSSSSS]"];
//        }
//        
//        Tweet * latestTweet = previousTweets.firstObject;
//        NSDate * latestTweetDate = latestTweet.created_at;
//        
//        BOOL dateIsStale = [self firstDate:latestTweetDate isGreaterThanSecondDate:date  byMoreThanXMinutes:9];
//        if (dateIsStale) {
//            Tweet * firstTweet = [[Tweet alloc]initWithEntity:entity insertIntoManagedObjectContext:context];
//            firstTweet.created_at = [NSDate date];
//            NSString * dateString = [dateFormatter stringFromDate:firstTweet.created_at];
//            firstTweet.text = [NSString stringWithFormat:@"One more tweet sent at: %@", dateString];
//            firstTweet.id_str = dateString;
//            
//            
//            [resultsArray addObject:firstTweet];
//            
//            Tweet * secondTweet = [[Tweet alloc]initWithEntity:entity insertIntoManagedObjectContext:context];
//            secondTweet.created_at = [NSDate date];
//            dateString = [dateFormatter stringFromDate:secondTweet.created_at];
//            secondTweet.text = [NSString stringWithFormat:@"And another tweet sent at: %@", dateString];
//            secondTweet.id_str = dateString;
//            
//            
//            [resultsArray addObject:secondTweet];
//            
//            [[STCDataManager sharedManager] saveContext];
//        }
//    }
//    
//    NSArray * value = [NSArray arrayWithArray:resultsArray];
//    responseBlock(value, err);
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
            managedModelObject.favourites_count = @0;
            
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
        NSDictionary * userInfo = @{
                                    NSLocalizedDescriptionKey : @"The tweet is too long",
                                    NSLocalizedRecoverySuggestionErrorKey : recoverySuggestion
                                    };
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
