//
//  NSError+JGCErrorForDescriptionAndReason.m
//  SampleTwitterClient
//
//  Created by Jason Cross on 2/7/15.
//  Copyright (c) 2015 Jason Cross. All rights reserved.
//

#import "NSError+JGCErrorDictionaryForDescriptionAndReason.h"

@implementation NSError (JGCErrorDictionaryForDescriptionAndReason)

+ (NSDictionary*)jgc_errorDictionaryForDescription:(NSString*)description
                                            reason:(NSString*)reason
                                   underlyingError:(NSError*)underlyingError; {
    
    NSMutableDictionary * mutableDictionary = [[NSMutableDictionary alloc]initWithCapacity:3];
    
    if (nil != description) {
        mutableDictionary[NSLocalizedDescriptionKey] = description;
    }
    if (nil != reason) {
        mutableDictionary[NSLocalizedFailureReasonErrorKey] = reason;
    }
    if (nil != underlyingError) {
        mutableDictionary[NSUnderlyingErrorKey] = underlyingError;
    }
    
    NSDictionary * value = [NSDictionary dictionaryWithDictionary:mutableDictionary];
    return value;
}

@end
