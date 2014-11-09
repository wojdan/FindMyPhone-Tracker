//
//  FMPApiController.h
//  FindMyPhoneTracker
//
//  Created by Wojdan on 25.10.2014.
//  Copyright (c) 2014 wojdan. All rights reserved.
//

#import "AFNetworking.h"
#import <CoreLocation/CoreLocation.h>

#define API_BASE_URL @"http://find-my-phone-api.herokuapp.com/api/v1/"

@interface FMPApiController : AFHTTPRequestOperationManager

@property (strong, nonatomic) NSString *accessToken;
@property (strong, nonatomic) NSNumber *deviceID;

+ (instancetype)sharedInstance;

+ (void)postUserLocation:(CLLocation*)location completionHandler:(void (^)(BOOL success, NSError *error))handler;
+ (void)loginWithEmailAddress:(NSString *)emailAddress password:(NSString *)password completionHandler:(void (^)(BOOL, BOOL, NSError *))handler;
+ (void)addDeviceWithName:(NSString *)name password:(NSString *)description vendorID:(NSString*)vendorID completionHandler:(void (^)(BOOL, NSError *))handler;
+ (void)deregisterCurrentDevice:(void (^)(BOOL, NSError *))handler;
+ (void)getDevicesWithCompletionHandler:(void (^)(BOOL, NSArray*, NSError *))handler;
+ (void)checkIfDeviceIsAlreadyRegistered:(void (^)(BOOL success, NSError *error))handler;
+ (void)logout;

@end
