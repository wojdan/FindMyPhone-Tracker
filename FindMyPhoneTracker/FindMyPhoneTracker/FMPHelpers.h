//
//  FMPHelpers.h
//  FindMyPhoneTracker
//
//  Created by Wojdan on 26.10.2014.
//  Copyright (c) 2014 wojdan. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

/**
 *  Klasa przechowująca funkcje pomocnicze.
 */
@interface FMPHelpers : NSObject


/**
 *  Walidacja emaila
 *
 *  @param candidate Adres email, który chcemy przetestować.
 *
 *  @return YES if email is valid, otherwise it returns NO.
 */
+ (BOOL)validateEmail:(NSString *)candidate;

/**
 *  Metoda wizualizuje nieprawidłowo wypełniony formularz, poprzez zatrzęsienie nim i obramowanie na czerwono (opcjonalnie)
 *
 *  @param viewToShake Widok, który ma zostać poddany animacji trzęsienia
 *  @param showBorder włączenie lub wyłączenie obramowania po trzęsieniu
 *
 */
+ (void)shakeView:(UIView *)viewToShake showingBorder:(BOOL)showBorder;

@end
