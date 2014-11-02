//
//  FMPApiController.m
//  FindMyPhoneTracker
//
//  Created by Wojdan on 25.10.2014.
//  Copyright (c) 2014 wojdan. All rights reserved.
//

#import "FMPApiController.h"
#import "SVProgressHUD.h"
#import "AppDelegate.h"
#import "FMPDefaultsController.h"

@implementation FMPApiController

+ (instancetype)sharedInstance {

    static FMPApiController *__sharedInstance;
    static dispatch_once_t onceToken;

    dispatch_once(&onceToken, ^{

        NSURL *baseURL = [NSURL URLWithString:API_BASE_URL];

        __sharedInstance = [[FMPApiController alloc] initWithBaseURL:baseURL];
        __sharedInstance.responseSerializer = [AFJSONResponseSerializer serializer];
        __sharedInstance.requestSerializer = [AFJSONRequestSerializer serializer];

    });
    return __sharedInstance;
}


+ (void)postUserLocation:(CLLocation*)location completionHandler:(void (^)(BOOL success, NSError *error))handler {

    NSParameterAssert(location);

    NSMutableDictionary *parameters = [@{
                                         @"lat" : @(location.coordinate.latitude),
                                         @"lng"  : @(location.coordinate.longitude)
                                         } mutableCopy];

    NSString *path;
    NSNumber *dID = [FMPApiController sharedInstance].deviceID;
    if (dID) {
        path = [NSString stringWithFormat:@"devices/%d/locations", dID.integerValue];
    } else {
        [SVProgressHUD showErrorWithStatus:@"Device unregistered. Sign in again."];
        [self logout];
        return;
    }

    [SVProgressHUD show];
    [[FMPApiController sharedInstance] POST:path parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {

        [SVProgressHUD showSuccessWithStatus:responseObject[@"message"]];

        NSLog(@"Request successul :) \nResponse object:\n%@", responseObject);
        handler(YES, nil);

    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {

        [self handleError:error];
        handler(NO, error);

    }];

}

+ (void)loginWithEmailAddress:(NSString *)emailAddress password:(NSString *)password completionHandler:(void (^)(BOOL, NSError *))handler {

    NSMutableDictionary *parameters = [@{
                                         @"email" : emailAddress,
                                         @"password"  : password
                                         } mutableCopy];

    [SVProgressHUD show];
    [[FMPApiController sharedInstance] POST:@"users/login" parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {

        NSString *token = [operation.response allHeaderFields][@"Authorization"];
        if (token) {
            [FMPDefaultsController saveToken:token];
            [FMPApiController sharedInstance].accessToken = token;
            [[FMPApiController sharedInstance].requestSerializer setValue:token forHTTPHeaderField:@"Authorization"];

            NSLog(@"Login successfull");
            handler(YES, nil);
        } else {
            handler(NO, nil);
        }


    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {

        [self handleError:error];
        handler(NO, error);
    }];
}

+ (void)addDeviceWithName:(NSString *)name password:(NSString *)description vendorID:(NSString*)vendorID completionHandler:(void (^)(BOOL, NSError *))handler {

    NSMutableDictionary *parameters = [@{
                                         @"name" : name,
                                         @"description"  : description,
                                         @"device_id" : vendorID
                                         } mutableCopy];

    [SVProgressHUD show];
    [[FMPApiController sharedInstance] POST:@"devices" parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {

        [SVProgressHUD showSuccessWithStatus:@"Device added successfully!"];
        handler(YES,nil);

    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {

        [self handleError:error];
        handler(NO, error);
    }];
}


+ (void)deregisterCurrentDevice:(void (^)(BOOL, NSError *))handler {

    NSString *path;
    NSNumber *dID = [FMPApiController sharedInstance].deviceID;
    if (dID) {
        path = [NSString stringWithFormat:@"devices/%d", dID.integerValue];
    } else {
        [SVProgressHUD showErrorWithStatus:@"Device unregistered. Sign in again."];
        [self logout];
        return;
    }
    [[FMPApiController sharedInstance] DELETE:path parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {

        [SVProgressHUD showSuccessWithStatus:@"Device deregistered!"];
        handler(YES, nil);

    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {

        [self handleError:error];
        handler(NO, error);

    }];

}

+ (void)getDevicesWithCompletionHandler:(void (^)(BOOL, NSArray*, NSError *))handler {

    [[FMPApiController sharedInstance] GET:@"devices" parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {

        NSArray *devices = @[];
        if ([responseObject isKindOfClass:[NSDictionary class]]) {
            if ([((NSDictionary*)responseObject) objectForKey:@"devices"]) {
                devices = [((NSDictionary*)responseObject) objectForKey:@"devices"];
            }
        }

        handler(YES, devices, nil);

    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {

        [self handleError:error];
        handler(NO, nil, error);
    }];
    
}

+ (void)checkIfDeviceIsAlreadyRegistered:(void (^)(BOOL registered, NSError *error))handler {

    [self getDevicesWithCompletionHandler:^(BOOL success, NSArray *devices, NSError *error) {

        BOOL isRegistered = NO;
        if (success) {
            for (NSDictionary *device in devices) {
                if ([device[@"device_id"] isKindOfClass:[NSString class]]) {

                    if ([device[@"device_id"] isEqualToString:[[UIDevice currentDevice] identifierForVendor].UUIDString]) {
                        NSLog(@"Device is already registered");
                        [FMPApiController sharedInstance].deviceID = device[@"id"];
                        isRegistered = YES;
                    }
                }
            }
        }
        handler(isRegistered, error);
        if (error) {
            [self handleError:error];
        }

    }];
}

+ (void)logout {

    [FMPApiController sharedInstance].accessToken = nil;
    [FMPApiController sharedInstance].deviceID = nil;

    [FMPDefaultsController clearDefaults];
    [AppDelegate showLoginViewController];
}

+ (void)handleError:(NSError*)error {

    if (error.code == 403) {
        [self logout];
        [SVProgressHUD showErrorWithStatus:@"Session expired. Please sign in again."];
    } else {
        [SVProgressHUD showErrorWithStatus:error.localizedDescription];
    }

}
@end
