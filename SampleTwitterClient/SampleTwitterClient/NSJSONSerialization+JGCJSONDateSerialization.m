//
//  NSJSONSerialization+JGCJSONDateSerialization.m
//  SampleTwitterClient
//
//  Created by Jason Cross on 2/6/15.
//  Copyright (c) 2015 Jason Cross. All rights reserved.
//

#import "NSJSONSerialization+JGCJSONDateSerialization.h"

@implementation NSJSONSerialization (JGCJSONDateSerialization)


static NSDateFormatter *longDateFormatter = nil;
static NSDateFormatter *longZuluDateFormatter = nil;
static NSDateFormatter *shortDateFormatter = nil;
static NSDateFormatter *longZuluDateReFormatter = nil;


// dealing with dates from JSON being passed in as strings
// Time (UTC).  ISO 8601 format YYYY-MM-DDThh:mm:ssZ, which is JSON standard
+ (NSDate *) jgc_convertJasonDateStringToNSDate: (NSString *) jsonDate; {
    
    // we expect the short date to be in this format:
    // 2011-12-02
    if (shortDateFormatter == nil) {
        shortDateFormatter = [[NSDateFormatter alloc] init];
        [shortDateFormatter setDateFormat:@"Y-M-d"];
    }
    
    // we expect the 'long' date to be in this format:
    // 2011-01-12T06:10:00
    if (longDateFormatter == nil) {
        longDateFormatter = [[NSDateFormatter alloc] init];
        [longDateFormatter setDateFormat:@"YYYY'-'MM'-'dd'T'HH':'mm':'ss"];
    }
    
    // we expect the 'long' date to sometimes have a 'Z' on the end:
    // 2008-11-25T14:34:01Z
    if (longZuluDateFormatter == nil) {
        longZuluDateFormatter = [[NSDateFormatter alloc] init];
        [longZuluDateFormatter setDateFormat:@"YYYY'-'MM'-'dd'T'HH':'mm':'ssZ"];
        [longZuluDateFormatter setTimeZone:[NSTimeZone timeZoneWithName:@"GMT"]];
    }
    
    NSDate * returnDate = [[NSDate alloc] init];
    if ([jsonDate length] == 10) {
        returnDate = [shortDateFormatter dateFromString:jsonDate];
    }
    else if ([jsonDate length] == 19) {
        returnDate = [longDateFormatter dateFromString:jsonDate];
    }
    else if ([jsonDate length] == 20) {
        // Z stands for "Zulu", or GMT minus 0 hours
        // this offset information is important; we don't want to lose it
        // therefore must replace the Z with an offset, -0000
        returnDate = [longZuluDateFormatter dateFromString:
                      [jsonDate stringByReplacingOccurrencesOfString:@"Z" withString:@"+0000"]];
    }
    
    
    return returnDate;
}


+ (NSString *) jgc_convertDateToJsonFormat: (NSDate *) date; {
    
    //TODO: fix formatter to deal with Zulu times
    
    if (longDateFormatter == nil) {
        longDateFormatter = [[NSDateFormatter alloc] init];
        [longDateFormatter setDateFormat:@"YYYY'-'MM'-'dd'T'HH':'mm':'ss"];
    }
    
    NSString *dateString = [longDateFormatter stringFromDate:date];
    return dateString;
}

+ (NSString *) jgc_convertZuluDateToJsonFormat: (NSDate *) zuluDate; {
    
    //Zulu dates are GMT times and as such need a specific reformatter
    if (longZuluDateReFormatter == nil) {
        longZuluDateReFormatter = [[NSDateFormatter alloc] init];
        [longZuluDateReFormatter setDateFormat:@"YYYY'-'MM'-'dd'T'HH':'mm':'ss'Z'"];
        [longZuluDateReFormatter setTimeZone:[NSTimeZone timeZoneWithName:@"GMT"]];
    }
    
    NSString *dateString = [longZuluDateReFormatter stringFromDate:zuluDate];
    return dateString;
}



@end
