//
//  JGCBaseModel.m
//  SampleTwitterClient
//
//  Created by Jason Cross on 2/6/15.
//  Copyright (c) 2015 Jason Cross. All rights reserved.
//

#import "JGCBaseModel.h"

@implementation JGCBaseModel

#pragma mark - key value coding

- (void) setNilValueForKey:(NSString *)key {
    // this blank override prevents an Exception
}

- (void) setValue:(id)value forUndefinedKey:(NSString *)key {
    // this blank override prevents an NSUndefinedKeyException
    return;
}

// note that subclasses of NSManagedObject throw an error for attempting to set undefined keys when calling [NSManagedObject setValuesForKeysWithDictionary:]
// and that [NSManagedObject valueForUndefinedKey:] needs to be overridden
- (id)valueForUndefinedKey:(NSString *)key {
    // this blank override prevents an Exception
    return nil;
}



@end
