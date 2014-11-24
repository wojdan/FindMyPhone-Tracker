//
//  FMPTrackerViewController.m
//  FindMyPhoneTracker
//
//  Created by Wojdan on 12.11.2014.
//  Copyright (c) 2014 wojdan. All rights reserved.
//

#import "FMPTrackerViewController.h"
#import "FMPApiController.h"
#import "SVProgressHUD.h"
#import "AppDelegate.h"

@interface FMPTrackerViewController ()
@property (weak, nonatomic) IBOutlet UISegmentedControl *modeControl;
@property (weak, nonatomic) IBOutlet MKMapView *mapView;

@property (weak, nonatomic) IBOutlet UILabel *modeDescription;
@property (weak, nonatomic) IBOutlet UIButton *postLocationButton;
@property (weak, nonatomic) IBOutlet UIButton *logoutButton;

@property (strong, nonatomic) CLLocation *currentLocation;

@property (weak, nonatomic) IBOutlet UILabel *ATStateLabel;
@property (weak, nonatomic) IBOutlet UIButton *ATButton;

@property (nonatomic) BOOL ATModeEnabled;
@end

@implementation FMPTrackerViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    [self.modeControl addTarget:self action:@selector(modeChanged:) forControlEvents:UIControlEventValueChanged];

    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleNotification:) name:@"ManualModeLocationNotification" object:nil];

    self.mapView.delegate = self;

    self.mapView.hidden = YES;
    self.postLocationButton.hidden = YES;
    self.ATButton.hidden = YES;
    self.ATStateLabel.hidden = YES;

    self.ATModeEnabled = NO;
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];


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

    self.mapView.showsUserLocation = NO;

    self.mapView.hidden = YES;
    self.postLocationButton.hidden = YES;
    self.ATButton.hidden = YES;
    self.ATStateLabel.hidden = YES;
    self.ATModeEnabled = YES;
    [self toggleATMode:nil];

    [SVProgressHUD dismiss];

    [AppDelegate deactivateLocation];
    switch (self.modeControl.selectedSegmentIndex) {
        case 0: {
            [AppDelegate deactivateLocation];
            NSLog(@"Manual mode selected");
            self.postLocationButton.hidden = NO;

            self.mapView.hidden = NO;
            self.mapView.showsUserLocation = YES;
            self.mapView.userTrackingMode = MKUserTrackingModeFollow;

            [FMPApiController sharedInstance].workingMode = FMPTrackerModeManual;

            [SVProgressHUD showWithStatus:@"Obtaining location..."];

            self.modeDescription.text = @"To send the current position to the Client application, please wait until your current location is obtained and then tap \"Post Location\" button.";
            [self.view layoutIfNeeded];
            break;
        }
        case 1: {
            NSLog(@"Anti-Thief mode selected");

            self.modeDescription.text = @"To turn Anti-Thief mode, please tap \"Enable AT Mode\" button. Once the button changes to \"Disable AT mode\" you can send the app to backgroud and position will be regisered automatically.";
            [self.view layoutIfNeeded];
            [FMPApiController getDeviceSettingsWithCompletionHandler:^(BOOL success, NSError *error) {


            }];

            self.ATButton.hidden = NO;
            self.ATStateLabel.hidden = NO;
            break;
        }
        case 2: {
            self.modeDescription.text = @"All location services are off. Choose between Manual and Anti-Thief mode to enable sending your location to Client app.";

            NSLog(@"Off mode selected");
            [self.view layoutIfNeeded];

            self.mapView.userTrackingMode = MKUserTrackingModeNone;
            self.mapView.showsUserLocation = NO;
            break;
        }

        default:{
            self.modeDescription.font = [UIFont fontWithName:@"HelveticaNeue-Thin" size:13];
            self.modeDescription.textAlignment = NSTextAlignmentCenter;
            [self.view layoutIfNeeded];
            }
            break;
    }

}

- (void)mapView:(MKMapView *)mapView didUpdateUserLocation:(MKUserLocation *)userLocation {

    [mapView selectAnnotation:userLocation animated:YES];

    CLLocation *lastLocation = [[CLLocation alloc] initWithLatitude:userLocation.coordinate.latitude longitude:userLocation.coordinate.longitude];
    self.currentLocation = lastLocation;

    self.postLocationButton.enabled = YES;
    self.mapView.userLocation.subtitle = [NSString stringWithFormat:@"Latitude: %.6f Longitude: %.6f", lastLocation.coordinate.latitude, lastLocation.coordinate.longitude];
    self.mapView.userTrackingMode = MKUserTrackingModeFollow;

    NSLog(@"Did update user location on map!");
    [SVProgressHUD dismiss];
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

- (IBAction)toggleATMode:(id)sender {

    if(self.ATModeEnabled) {

        [AppDelegate deactivateLocation];
        self.ATModeEnabled = NO;
        self.ATStateLabel.text = @"Anti-Thief mode is OFF";
        [self.ATButton setTitle:@"Enable AT Mode" forState:UIControlStateNormal];
        [self.ATButton setBackgroundColor:self.ATButton.tintColor];
    } else {

        [AppDelegate activateLocationForMode:FMPTrackerModeAntiThief];
        self.ATModeEnabled = YES;
        self.ATStateLabel.text = @"Anti-Thief mode is ON";
        [self.ATButton setTitle:@"Disable AT Mode" forState:UIControlStateNormal];
        [self.ATButton setBackgroundColor:[UIColor colorWithRed:191.f/255.f green:86.f/255.f blue:92.f/255.f alpha:1.f]];
    }

}
@end
