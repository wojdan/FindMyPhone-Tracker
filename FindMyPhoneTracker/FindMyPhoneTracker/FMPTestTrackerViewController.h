//
//  FMPTestTrackerViewController.h
//  FindMyPhoneTracker
//
//  Created by Wojdan on 26.10.2014.
//  Copyright (c) 2014 wojdan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import <CoreLocation/CoreLocation.h>

/**
 *  Kontroler do testowania trackowania. Przy wdrożeniu wyłączony z aplikacji.
 */
@interface FMPTestTrackerViewController : UIViewController <CLLocationManagerDelegate, MKMapViewDelegate>

@end
