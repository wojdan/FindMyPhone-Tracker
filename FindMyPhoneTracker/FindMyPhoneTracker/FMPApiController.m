//
//  FMPApiController.m
//  FindMyPhoneTracker
//
//  Created by Wojdan on 25.10.2014.
//  Copyright (c) 2014 wojdan. All rights reserved.
//

#import "FMPApiController.h"
#import "SVProgressHUD.h"

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

    [SVProgressHUD show];
    [[FMPApiController sharedInstance] POST:@"testTracker" parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {

        [SVProgressHUD showSuccessWithStatus:responseObject[@"message"]];

        NSLog(@"Request successul :) \nResponse object:\n%@", responseObject);
        handler(YES, nil);

    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {

        [SVProgressHUD showErrorWithStatus:operation.responseObject[@"message"] ? : [error localizedDescription]];

        NSLog(@"Request unsuccessful :(\nResponse error:\n%@", error);
        handler(NO, error);

    }];

}

@end
