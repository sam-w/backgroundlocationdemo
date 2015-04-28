//
//  LocationDataStore.h
//  backgroundlocationdemo
//
//  Created by Sam Warner on 28/04/2015.
//  Copyright (c) 2015 samw. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>

@interface LocationDataStore : NSObject

+ (instancetype)sharedInstance;

- (void)logSuccessfulLocationUpdate:(CLLocation *)location;
- (void)logFailedLocationUpdate;

- (void)dumpLocationUpdates;
- (NSArray *)locationUpdates;

- (void)saveContext;

@end
