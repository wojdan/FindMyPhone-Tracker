//
//  LocationTracker.h
//  FindMyPhoneTracker
//
//  Created by Wojdan on 11.11.2014.
//  Copyright (c) 2014 wojdan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>
#import "LocationShareModel.h"

/**
 * Klasa służy do rozpoczynania, przerywania lokalizacji w trybier Anti-Thief oraz wysyłania uzyskanych wyników na serwer.
 */
@interface LocationTracker : NSObject <CLLocationManagerDelegate>

/**
 *  Ostatnie pobrane współrzędne
 */
@property (nonatomic) CLLocationCoordinate2D myLastLocation;

/**
 * Ostatnia dobrana dokładność lokalizacji
 */
@property (nonatomic) CLLocationAccuracy myLastLocationAccuracy;

/**
 * Singleton przechowujący parametry trackera
 */
@property (strong,nonatomic) LocationShareModel * shareModel;

/**
 *  Obecne współrzędne użytkownika
 */
@property (nonatomic) CLLocationCoordinate2D myLocation;

/**
 *  Obecna dokładność pozycji użytkownika
 */
@property (nonatomic) CLLocationAccuracy myLocationAccuracy;

/**
 *  LocationManager, obiekt odpowiedzialny za aktualizację lokalizacji.
 */
+ (CLLocationManager *)sharedLocationManager;

/**
 * Metoda rozpoczynające lokalizację w trybie Anti-Thief
 */
- (void)startLocationTracking;

/**
 *  Metoda zatrzymująca lokalizację w trybie Anti-Thief
 */
- (void)stopLocationTracking;

/**
 *  Metoda wysyłająca ostatnią pobraną pozycję na serwer
 */
- (void)updateLocationToServer;

/**
 * Metoda wysyłająca notifikację z ostatnią pobraną pozycją
 */
- (void)postNotificationWithLocation;


@end
