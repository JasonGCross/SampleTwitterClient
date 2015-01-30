//
//  MockWebService.m
//  SampleTwitterClient
//
//  Created by Jason Cross on 1/29/15.
//  Copyright (c) 2015 Jason Cross. All rights reserved.
//


#import "STCServiceLayer.h"
#import "STCGlobals.h"



@implementation STCServiceLayer

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
        NSString * errorString = @"The username / password combination is invalid";
        NSDictionary * userInfo = @{ NSLocalizedDescriptionKey : errorString};
        err = [NSError errorWithDomain:@"ca.jasoncross.login"
                                  code:kSampleTwitterClientErrorCodeLoginError
                              userInfo:userInfo];
    }
    
    responseBlock(result, err);
}

+ (void) fetchTweetsSinceDate:(NSDate*)date responseBlock:(TweetsResponseBlock)responseBlock; {
    NSMutableArray * resultsArray = nil;
    NSError * err = nil;
    
    // simulate network delay
    [self waitForCompletion:2.0];
    
    
    
    responseBlock(resultsArray, err);
}

@end
