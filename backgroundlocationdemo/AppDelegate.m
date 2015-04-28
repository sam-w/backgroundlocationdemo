//
//  AppDelegate.m
//  backgroundlocationdemo
//
//  Created by Sam Warner on 28/04/2015.
//  Copyright (c) 2015 samw. All rights reserved.
//

#import "AppDelegate.h"

#import "LocationManager.h"
#import "LogDataStore.h"

@interface AppDelegate ()

@end

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    if (launchOptions[UIApplicationLaunchOptionsLocationKey]) {
        [[LogDataStore sharedInstance] logDidFinishLaunchingWithLocation];
        [[LocationManager sharedInstance] startMonitoringSignificantLocationChanges];
    }
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application {
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    [[LogDataStore sharedInstance] logDidEnterBackground];
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    [[LogDataStore sharedInstance] logWillEnterForeground];
}

- (void)applicationWillTerminate:(UIApplication *)application {
    [[LogDataStore sharedInstance] logWillTerminate];
    [[LogDataStore sharedInstance] saveContext];
}

@end
