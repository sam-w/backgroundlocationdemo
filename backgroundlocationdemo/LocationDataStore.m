//
//  LocationDataStore.m
//  backgroundlocationdemo
//
//  Created by Sam Warner on 28/04/2015.
//  Copyright (c) 2015 samw. All rights reserved.
//

#import "LocationDataStore.h"

#import <CoreData/CoreData.h>
#import <CoreLocation/CoreLocation.h>

@interface LocationDataStore ()

@property (readonly, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (readonly, nonatomic) NSManagedObjectModel *managedObjectModel;
@property (readonly, nonatomic) NSPersistentStoreCoordinator *persistentStoreCoordinator;

- (void)saveContext;
- (NSURL *)applicationDocumentsDirectory;

@end

@implementation LocationDataStore

+ (instancetype)sharedInstance
{
    static LocationDataStore *_sharedInstance;
    static dispatch_once_t _onceToken;
    dispatch_once(&_onceToken, ^{
        _sharedInstance = [[self alloc] init];
    });
    return _sharedInstance;
}

#pragma mark - Core Data stack

@synthesize managedObjectContext = _managedObjectContext;
@synthesize managedObjectModel = _managedObjectModel;
@synthesize persistentStoreCoordinator = _persistentStoreCoordinator;

- (NSURL *)applicationDocumentsDirectory {
    // The directory the application uses to store the Core Data store file. This code uses a directory named "com.samw.backgroundlocationdemo" in the application's documents directory.
    return [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
}

- (NSManagedObjectModel *)managedObjectModel {
    // The managed object model for the application. It is a fatal error for the application not to be able to find and load its model.
    if (_managedObjectModel != nil) {
        return _managedObjectModel;
    }
    NSURL *modelURL = [[NSBundle mainBundle] URLForResource:@"backgroundlocationdemo" withExtension:@"momd"];
    _managedObjectModel = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];
    return _managedObjectModel;
}

- (NSPersistentStoreCoordinator *)persistentStoreCoordinator {
    // The persistent store coordinator for the application. This implementation creates and return a coordinator, having added the store for the application to it.
    if (_persistentStoreCoordinator != nil) {
        return _persistentStoreCoordinator;
    }
    
    // Create the coordinator and store
    
    _persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:[self managedObjectModel]];
    NSURL *storeURL = [[self applicationDocumentsDirectory] URLByAppendingPathComponent:@"backgroundlocationdemo.sqlite"];
    NSError *error = nil;
    NSString *failureReason = @"There was an error creating or loading the application's saved data.";
    if (![_persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeURL options:nil error:&error]) {
        // Report any error we got.
        NSMutableDictionary *dict = [NSMutableDictionary dictionary];
        dict[NSLocalizedDescriptionKey] = @"Failed to initialize the application's saved data";
        dict[NSLocalizedFailureReasonErrorKey] = failureReason;
        dict[NSUnderlyingErrorKey] = error;
        error = [NSError errorWithDomain:@"YOUR_ERROR_DOMAIN" code:9999 userInfo:dict];
        // Replace this with code to handle the error appropriately.
        // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        abort();
    }
    
    return _persistentStoreCoordinator;
}


- (NSManagedObjectContext *)managedObjectContext {
    // Returns the managed object context for the application (which is already bound to the persistent store coordinator for the application.)
    if (_managedObjectContext != nil) {
        return _managedObjectContext;
    }
    
    NSPersistentStoreCoordinator *coordinator = [self persistentStoreCoordinator];
    if (!coordinator) {
        return nil;
    }
    _managedObjectContext = [[NSManagedObjectContext alloc] init];
    [_managedObjectContext setPersistentStoreCoordinator:coordinator];
    return _managedObjectContext;
}

#pragma mark - Core Data Saving support

- (void)saveContext {
    NSManagedObjectContext *managedObjectContext = self.managedObjectContext;
    if (managedObjectContext != nil) {
        NSError *error = nil;
        if ([managedObjectContext hasChanges] && ![managedObjectContext save:&error]) {
            // Replace this implementation with code to handle the error appropriately.
            // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
            NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
            abort();
        }
    }
}

#pragma mark - Storing Locations

- (void)logSuccessfulLocationUpdate:(CLLocation *)location
{
    NSManagedObject *locationObject = [NSEntityDescription insertNewObjectForEntityForName:@"LocationUpdate" inManagedObjectContext:self.managedObjectContext];
    [locationObject setValue:@(location.coordinate.latitude) forKey:@"lat"];
    [locationObject setValue:@(location.coordinate.longitude) forKey:@"lon"];
    [locationObject setValue:@YES forKey:@"success"];
    [locationObject setValue:[NSDate date] forKey:@"timestamp"];
    [self.managedObjectContext save:nil];
}

- (void)logFailedLocationUpdate
{
    NSManagedObject *locationObject = [NSEntityDescription insertNewObjectForEntityForName:@"LocationUpdate" inManagedObjectContext:self.managedObjectContext];
    [locationObject setValue:@(0.0) forKey:@"lat"];
    [locationObject setValue:@(0.0) forKey:@"lon"];
    [locationObject setValue:@NO forKey:@"success"];
    [locationObject setValue:[NSDate date] forKey:@"timestamp"];
    [self.managedObjectContext save:nil];
}

#pragma mark - Retrieving Locations

- (void)dumpLocationUpdates
{
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"LocationUpdate" inManagedObjectContext:self.managedObjectContext];
    [fetchRequest setEntity:entity];
    
    NSArray *fetchedObjects = [self.managedObjectContext executeFetchRequest:fetchRequest error:nil];
    for (NSManagedObject *info in fetchedObjects) {
        if ([[info valueForKey:@"success"] boolValue]) {
            NSLog(@"%@ - Success (%@, %@)", [info valueForKey:@"timestamp"], [info valueForKey:@"lat"], [info valueForKey:@"lon"]);
        }
        else {
            NSLog(@"%@ - Failed", [info valueForKey:@"timestamp"]);
        }
    }
}

@end
