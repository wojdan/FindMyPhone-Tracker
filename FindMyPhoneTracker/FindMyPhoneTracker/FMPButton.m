//
//  FMPButton.m
//  FindMyPhoneClient
//
//  Created by Wojdan on 25.10.2014.
//  Copyright (c) 2014 wojdan. All rights reserved.
//

#import "FMPButton.h"

@implementation FMPButton

- (id)initWithCoder:(NSCoder *)aDecoder {

    self = [super initWithCoder:aDecoder];
    if (self) {

        self.layer.cornerRadius = 5.f;

    }
    return self;

}

@end
