//
//  FMPAfterLoginViewController.m
//  FindMyPhoneTracker
//
//  Created by Wojdan on 09.11.2014.
//  Copyright (c) 2014 wojdan. All rights reserved.
//

#import "FMPAfterLoginViewController.h"
#import "FMPApiController.h"
#import "FMPNewDeviceViewController.h"
#import "AppDelegate.h"

@interface FMPAfterLoginViewController ()

@end

@implementation FMPAfterLoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (IBAction)configureDeviceButtonClicked:(id)sender {
    FMPNewDeviceViewController *newDeviceView = [[UIStoryboard storyboardWithName:@"NewDeviceViewController" bundle:nil] instantiateInitialViewController];
    [AppDelegate setRootViewController:newDeviceView];
}

- (IBAction)logoutButtonClicked:(id)sender {
    [FMPApiController logout];
}

@end
