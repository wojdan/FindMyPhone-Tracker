//
//  FMPTrackerViewController.m
//  FindMyPhoneTracker
//
//  Created by Wojdan on 12.11.2014.
//  Copyright (c) 2014 wojdan. All rights reserved.
//

#import "FMPTrackerViewController.h"
#import "FMPApiController.h"
#import "AppDelegate.h"

@interface FMPTrackerViewController ()
@property (weak, nonatomic) IBOutlet UISegmentedControl *modeControl;
@property (weak, nonatomic) IBOutlet MKMapView *mapView;

@property (weak, nonatomic) IBOutlet UITextView *modeDescription;
@property (weak, nonatomic) IBOutlet UIButton *postLocationButton;
@property (weak, nonatomic) IBOutlet UIButton *logoutButton;

@property (strong, nonatomic) CLLocation *currentLocation;

@end

@implementation FMPTrackerViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    [self.modeControl addTarget:self action:@selector(modeChanged:) forControlEvents:UIControlEventValueChanged];

    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleNotification:) name:@"ManualModeLocationNotification" object:nil];

    self.mapView.delegate = self;
    self.mapView.showsUserLocation = YES;
    self.mapView.userTrackingMode = MKUserTrackingModeFollow;

    self.mapView.hidden = YES;
    self.postLocationButton.hidden = YES;
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];

    if ([FMPApiController sharedInstance].workingMode == FMPTrackerModeManual) {
        [AppDelegate activateLocationForMode:FMPTrackerModeManual];
    }
}

-(void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)handleNotification:(NSNotification*)notification {

    CLLocation *lastLocation = notification.userInfo[@"location"];
    self.currentLocation = lastLocation;

    self.postLocationButton.enabled = YES;
    self.mapView.userLocation.subtitle = [NSString stringWithFormat:@"Latitude: %.6f Longitude: %.6f", lastLocation.coordinate.latitude, lastLocation.coordinate.longitude];
    self.mapView.userTrackingMode = MKUserTrackingModeFollow;
}

-(void)mapView:(MKMapView *)mapView annotationView:(MKAnnotationView *)view calloutAccessoryControlTapped:(UIControl *)control {
    
}

- (void)modeChanged:(id)sender {

    self.mapView.userLocation.subtitle = @"Obtaining...";
    self.postLocationButton.enabled = NO;

    self.mapView.hidden = YES;
    self.mapView.showsUserLocation = NO;
    self.postLocationButton.hidden = YES;

    [AppDelegate deactivateLocation];
    switch (self.modeControl.selectedSegmentIndex) {
        case 0: {
            NSLog(@"Manual mode selected");
            self.mapView.hidden = NO;
            self.mapView.showsUserLocation = YES;
            self.postLocationButton.hidden = NO;
            [AppDelegate activateLocationForMode:FMPTrackerModeManual];
            break;
        }
        case 1: {
            NSLog(@"Anti-Thief mode selected");
            [AppDelegate activateLocationForMode:FMPTrackerModeAntiThief];
            break;
        }
        case 2: {
            NSLog(@"Off mode selected");
            break;
        }

        default:
            break;
    }

}

- (void)mapView:(MKMapView *)mapView didUpdateUserLocation:(MKUserLocation *)userLocation {

    [mapView selectAnnotation:userLocation animated:YES];

}


- (IBAction)postLocationButtonClicked:(id)sender {

    [FMPApiController postUserLocation:self.currentLocation completionHandler:^(BOOL success, NSError *error) {

        if (error) {
        }
        
    }];

}

- (IBAction)logoutButtonClicked:(id)sender {

    [FMPApiController logout];

}
@end
