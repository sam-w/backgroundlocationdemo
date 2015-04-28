//
//  LocationDataStore.h
//  backgroundlocationdemo
//
//  Created by Sam Warner on 28/04/2015.
//  Copyright (c) 2015 samw. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>

@interface LogDataStore : NSObject

+ (instancetype)sharedInstance;

- (void)logStartMonitoring;
- (void)logSuccessfulLocationUpdate:(CLLocation *)location;
- (void)logFailedLocationUpdate;
- (void)logDidFinishLaunchingWithLocation;
- (void)logDidEnterBackground;
- (void)logWillEnterForeground;
- (void)logWillTerminate;


- (NSArray *)logLines;

- (void)clearLog;
- (void)saveContext;

@end
