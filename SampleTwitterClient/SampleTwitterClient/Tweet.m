//
//  Tweet.m
//  SampleTwitterClient
//
//  Created by Jason Cross on 2/8/15.
//  Copyright (c) 2015 Jason Cross. All rights reserved.
//

#import "Tweet.h"
#import "User.h"
#import "NSJSONSerialization+JGCJSONDateSerialization.h"



@implementation Tweet

@dynamic created_at;
@dynamic favorite_count;
@dynamic id_str;
@dynamic text;
@dynamic retweet_count;
@dynamic user;


#pragma mark - key value coding

// see "Core Data for iOS: Developing Data-Driven Applications... (Addison-Wesley Professional, 2011, Isted and Harrington)
// for information on overriding Managed Object setters

- (void) setCreated_at:(id)value {
    static NSString * key = @"created_at";
    
    if (nil == value) {
        [self willChangeValueForKey:key];
        [self setPrimitiveValue:nil forKey:key];
        [self didChangeValueForKey:key];
    }
    else if ([value isKindOfClass:[NSDate class]]) {
        [self willChangeValueForKey:key];
        [self setPrimitiveValue:value forKey:key];
        [self didChangeValueForKey:key];
    }
    else if ([value isKindOfClass:[NSString class]]) {
        NSDate * convertedDate = [NSJSONSerialization jgc_convertJasonDateStringToNSDate:(NSString*)value];
        [self willChangeValueForKey:key];
        [self setPrimitiveValue:convertedDate forKey:key];
        [self didChangeValueForKey:key];
    }
}

- (void) setId_str:(id)value {
    static NSString * key = @"id_str";
    
    if (nil == value) {
        [self willChangeValueForKey:key];
        [self setPrimitiveValue:nil forKey:key];
        [self didChangeValueForKey:key];
    }
    else if ([value isKindOfClass:[NSString class]]) {
        [self willChangeValueForKey:key];
        [self setPrimitiveValue:value forKey:key];
        [self didChangeValueForKey:key];
    }
    else if ([value isKindOfClass:[NSNumber class]]) {
        NSString * convertedId = [(NSNumber*)value stringValue];
        [self willChangeValueForKey:key];
        [self setPrimitiveValue:convertedId forKey:key];
        [self didChangeValueForKey:key];
    }
}


- (void) setUser:(id)value {
    static NSString * key = @"user";
    
    if (nil == value) {
        [self willChangeValueForKey:key];
        [self setPrimitiveValue:nil forKey:key];
        [self didChangeValueForKey:key];
    }
    else if ([value isKindOfClass:[User class]]) {
        [self willChangeValueForKey:key];
        [self setPrimitiveValue:value forKey:key];
        [self didChangeValueForKey:key];
    }
    else if ([value isKindOfClass:[NSDictionary class]]) {
        NSDictionary * dictionary = (NSDictionary*)value;
        NSManagedObjectContext * context = [self managedObjectContext];
        User * user = [User matchingOrNewlyCreatedUserForSerializedUser:dictionary
                                                   managedObjectContext:context];
        [user addUser_tweetsObject:self];
        [self willChangeValueForKey:key];
        [self setPrimitiveValue:user forKey:key];
        [self didChangeValueForKey:key];
    }
}

@end
