//
//  ViewController.m
//  backgroundlocationdemo
//
//  Created by Sam Warner on 28/04/2015.
//  Copyright (c) 2015 samw. All rights reserved.
//

#import "ViewController.h"

#import "LocationManager.h"
#import "LocationDataStore.h"

@interface ViewController ()

@property (nonatomic, weak) IBOutlet UILabel *outputLabel;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (IBAction)startTracking:(id)sender {
    [[LocationManager sharedInstance] startMonitoringSignificantLocationChanges];
}

- (IBAction)refresh:(id)sender {
    self.outputLabel.text = [[[LocationDataStore sharedInstance] locationUpdates] componentsJoinedByString:@"\n"];
}

- (IBAction)log:(id)sender {
    [[LocationDataStore sharedInstance] dumpLocationUpdates];
}

@end
