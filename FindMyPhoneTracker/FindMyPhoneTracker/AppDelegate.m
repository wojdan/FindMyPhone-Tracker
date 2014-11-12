//
//  AppDelegate.m
//  FindMyPhoneTracker
//
//  Created by Wojdan on 26.10.2014.
//  Copyright (c) 2014 wojdan. All rights reserved.
//

#import "AppDelegate.h"
#import "SVProgressHUD.h"
#import "FMPApiController.h"

#import "FMPAfterLoginViewController.h"
#import "FMPTestTrackerViewController.h"
#import "FMPTrackerViewController.h"

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {

    [self _setupAppearance];

    return YES;
}


- (void)_setupAppearance {

    [SVProgressHUD setBackgroundColor:[UIColor colorWithWhite:0 alpha:0.75]];
    [SVProgressHUD setForegroundColor:[UIColor whiteColor]];

}

+ (void)setRootViewController:(UIViewController*)viewController {

    NSParameterAssert(viewController);

    UIWindow *window = [[UIApplication sharedApplication].delegate window];

    window.rootViewController = viewController;

    return;
    
    UIViewController *oldRootViewController = window.rootViewController;

    [oldRootViewController addChildViewController:viewController];
    [oldRootViewController.view addSubview:viewController.view];
    [viewController didMoveToParentViewController:oldRootViewController];

    viewController.view.alpha = 0.0;
    [oldRootViewController.view bringSubviewToFront:viewController.view];

    [UIView transitionWithView:window duration:0.5 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        viewController.view.alpha = 1.0;

    } completion:^(BOOL finished) {
        [viewController willMoveToParentViewController:nil];
        [viewController.view removeFromSuperview];
        [viewController removeFromParentViewController];
        window.rootViewController = viewController;
    }];
}

+ (void)showLoginViewController{

    UIViewController *loginViewController = [[UIStoryboard storyboardWithName:@"LoginViewController" bundle:nil] instantiateInitialViewController];
    [AppDelegate setRootViewController:loginViewController];
    
}

+ (void)showTrackerViewController{

    FMPTrackerViewController *trackerVC = [[UIStoryboard storyboardWithName:@"TrackerViewController" bundle:nil] instantiateInitialViewController];
    [AppDelegate setRootViewController:trackerVC];

}

+ (void)showAfterLoginViewController{

    FMPAfterLoginViewController *afterLoginVC = [[UIStoryboard storyboardWithName:@"AfterLoginViewController" bundle:nil] instantiateInitialViewController];
    [AppDelegate setRootViewController:afterLoginVC];

}


-(void)updateLocation {
    NSLog(@"updateLocation");

    [self.locationTracker updateLocationToServer];
}


-(void)postNotificationWithLocation {
    NSLog(@"postLocation");

    [self.locationTracker postNotificationWithLocation];
}

- (void)_activateLocationForMode:(FMPTrackerMode)mode {

    [FMPApiController sharedInstance].workingMode = mode;

    UIAlertView * alert;

    //We have to make sure that the Background App Refresh is enable for the Location updates to work in the background.
    if([[UIApplication sharedApplication] backgroundRefreshStatus] == UIBackgroundRefreshStatusDenied){

        alert = [[UIAlertView alloc]initWithTitle:@""
                                          message:@"The app doesn't work without the Background App Refresh enabled. To turn it on, go to Settings > General > Background App Refresh"
                                         delegate:nil
                                cancelButtonTitle:@"Ok"
                                otherButtonTitles:nil, nil];
        [alert show];

    }else if([[UIApplication sharedApplication] backgroundRefreshStatus] == UIBackgroundRefreshStatusRestricted){

        alert = [[UIAlertView alloc]initWithTitle:@""
                                          message:@"The functions of this app are limited because the Background App Refresh is disable."
                                         delegate:nil
                                cancelButtonTitle:@"Ok"
                                otherButtonTitles:nil, nil];
        [alert show];

    } else{

        AppDelegate *sharedDelegate = [UIApplication sharedApplication].delegate;

        sharedDelegate.locationTracker = [[LocationTracker alloc]init];
        [sharedDelegate.locationTracker startLocationTracking];

        //Send the best location to server every 60 seconds
        //You may adjust the time interval depends on the need of your app.

        if (mode == FMPTrackerModeAntiThief) {
            NSTimeInterval time = [FMPApiController sharedInstance].updatePeriod.integerValue;
            sharedDelegate.locationUpdateTimer =
            [NSTimer scheduledTimerWithTimeInterval:time
                                             target:self
                                           selector:@selector(updateLocation)
                                           userInfo:nil
                                            repeats:YES];
        } else if (mode == FMPTrackerModeManual) {
            NSTimeInterval time = [FMPApiController sharedInstance].updatePeriod.integerValue;
            sharedDelegate.locationUpdateTimer =
            [NSTimer scheduledTimerWithTimeInterval:time
                                             target:self
                                           selector:@selector(postNotificationWithLocation)
                                           userInfo:nil
                                            repeats:YES];
        } else if (sharedDelegate.locationUpdateTimer) {
            [sharedDelegate.locationUpdateTimer invalidate];
            sharedDelegate.locationUpdateTimer = nil;
        }

    }
}

+ (void)activateLocationForMode:(FMPTrackerMode)mode {

    AppDelegate *sharedDelegate = [UIApplication sharedApplication].delegate;
    [sharedDelegate _activateLocationForMode:mode];
    
}

+ (void)deactivateLocation {

    AppDelegate *sharedDelegate = [UIApplication sharedApplication].delegate;
    [sharedDelegate.locationTracker stopLocationTracking];

    if(sharedDelegate.locationUpdateTimer) {
        [sharedDelegate.locationUpdateTimer invalidate];
        sharedDelegate = nil;
    }
}
@end
