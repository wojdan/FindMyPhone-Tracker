//
//  LocationShareModel.h
//  FindMyPhoneTracker
//
//  Created by Wojdan on 11.11.2014.
//  Copyright (c) 2014 wojdan. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BackgroundTaskManager.h"
#import <CoreLocation/CoreLocation.h>

/**
 * Singleton przechowujący najpotrzebniejsze parametry dla trybu Anti-Thief
 */
@interface LocationShareModel : NSObject

/**
 *  Główny timer trybu Anti-Thief. Odpowiedzialny za częstotliwość aktualizacji lokalizacji.
 */
@property (nonatomic) NSTimer *timer;

/**
 *  Timer wyłączający śledzenie pozycji po 10 sekundach pobierania lokalizacji. Dla oszczędności baterii.
 */
@property (nonatomic) NSTimer * delay10Seconds;


/**
 *  Timer uruchamiający co 30 sek pobieranie ustawień Anti-Thief
 */
@property (nonatomic) NSTimer *updateSettingsTimer;

/**
 *  Singleton managera odpowiedzialnego za działanie aplikacji w tle
 */
@property (nonatomic) BackgroundTaskManager * bgTask;

/**
 *  Tablica przechowująca ostatnie lokalizacje użytkownika w trybie Anti-Thief
 */
@property (nonatomic) NSMutableArray *myLocationArray;


/**
 * Getter singletona klasy
 */
+(id)sharedModel;

@end
