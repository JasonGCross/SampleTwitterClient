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
#import "NSJSONSerialization+JGCJSONDateSerialization.h"
#import <CoreData/CoreData.h>
#import "User.h"



@interface SampleTwitterClientTests : XCTestCase
@property (nonatomic, strong) NSManagedObjectContext * managedObjectContext;
@end

@implementation SampleTwitterClientTests

- (void)setUp {
    [super setUp];
    
    NSBundle * bundleContainingXCDataModel = [NSBundle mainBundle];
    NSManagedObjectModel *mom = [NSManagedObjectModel mergedModelFromBundles:[NSArray arrayWithObject:bundleContainingXCDataModel]];
    NSPersistentStoreCoordinator *psc = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:mom];
    XCTAssertTrue([psc addPersistentStoreWithType:NSInMemoryStoreType
                                    configuration:nil
                                              URL:nil
                                          options:nil
                                            error:NULL] ? YES : NO, @"Should be able to add in-memory store");
    self.managedObjectContext = [[NSManagedObjectContext alloc] init];
    self.managedObjectContext.persistentStoreCoordinator = psc;
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
    [self.managedObjectContext rollback];
    self.managedObjectContext = nil;
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

- (void) testPostingTweetWithFailure {
    NSString * tweetString;
    tweetString = @"abcdefghijklmnopqrstuvwxyz 1234567890 abcdefghijklmnopqrstuvwxyz 1234567890 abcdefghijklmnopqrstuvwxyz 1234567890 abcdefghijklmnopqrstuvwxyz 1234567890 abcdefghijklmnopqrstuvwxyz 1234567890 abcdefghijklmnopqrstuvwxyz 1234567890 abcdefghijklmnopqrstuvwxyz 1234567890 abcdefghijklmnopqrstuvwxyz 1234567890 abcdefghijklmnopqrstuvwxyz 1234567890 abcdefghijklmnopqrstuvwxyz 1234567890 abcdefghijklmnopqrstuvwxyz 1234567890 abcdefghijklmnopqrstuvwxyz 1234567890";
    
    XCTestExpectation * expectation = [self expectationWithDescription:@"Testing posting new tweet"];
    
    [STCServiceLayer postTweetText:tweetString responseBlock:^(BOOL success, NSError *error) {
        XCTAssertNotNil(error);
        XCTAssertFalse(success);
        
        [expectation fulfill];
    }];
    
    [self waitForExpectationsWithTimeout:3.0 handler:^(NSError *error) {
        if (nil != error) {
            XCTFail(@"Login timed out");
        }
    }];

}

- (void) testPostingTweetWithSuccess {
    NSString * tweetString;
    tweetString = @"abcdefghijklmnop";
    
    XCTestExpectation * expectation = [self expectationWithDescription:@"Testing posting new tweet"];
    
    [STCServiceLayer postTweetText:tweetString responseBlock:^(BOOL success, NSError *error) {
        XCTAssertNil(error);
        XCTAssertTrue(success);
        
        [expectation fulfill];
    }];
    
    [self waitForExpectationsWithTimeout:3.0 handler:^(NSError *error) {
        if (nil != error) {
            XCTFail(@"Login timed out");
        }
    }];

}

#pragma mark date
/*
 * date to JSON
 */
- (void) testConvertDateToJsonFormat {
    NSDateComponents *comps = [[NSDateComponents alloc] init];
    [comps setDay:06];
    [comps setMonth:05];
    [comps setYear:2004];
    [comps setHour:14];
    [comps setMinute:13];
    [comps setSecond:55];
    NSCalendar *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    NSDate *date = [gregorian dateFromComponents:comps];
    
    NSString *dateString = [NSJSONSerialization jgc_convertDateToJsonFormat:date];
    XCTAssertNotNil(dateString, @"dateString should not be nil");
    XCTAssertTrue([dateString isEqualToString:@"2004-05-06T14:13:55"], @"date string is not what it should be");
}

/*
 * date round trip
 */
