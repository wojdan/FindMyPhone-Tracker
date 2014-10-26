//
//  FMPHelpers.h
//  FindMyPhoneTracker
//
//  Created by Wojdan on 26.10.2014.
//  Copyright (c) 2014 wojdan. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface FMPHelpers : NSObject

+ (BOOL)validateEmail:(NSString *)candidate;
+ (void)shakeView:(UIView *)viewToShake showingBorder:(BOOL)showBorder;

@end
