//
//  TwitterDataManager.h
//  SampleTwitterClient
//
//  Created by Jason Cross on 1/29/15.
//  Copyright (c) 2015 Jason Cross. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface STCDataManager : NSObject

@property (readonly, strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (readonly, strong, nonatomic) NSManagedObjectModel *managedObjectModel;
@property (readonly, strong, nonatomic) NSPersistentStoreCoordinator *persistentStoreCoordinator;

/*!
 The global singleton for accessing application data
 */
+ (STCDataManager*) sharedManager;

/*!
 Saves data to persist on file. Deletes any undo stack.
 */
- (void)saveContext;

@end