- (void) testRoundTripSerializationDate {
    NSString *checkinDate = @"2011-12-02";
    NSString *arrivalDate = @"2011-01-12T06:10:13";
    
    NSDate *date1 = [NSJSONSerialization jgc_convertJasonDateStringToNSDate:checkinDate];
    XCTAssertNotNil(date1, @"date1 should not be nil");
    
    NSDate *date2 = [NSJSONSerialization jgc_convertJasonDateStringToNSDate:arrivalDate];
    XCTAssertNotNil(date2, @"date2 should not be nil");
    
    unsigned unitFlags1 = NSCalendarUnitYear | NSCalendarUnitMonth |  NSCalendarUnitDay;
    unsigned unitFlags2 = NSCalendarUnitSecond | NSCalendarUnitMinute | NSCalendarUnitHour | NSCalendarUnitYear | NSCalendarUnitMonth |  NSCalendarUnitDay;
    NSCalendar *gregorian = [[NSCalendar alloc]
                             initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    NSDateComponents *date1Components = [gregorian components:unitFlags1 fromDate:date1];
    NSDateComponents *date2Components = [gregorian components:unitFlags2 fromDate:date2];
    
    XCTAssertTrue([date1Components year] == 2011, @"year should be 2011");
    XCTAssertTrue([date1Components month] == 12, @"month should be 12");
    XCTAssertTrue([date1Components day] == 02, @"day should be 02");
    
    XCTAssertTrue([date2Components year] == 2011, @"year should be 2011");
    XCTAssertTrue([date2Components month] == 01, @"month should be 01");
    XCTAssertTrue([date2Components day] == 12, @"day should be 12");
    XCTAssertTrue([date2Components hour] == 06, @"hour should be 06");
    XCTAssertTrue([date2Components minute] == 10, @"minute should be 10");
    XCTAssertTrue([date2Components second] == 13, @"seconds should be 13");
    
    NSString *arrivalDateString = [NSJSONSerialization jgc_convertDateToJsonFormat:date2];
    XCTAssertEqualObjects(arrivalDate, arrivalDateString, @"the date strings should be equal");
    
    NSString *checkinDateString = [NSJSONSerialization jgc_convertDateToJsonFormat:date1];
    NSString *checkindateSubString = [checkinDateString substringToIndex:10];
    XCTAssertEqualObjects(checkinDate, checkindateSubString, @"the date strings should be equal");
}

- (void) testTwitterDateFormat {
    NSDateComponents *comps = [[NSDateComponents alloc] init];
    [comps setDay:06];
    [comps setMonth:02];
    [comps setYear:2015];
    [comps setHour:03];
    [comps setMinute:30];
    [comps setSecond:57];
    [comps setTimeZone:[NSTimeZone timeZoneWithName:@"GMT"]];
    NSCalendar *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    NSDate *date = [gregorian dateFromComponents:comps];
    
    NSString *dateString = [NSJSONSerialization jgc_convertDateToTwitterJsonFormat:date];
    XCTAssertNotNil(dateString, @"dateString should not be nil");
    XCTAssertTrue([dateString isEqualToString:@"Fri Feb 06 03:30:57 +0000 2015"], @"date string is not what it should be");
    
    NSDate * roundTripDate = [NSJSONSerialization jgc_convertJasonDateStringToNSDate:dateString];
    XCTAssertTrue([roundTripDate isEqualToDate:date]);
}

#pragma mark - JSON model objects

- (void) testDeserializingJSON {
    NSURL * jsonFileURL = [[NSBundle mainBundle]URLForResource:@"twitter_data" withExtension:@"json"];
    NSError * fileReadError = nil;
    NSFileHandle * fileHandle = [NSFileHandle fileHandleForReadingFromURL:jsonFileURL error:&fileReadError];
    XCTAssertNil(fileReadError);
    XCTAssertNotNil(fileHandle);
    if (nil == fileReadError) {
        NSData * jsonData = fileHandle.readDataToEndOfFile;
        NSError * jsonDeserializationError = nil;
        id obj = [NSJSONSerialization JSONObjectWithData:jsonData options:0 error:&jsonDeserializationError];
        XCTAssertNil(jsonDeserializationError);
        XCTAssertNotNil(obj);
        BOOL expectedFormat = [obj isKindOfClass:[NSArray class]];
        XCTAssertTrue(expectedFormat);
        if (expectedFormat) {
            NSArray * arrayOfTweets = (NSArray*)obj;
            XCTAssertTrue(arrayOfTweets.count == 20);
            id firstTweetObj = arrayOfTweets.firstObject;
            XCTAssertNotNil(firstTweetObj);
            expectedFormat = [firstTweetObj isKindOfClass:[NSDictionary class]];
            XCTAssertTrue(expectedFormat);
            if (expectedFormat) {
                NSDictionary * firstTweetDictionary = (NSDictionary*)firstTweetObj;
                Tweet * firstTweet = [NSEntityDescription insertNewObjectForEntityForName:@"Tweet" inManagedObjectContext:self.managedObjectContext];
                [firstTweet setValuesForKeysWithDictionary:firstTweetDictionary];
                
                // check the creation date
                NSCalendar *gregorian = [[NSCalendar alloc]
                                         initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
                [gregorian setTimeZone:[NSTimeZone timeZoneWithName:@"GMT"]];
                NSDateComponents * referenceDateComponents = [[NSDateComponents alloc]init];
                referenceDateComponents.year = 2015;
                referenceDateComponents.month = 2;
                referenceDateComponents.day = 6;
                referenceDateComponents.hour = 3;
                referenceDateComponents.minute = 30;
                referenceDateComponents.second = 57;
                NSDate * referenceDate = [gregorian dateFromComponents:referenceDateComponents];
                
                unsigned unitFlags2 = NSCalendarUnitSecond | NSCalendarUnitMinute | NSCalendarUnitHour | NSCalendarUnitYear | NSCalendarUnitMonth |  NSCalendarUnitDay | NSCalendarUnitTimeZone;
                
                NSDate * deserializedDate = firstTweet.created_at;
                 [gregorian components:unitFlags2 fromDate:deserializedDate];
                XCTAssertEqualObjects(referenceDate, deserializedDate);
                
                // other (simpler) properties
                XCTAssertTrue([firstTweet.id_str isEqualToString:@"563540322089566208"]);
                XCTAssertTrue([firstTweet.text isEqualToString:@"RT @Kaibutsu: Hilarious! RT @ImTheQ: ROFLLLLL---&gt;  RT @rickburin: Probably the best thing on the internet. http://t.co/8dC8YIK5SP"]);
                XCTAssertTrue([firstTweet.favourite_count isEqualToNumber:@0]);
            }
        }
    }
}

- (void) testNormalizationOfUsers {
    NSDictionary * serializedUser = @{
                                      @"name" : @"Tester Morris",
                                      @"screen_name" : @"testerMorris123",
                                      @"profile_image_url" : @"http://test.com/testerMorris_large.jpg"
                                      };
    
    NSManagedObjectContext * context = self.managedObjectContext;
    NSEntityDescription * entity = [NSEntityDescription entityForName:@"User" inManagedObjectContext:context];
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    [fetchRequest setEntity:entity];
    [fetchRequest setFetchLimit:20];
    NSPredicate * predicate = [NSPredicate predicateWithFormat:@"screen_name like \"testerMorris123\""];
    [fetchRequest setPredicate:predicate];
    NSError * fetchError = nil;
    
    NSArray * matchingUsers = [context executeFetchRequest:fetchRequest error:&fetchError];
    XCTAssertNil(fetchError);
    if (nil == fetchError) {
        XCTAssertTrue(matchingUsers.count == 0);
    }

    // now insert a new user and check the count
    User * user = [User matchingOrNewlyCreatedUserForSerializedUser:serializedUser managedObjectContext:context];
    matchingUsers = [context executeFetchRequest:fetchRequest error:&fetchError];
    XCTAssertNil(fetchError);
    if (nil == fetchError) {
        XCTAssertTrue(matchingUsers.count == 1);
        User * duplicate = matchingUsers.firstObject;
        XCTAssertNotNil(duplicate);
        XCTAssertTrue([duplicate.screen_name isEqualToString:user.screen_name]);
    }

    // repeating the "insert" should have no change on the number of users in the data base
    user = [User matchingOrNewlyCreatedUserForSerializedUser:serializedUser managedObjectContext:context];
    matchingUsers = [context executeFetchRequest:fetchRequest error:&fetchError];
    XCTAssertNil(fetchError);
    if (nil == fetchError) {
        XCTAssertTrue(matchingUsers.count == 1);
        User * duplicate = matchingUsers.firstObject;
        XCTAssertNotNil(duplicate);
        XCTAssertTrue([duplicate.screen_name isEqualToString:user.screen_name]);
    }

    // once more for over-kill
    user = [User matchingOrNewlyCreatedUserForSerializedUser:serializedUser managedObjectContext:context];
    matchingUsers = [context executeFetchRequest:fetchRequest error:&fetchError];
    XCTAssertNil(fetchError);
    if (nil == fetchError) {
        XCTAssertTrue(matchingUsers.count == 1);
        User * duplicate = matchingUsers.firstObject;
        XCTAssertNotNil(duplicate);
        XCTAssertTrue([duplicate.screen_name isEqualToString:user.screen_name]);
    }
}

- (void) testArchivingImageAssociatedWithUser {
    UIImage * image = [UIImage imageNamed:@"pUd0vvMB_reasonably_small.jpeg"];
    XCTAssertNotNil(image);
    NSDictionary * serializedUser = @{
                                      @"name" : @"Tester Morris",
                                      @"screen_name" : @"testerMorris123",
                                      @"profile_image_url" : @"http://test.com/testerMorris_large.jpg"
                                      };
    
    NSDictionary * serialzedTweet1 = @{
                                       @"id_str" : @"123456789",
                                       @"created_at" : @"Fri Feb 06 03:30:57 +0000 2015",
                                       @"user" : serializedUser
                                       };
    
    NSDictionary * serialzedTweet2 = @{
                                       @"id_str" : @"663456789",
                                       @"created_at" : @"Fri Feb 06 14:57:18 +0000 2015",
                                       @"user" : serializedUser
                                       };
    
    NSManagedObjectContext * context = self.managedObjectContext;
    NSEntityDescription * userEntityDescription = [NSEntityDescription entityForName:@"User"
                                                              inManagedObjectContext:context];
    NSFetchRequest *fetchUserRequest = [[NSFetchRequest alloc] init];
    [fetchUserRequest setEntity:userEntityDescription];
    [fetchUserRequest setFetchLimit:20];
    NSPredicate * predicate = [NSPredicate predicateWithFormat:@"screen_name like \"testerMorris123\""];
    [fetchUserRequest setPredicate:predicate];
    NSError * userFetchError = nil;
    
    NSArray * matchingUsers = [context executeFetchRequest:fetchUserRequest error:&userFetchError];
    XCTAssertNil(userFetchError);
    XCTAssertTrue(matchingUsers.count == 0);
    
    // now add the tweets to the database and verify the user image
    NSEntityDescription * tweetEntityDescription = [NSEntityDescription entityForName:@"Tweet"
                                                               inManagedObjectContext:context];
    Tweet * tweet1 = [[Tweet alloc]initWithEntity:tweetEntityDescription
                   insertIntoManagedObjectContext:context];
    [tweet1 setValuesForKeysWithDictionary:serialzedTweet1];
    tweet1.user.profile_image = image;
    
    Tweet * tweet2 = [[Tweet alloc] initWithEntity:tweetEntityDescription
                    insertIntoManagedObjectContext:context];
    [tweet2 setValuesForKeysWithDictionary:serialzedTweet2];
    tweet2.user.profile_image = image;
    
    NSFetchRequest * fetchTweetsRequest = [[NSFetchRequest alloc]init];
    [fetchTweetsRequest setEntity:tweetEntityDescription];
    [fetchTweetsRequest setFetchLimit:20];
    NSError * tweetFetchError = nil;
    
    NSArray * savedTweets = [context executeFetchRequest:fetchTweetsRequest error:&tweetFetchError];
    XCTAssertNil(tweetFetchError);
    XCTAssertTrue(savedTweets.count == 2);
    
    // we've checked the tweets. how about the users?
    userFetchError = nil;
    matchingUsers = [context executeFetchRequest:fetchUserRequest error:&userFetchError];
    XCTAssertNil(userFetchError);
    XCTAssertTrue(matchingUsers.count == 1);
    
    UIImage * image1 = tweet1.user.profile_image;
    XCTAssertEqualObjects(image, image1);
    
    if (savedTweets.count > 1) {
        Tweet * savedTweet1 = savedTweets[0];
        Tweet * savedTweet2 = savedTweets[1];
        
        UIImage * savedImage1 = savedTweet1.user.profile_image;
        UIImage * savedImage2 = savedTweet2.user.profile_image;
        
        XCTAssertEqualObjects(savedImage1, image);
        XCTAssertEqualObjects(savedImage2, image);
        
        XCTAssertEqualObjects(savedTweet1.user, savedTweet2.user);
        User * savedUser = matchingUsers.firstObject;
        XCTAssertEqualObjects(savedUser, savedTweet1.user);
    }
}

@end
