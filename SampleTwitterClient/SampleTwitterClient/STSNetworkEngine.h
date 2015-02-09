//
//  STSNetworkEngine.h
//  SampleTwitterClient
//
//  Created by Jason Cross on 2/8/15.
//  Copyright (c) 2015 Jason Cross. All rights reserved.
//

#import "MKNetworkEngine.h"

@interface STSNetworkEngine : MKNetworkEngine

/*!
 The global singleton for making network calls via the queing and caching network engine
 */
+ (STSNetworkEngine*) sharedInstance;

@end
