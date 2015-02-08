//
//  STSNetworkEngine.m
//  SampleTwitterClient
//
//  Created by Jason Cross on 2/8/15.
//  Copyright (c) 2015 Jason Cross. All rights reserved.
//

#import "STSNetworkEngine.h"

@implementation STSNetworkEngine

- (id)init {
    NSAssert(NO, @"Must use designated initializer: initWithHostName:");
    return nil;
}

+ (STSNetworkEngine*) sharedInstance; {
    static STSNetworkEngine *_sharedInstance;
    if (nil == _sharedInstance) {
        NSString *basePath = @"Twitter.com";
        _sharedInstance = [[self alloc] initWithHostName:basePath];
        [_sharedInstance useCache];
    }
    return _sharedInstance;
}

@end
