//
//  FMPApiController.h
//  FindMyPhoneTracker
//
//  Created by Wojdan on 25.10.2014.
//  Copyright (c) 2014 wojdan. All rights reserved.
//

#import "AFNetworking.h"
#import <CoreLocation/CoreLocation.h>

/**
 *  API URL
 */
#define API_BASE_URL @"http://find-my-phone-api.herokuapp.com/api/v1/"

/**
 *  Możliwe tryby działania trackera
 */
typedef enum : NSUInteger {
    FMPTrackerModeOff = 0,
    FMPTrackerModeManual,
    FMPTrackerModeAntiThief
} FMPTrackerMode;

/**
 * Kontroler API. Klasa odpowiedzialna za wymianę informacji z serwerem.
 * 
 * @see http://find-my-phone-api.herokuapp.com/doc/ - Dokumentcja API
 */
@interface FMPApiController : AFHTTPRequestOperationManager

/**
 * Access token zalogowanego usera
 */
@property (strong, nonatomic) NSString *accessToken;

/**
 *  Device ID używanego urządzenia. Jest to id generowane przez serwer. Nie mylić z UUID sprzętowym.
 */
@property (strong, nonatomic) NSNumber *deviceID;

/**
 *  Częstotliwość odświeżania lokalizacji w sekundach.
 */
@property (strong, nonatomic) NSNumber *updatePeriod;

/**
 *  Tryb w którym pracuje obecnie aplikacja Tracker.
 */
@property (nonatomic) FMPTrackerMode workingMode;

/**
 *  Singleton klasy
 */
+ (instancetype)sharedInstance;

#pragma mark - API Methods

/**
 *  Metoda wykonująca request typu POST w celu zalogowania użytkownika.
 *
 *  @param emailAddress Adres email usera
 *  @param password Hasło usera
 *  @param handler Handler przekazuje następujące parametry:
 *  <ol>
 *      <li>typu boolean sprawdzajacy czy request się powiódł</li>
 *      <li>typu boolean sprawdzający czy używane urządzenia jest już zarejestrowane</li>
 *      <li>error jeżeli wystąpił</li>
 *  </ol>
 */
+ (void)loginWithEmailAddress:(NSString *)emailAddress password:(NSString *)password completionHandler:(void (^)(BOOL, BOOL, NSError *))handler;

/**
 *  Metoda wykonująca request typu POST w celu wysłania lokalizacji
 *
 *  @param location obiekt CLLocation przechowujący koordynaty
 *  @param handler Handler przekazuje następujące parametry:
 *  <ol>
 *      <li>typu boolean sprawdzajacy czy request się powiódł</li>
 *      <li>error jeżeli wystąpił</li>
 *  </ol>
 */
+ (void)postUserLocation:(CLLocation*)location completionHandler:(void (^)(BOOL success, NSError *error))handler;

/**
 *  Metoda wykonująca request typu POST w celu zarejestrowania urządzenia.
 *
 *  @param name Nazwa urządzenia
 *  @param description Opis urządzenia
 *  @param vendorID Unikalny identyfikator urządzenia
 *  @param handler Handler przekazuje następujące parametry:
 *  <ol>
 *      <li>typu boolean sprawdzajacy czy request się powiódł</li>
 *      <li>error jeżeli wystąpił</li>
 *  </ol>
 */
+ (void)addDeviceWithName:(NSString *)name password:(NSString *)description vendorID:(NSString*)vendorID completionHandler:(void (^)(BOOL, NSError *))handler;

/**
 *  Metoda wykonująca request typu DELETE w celu wyrejestrowania urządzenia z konta użytkownika.
 *
 *  @param handler Handler przekazuje następujące parametry:
 *  <ol>
 *      <li>typu boolean sprawdzajacy czy request się powiódł</li>
 *      <li>error jeżeli wystąpił</li>
 *  </ol>
 */
+ (void)deregisterCurrentDevice:(void (^)(BOOL, NSError *))handler;


/**
 *  Metoda wykonująca request typu GET w celu pobrania listy urządzeń.
 *
 *  @param handler Handler przekazuje następujące parametry:
 *  <ol>
 *      <li>typu boolean sprawdzajacy czy request się powiódł</li>
 *      <li>typu NSArray - tablica zarejestrowanych na koncie urządzeń</li>
 *      <li>error jeżeli wystąpił</li>
 *  </ol>
 */
+ (void)getDevicesWithCompletionHandler:(void (^)(BOOL, NSArray*, NSError *))handler;


/**
 *  Metoda wykonująca request typu GET w celu pobrania ustawień Anti-Thief dla urządzenia.
 *
 *  @param handler Handler przekazuje następujące parametry:
 *  <ol>
 *      <li>typu boolean sprawdzajacy czy request się powiódł</li>
 *      <li>error jeżeli wystąpił</li>
 *  </ol>
 */
+ (void)getDeviceSettingsWithCompletionHandler:(void (^)(BOOL, NSError *))handler;


/**
 *  Metoda sprawdzająca dodatkowo czy urządzenie jest już zarejestrowane.
 *
 *  <ol>
 *      <li>typu boolean sprawdzajacy czy request się powiódł</li>
 *      <li>error jeżeli wystąpił</li>
 *  </ol>
 */
+ (void)checkIfDeviceIsAlreadyRegistered:(void (^)(BOOL success, NSError *error))handler;

#pragma mark - Other Handful methods

/**
 *  Metoda wylogowuje usera i usuwa po nim wszystkie istotne dane.
 */
+ (void)logout;

@end
