//
//  AppDelegate.h
//  FindMyPhoneTracker
//
//  Created by Wojdan on 26.10.2014.
//  Copyright (c) 2014 wojdan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LocationTracker.h"
#import "FMPApiController.h"

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

@property LocationTracker * locationTracker;
@property (nonatomic) NSTimer* locationUpdateTimer;

+ (void)setRootViewController:(UIViewController*)viewController;
+ (void)showLoginViewController;
+ (void)showAfterLoginViewController;
+ (void)showTrackerViewController;

+ (void)activateLocationForMode:(FMPTrackerMode)mode;
+ (void)deactivateLocation;

@end

