//
//  NSError+JGCErrorForDescriptionAndReason.h
//  SampleTwitterClient
//
//  Created by Jason Cross on 2/7/15.
//  Copyright (c) 2015 Jason Cross. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSError (JGCErrorDictionaryForDescriptionAndReason)
+ (NSDictionary*)jgc_errorDictionaryForDescription:(NSString*)description
                                            reason:(NSString*)reason
                                   underlyingError:(NSError*)previousError;
@end
