//
//  NSJSONSerialization+JGCJSONDateSerialization.m
//  SampleTwitterClient
//
//  Created by Jason Cross on 2/6/15.
//  Copyright (c) 2015 Jason Cross. All rights reserved.
//

#import "NSJSONSerialization+JGCJSONDateSerialization.h"

@implementation NSJSONSerialization (JGCJSONDateSerialization)

static NSDateFormatter *characterLength_30_dateFormatter = nil;
static NSDateFormatter *characterLength_19_dateFormatter = nil;
static NSDateFormatter *characterLength_20_dateFormatter = nil;
static NSDateFormatter *characterLength_10_dateFormatter = nil;

//Zulu dates are GMT times and as such need a specific reformatter

static NSDateFormatter *longZuluDateReFormatter = nil;

+ (void) initialize {
    // we expect the short date to be in this format:
    // 2011-12-02
    characterLength_10_dateFormatter = [[NSDateFormatter alloc] init];
    [characterLength_10_dateFormatter setDateFormat:@"Y-M-d"];
    
    
    // we expect the 'long' date to be in this format:
    // 2011-01-12T06:10:00
    characterLength_19_dateFormatter = [[NSDateFormatter alloc] init];
    [characterLength_19_dateFormatter setDateFormat:@"YYYY'-'MM'-'dd'T'HH':'mm':'ss"];
    
    
    // we expect the 'long' date to sometimes have a 'Z' on the end:
    // 2008-11-25T14:34:01Z
    characterLength_20_dateFormatter = [[NSDateFormatter alloc] init];
    [characterLength_20_dateFormatter setDateFormat:@"YYYY'-'MM'-'dd'T'HH':'mm':'ssZ"];
    [characterLength_20_dateFormatter setTimeZone:[NSTimeZone timeZoneWithName:@"GMT"]];
    
    
    // Twitter gives dates in the following format:
    // Fri Feb 06 03:30:57 +0000 2015
    characterLength_30_dateFormatter = [[NSDateFormatter alloc] init];
    
    // note that in this case, YYYY is not equivalent to yyyy
    // see http://www.unicode.org/reports/tr35/tr35-31/tr35-dates.html#Date_Format_Patterns
    [characterLength_30_dateFormatter setDateFormat:@"EEE MMM dd HH:mm:ss Z yyyy"];
    [characterLength_30_dateFormatter setTimeZone:[NSTimeZone timeZoneWithName:@"GMT"]];
    
    longZuluDateReFormatter = [[NSDateFormatter alloc] init];
    [longZuluDateReFormatter setDateFormat:@"YYYY'-'MM'-'dd'T'HH':'mm':'ss'Z'"];
    [longZuluDateReFormatter setTimeZone:[NSTimeZone timeZoneWithName:@"GMT"]];
}


// dealing with dates from JSON being passed in as strings
// Time (UTC).  ISO 8601 format YYYY-MM-DDThh:mm:ssZ, which is JSON standard
+ (NSDate *) jgc_convertJasonDateStringToNSDate: (NSString *) jsonDate; {
    
    
    NSDate * returnDate = nil;
    if ([jsonDate length] == 10) {
        returnDate = [characterLength_10_dateFormatter dateFromString:jsonDate];
    }
    else if ([jsonDate length] == 19) {
        returnDate = [characterLength_19_dateFormatter dateFromString:jsonDate];
    }
    else if ([jsonDate length] == 20) {
        // Z stands for "Zulu", or GMT minus 0 hours
        // this offset information is important; we don't want to lose it
        // therefore must replace the Z with an offset, -0000
        returnDate = [characterLength_20_dateFormatter dateFromString:
                      [jsonDate stringByReplacingOccurrencesOfString:@"Z" withString:@"+0000"]];
    }
    else if ([jsonDate length] >= 30) {
        returnDate = [characterLength_30_dateFormatter dateFromString:jsonDate];
    }
    
    
    return returnDate;
}


+ (NSString *) jgc_convertDateToJsonFormat: (NSDate *) date; {
    NSString *dateString = [characterLength_19_dateFormatter stringFromDate:date];
    return dateString;
}

+ (NSString *) jgc_convertZuluDateToJsonFormat: (NSDate *) zuluDate; {
    NSString *dateString = [longZuluDateReFormatter stringFromDate:zuluDate];
    return dateString;
}

+ (NSString*) jgc_convertDateToTwitterJsonFormat: (NSDate*) date; {
    NSString *dateString = [characterLength_30_dateFormatter stringFromDate:date];
    return dateString;
}

@end
