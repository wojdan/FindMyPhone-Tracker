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

    UIWindow *delegateWindow = [[UIApplication sharedApplication].delegate window];

    [UIView transitionWithView:delegateWindow
                      duration:0.5
                       options:UIViewAnimationOptionTransitionFlipFromLeft
                    animations:^{
                        delegateWindow.rootViewController = viewController;
                    }
                    completion:nil];
}


@end
