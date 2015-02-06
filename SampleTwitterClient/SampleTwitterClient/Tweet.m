//
//  Tweet.m
//  SampleTwitterClient
//
//  Created by Jason Cross on 1/29/15.
//  Copyright (c) 2015 Jason Cross. All rights reserved.
//

#import "Tweet.h"
#import "NSJSONSerialization+JGCJSONDateSerialization.h"


@implementation Tweet

@dynamic created_at;
@dynamic id_str;
@dynamic text;
@dynamic favourite_count;


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


@end
