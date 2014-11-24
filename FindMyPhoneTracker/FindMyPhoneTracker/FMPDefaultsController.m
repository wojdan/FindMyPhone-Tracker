//
//  FMPDefaultsController.m
//  FindMyPhoneTracker
//
//  Created by Wojdan on 31.10.2014.
//  Copyright (c) 2014 wojdan. All rights reserved.
//

#import "FMPDefaultsController.h"

@implementation FMPDefaultsController

+ (void)saveToken:(NSString*)token {

    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:token forKey:FMP_TOKEN_KEY];
    [defaults synchronize];

}

+ (NSString*)getToken{

    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    return [defaults objectForKey:FMP_TOKEN_KEY];
    
}

+ (void)clearDefaults {

    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults removeObjectForKey:FMP_TOKEN_KEY];
}

@end
