//
//  ViewController.m
//  backgroundlocationdemo
//
//  Created by Sam Warner on 28/04/2015.
//  Copyright (c) 2015 samw. All rights reserved.
//

#import "ViewController.h"

#import "LocationManager.h"
#import "LogDataStore.h"

@interface ViewController ()

@property (nonatomic, weak) IBOutlet UITextView *logTextView;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.logTextView.text = @"";
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [self refresh:nil];
}

- (IBAction)startTracking:(id)sender {
    [[LocationManager sharedInstance] startMonitoringSignificantLocationChanges];
}

- (IBAction)clearLog:(id)sender {
    [[LogDataStore sharedInstance] clearLog];
}

- (IBAction)refresh:(id)sender {
    self.logTextView.text = [[[LogDataStore sharedInstance] logLines] componentsJoinedByString:@"\n"];
}

@end
