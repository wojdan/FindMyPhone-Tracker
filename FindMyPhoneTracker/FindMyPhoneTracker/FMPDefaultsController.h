//
//  FMPDefaultsController.h
//  FindMyPhoneTracker
//
//  Created by Wojdan on 31.10.2014.
//  Copyright (c) 2014 wojdan. All rights reserved.
//

#import <Foundation/Foundation.h>

#define FMP_TOKEN_KEY @"FindMyPhone-Token-Key"


/**
 *  Klasa odpowiedzialna za przechowywania ustawień użytkownika.
 */
@interface FMPDefaultsController : NSObject

/**
 *  Metoda zapisująca access token.
 *  @param token access token do zapisania
 */
+ (void)saveToken:(NSString*)token;

/**
 *  Pobranie access tokena
 */
+ (NSString*)getToken;


/**
 *  Metoda czyszcząca ustawienia użytkownika
 */
+ (void)clearDefaults;


@end
