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

@end
