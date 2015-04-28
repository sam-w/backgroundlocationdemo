//
//  NSUserDefaults+WatchGroup.m
//  backgroundlocationdemo
//
//  Created by Sam Warner on 28/04/2015.
//  Copyright (c) 2015 samw. All rights reserved.
//


#import "NSUserDefaults+WatchGroup.h"

@implementation NSUserDefaults (WatchKit)

+ (instancetype)watchAppGroupDefaults
{
    return [[NSUserDefaults alloc] initWithSuiteName:@"group.backgroundlocationdemo"];
}

@end
