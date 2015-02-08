//
//  STSNetworkEngine.h
//  SampleTwitterClient
//
//  Created by Jason Cross on 2/8/15.
//  Copyright (c) 2015 Jason Cross. All rights reserved.
//

#import "MKNetworkEngine.h"

@interface STSNetworkEngine : MKNetworkEngine
+ (STSNetworkEngine*) sharedInstance;
@end
