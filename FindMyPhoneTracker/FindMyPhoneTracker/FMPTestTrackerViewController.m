//
//  FMPTestTrackerViewController.m
//  FindMyPhoneTracker
//
//  Created by Wojdan on 26.10.2014.
//  Copyright (c) 2014 wojdan. All rights reserved.
//

#import "FMPTestTrackerViewController.h"
#import "FMPApiController.h"
#import "AppDelegate.h"

#import <MapKit/MapKit.h>

@interface FMPTestTrackerViewController ()

@property (weak, nonatomic) IBOutlet MKMapView *mapView;
@property (weak, nonatomic) IBOutlet UIButton *sendButton;
@property (weak, nonatomic) IBOutlet UILabel *latitudeLabel;
@property (weak, nonatomic) IBOutlet UILabel *longitudeLabel;
@property (weak, nonatomic) IBOutlet UIView *controlView;

@property (strong, nonatomic) CLLocationManager *locationManager;
@property (strong, nonatomic) CLLocation *mostRecentLocation;
@property (strong, nonatomic) NSTimer *timer;



@end

@implementation FMPTestTrackerViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.locationManager = [[CLLocationManager alloc] init];
    if ( [CLLocationManager locationServicesEnabled] ) {
        self.locationManager.delegate = self;
        self.locationManager.desiredAccuracy = kCLLocationAccuracyBest;
        self.locationManager.distanceFilter = kCLDistanceFilterNone;
        self.locationManager.pausesLocationUpdatesAutomatically = NO;
        [self.locationManager startUpdatingLocation];
    } else {
        [self.locationManager requestWhenInUseAuthorization];
    }

    self.sendButton.enabled = NO;
    self.controlView.layer.borderColor = [[UIColor colorWithWhite:0 alpha:0.3f] CGColor];
    self.controlView.layer.borderWidth = 0.5f;
}

- (void)dealloc {
    [self.locationManager stopUpdatingLocation];
    self.locationManager = nil;
}

#pragma mark - CLLogationManagerDelegate

-(void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations {

    [self.locationManager stopUpdatingLocation];
    NSLog(@"Location updated");

    CLLocation *lastLocation = [locations lastObject];
    self.mostRecentLocation = lastLocation;

    self.sendButton.enabled = YES;

    double meters = 2;
    double scalingFactor = ABS( cos(2 * M_PI * lastLocation.coordinate.latitude /360.0) );

    MKCoordinateSpan span;
    span.latitudeDelta = meters/69.0;
    span.longitudeDelta = meters/( scalingFactor*69.0 );

    MKCoordinateRegion region;
    region.span = span;
    region.center = lastLocation.coordinate;

    [self.mapView setRegion:region animated:YES];
    self.mapView.showsUserLocation = YES;

    self.latitudeLabel.text = [NSString stringWithFormat:@"%.8f", lastLocation.coordinate.latitude];
    self.longitudeLabel.text = [NSString stringWithFormat:@"%.8f", lastLocation.coordinate.longitude];

}

- (void)locationManager:(CLLocationManager *)manager didFinishDeferredUpdatesWithError:(NSError *)error {

    self.sendButton.enabled = NO;

}

- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error {

    NSLog(@"%@", [error localizedDescription]);

}

- (void)locationManagerDidPauseLocationUpdates:(CLLocationManager *)manager {

    self.sendButton.enabled = NO;

}


#pragma mark - IBActions

- (IBAction)sendButtonClicked:(id)sender {

    [FMPApiController postUserLocation:self.mostRecentLocation completionHandler:^(BOOL success, NSError *error) {

        if (error) {
        }

    }];

}
- (IBAction)deregisterButtonClicked:(id)sender {

    [AppDelegate deactivateLocation];

}

@end
