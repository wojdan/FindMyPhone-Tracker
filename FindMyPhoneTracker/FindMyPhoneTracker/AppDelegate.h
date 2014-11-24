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

/**
 
 Delegat aplikacji
 @see http://find-my-phone-api.herokuapp.com/doc aby dowiedzieć się więcej o aplikacji

 */
@interface AppDelegate : UIResponder <UIApplicationDelegate>

/**
 * Główne okno aplikacji
 */
@property (strong, nonatomic) UIWindow *window;

/**
 *  Metoda odpowiedzialna za podmianę głównego kontrollera aplikacji.
 *
 *  @param viewController Kontroler który ma zastać użyty jako główny.
 */
+ (void)setRootViewController:(UIViewController*)viewController;

/**
 *  Metoda podmienia główny ekran na ekran logowania
 */
+ (void)showLoginViewController;

/**
 *  Metoda podmienia główny ekran na ekran następujący po pierwszym logowaniu
 */
+ (void)showAfterLoginViewController;


/**
 *  Metoda podmienia główny ekran na ekran trackera
 */
+ (void)showTrackerViewController;

#pragma mark - Lokalizacja

/**
 * locationTracker jest obiektem klasy LocationTracker odpowiedzialną za obsługę lokalizacji, gdy aplikacja pracuje w tle
 */
@property LocationTracker * locationTracker;

/**
 *  Timer odpowiedzialny za częstotliwość aktualizacji lokalizacji
 */
@property (nonatomic) NSTimer* locationUpdateTimer;

/**
 *  Metoda uruchamiająca trackowanie w odpowiednim trybie
 *  @param mode wybrany tryb lokalizacji
 */
+ (void)activateLocationForMode:(FMPTrackerMode)mode;

/**
 *  Metoda wyłączająca trackowanie (jeżeli włączone)
 */
+ (void)deactivateLocation;

@end

