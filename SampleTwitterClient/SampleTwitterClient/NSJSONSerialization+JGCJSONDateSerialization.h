//
//  NSJSONSerialization+JGCJSONDateSerialization.h
//  SampleTwitterClient
//
//  Created by Jason Cross on 2/6/15.
//  Copyright (c) 2015 Jason Cross. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSJSONSerialization (JGCJSONDateSerialization)

/*!
 @method convertJasonDateStringToNSDate:
 Dates will be converted to match the format expected by Yapta's API:
 Time (UTC).  ISO 8601 format YYYY-MM-DDThh:mm:ssZ, which is JSON standard
 */
+ (NSDate *) jgc_convertJasonDateStringToNSDate: (NSString *) jsonDate;

/*!
 @method convertDateToJsonFormat:
 Dates will be converted to match the format expected by Yapta's API:
 Time (UTC).  ISO 8601 format YYYY-MM-DDThh:mm:ssZ, which is JSON standard
 @param date the date to be converted to a JSON string
 */
+ (NSString *) jgc_convertDateToJsonFormat: (NSDate *) date;

/*!
 @method convertZuluDateToJsonFormat:
 Dates will be converted to match the format expected by Yapta's API:
 Time (UTC).  ISO 8601 format YYYY-MM-DDThh:mm:ssZ, which is JSON standard
 This method will let us keep GMT times on dates
 @param zuluDate the date to be converted to a JSON string
 */
+ (NSString *) jgc_convertZuluDateToJsonFormat: (NSDate *) zuluDate;

/*!
 @method jgc_convertDateToTwitterJsonFormat
 Dates will be converted to match the format used by Twitter's API:
 Fri Feb 06 03:30:57 +0000 2015
 @param date the date to be converted to a JSON string
 */
+ (NSString*) jgc_convertDateToTwitterJsonFormat: (NSDate*) date;


@end
