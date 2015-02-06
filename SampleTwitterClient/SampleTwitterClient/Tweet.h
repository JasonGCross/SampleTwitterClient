//
//  Tweet.h
//  SampleTwitterClient
//
//  Created by Jason Cross on 1/29/15.
//  Copyright (c) 2015 Jason Cross. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "JGCBaseModel.h"


@interface Tweet : JGCBaseModel

@property (nonatomic, retain) NSDate * created_at;
@property (nonatomic, retain) NSString * id_str;
@property (nonatomic, retain) NSString * text;
@property (nonatomic, retain) NSNumber * favourite_count;

@end
