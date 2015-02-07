//
//  STSSettingsManager.h
//  SampleTwitterClient
//
//  Created by Jason Cross on 2/6/15.
//  Copyright (c) 2015 Jason Cross. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface STSSettingsManager : NSObject


+ (STSSettingsManager*) sharedInstance; 

@property (nonatomic, strong) NSString * maximumTweetIdFromPreviousFetch;

@end
