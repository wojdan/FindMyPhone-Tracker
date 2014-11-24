//
//  BackgroundTaskManager.h
//  FindMyPhoneTracker
//
//  Created by Wojdan on 11.11.2014.
//  Copyright (c) 2014 wojdan. All rights reserved.
//
#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

/**
 *  Klasa odpowiedzialna za uruchamianie tasków tle.
 */
@interface BackgroundTaskManager : NSObject

/**
 *  Zwraca singleton managera
 */
+(instancetype)sharedBackgroundTaskManager;

/**
 * Metoda rozpoczynająca nowy task w tle
 */
-(UIBackgroundTaskIdentifier)beginNewBackgroundTask;

@end
