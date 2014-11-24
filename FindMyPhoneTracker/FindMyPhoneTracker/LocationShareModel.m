//
//  LocationShareModel.m
//  FindMyPhoneTracker
//
//  Created by Wojdan on 11.11.2014.
//  Copyright (c) 2014 wojdan. All rights reserved.
//

#import "LocationShareModel.h"

@implementation LocationShareModel

+ (id)sharedModel
{
    static id sharedMyModel = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedMyModel = [[self alloc] init];
    });
    return sharedMyModel;
}


@end
