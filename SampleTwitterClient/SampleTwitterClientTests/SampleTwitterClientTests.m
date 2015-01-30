//
//  SampleTwitterClientTests.m
//  SampleTwitterClientTests
//
//  Created by Jason Cross on 1/29/15.
//  Copyright (c) 2015 Jason Cross. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <XCTest/XCTest.h>
#import "STCServiceLayer.h"
#import "STCGlobals.h"
#import "Tweet.h"


@interface SampleTwitterClientTests : XCTestCase

@end

@implementation SampleTwitterClientTests

- (void)setUp {
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)testLoggingInFail {
    XCTestExpectation * expectation = [self expectationWithDescription:@"Testing login fail"];
    
    [STCServiceLayer loginWithUsername:@"jason" password:@"wrong" responseBlock:^(BOOL success, NSError *error) {
        if (nil == error) {
            XCTFail(@"The login should fail for wrong credentials");
        }
        else {
            NSInteger statusCode = error.code;
            XCTAssertEqual(statusCode, kSampleTwitterClientErrorCodeLoginError);
            [expectation fulfill];
        }
    }];
    
    [self waitForExpectationsWithTimeout:3.0 handler:^(NSError *error) {
        if (nil != error) {
            XCTFail(@"Login timed out");
        }
    }];
}

- (void)testLoggingInPass {
    XCTestExpectation * expectation = [self expectationWithDescription:@"Testing login pass"];
    
    [STCServiceLayer loginWithUsername:@"tester" password:@"abc123" responseBlock:^(BOOL success, NSError *error) {
        if (nil != error) {
            XCTFail(@"The login should pass for valid credentials");
        }
        else {
            XCTAssertTrue(success);
            [expectation fulfill];
        }
    }];
    
    [self waitForExpectationsWithTimeout:3.0 handler:^(NSError *error) {
        if (nil != error) {
            XCTFail(@"Login timed out");
        }
    }];
}

- (void)testFetchingLatestTweets {
    XCTestExpectation * expectation = [self expectationWithDescription:@"Testing fetching latest tweets"];
    
    NSDate * date;
    NSDateComponents * components = [[NSDateComponents alloc]init];
    components.year = 2000;
    components.month = 1;
    components.day = 1;
    NSCalendar * calendar = [NSCalendar calendarWithIdentifier:NSCalendarIdentifierGregorian];
    date = [calendar dateFromComponents:components];
    
    [STCServiceLayer fetchTweetsSinceDate:date responseBlock:^(NSArray *tweets, NSError *error) {
        if (tweets.count < 1) {
            XCTFail(@"No tweets returned");
        }
        else if (nil != error) {
            XCTFail(@"unexpected error fetching tweets");
        }
        else {
            id obj = tweets.firstObject;
            XCTAssertNotNil(obj);
            XCTAssertTrue([obj isKindOfClass:[Tweet class]]);
            [expectation fulfill];
        }
    }];
    
    [self waitForExpectationsWithTimeout:3.0 handler:^(NSError *error) {
        if (nil != error) {
            XCTFail(@"Login timed out");
        }
    }];
}

- (void) testDateDifferences {
    NSCalendar * calendar = [NSCalendar calendarWithIdentifier:NSCalendarIdentifierGregorian];
    
    NSDate * date1;
    NSDate * date2;
    
    NSDateComponents * components = [[NSDateComponents alloc]init];
    components.year = 2000;
    components.month = 1;
    components.day = 1;
    components.minute = 20;
    date1 = [calendar dateFromComponents:components];
    
    
    NSDateComponents * components2 = [[NSDateComponents alloc]init];
    components2.year = 2000;
    components2.month = 1;
    components2.day = 1;
    components2.minute = 43;
    date2 = [calendar dateFromComponents:components2];
    
    BOOL result;
    result = [STCServiceLayer firstDate:date2 isGreaterThanSecondDate:date1 byMoreThanXMinutes:10];
    XCTAssertTrue(result);
    
    result = [STCServiceLayer firstDate:date2 isGreaterThanSecondDate:date1 byMoreThanXMinutes:49];
    XCTAssertFalse(result);
    
    result = [STCServiceLayer firstDate:date1 isGreaterThanSecondDate:date2 byMoreThanXMinutes:10];
    XCTAssertFalse(result);
    
    result = [STCServiceLayer firstDate:date1 isGreaterThanSecondDate:date1 byMoreThanXMinutes:10];
    XCTAssertFalse(result);
    
    components.year = 2015;
    date1 = [calendar dateFromComponents:components];
    
    // now that the first date is 15 years newer, opposite of above is expected
    result = [STCServiceLayer firstDate:date2 isGreaterThanSecondDate:date1 byMoreThanXMinutes:10];
    XCTAssertFalse(result);
    
    result = [STCServiceLayer firstDate:date1 isGreaterThanSecondDate:date2 byMoreThanXMinutes:10];
    XCTAssertTrue(result);
}

@end
