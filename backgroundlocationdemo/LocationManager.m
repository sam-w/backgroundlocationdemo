//
//  LocationManager.m
//  backgroundlocationdemo
//
//  Created by Sam Warner on 28/04/2015.
//  Copyright (c) 2015 samw. All rights reserved.
//

#import "LocationManager.h"

#import "LocationDataStore.h"
#import "NSUserDefaults+WatchGroup.h"

@interface LocationManager () <CLLocationManagerDelegate>

@property (nonatomic, strong) CLLocationManager *locationManager;
@property (nonatomic) BOOL servicesAvailable;

@end

@implementation LocationManager

+ (instancetype)sharedInstance
{
    static LocationManager *_sharedInstance;
    static dispatch_once_t _onceToken;
    dispatch_once(&_onceToken, ^{
        _sharedInstance = [[self alloc] init];
    });
    return _sharedInstance;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.locationManager = [[CLLocationManager alloc] init];
        self.locationManager.delegate = self;
    }
    
    return self;
}

- (BOOL)servicesAvailable
{
    if ([CLLocationManager locationServicesEnabled] == NO) {
        return NO;
    }
    else if ([CLLocationManager authorizationStatus] == kCLAuthorizationStatusDenied) {
        return NO;
    }
    else if ([CLLocationManager authorizationStatus] == kCLAuthorizationStatusRestricted) {
        return NO;
    }
    return YES;
}

- (void)startMonitoringSignificantLocationChanges
{
    if ([CLLocationManager authorizationStatus] == kCLAuthorizationStatusNotDetermined) {
        if ([self.locationManager respondsToSelector:@selector(requestAlwaysAuthorization)]) {
            [self.locationManager requestAlwaysAuthorization];
        }
    }
    if ([CLLocationManager locationServicesEnabled]) {
        [self.locationManager startMonitoringSignificantLocationChanges];
    }
}

- (void)startUpdatingLocationWithAccuracy:(CLLocationAccuracy)accuracy distanceFilter:(NSUInteger)distanceInMeters
{
    [self.locationManager stopMonitoringSignificantLocationChanges];
    
    if ([CLLocationManager authorizationStatus] == kCLAuthorizationStatusNotDetermined) {
        if ([self.locationManager respondsToSelector:@selector(requestAlwaysAuthorization)]) {
            [self.locationManager requestAlwaysAuthorization];
        }
    }
    
    self.locationManager.desiredAccuracy = accuracy;
    self.locationManager.distanceFilter = distanceInMeters;

    if ([CLLocationManager locationServicesEnabled]) {
        [self.locationManager startUpdatingLocation];
    }
}

- (void)stopUpdatingLocation
{
    [self.locationManager stopUpdatingLocation];
}

#pragma CLLocationDelegate

- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations
{
    for (CLLocation *location in locations) {
        [[LocationDataStore sharedInstance] logSuccessfulLocationUpdate:location];
    }
}

- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error
{
    [[LocationDataStore sharedInstance] logFailedLocationUpdate];
}

@end
