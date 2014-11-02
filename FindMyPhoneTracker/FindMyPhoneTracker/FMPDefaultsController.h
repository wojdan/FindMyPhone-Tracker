//
//  FMPDefaultsController.h
//  FindMyPhoneTracker
//
//  Created by Wojdan on 31.10.2014.
//  Copyright (c) 2014 wojdan. All rights reserved.
//

#import <Foundation/Foundation.h>

#define FMP_TOKEN_KEY @"FindMyPhone-Token-Key"

@interface FMPDefaultsController : NSObject

+ (void)saveToken:(NSString*)token;
+ (NSString*)getToken;
+ (void)clearDefaults;


@end
