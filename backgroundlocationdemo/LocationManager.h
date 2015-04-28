//
//  LocationManager.h
//  backgroundlocationdemo
//
//  Created by Sam Warner on 28/04/2015.
//  Copyright (c) 2015 samw. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>

@interface LocationManager : NSObject

+ (instancetype)sharedInstance;

@property (nonatomic, readonly) BOOL servicesAvailable;

- (void)startMonitoringSignificantLocationChanges;

- (void)startUpdatingLocationWithAccuracy:(CLLocationAccuracy)accuracy distanceFilter:(NSUInteger)distanceInMeters;
- (void)stopUpdatingLocation;

@end
