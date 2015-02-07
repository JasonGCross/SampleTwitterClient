//
//  STSSettingsManager.m
//  SampleTwitterClient
//
//  Created by Jason Cross on 2/6/15.
//  Copyright (c) 2015 Jason Cross. All rights reserved.
//

#import "STSSettingsManager.h"
#import "UIAlertView+MKNetworkKitAdditions.h"



@interface STSSettingsManager ()
@property (nonatomic, strong) NSUserDefaults * defaults;
@end


static NSString * const kSTSMaximumTweetIdFromPreviousFetchKey = @"STS_MaximumTweetIdFromPreviousFetchKey";


@implementation STSSettingsManager
@dynamic maximumTweetIdFromPreviousFetch;

#pragma mark - initialization

- (id) init {
    static BOOL alreadyInitialized = NO;
    if (alreadyInitialized) {
        return self;
    }
    alreadyInitialized = YES;
    
    self = [super init];
    if (self) {
        self.defaults = [NSUserDefaults standardUserDefaults];
    }
    return self;
}

+ (STSSettingsManager*) sharedInstance; {
    static dispatch_once_t onceQueue;
    static STSSettingsManager* _sharedInstance;
    dispatch_once(&onceQueue, ^{ _sharedInstance = [[self alloc] init]; });
    return _sharedInstance;
}

#pragma mark - properties

- (void) setMaximumTweetIdFromPreviousFetch:(NSString *)value {
    [self.defaults setObject:value forKey:kSTSMaximumTweetIdFromPreviousFetchKey];
}

- (NSString*) maximumTweetIdFromPreviousFetch {
    NSString * value = [self.defaults valueForKey:kSTSMaximumTweetIdFromPreviousFetchKey];
    return value;
}

@end
