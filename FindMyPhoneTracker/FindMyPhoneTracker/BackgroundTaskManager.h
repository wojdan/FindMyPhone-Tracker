//
//  BackgroundTaskManager.h
//  FindMyPhoneTracker
//
//  Created by Wojdan on 11.11.2014.
//  Copyright (c) 2014 wojdan. All rights reserved.
//
#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface BackgroundTaskManager : NSObject

+(instancetype)sharedBackgroundTaskManager;

-(UIBackgroundTaskIdentifier)beginNewBackgroundTask;

@end
