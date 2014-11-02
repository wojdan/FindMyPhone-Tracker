//
//  AppDelegate.m
//  FindMyPhoneTracker
//
//  Created by Wojdan on 26.10.2014.
//  Copyright (c) 2014 wojdan. All rights reserved.
//

#import "AppDelegate.h"
#import "SVProgressHUD.h"

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


@end
